Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCA2C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E39361156
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFUFdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhFUFdP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 01:33:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC7FC061574
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jun 2021 22:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CvMnctKD7Gyh2j8FKm4G6Wu8plUhc/S5E1CnRWKnDOU=; b=pizPVc8vGMw+HZ2xHS3QsaCkJW
        YiD7T2YsmKwdNI7cF8pzj0xS1DOiLuWO6CqzjWPMB5te45TPSRwiiwTB6J/dk3Y2w3We9d4EWfJct
        9Kng1eTY1paxf8cbobTBHx8brtwke0RFIyympG5BhAVGw/I4vrkczHFJIx8hk7FpuJ1wVkJIueHxD
        kxi1sR088LxnrhhnLtvOiLhe5VmxELDwDnxvSnmBZCO/qHg5rFLakZyuuCCevPL6m579A49wONUVK
        HBz2v7d110xio2fkMbJGYQoKCVlD0bL5Ym7zUo+p3e7y+X5qWtxOOw6SN3R4vgKIgVFxwof1HlRRr
        ZYMnsn0Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvCVv-00CkjX-6i; Mon, 21 Jun 2021 05:30:32 +0000
Date:   Mon, 21 Jun 2021 06:30:27 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        chandanrlinux@gmail.com, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: shorten the shutdown messages to a single line
Message-ID: <YNAj8xlFB/XnmVIn@infradead.org>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
 <162404245053.2377241.2678360661858649500.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162404245053.2377241.2678360661858649500.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 11:54:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Consolidate the shutdown messages to a single line containing the
> reason, the passed-in flags, the source of the shutdown, and the end
> result.  This means we now only have one line to look for when
> debugging, which is useful when the fs goes down while something else is
> flooding dmesg.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsops.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index b7f979eca1e2..6ed29b158312 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -538,25 +538,25 @@ xfs_do_force_shutdown(
>  
>  	if (flags & SHUTDOWN_FORCE_UMOUNT) {
>  		xfs_alert(mp,
> -"User initiated shutdown received. Shutting down filesystem");
> +"User initiated shutdown (0x%x) received. Shutting down filesystem",
> +				flags);
>  		return;
>  	}

So SHUTDOWN_FORCE_UMOUNT can actually be used together with
SHUTDOWN_LOG_IO_ERROR so printing something more specific could be
useful, although I'd prefer text over the hex flags.

>  	if (flags & SHUTDOWN_CORRUPT_INCORE) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
> -"Corruption of in-memory data detected.  Shutting down filesystem");
> +"Corruption of in-memory data (0x%x) detected at %pS (%s:%d).  Shutting down filesystem",
> +				flags, __return_address, fname, lnnum);
>  		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
>  			xfs_stack_trace();
>  	} else if (logerror) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
> -			"Log I/O Error Detected. Shutting down filesystem");
> +"Log I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> +				flags, __return_address, fname, lnnum);
>  	} else {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> -			"I/O Error Detected. Shutting down filesystem");
> +"I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> +				flags, __return_address, fname, lnnum);
>  	}

However once we get here, flags can have exactly one specific value,
so printing it (especially as unreadable hex value) is completely
pointless.
