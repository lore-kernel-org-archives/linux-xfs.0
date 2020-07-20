Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2780AC433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 05:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 035E820758
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 05:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDse7yyb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgGTFi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 01:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGTFi1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 01:38:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECA2C0619D2
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2020 22:38:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u5so8485282pfn.7
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2020 22:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TK5CdTR6UFf9rmSQmh49JPQPiM+liD85kSjrxRzLWKE=;
        b=NDse7yybzVjDJ11imObuWu3MBn6uPbRAf7oiLc2//OQ71QZ2UoaGVSTkEP307j0Gq0
         B7hgWick2aGt2Q8KACGARc5VvyErl0lewWTl9ysA10I5mbazZIWWcts7QlCVpQ+U4oGr
         HZPps9n7meEgVj12NxbeBrXBFtI4CEqnAPpZA6VJ8jNjtVGeqROmXSBN0ydhzBBccWUa
         5pO1tu4AtBnAbpI0XmvfKy5f+XnTH21f8SJ7Atn+ypc2VN7Mdc95ntvPfpAFspp/woKS
         TtwrsqOH+2soExBv5jjj0CDjNdCO4Vjv+APFwxblRwLy8uQ/1DZN7cZwCBMWkANIPa/J
         ZrFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TK5CdTR6UFf9rmSQmh49JPQPiM+liD85kSjrxRzLWKE=;
        b=btMqKzygXysj5axq4Xf0aEn/0lnbz5msb185ppFvF4Ew9N7QEJ+U2i+7Awdp/aS2a6
         /6+nTNmhORlRc2diSafflHfPskTeqNfgYqP1znxsP1kor54sHTVVySsT1E9hO1gt2rnm
         oi2TJim2KgZIAU7IJHajXVqVA5QZi8mQw+cUP1JvZg59Vpmlh5eJg9TUmC486bcY6uer
         hVi3I/RM/sYeF4n6LZLyPWztUM8siTWqdc9rbULSTR7sG3bYSka1n3YIskkv4UPhkJmk
         qqCF6vcEKzAwCPxvGsGFJkDjkf7eB9fjYG97p95tylbe2/ukBwfBzUMVdexrSK09UVy4
         sK6w==
X-Gm-Message-State: AOAM530PtCkjdUll/Nm3k9BO1trf86aVG+ceA5W2YdfsWAzrnUqiEePz
        9adDQauIOM7/QfssJABGx2UTVMuu
X-Google-Smtp-Source: ABdhPJzSbhomWWzhSKMI/YGitpCuDhPpfN5YZkGGCesyftL0yg3SFWWSMUX2Hb4AloS+OVdog6AbVg==
X-Received: by 2002:a63:b508:: with SMTP id y8mr18052553pge.106.1595223506833;
        Sun, 19 Jul 2020 22:38:26 -0700 (PDT)
Received: from garuda.localnet ([122.171.166.148])
        by smtp.gmail.com with ESMTPSA id s30sm14672229pgn.34.2020.07.19.22.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 22:38:26 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/26] xfs: assume the default quota limits are always set in xfs_qm_adjust_dqlimits
Date:   Mon, 20 Jul 2020 11:08:05 +0530
Message-ID: <2472470.UBcdlpre6e@garuda>
In-Reply-To: <159477799136.3263162.16638446868281519003.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477799136.3263162.16638446868281519003.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:23:11 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We always initialize the default quota limits to something nowadays, so
> we don't need to check that the defaults are set to something before
> using them.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_dquot.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index e44f80700005..2b52913073b3 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -77,21 +77,21 @@ xfs_qm_adjust_dqlimits(
>  	ASSERT(dq->q_id);
>  	defq = xfs_get_defquota(q, dq->q_type);
>  
> -	if (defq->blk.soft && !dq->q_blk.softlimit) {
> +	if (!dq->q_blk.softlimit) {
>  		dq->q_blk.softlimit = defq->blk.soft;
>  		prealloc = 1;
>  	}
> -	if (defq->blk.hard && !dq->q_blk.hardlimit) {
> +	if (!dq->q_blk.hardlimit) {
>  		dq->q_blk.hardlimit = defq->blk.hard;
>  		prealloc = 1;
>  	}
> -	if (defq->ino.soft && !dq->q_ino.softlimit)
> +	if (!dq->q_ino.softlimit)
>  		dq->q_ino.softlimit = defq->ino.soft;
> -	if (defq->ino.hard && !dq->q_ino.hardlimit)
> +	if (!dq->q_ino.hardlimit)
>  		dq->q_ino.hardlimit = defq->ino.hard;
> -	if (defq->rtb.soft && !dq->q_rtb.softlimit)
> +	if (!dq->q_rtb.softlimit)
>  		dq->q_rtb.softlimit = defq->rtb.soft;
> -	if (defq->rtb.hard && !dq->q_rtb.hardlimit)
> +	if (!dq->q_rtb.hardlimit)
>  		dq->q_rtb.hardlimit = defq->rtb.hard;
>  
>  	if (prealloc)
> 
> 


-- 
chandan



