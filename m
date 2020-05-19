Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C55C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 07:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E03F2075F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 07:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O1lWKTb5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgESHDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 03:03:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44768 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgESHDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 03:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589871799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bbxb8pdB26nRdLXtY4YQeRdfS1uzHcIGUnA77PK9Bhg=;
        b=O1lWKTb52KJyU8KhGM6R/CXmZZW+WUDgP4BIXoMN1lgR+Nj2nNkMUMRCBX1psHpTPtg6iU
        37JZgcOGXGvDWkC3LMNKlkzdZTEB52nAC+YLeMp9QdRSCxBUFWKpBv9TNiW8hm/DF0DM5X
        4aQsSmrjhf682OIF58vYhu5Ho19MCVc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-9QxMFrqlOUmw0XXqy2ibQg-1; Tue, 19 May 2020 03:03:18 -0400
X-MC-Unique: 9QxMFrqlOUmw0XXqy2ibQg-1
Received: by mail-pl1-f200.google.com with SMTP id q7so9387362plr.4
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 00:03:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bbxb8pdB26nRdLXtY4YQeRdfS1uzHcIGUnA77PK9Bhg=;
        b=LaJY8d7FFctRcThiiSlSIt+h08Aw7Shv1ukVv0j6R18WV+bSpCtGGfsdjB8ZGZ7KwY
         IYAqxjD/vhaiOiUUm7f3eWnsGcj+KFAgyrYe6hIDdb9mYDnos0T5c5EBmDf+/WpsxqiE
         Wg7QbZGkT9/yPX3rJUqgskOIHv08lSTfUWVrbWwaczF23QjX2leB6kdzcVlc5oO265Ue
         xXHpgjDUbkCfaVyxCeQ97p/3jaCJ8mRoZUa+9Vq4cm+So6bzfFCm25jvYJSD4s2OC/68
         s9Tp+nkzwjRrAr0ujLliUhFbg2GxdQ93MrTlv/dV/+4eTHyx6YAYtS0ZPKFpsOUKiWAf
         zt3g==
X-Gm-Message-State: AOAM530DW1odF28iXi3/0Uf5/B0LNwNEoPKDwyMuU9YBTQdo2mhjijH4
        58Q9WEcZ2C//c4Js9KIZZuU2GqpCa/t7vPrX0jDQmM9Z5xJYW93509xkYuNrTYjeDNRky5l9X7x
        mbJtuVuIypAe6JmjTUTS/
X-Received: by 2002:a17:90a:26d1:: with SMTP id m75mr1969246pje.27.1589871797145;
        Tue, 19 May 2020 00:03:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyygdzGqWa3P0G4UwJlqmWBL/w9qJII//WPaSKwWH43+DWfonfzUqCy92xxUZPcZaB+kzgTNg==
X-Received: by 2002:a17:90a:26d1:: with SMTP id m75mr1969225pje.27.1589871796870;
        Tue, 19 May 2020 00:03:16 -0700 (PDT)
Received: from don.don ([60.224.129.195])
        by smtp.gmail.com with ESMTPSA id w192sm10818467pff.126.2020.05.19.00.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 00:03:16 -0700 (PDT)
Subject: Re: [PATCH V2] xfs_repair: fix progress reporting
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Leonardo Vaz <lvaz@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
 <be31d007-5104-e534-eec6-931ff5df5444@redhat.com>
From:   Donald Douwsma <ddouwsma@redhat.com>
Message-ID: <8d81d09c-9bc7-5cf7-4114-85b1e8905940@redhat.com>
Date:   Tue, 19 May 2020 17:03:11 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <be31d007-5104-e534-eec6-931ff5df5444@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 19/05/2020 11:29, Eric Sandeen wrote:
> The Fixes: commit tried to avoid a segfault in case the progress timer
> went off before the first message type had been set up, but this
> had the net effect of short-circuiting the pthread start routine,
> and so the timer didn't get set up at all and we lost all fine-grained
> progress reporting.
> 
> The initial problem occurred when log zeroing took more time than the
> timer interval.
> 
> So, make a new log zeroing progress item and initialize it when we first
> set up the timer thread, to be sure that if the timer goes off while we
> are still zeroing the log, it will be initialized and correct.
> 
> (We can't offer fine-grained status on log zeroing, so it'll go from
> zero to $LOGBLOCKS with nothing in between, but it's unlikely that log
> zeroing will take so long that this really matters.)
> 
> Reported-by: Leonardo Vaz <lvaz@redhat.com>
> Fixes: 7f2d6b811755 ("xfs_repair: avoid segfault if reporting progre...")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

