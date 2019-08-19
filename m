Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CCBC3A59B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 04:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9C32070B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 04:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbfHSEYK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 00:24:10 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46411 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbfHSEYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 00:24:10 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 16FD343DE59;
        Mon, 19 Aug 2019 14:24:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzZC7-00025g-Ho; Mon, 19 Aug 2019 14:22:59 +1000
Date:   Mon, 19 Aug 2019 14:22:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "hch@lst.de" <hch@lst.de>
Cc:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190819042259.GZ6129@dread.disaster.area>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
 <20190818071128.GA17286@lst.de>
 <20190818074140.GA18648@lst.de>
 <20190818173426.GA32311@lst.de>
 <20190819000831.GX6129@dread.disaster.area>
 <20190819034948.GA14261@lst.de>
 <20190819041132.GA14492@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819041132.GA14492@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=m86_S26F_7qqHbqmw3wA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 06:11:32AM +0200, hch@lst.de wrote:
> On Mon, Aug 19, 2019 at 05:49:48AM +0200, hch@lst.de wrote:
> > The fake pmem was create by the following kernel command line sniplet:
> > "memmap=2000M!1024M,2000M!4096M" and my kernel config is attached.  I
> > suspect you'll need CONFIG_SLUB to create the woes, but let me confirm
> > that..
> 
> Yep, doesn't reproduce with CONFIG_SLAB.

That implies a kmalloc heap issue.

Oh, is memory poisoning or something that modifies the alignment of
slabs turned on?

i.e. 4k/8k allocations from the kmalloc heap slabs might not be
appropriately aligned for IO, similar to the problems we have with
the xen blk driver?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
