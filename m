Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4B6C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 425E820663
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UmmV70in"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgGORwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 13:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGORwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 13:52:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3F1C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 10:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+p5S8iu391B8Mjdcq5UEows6juXGOv2lFygcsQTTEvs=; b=UmmV70inZVRWOzOyJ0trSTfHgn
        TmCRLrS7hpwt7AQ6vAkWKx1hqCGWvbHh/Fnymth3aOWEOW20tB/99dG315rckRUhTDF8p15wyw+Vh
        x/lIDP8YMRKvJl0OsaEBf5QVO/yL2SSWFtxhEZAfpQzcF+PFuDll50PxRkzEoUPqunyoA0xMyFgTe
        CJ6yRlKQpbvYmlpJkJwmr0j12Is8gWgQ7PNAQlTQBdofzYKlFOmTfwdEJzSjebCyZwDjMceas/my3
        UaDUYWH5Co+vrt5TOF4OxbSeTuIF4InJ6UPPeH5yTNTVl+X4vSXtE8uFRdMaJacPbas2Dur0tLQoF
        fqy8y1Hw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvlZf-0003mj-Tq; Wed, 15 Jul 2020 17:52:07 +0000
Date:   Wed, 15 Jul 2020 18:52:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: drain the buf delwri queue before xfsaild idles
Message-ID: <20200715175207.GA14300@infradead.org>
References: <20200715123835.8690-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715123835.8690-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 08:38:35AM -0400, Brian Foster wrote:
> index c3be6e440134..6a6a79791fbb 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -542,11 +542,11 @@ xfsaild_push(
>  	xfs_trans_ail_cursor_done(&cur);
>  	spin_unlock(&ailp->ail_lock);
>  
> +out_done:
>  	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
>  		ailp->ail_log_flush++;
>  
>  	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
> -out_done:

Nit:  if you move the out_done up a bit we can also de-duplicate the
xfs_trans_ail_cursor_done and spin_unlock calls.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
