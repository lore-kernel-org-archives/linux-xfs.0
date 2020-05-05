Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F97C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E104B206A5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRMwTR2Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgEENn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 09:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728954AbgEENn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 09:43:26 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12332C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 06:43:26 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h11so827761plr.11
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 06:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e1maqNRGZq62qTdawhJF+h1G2+aca9NQERsy515O6Uo=;
        b=PRMwTR2YYwwv2ONkFIK9J4AF8PZ8xm7E6TB5aPx9APgJXAZb++IzlkbolQxXhYwnon
         pcz8OjGenFI7BUXGUZeOHqZHVB3ARqWRC2TTg++h2DMV/tA/ZbMpZERyOy0KiCHrugww
         MNhWaDypx3kkw028Apb+64Ni8156PDCuyexayeERf3/FaNwkSDjVGtmOTe8oIT8kKyLz
         4ZLLeolMX3WJtcDVXF5hRxHSnAkclDDiEPO+m/0goRoJNVVZNhpYKEaATJMyXQZrUxwe
         AxHJeNTDDPX1J2caS1paoQqb4gBTd5nx3mgGg1GB2S8l/GTUzGXKThA3PqmHxFFJzSll
         rZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e1maqNRGZq62qTdawhJF+h1G2+aca9NQERsy515O6Uo=;
        b=cbwZ/SknnAKAfA25L9256Y0owSYR3+iFqZuDcvlJTdFb+aD2UlDDBSkboQ8ChP8wQN
         +A8ioG1ViLZeT4zOkwTJevQDk41cEKEieik0NkXrAVz0eWdC0nHgyD9p81Bn3JgouHCS
         NyZNEJ6LwdBSDjHsdHHaf/o9zfHQ7wShwXrPFVIWwNEvPZpN81oBlWQtXucP1sEW4GNQ
         CLN0MN4hc7hN4Q5iHOWrM7qBvfCs88OOCgKnpyIoSYVJX+xQnRRjH2Ak5OZpEDbUMnFv
         9NiFa4RXcaZ1go57KtgU5ZVPu/+crXlWakrYQ55LmeaBlqyFyez4xUhao6gEUkSEGWIc
         9duw==
X-Gm-Message-State: AGi0PubEXKdnnw8+G3/Z26+p5xFIFhunFk/DxWCdnRMY6YRvaY4Wir6t
        8uBBV+iEuLnZY3nXnTJYrY4=
X-Google-Smtp-Source: APiQypJTn8/UxSdyzU65xpBcZ4w5cztl9CzChJaQwrmBJ3A5+P/iiKEcNKc3/B1GVO80p5J6gC1ZqQ==
X-Received: by 2002:a17:90a:9e9:: with SMTP id 96mr3260899pjo.41.1588686205505;
        Tue, 05 May 2020 06:43:25 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id q21sm1573786pgc.76.2020.05.05.06.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 06:43:24 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/28] xfs: report iunlink recovery failure upwards
Date:   Tue, 05 May 2020 19:13:22 +0530
Message-ID: <9081924.4ErFf4OaHu@garuda>
In-Reply-To: <158864116132.182683.16387605365627894770.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864116132.182683.16387605365627894770.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:42:41 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we fail to recover unlinked inodes due to corruption or whatnot, we
> should report this upwards and fail the mount instead of continuing on
> like nothing's wrong.  Eventually the user will trip over the busted
> AGI anyway.

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_recover.h |    2 +-
>  fs/xfs/xfs_log.c                |    4 +++-
>  fs/xfs/xfs_log_recover.c        |    7 ++++++-
>  fs/xfs/xfs_unlink_recover.c     |    4 +++-
>  4 files changed, 13 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 33c14dd22b77..d4d6d4f84fda 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -124,6 +124,6 @@ bool xlog_add_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  bool xlog_put_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  void xlog_recover_iodone(struct xfs_buf *bp);
> -void xlog_recover_process_unlinked(struct xlog *log);
> +int xlog_recover_process_unlinked(struct xlog *log);
>  
>  #endif	/* __XFS_LOG_RECOVER_H__ */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00fda2e8e738..8203b9b0fd08 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -727,6 +727,8 @@ xfs_log_mount_finish(
>  		xfs_log_work_queue(mp);
>  	mp->m_super->s_flags &= ~SB_ACTIVE;
>  	evict_inodes(mp->m_super);
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * Drain the buffer LRU after log recovery. This is required for v4
> @@ -737,7 +739,7 @@ xfs_log_mount_finish(
>  	 * Don't push in the error case because the AIL may have pending intents
>  	 * that aren't removed until recovery is cancelled.
>  	 */
> -	if (!error && recovered) {
> +	if (recovered) {
>  		xfs_log_force(mp, XFS_LOG_SYNC);
>  		xfs_ail_push_all_sync(mp->m_ail);
>  	}
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 362296b34490..0ccc09c004f1 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3399,7 +3399,12 @@ xlog_recover_finish(
>  		 */
>  		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
>  
> -		xlog_recover_process_unlinked(log);
> +		error = xlog_recover_process_unlinked(log);
> +		if (error) {
> +			xfs_alert(log->l_mp,
> +					"Failed to recover unlinked metadata");
> +			return error;
> +		}
>  
>  		xlog_recover_check_summary(log);
>  
> diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
> index 413b34085640..fe7fa3d623f2 100644
> --- a/fs/xfs/xfs_unlink_recover.c
> +++ b/fs/xfs/xfs_unlink_recover.c
> @@ -195,7 +195,7 @@ xlog_recover_process_iunlinked(
>  	return 0;
>  }
>  
> -void
> +int
>  xlog_recover_process_unlinked(
>  	struct xlog		*log)
>  {
> @@ -208,4 +208,6 @@ xlog_recover_process_unlinked(
>  		if (error)
>  			break;
>  	}
> +
> +	return error;
>  }
> 
> 


-- 
chandan



