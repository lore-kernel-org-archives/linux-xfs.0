Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775CCC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CE95206F4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N09x0x1/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgGPG7z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgGPG7z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:59:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4952EC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 23:59:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id q17so3236395pfu.8
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 23:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UkoBeT0TAwjlVbLJeLEQV2g/klUqcMP8QFuhKJWMBdQ=;
        b=N09x0x1/ZjW3dDuNcOIdmTwmeJQoH6EdHDrRggsa/DRfM4ksiv+jxx8e0K0i5efNUk
         JR4c02ji5FUqCcvMAeOHmh9PaMEMiyptDPbkvAlW+vROaYK4KGaby+0zUl8tTYQJXOa8
         95RBxZbkK+5at4MEkUaVmMdZ1+33g2Z2KYlMH9lk4K7AyRS168LZo0NJaU+6YdvphIWm
         LyaJPnKstB44cIhe9z1JsQEueu/cwtLI+2GbqYNTUtXI6fEiWbt8zfTt0iyrKa4k9oOh
         3mIYJ4Ijf1RM8SGOOcAIQ8pRxwWMq855Ot7pIBeHULJSbSSeQGhN/EFH9oU5/uDd3iOz
         WmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UkoBeT0TAwjlVbLJeLEQV2g/klUqcMP8QFuhKJWMBdQ=;
        b=dblEfdL7rswiyGxb7m00FqPSc7EI6w2WIf55o9PprZ9F+DcykwAY6IvoPS2VR05STu
         d5KrfblXss2S56pbmUfiMuRLkTE6fxhnzTrJbRK6iatseWnB65YCyprWquqIuw8LDuYq
         w489wGgXd3oCaohY2bHZIpHkUmjyooHQigCyoHUdR4DUQPO60wRlVx/c/OHOuFj32wor
         ybNA75Mdq2OXm78QCsg+ZzT1FXilpTB3PBAaVmAi4OUqc9z2GmzDFmcC8gkIoCz9Hmun
         XsqAInfFforIQaLn+taBpdsLjjY/8kDMrZW72VR8eTev8DZEDGIfBnZQzzmxfMgk7p//
         0j/A==
X-Gm-Message-State: AOAM531WeYTGQztSAg2EFgQ9eyNIR/SJGU2TwdaYikWSVXoYJHslPNLc
        FUSc3AkrVbJHdTUNQyNDEJI=
X-Google-Smtp-Source: ABdhPJz5vxCRKzk0ibxd5OD9uV6hYVQnPn+uY8yhTCuEJbMhANLu/Rpk+D6leQso5MeZExuq4VcdJA==
X-Received: by 2002:aa7:9a92:: with SMTP id w18mr2435829pfi.233.1594882794841;
        Wed, 15 Jul 2020 23:59:54 -0700 (PDT)
Received: from garuda.localnet ([122.167.32.2])
        by smtp.gmail.com with ESMTPSA id g19sm3642416pfu.183.2020.07.15.23.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 23:59:53 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/26] xfs: refactor quotacheck flags usage
Date:   Thu, 16 Jul 2020 12:29:33 +0530
Message-ID: <177216482.sJsirB9EQM@garuda>
In-Reply-To: <159477787448.3263162.11425861807454204294.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477787448.3263162.11425861807454204294.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:21:14 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We only use the XFS_QMOPT flags in quotacheck to signal the quota type,
> so rip out all the flags handling and just pass the type all the way
> through.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm.c |   18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 9c455ebd20cb..939ee728d9af 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -902,17 +902,13 @@ xfs_qm_reset_dqcounts_all(
>  	xfs_dqid_t		firstid,
>  	xfs_fsblock_t		bno,
>  	xfs_filblks_t		blkcnt,
> -	uint			flags,
> +	xfs_dqtype_t		type,
>  	struct list_head	*buffer_list)
>  {
>  	struct xfs_buf		*bp;
> -	int			error;
> -	xfs_dqtype_t		type;
> +	int			error = 0;
>  
>  	ASSERT(blkcnt > 0);
> -	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQTYPE_USER :
> -		(flags & XFS_QMOPT_PQUOTA ? XFS_DQTYPE_PROJ : XFS_DQTYPE_GROUP);
> -	error = 0;
>  
>  	/*
>  	 * Blkcnt arg can be a very big number, and might even be
> @@ -972,7 +968,7 @@ STATIC int
>  xfs_qm_reset_dqcounts_buf(
>  	struct xfs_mount	*mp,
>  	struct xfs_inode	*qip,
> -	uint			flags,
> +	xfs_dqtype_t		type,
>  	struct list_head	*buffer_list)
>  {
>  	struct xfs_bmbt_irec	*map;
> @@ -1048,7 +1044,7 @@ xfs_qm_reset_dqcounts_buf(
>  			error = xfs_qm_reset_dqcounts_all(mp, firstid,
>  						   map[i].br_startblock,
>  						   map[i].br_blockcount,
> -						   flags, buffer_list);
> +						   type, buffer_list);
>  			if (error)
>  				goto out;
>  		}
> @@ -1292,7 +1288,7 @@ xfs_qm_quotacheck(
>  	 * We don't log our changes till later.
>  	 */
>  	if (uip) {
> -		error = xfs_qm_reset_dqcounts_buf(mp, uip, XFS_QMOPT_UQUOTA,
> +		error = xfs_qm_reset_dqcounts_buf(mp, uip, XFS_DQTYPE_USER,
>  					 &buffer_list);
>  		if (error)
>  			goto error_return;
> @@ -1300,7 +1296,7 @@ xfs_qm_quotacheck(
>  	}
>  
>  	if (gip) {
> -		error = xfs_qm_reset_dqcounts_buf(mp, gip, XFS_QMOPT_GQUOTA,
> +		error = xfs_qm_reset_dqcounts_buf(mp, gip, XFS_DQTYPE_GROUP,
>  					 &buffer_list);
>  		if (error)
>  			goto error_return;
> @@ -1308,7 +1304,7 @@ xfs_qm_quotacheck(
>  	}
>  
>  	if (pip) {
> -		error = xfs_qm_reset_dqcounts_buf(mp, pip, XFS_QMOPT_PQUOTA,
> +		error = xfs_qm_reset_dqcounts_buf(mp, pip, XFS_DQTYPE_PROJ,
>  					 &buffer_list);
>  		if (error)
>  			goto error_return;
> 
> 


-- 
chandan



