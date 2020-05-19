Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D69C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 02:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72FCF206D4
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 02:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0L2kSDB2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgESCEx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 22:04:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32984 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgESCEw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 22:04:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J23Qjx121600;
        Tue, 19 May 2020 02:04:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hmLKGPlqp3SL90qqAtKiDJMVFtNtiotmKuc68HSAxj4=;
 b=0L2kSDB25/8RmTao0kdPtfkSsVljhAUral4+2AD19ehztt7AWARYH9WQOkTYCiYJ8urY
 5/htQU0RcBiwL31h8XqtDQYxBQ/kWYqnvUUz8bYf3jq25xFmhtAJuSOkPlsvJuPyKT71
 f1LkzuwaNxXD5KzZg56jq5iT6Ak3+/mvWGsfQbvR+RhvPUvp6TSX4Wa/asEc/qrBTV+q
 Q7h2SqhF/5wjHWwlqkR6I4jF9iAm1Xzt2MHcDLkA2O9ZXdosp+mgQlILpVkRwx33h5x7
 Z+jLoPrktNlAym2wW5iYSqxeTeaE1hTbiUhGUA05rcmF8EZ4W8MQMYIx9qs3Vx6SSg/1 Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tna809-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 02:04:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J1wLqs112077;
        Tue, 19 May 2020 02:04:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 312t3wuv53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 02:04:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04J24lTk017972;
        Tue, 19 May 2020 02:04:47 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 19:04:47 -0700
Date:   Mon, 18 May 2020 19:04:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Leonardo Vaz <lvaz@redhat.com>
Subject: Re: [PATCH V2] xfs_repair: fix progress reporting
Message-ID: <20200519020444.GF17635@magnolia>
References: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
 <be31d007-5104-e534-eec6-931ff5df5444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be31d007-5104-e534-eec6-931ff5df5444@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=1 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 08:29:40PM -0500, Eric Sandeen wrote:
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

Fixable in a separate patch if anyone else is motivated <wink>...

> Reported-by: Leonardo Vaz <lvaz@redhat.com>
> Fixes: 7f2d6b811755 ("xfs_repair: avoid segfault if reporting progre...")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
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
