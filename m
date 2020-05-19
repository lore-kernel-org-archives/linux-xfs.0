Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AA1C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 01:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36221207D8
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 01:29:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MakHPpxN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgESB3r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 21:29:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41003 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726276AbgESB3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 21:29:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589851784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=KIvla5Oy65fDRs5AtMYYjopEMRBiFOvpZOLayh7OShU=;
        b=MakHPpxNCHsQWU9IsRBE7Cr7pYPbSnJ+CHMgNoKiwnGhx71x3d8XsqthVRS43i7hmDrZiy
        mBLOtocpQSBJP7inHsoI4pasTHoDyi/+1ZQJHZgyr9qMinh1N4KnoY/Rt6yPxQeMYa8bBA
        4gA34PzE8dn3VyWTVUelNkW1hm8/A6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-Om5yJxcPNECLZ37CU0fgoQ-1; Mon, 18 May 2020 21:29:42 -0400
X-MC-Unique: Om5yJxcPNECLZ37CU0fgoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D79C7107ACF8;
        Tue, 19 May 2020 01:29:41 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FEEB261A1;
        Tue, 19 May 2020 01:29:41 +0000 (UTC)
Subject: [PATCH V2] xfs_repair: fix progress reporting
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Leonardo Vaz <lvaz@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <be31d007-5104-e534-eec6-931ff5df5444@redhat.com>
Date:   Mon, 18 May 2020 20:29:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The Fixes: commit tried to avoid a segfault in case the progress timer
went off before the first message type had been set up, but this
had the net effect of short-circuiting the pthread start routine,
and so the timer didn't get set up at all and we lost all fine-grained
progress reporting.

The initial problem occurred when log zeroing took more time than the
timer interval.

So, make a new log zeroing progress item and initialize it when we first
set up the timer thread, to be sure that if the timer goes off while we
are still zeroing the log, it will be initialized and correct.

(We can't offer fine-grained status on log zeroing, so it'll go from
zero to $LOGBLOCKS with nothing in between, but it's unlikely that log
zeroing will take so long that this really matters.)

Reported-by: Leonardo Vaz <lvaz@redhat.com>
Fixes: 7f2d6b811755 ("xfs_repair: avoid segfault if reporting progre...")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase2.c b/repair/phase2.c
index 40ea2f84..952ac4a5 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -120,6 +120,9 @@ zero_log(
 			do_error(_("failed to clear log"));
 	}
 
+	/* And we are now magically complete! */
+	PROG_RPT_INC(prog_rpt_done[0], mp->m_sb.sb_logblocks);
+
 	/*
 	 * Finally, seed the max LSN from the current state of the log if this
 	 * is a v5 filesystem.
@@ -160,7 +163,10 @@ phase2(
 
 	/* Zero log if applicable */
 	do_log(_("        - zero log...\n"));
+
+	set_progress_msg(PROG_FMT_ZERO_LOG, (uint64_t)mp->m_sb.sb_logblocks);
 	zero_log(mp);
+	print_final_rpt();
 
 	do_log(_("        - scan filesystem freespace and inode maps...\n"));
 
