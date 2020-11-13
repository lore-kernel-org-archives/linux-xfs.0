Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703E2C388F7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 09:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086BE2145D
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 09:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2VTZ9SG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgKMJIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 04:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMJId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 04:08:33 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CE0C0613D1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:08:33 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id f27so6613259pgl.1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zloahej5/iacxM6z8FJU9ll4sVB6Hivp344g5U9mQbw=;
        b=H2VTZ9SG7RcfaoU31zutgFesQJXLttKOUSmO43CeczIgQ6yIQtpYhRTcWdQdmJbdcU
         oqvO36xDXxkNwyi+fDT5lHftRVrAYAqb1BlMxth8d7satFC6h1BtPhCAKefFddzKj+7w
         NzKkDDhHk01bl3yb+TgvzjiP/HeUlpcUuIhX/S+LYtuuoTlReTXWMPgYqKQ3yyYJ1C4T
         +Xl/65+VKbGcZnuSemv2vqWRcWm9tjfNJPWuCa6P2tgGZkuqYpbPzXJPZVcE/OjVVRFO
         atbSvRI/nnIZLx5ztHJJFLunXOivAYKXCypu1ANQLa8l5vhsL/nXYGKzUUDvHuKeBb0e
         xKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zloahej5/iacxM6z8FJU9ll4sVB6Hivp344g5U9mQbw=;
        b=V7Fc/e1fpn98LAbogieh68ov9ZOotelnP8ZK9MsBw+xFSzwWh9JcpXYG+U5u3agbwu
         PnhAbC6TGgJ9FCe1uo+XFk0C3r7+zR9SnGwdE4uhSgj0jsoqepIFe3LFRDtvnV18Z+XQ
         A13ArLQLfDPotvBGiqZWI3lXVfLQ9+xXtlRHWN0QhNKpUHOjwbbaOUyd14spvWxqWPqd
         agPMPs4Mx+n5o6I4JlSWNOf2CQi4d1hV9MRctZBIOUDw4rCoQXRq8Os2cbJJi/x3N60z
         8nN1RAEnMRAYZqyGYqifAuAWBC76CCFqUYhOKnKKHsIW8QvL+MahBdwBFC8b/c+dCLU0
         qQYw==
X-Gm-Message-State: AOAM530WWHtgb35U97em37fS4djx5s9mQ5kuBXufiVvl2Oa+zkcMsOXb
        +wrXuo4HhfhRem5x61MeibsarKkbY6c=
X-Google-Smtp-Source: ABdhPJw97h3iF/ppOvrMt4GT+CClBzWGYan1hF1eZkcYtIn3Iel2lIxoQSKKuyzjedyFJdVB+8evWQ==
X-Received: by 2002:a63:8c51:: with SMTP id q17mr1301631pgn.241.1605258513335;
        Fri, 13 Nov 2020 01:08:33 -0800 (PST)
Received: from garuda.localnet ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id k9sm8782376pfi.188.2020.11.13.01.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 01:08:32 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/4] xfs: directory scrub should check the null bestfree entries too
Date:   Fri, 13 Nov 2020 14:38:30 +0530
Message-ID: <23267072.YfSsYFqK8s@garuda>
In-Reply-To: <160494587794.772802.11043398495774645870.stgit@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia> <160494587794.772802.11043398495774645870.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 9 November 2020 11:47:58 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach the directory scrubber to check all the bestfree entries,
> including the null ones.  We want to be able to detect the case where
> the entry is null but there actually /is/ a directory data block.
> 
> Found by fuzzing lbests[0] = ones in xfs/391.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: df481968f33b ("xfs: scrub directory freespace")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/dir.c |   27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 7c432997edad..b045e95c2ea7 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -558,14 +558,27 @@ xchk_directory_leaf1_bestfree(
>  	/* Check all the bestfree entries. */
>  	for (i = 0; i < bestcount; i++, bestp++) {
>  		best = be16_to_cpu(*bestp);
> +		error = xfs_dir3_data_read(sc->tp, sc->ip,
> +				xfs_dir2_db_to_da(args->geo, i),
> +				XFS_DABUF_MAP_HOLE_OK,
> +				&dbp);
> +		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
> +				&error))
> +			break;
> +
> +		if (!dbp) {
> +			if (best != NULLDATAOFF) {
> +				xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
> +						lblk);
> +				break;
> +			}
> +			continue;
> +		}
> +
>  		if (best == NULLDATAOFF)
> -			continue;
> -		error = xfs_dir3_data_read(sc->tp, sc->ip,
> -				i * args->geo->fsbcount, 0, &dbp);
> -		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
> -				&error))
> -			break;
> -		xchk_directory_check_freesp(sc, lblk, dbp, best);
> +			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> +		else
> +			xchk_directory_check_freesp(sc, lblk, dbp, best);
>  		xfs_trans_brelse(sc->tp, dbp);
>  		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  			break;
> 
> 


-- 
chandan



