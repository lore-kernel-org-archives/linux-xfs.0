Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB07C3A589
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 00:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9702922CF7
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 00:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfHUA1w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 20:27:52 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40315 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbfHUA1v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 20:27:51 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 58B4343E0D7;
        Wed, 21 Aug 2019 10:27:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0ESZ-0001vi-DY; Wed, 21 Aug 2019 10:26:43 +1000
Date:   Wed, 21 Aug 2019 10:26:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "hch@lst.de" <hch@lst.de>
Cc:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190821002643.GK1119@dread.disaster.area>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
 <20190818071128.GA17286@lst.de>
 <20190818074140.GA18648@lst.de>
 <20190818173426.GA32311@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818173426.GA32311@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=rg55TvFzVAOYHM5hWT0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 18, 2019 at 07:34:26PM +0200, hch@lst.de wrote:
> On Sun, Aug 18, 2019 at 09:41:40AM +0200, hch@lst.de wrote:
> > On Sun, Aug 18, 2019 at 09:11:28AM +0200, hch@lst.de wrote:
> > > > The kernel log shows the following when the mount fails:
> > > 
> > > Is it always that same message?  I'll see if I can reproduce it,
> > > but I won't have that much memory to spare to create fake pmem,
> > > hope this also works with a single device and/or less memory..
> > 
> > I've reproduced a similar ASSERT with a small pmem device, so I hope
> > I can debug the issue locally now.
> 
> So I can also reproduce the same issue with the ramdisk driver, but not
> with any other 4k sector size device (nvmet, scsi target, scsi_debug,
> loop).  Which made me wonder if there is some issue about the memory
> passed in, and indeed just switching to plain vmalloc vs the XFS
> kmem_alloc_large wrapper that either uses kmalloc or vmalloc fixes
> the issue for me.  I don't really understand why yet, maybe I need to
> dig out alignment testing patches.
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 13d1d3e95b88..918ad3b884a7 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -125,7 +125,7 @@ xlog_alloc_buffer(
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
> -	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
> +	return vmalloc(BBTOB(nbblks));
>  }

After thinking on this for a bit, I suspect the better thing to do
here is add a KM_ALIGNED flag to the allocation, so if the internal
kmem_alloc() returns an unaligned pointer we free it and fall
through to vmalloc() to get a properly aligned pointer....

That way none of the other interfaces have to change, and we can
then use kmem_alloc_large() everywhere we allocate buffers for IO.
And we don't need new infrastructure just to support these debug
configurations, either.

Actually, kmem_alloc_io() might be a better idea - keep the aligned
flag internal to the kmem code. Seems like a pretty simple solution
to the entire problem we have here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
