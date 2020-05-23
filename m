Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C085C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 09:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C8E207DA
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 09:12:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q8AwVN3i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387689AbgEWJMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 05:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgEWJMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 05:12:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCD7C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 02:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=81wtl+oVDACz8I2Ab1tIi1YJzLpQdOWcqalnUWFxIRw=; b=q8AwVN3i7nxouTtfLYYpUMXheU
        rE7AOppU0UBI2fmTRbSOYdit1Vuf6GBZ76JEwyOmpKPFOhp4UE3CwxMLegN/OZISBShGCyX7ErGch
        PjBb8CBKleCulQbsFo5xN+M5/hl7qpaZuSdMZik/1EZZSUrXVh8Py/2EoeRvAyRQCv/WD12AvZS/D
        JcI17z0csRrEDtxtfQ6KMR2k0zsaU7/lTKMXd9yV2HrykDiOTSTOn/GUBdBlYwAS2GWBxCu8QbMPw
        2F8eZ3dM/UCAbBEfDu3tOKRqC63TXHBnobeL6tU0y5jLwttTIyv55kMm0IszVOCCm38dnGq3cw7D8
        4ndTj6DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcQD6-0007Iw-Se; Sat, 23 May 2020 09:12:52 +0000
Date:   Sat, 23 May 2020 02:12:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/24] xfs: fold xfs_istale_done into xfs_iflush_done
Message-ID: <20200523091252.GD31566@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200522035029.3022405-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:13PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Having different io completion callbacks for different inode states
> makes things complex. We can detect if the inode is stale via the
> XFS_ISTALE flag in IO completion, so we don't need a special
> callback just for this.
> 
> This means inodes only have a single iodone callback, and inode IO
> completion is entirely buffer centric at this point. Hence we no
> longer need to use a log item callback at all as we can just call
> xfs_iflush_done() directly from the buffer completions and walk the
> buffer log item list to complete the all inodes under IO.

I find the subject a bit confuing.  Yes, this merges xfs_istale_done into
xfs_iflush_done, but that ѕeems to be a side effect of the other
changes.

The main change is that the inode I/O completion is run directly
instead of through b_iodone and li_cb.  Maybe pick a subject that
better reflects this?

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

One minor nitpick below:

> -static void
> -xfs_buf_run_callbacks(
> +static inline bool
> +xfs_buf_had_callback_errors(
>  	struct xfs_buf		*bp)
>  {
>  
> @@ -1152,7 +1155,7 @@ xfs_buf_run_callbacks(
>  	 * appropriate action.
>  	 */
>  	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
> -		return;
> +		return true;
>  
>  	/*
>  	 * Successful IO or permanent error. Either way, we can clear the
> @@ -1161,7 +1164,16 @@ xfs_buf_run_callbacks(
>  	bp->b_last_error = 0;
>  	bp->b_retries = 0;
>  	bp->b_first_retry_time = 0;
> +	return false;
> +}
>  
> +static void
> +xfs_buf_run_callbacks(
> +	struct xfs_buf		*bp)
> +{
> +
> +	if (xfs_buf_had_callback_errors(bp))
> +		return;
>  	xfs_buf_do_callbacks(bp);
>  	bp->b_log_item = NULL;
>  }

Maybe its worth splitting this refactoring into a separate prep patch?