diff --git a/repair/progress.c b/repair/progress.c
index 5ee08229..e5a9c1ef 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -49,35 +49,37 @@ typedef struct progress_rpt_s {
 
 static
 progress_rpt_t progress_rpt_reports[] = {
-{FMT1, N_("scanning filesystem freespace"),			/*  0 */
+{FMT1, N_("zeroing log"),					/*  0 */
+	&rpt_fmts[FMT1], &rpt_types[TYPE_BLOCK]},
+{FMT1, N_("scanning filesystem freespace"),			/*  1 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, N_("scanning agi unlinked lists"),			/*  1 */
+{FMT1, N_("scanning agi unlinked lists"),			/*  2 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT2, N_("check uncertain AG inodes"),				/*  2 */
+{FMT2, N_("check uncertain AG inodes"),				/*  3 */
 	&rpt_fmts[FMT2], &rpt_types[TYPE_AGI_BUCKET]},
-{FMT1, N_("process known inodes and inode discovery"),		/*  3 */
+{FMT1, N_("process known inodes and inode discovery"),		/*  4 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]},
-{FMT1, N_("process newly discovered inodes"),			/*  4 */
+{FMT1, N_("process newly discovered inodes"),			/*  5 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, N_("setting up duplicate extent list"),			/*  5 */
+{FMT1, N_("setting up duplicate extent list"),			/*  6 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, N_("initialize realtime bitmap"),			/*  6 */
+{FMT1, N_("initialize realtime bitmap"),			/*  7 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_BLOCK]},
-{FMT1, N_("reset realtime bitmaps"),				/*  7 */
+{FMT1, N_("reset realtime bitmaps"),				/*  8 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, N_("check for inodes claiming duplicate blocks"),	/*  8 */
+{FMT1, N_("check for inodes claiming duplicate blocks"),	/*  9 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_INODE]},
-{FMT1, N_("rebuild AG headers and trees"),	 		/*  9 */
+{FMT1, N_("rebuild AG headers and trees"),	 		/* 10 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, N_("traversing filesystem"),				/* 10 */
+{FMT1, N_("traversing filesystem"),				/* 12 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT2, N_("traversing all unattached subtrees"),		/* 11 */
+{FMT2, N_("traversing all unattached subtrees"),		/* 12 */
 	&rpt_fmts[FMT2], &rpt_types[TYPE_DIR]},
-{FMT2, N_("moving disconnected inodes to lost+found"),		/* 12 */
+{FMT2, N_("moving disconnected inodes to lost+found"),		/* 13 */
 	&rpt_fmts[FMT2], &rpt_types[TYPE_INODE]},
-{FMT1, N_("verify and correct link counts"),			/* 13 */
+{FMT1, N_("verify and correct link counts"),			/* 14 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]},
-{FMT1, N_("verify link counts"),				/* 14 */
+{FMT1, N_("verify link counts"),				/* 15 */
 	&rpt_fmts[FMT1], &rpt_types[TYPE_AG]}
 };
 
@@ -125,7 +127,8 @@ init_progress_rpt (void)
 	 */
 
 	pthread_mutex_init(&global_msgs.mutex, NULL);
-	global_msgs.format = NULL;
+	/* Make sure the format is set to the first phase and not NULL */
+	global_msgs.format = &progress_rpt_reports[PROG_FMT_ZERO_LOG];
 	global_msgs.count = glob_agcount;
 	global_msgs.interval = report_interval;
 	global_msgs.done   = prog_rpt_done;
diff --git a/repair/progress.h b/repair/progress.h
index 9de9eb72..2c1690db 100644
--- a/repair/progress.h
+++ b/repair/progress.h
@@ -8,26 +8,27 @@
 #define	PHASE_END		1
 
 
-#define	PROG_FMT_SCAN_AG 	0	/* Phase 2 */
+#define	PROG_FMT_ZERO_LOG	0	/* Phase 2 */
+#define	PROG_FMT_SCAN_AG 	1
 
-#define	PROG_FMT_AGI_UNLINKED 	1	/* Phase 3 */
-#define	PROG_FMT_UNCERTAIN      2
-#define	PROG_FMT_PROCESS_INO	3
-#define	PROG_FMT_NEW_INODES	4
+#define	PROG_FMT_AGI_UNLINKED 	2	/* Phase 3 */
+#define	PROG_FMT_UNCERTAIN      3
+#define	PROG_FMT_PROCESS_INO	4
+#define	PROG_FMT_NEW_INODES	5
 
-#define	PROG_FMT_DUP_EXTENT	5	/* Phase 4 */
-#define	PROG_FMT_INIT_RTEXT	6
-#define	PROG_FMT_RESET_RTBM	7
-#define	PROG_FMT_DUP_BLOCKS	8
+#define	PROG_FMT_DUP_EXTENT	6	/* Phase 4 */
+#define	PROG_FMT_INIT_RTEXT	7
+#define	PROG_FMT_RESET_RTBM	8
+#define	PROG_FMT_DUP_BLOCKS	9
 
-#define	PROG_FMT_REBUILD_AG	9	/* Phase 5 */
+#define	PROG_FMT_REBUILD_AG	10	/* Phase 5 */
 
-#define	PROG_FMT_TRAVERSAL	10	/* Phase 6 */
-#define	PROG_FMT_TRAVERSSUB	11
-#define	PROG_FMT_DISCONINODE	12
+#define	PROG_FMT_TRAVERSAL	11	/* Phase 6 */
+#define	PROG_FMT_TRAVERSSUB	12
+#define	PROG_FMT_DISCONINODE	13
 
-#define	PROGRESS_FMT_CORR_LINK	13	/* Phase 7 */
-#define	PROGRESS_FMT_VRFY_LINK 	14
+#define	PROGRESS_FMT_CORR_LINK	14	/* Phase 7 */
+#define	PROGRESS_FMT_VRFY_LINK 	15
 
 #define	DURATION_BUF_SIZE	512
 


