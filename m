Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9B8CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 20:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D25682084C
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 20:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfJYUne (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 16:43:34 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49222 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbfJYUne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 16:43:34 -0400
Received: from dread.disaster.area (pa49-181-161-154.pa.nsw.optusnet.com.au [49.181.161.154])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 43CEB3A02D8;
        Sat, 26 Oct 2019 07:43:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iO6Qj-0006Be-6N; Sat, 26 Oct 2019 07:43:29 +1100
Date:   Sat, 26 Oct 2019 07:43:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 3/7] xfs: remove the m_readio_log field from struct
 xfs_mount
Message-ID: <20191025204329.GF4614@dread.disaster.area>
References: <20191025174026.31878-1-hch@lst.de>
 <20191025174026.31878-4-hch@lst.de>
 <851dcbf3-afbf-77fa-bd6e-3e1a8ccba7c7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <851dcbf3-afbf-77fa-bd6e-3e1a8ccba7c7@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=l3vQdJ1SkhDHY1nke8Lmag==:117 a=l3vQdJ1SkhDHY1nke8Lmag==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=6X7Q8ocAT_GAQLeLGJ4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 01:26:05PM -0500, Eric Sandeen wrote:
> On 10/25/19 12:40 PM, Christoph Hellwig wrote:
> > The m_readio_log is only used for reporting the blksize (aka preferred
> > I/O size) in struct stat.  For all cases but a file system that does not
> > use stripe alignment, but which has the wsync and largeio mount option
> > set the value is the same as the write I/O size.
> > 
> > Remove the field and report a smaller preferred I/O size for that corner
> > case, which actually is the right thing to do for that case (except for
> > the fact that is probably is entirely unused).
> 
> hm, I wonder what the history of the WSYNC_ sizes are, tbh.  So while I can't
> speak to the need for a separate READIO_LOG or not, this doesn't seem 
> too far fetched...

NFSv2 had a maximum client IO size of 8kB and writes were
synchronous. The Irix NFS server had some magic in it (enabled by
the filesystem wsync mount option) that allowed clients to have two
sequential 8k writes in flight at once, allowing XFS to optimise for
16KB write IOs instead of the normal default of 64kB. This
optimisation was the reason that, at the time (early-mid 90s), SGI
machines had double the NFS write throughput of any other Unix
systems.

I'm surprised we still support NFSv2 at all in this day and age - I
suspect we should just kill NFSv2 altogether. We need to keep the
wsync option around for HA systems serving files to NFS and CIFS
clients, but the 8kB IO size optimisations can certainly die....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
