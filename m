Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4189C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4440C2224E
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tYvVuw60"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgJOILt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbgJOILt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:11:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCBBC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:11:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u3so1520804pjr.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ebXNyxmF8NcXtmXeyBJBfXgW+TYvXn7I/Zuz09K0zDM=;
        b=tYvVuw60w3zwh+/snWjaKxJaxjL0c2KYKJgIeAJjMwF/BzWsyPyxe9TkP1o2M/T8Gh
         79ZRbj6kAReRSEA3IwGH6Z5V4LHBpThFNQY1i2hKjAt7DxgsgJ2fAFmyPB9wKjXVrFRX
         NsWpcFvV/Q3kvpk9OyxJDQc3LhdaC1WDB3bk9iGGeftF2LZ9rQUQN9AT0n0L5OzmTmYp
         mbC8TY3WBe83wNBUtkVK6HV9TUjZzgiIVH0IqTHpkd0uf35f2eT2xW/Mii8VUSoJ0W5v
         RwCF4Dr5mo4Vj1YO/Ivj1Edod7W6qn43R8fBv8TBld0J3JzC9/Ydphvr+U3OFn/WRClS
         Nt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebXNyxmF8NcXtmXeyBJBfXgW+TYvXn7I/Zuz09K0zDM=;
        b=UFU3qQxBjnodms0PqjE0hJO8Z55JTs82ZqKFpzI/ULf2oqHnuchXa7+ZEaABHZASl+
         rwArk0Ns6uqok9FuOmTXnP8OVwB7JbM8Yo7m2pZilgIRhfYGyCmOm3cZt8JUJNaW/NLG
         yYnbVU+6Z+LpQlrPWHS/htSXNnQ8IPUL+ZiEEUYUjLxc818vIfX7XkT1sVYgLKMPdAIW
         ifS3PyD/8wh5lYZ701pSn78eDl6dPhPaavCFsLiiQilJ+a+NISDHmEtEek44t7KT9HHq
         lgFBFYYII2FISfbE3fhEqBW2OJJ9GrX3YKnXpAVoE6Q4WYyWpEEM532NxAo4E4sw4Kma
         1HXw==
X-Gm-Message-State: AOAM5337NhS+ZpvhNxvHsSh6PVfIqVbrOHzpiBT9xet8W5SE5gIp0Ob8
        3+kKNfNviLkLIU6N1iMMCjAbOG6fE1M=
X-Google-Smtp-Source: ABdhPJyMCCEfcas8D6JqNOq9ykNi7aAJ4FY8ZIU7i+5qZjfYTz/dlE7gQZoCY+UmCU6n8QCM5YNvtA==
X-Received: by 2002:a17:90a:450d:: with SMTP id u13mr3183156pjg.148.1602749508080;
        Thu, 15 Oct 2020 01:11:48 -0700 (PDT)
Received: from garuda.localnet ([122.167.224.49])
        by smtp.gmail.com with ESMTPSA id l3sm2244095pju.28.2020.10.15.01.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 01:11:47 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Allison Collins <allison.henderson@oracle.com>,
        Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: fix high key handling in the rt allocator's query_range function
Date:   Thu, 15 Oct 2020 13:41:43 +0530
Message-ID: <3740144.kZTAeIQyPV@garuda>
In-Reply-To: <20201013165853.GC9832@magnolia>
References: <20201013165853.GC9832@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 13 October 2020 10:28:53 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix some off-by-one errors in xfs_rtalloc_query_range.  The highest key
> in the realtime bitmap is always one less than the number of rt extents,
> which means that the key clamp at the start of the function is wrong.
> The 4th argument to xfs_rtfind_forw is the highest rt extent that we
> want to probe, which means that passing 1 less than the high key is
> wrong.  Finally, drop the rem variable that controls the loop because we
> can compare the iteration point (rtstart) against the high key directly.
> 
> The sordid history of this function is that the original commit (fb3c3)
> incorrectly passed (high_rec->ar_startblock - 1) as the 'limit' parameter
> to xfs_rtfind_forw.  This was wrong because the "high key" is supposed
> to be the largest key for which the caller wants result rows, not the
> key for the first row that could possibly be outside the range that the
> caller wants to see.
> 
> A subsequent attempt (8ad56) to strengthen the parameter checking added
> incorrect clamping of the parameters to the number of rt blocks in the
> system (despite the bitmap functions all taking units of rt extents) to
> avoid querying ranges past the end of rt bitmap file but failed to fix
> the incorrect _rtfind_forw parameter.  The original _rtfind_forw
> parameter error then survived the conversion of the startblock and
> blockcount fields to rt extents (a0e5c), and the most recent off-by-one
> fix (a3a37) thought it was patching a problem when the end of the rt
> volume is not in use, but none of these fixes actually solved the
> original problem that the author was confused about the "limit" argument
> to xfs_rtfind_forw.
> 
> Sadly, all four of these patches were written by this author and even
> his own usage of this function and rt testing were inadequate to get
> this fixed quickly.
>

The high key being the minimum of (number of rtextents - 1, high key passed by
userspace) is correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Original-problem: fb3c3de2f65c ("xfs: add a couple of queries to iterate free extents in the rtbitmap")
> Not-fixed-by: 8ad560d2565e ("xfs: strengthen rtalloc query range checks")
> Not-fixed-by: a0e5c435babd ("xfs: fix xfs_rtalloc_rec units")
> Fixes: a3a374bf1889 ("xfs: fix off-by-one error in xfs_rtalloc_query_range")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 1d9fa8a300f1..6c1aba16113c 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1018,7 +1018,6 @@ xfs_rtalloc_query_range(
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	xfs_rtblock_t			rtstart;
>  	xfs_rtblock_t			rtend;
> -	xfs_rtblock_t			rem;
>  	int				is_free;
>  	int				error = 0;
>  
> @@ -1027,13 +1026,12 @@ xfs_rtalloc_query_range(
>  	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
>  	    low_rec->ar_startext == high_rec->ar_startext)
>  		return 0;
> -	if (high_rec->ar_startext > mp->m_sb.sb_rextents)
> -		high_rec->ar_startext = mp->m_sb.sb_rextents;
> +	high_rec->ar_startext = min(high_rec->ar_startext,
> +			mp->m_sb.sb_rextents - 1);
>  
>  	/* Iterate the bitmap, looking for discrepancies. */
>  	rtstart = low_rec->ar_startext;
> -	rem = high_rec->ar_startext - rtstart;
> -	while (rem) {
> +	while (rtstart <= high_rec->ar_startext) {
>  		/* Is the first block free? */
>  		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
>  				&is_free);
> @@ -1042,7 +1040,7 @@ xfs_rtalloc_query_range(
>  
>  		/* How long does the extent go for? */
>  		error = xfs_rtfind_forw(mp, tp, rtstart,
> -				high_rec->ar_startext - 1, &rtend);
> +				high_rec->ar_startext, &rtend);
>  		if (error)
>  			break;
>  
> @@ -1055,7 +1053,6 @@ xfs_rtalloc_query_range(
>  				break;
>  		}
>  
> -		rem -= rtend - rtstart + 1;
>  		rtstart = rtend + 1;
>  	}
>  
> 


-- 
chandan