I've been looking at this myself, got stuck writing an xfstest, which this
passes, though the fix I was trying missed at least one of the formatters
that this fixes, and the log zeroing is a nice touch.

Reviewed-by: Donald Douwsma <ddouwsma@redhat.com>

--
Don

> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 40ea2f84..952ac4a5 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -120,6 +120,9 @@ zero_log(
>  			do_error(_("failed to clear log"));
>  	}
>  
> +	/* And we are now magically complete! */
> +	PROG_RPT_INC(prog_rpt_done[0], mp->m_sb.sb_logblocks);
> +
>  	/*
>  	 * Finally, seed the max LSN from the current state of the log if this
>  	 * is a v5 filesystem.
> @@ -160,7 +163,10 @@ phase2(
>  
>  	/* Zero log if applicable */
>  	do_log(_("        - zero log...\n"));
> +
> +	set_progress_msg(PROG_FMT_ZERO_LOG, (uint64_t)mp->m_sb.sb_logblocks);
>  	zero_log(mp);
> +	print_final_rpt();
>  
>  	do_log(_("        - scan filesystem freespace and inode maps...\n"));
>  
> diff --git a/repair/progress.c b/repair/progress.c
> index 5ee08229..e5a9c1ef 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -49,35 +49,37 @@ typedef struct progress_rpt_s {
>  
>  static
>  progress_rpt_t progress_rpt_reports[] = {
> -{FMT1, N_("scanning filesystem freespace"),			/*  0 */
> +{FMT1, N_("zeroing log"),					/*  0 */
> +	&rpt_fmts[FMT1], &rpt_types[TYPE_BLOCK]},
> +{FMT1, N_("scanning filesystem freespace"),			/*  1 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
> -{FMT1, N_("scanning agi unlinked lists"),			/*  1 */
> +{FMT1, N_("scanning agi unlinked lists"),			/*  2 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
> -{FMT2, N_("check uncertain AG inodes"),				/*  2 */
> +{FMT2, N_("check uncertain AG inodes"),				/*  3 */
>  	&rpt_fmts[FMT2], &rpt_types[TYPE_AGI_BUCKET]},
> -{FMT1, N_("process known inodes and inode discovery"),		/*  3 */
> +{FMT1, N_("process known inodes and inode discovery"),		/*  4 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]},
> -{FMT1, N_("process newly discovered inodes"),			/*  4 */
> +{FMT1, N_("process newly discovered inodes"),			/*  5 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
> -{FMT1, N_("setting up duplicate extent list"),			/*  5 */
> +{FMT1, N_("setting up duplicate extent list"),			/*  6 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
> -{FMT1, N_("initialize realtime bitmap"),			/*  6 */
> +{FMT1, N_("initialize realtime bitmap"),			/*  7 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_BLOCK]},
> -{FMT1, N_("reset realtime bitmaps"),				/*  7 */
> +{FMT1, N_("reset realtime bitmaps"),				/*  8 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
> -{FMT1, N_("check for inodes claiming duplicate blocks"),	/*  8 */
> +{FMT1, N_("check for inodes claiming duplicate blocks"),	/*  9 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]},
> -{FMT1, N_("rebuild AG headers and trees"),	 		/*  9 */
> +{FMT1, N_("rebuild AG headers and trees"),	 		/* 10 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
> -{FMT1, N_("traversing filesystem"),				/* 10 */
> +{FMT1, N_("traversing filesystem"),				/* 12 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
> -{FMT2, N_("traversing all unattached subtrees"),		/* 11 */
> +{FMT2, N_("traversing all unattached subtrees"),		/* 12 */
>  	&rpt_fmts[FMT2], &rpt_types[TYPE_DIR]},
> -{FMT2, N_("moving disconnected inodes to lost+found"),		/* 12 */
> +{FMT2, N_("moving disconnected inodes to lost+found"),		/* 13 */
>  	&rpt_fmts[FMT2], &rpt_types[TYPE_INODE]},
> -{FMT1, N_("verify and correct link counts"),			/* 13 */
> +{FMT1, N_("verify and correct link counts"),			/* 14 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
> -{FMT1, N_("verify link counts"),				/* 14 */
> +{FMT1, N_("verify link counts"),				/* 15 */
>  	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]}
>  };
>  
> @@ -125,7 +127,8 @@ init_progress_rpt (void)
>  	 */
>  
>  	pthread_mutex_init(&global_msgs.mutex, NULL);
> -	global_msgs.format = NULL;
> +	/* Make sure the format is set to the first phase and not NULL */
> +	global_msgs.format = &progress_rpt_reports[PROG_FMT_ZERO_LOG];
>  	global_msgs.count = glob_agcount;
>  	global_msgs.interval = report_interval;
>  	global_msgs.done   = prog_rpt_done;
> diff --git a/repair/progress.h b/repair/progress.h
> index 9de9eb72..2c1690db 100644
> --- a/repair/progress.h
> +++ b/repair/progress.h
> @@ -8,26 +8,27 @@
>  #define	PHASE_END		1
>  
>  
> -#define	PROG_FMT_SCAN_AG 	0	/* Phase 2 */
> +#define	PROG_FMT_ZERO_LOG	0	/* Phase 2 */
> +#define	PROG_FMT_SCAN_AG 	1
>  
> -#define	PROG_FMT_AGI_UNLINKED 	1	/* Phase 3 */
> -#define	PROG_FMT_UNCERTAIN      2
> -#define	PROG_FMT_PROCESS_INO	3
> -#define	PROG_FMT_NEW_INODES	4
> +#define	PROG_FMT_AGI_UNLINKED 	2	/* Phase 3 */
> +#define	PROG_FMT_UNCERTAIN      3
> +#define	PROG_FMT_PROCESS_INO	4
> +#define	PROG_FMT_NEW_INODES	5
>  
> -#define	PROG_FMT_DUP_EXTENT	5	/* Phase 4 */
> -#define	PROG_FMT_INIT_RTEXT	6
> -#define	PROG_FMT_RESET_RTBM	7
> -#define	PROG_FMT_DUP_BLOCKS	8
> +#define	PROG_FMT_DUP_EXTENT	6	/* Phase 4 */
> +#define	PROG_FMT_INIT_RTEXT	7
> +#define	PROG_FMT_RESET_RTBM	8
> +#define	PROG_FMT_DUP_BLOCKS	9
>  
> -#define	PROG_FMT_REBUILD_AG	9	/* Phase 5 */
> +#define	PROG_FMT_REBUILD_AG	10	/* Phase 5 */
>  
> -#define	PROG_FMT_TRAVERSAL	10	/* Phase 6 */
> -#define	PROG_FMT_TRAVERSSUB	11
> -#define	PROG_FMT_DISCONINODE	12
> +#define	PROG_FMT_TRAVERSAL	11	/* Phase 6 */
> +#define	PROG_FMT_TRAVERSSUB	12
> +#define	PROG_FMT_DISCONINODE	13
>  
> -#define	PROGRESS_FMT_CORR_LINK	13	/* Phase 7 */
> -#define	PROGRESS_FMT_VRFY_LINK 	14
> +#define	PROGRESS_FMT_CORR_LINK	14	/* Phase 7 */
> +#define	PROGRESS_FMT_VRFY_LINK 	15
>  
>  #define	DURATION_BUF_SIZE	512
>  
> 
> 

