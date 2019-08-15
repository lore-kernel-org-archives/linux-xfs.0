Return-Path: <SRS0=AwRW=WL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F86C3A59C
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 21:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A16206C1
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 21:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfHOVi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Aug 2019 17:38:27 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49331 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbfHOVi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 17:38:26 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 610B13616FA;
        Fri, 16 Aug 2019 07:38:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hyNQr-0006eN-0t; Fri, 16 Aug 2019 07:37:17 +1000
Date:   Fri, 16 Aug 2019 07:37:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix reflink source file racing with directio writes
Message-ID: <20190815213716.GS6129@dread.disaster.area>
References: <20190815165043.GB15186@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815165043.GB15186@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=9DvzHAtuNbEfJHX3IV4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 15, 2019 at 09:50:43AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While trawling through the dedupe file comparison code trying to fix
> page deadlocking problems, Dave Chinner noticed that the reflink code
> only takes shared IOLOCK/MMAPLOCKs on the source file.  Because
> page_mkwrite and directio writes do not take the EXCL versions of those
> locks, this means that reflink can race with writer processes.
> 
> For pure remapping this can lead to undefined behavior and file
> corruption; for dedupe this means that we cannot be sure that the
> contents are identical when we decide to go ahead with the remapping.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I don't think this is quite right yet. The source inode locking
change is good, but it doesn't break the layout on the source inode
and so there is still they possibility that something has physical
access and is directly modifying the source file.

And with that, I suspect the locking algorithm changes
substantially:

	order inodes
restart:
	lock first inode
	break layout on first inode
	lock second inode
	break layout on second inode
	fail then unlock both inodes, goto restart

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
