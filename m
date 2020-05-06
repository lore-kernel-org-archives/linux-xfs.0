Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FA4C47256
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A4732068E
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dteuwz8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbgEFP1I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbgEFP1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:27:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B24C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h/MV9UPXGELF3JDIqDeEprmNmClriBEZ26bsOOQp+2k=; b=dteuwz8eApp7zaa5iD5Qdf1r2L
        zMLGAG4YfYkJpC4bc4hix3TD3ggbNn51OFW2UQUesqF+8ICS9k5rd+izdfZqb+wDTlRX3OZZS3Zu4
        WJ+Lbkpfpdu49k6oryteaJKW9DkitImeRKI3VpWLcuIQDovYUWgAhrmLWzC6bodfnDNQHCGLQF3x3
        X6DBwshgLE3iaBvhhDgnhyPDHAq+zFM8VrjVHpiagf6OY0iT4xWdgYpweCz8ZGmCxrApuwH+eRXut
        cz+iTqsA+rkeewXP9q1/UjbvEByIaYPdHaqBdmRM/P3QqX/XfMX8ZRLZIMiqHw6+Usk4agamoV4Lo
        NR1ruaEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLwx-0000UR-Bf; Wed, 06 May 2020 15:27:07 +0000
Date:   Wed, 6 May 2020 08:27:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/28] xfs: refactor xlog_recover_process_unlinked
Message-ID: <20200506152707.GX7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864115522.182683.9248036319539577559.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864115522.182683.9248036319539577559.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:12:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the unlinked inode processing logic out of the AG loop and into
> its own function.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_unlink_recover.c |   91 +++++++++++++++++++++++++------------------
>  1 file changed, 52 insertions(+), 39 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
> index 2a19d096e88d..413b34085640 100644
> --- a/fs/xfs/xfs_unlink_recover.c
> +++ b/fs/xfs/xfs_unlink_recover.c
> @@ -145,54 +145,67 @@ xlog_recover_process_one_iunlink(
>   * scheduled on this CPU to ensure other scheduled work can run without undue
>   * latency.
>   */
> -void
> -xlog_recover_process_unlinked(
> -	struct xlog		*log)
> +STATIC int
> +xlog_recover_process_iunlinked(

xlog_recover_process_ag_iunlinked?

