Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42B0C636D3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjBIWSm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjBIWSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:37 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CE169537
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:34 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id k13so4591906plg.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xin3lhPINgxQ/vw661cQaP/j5HNHxYnfWw/wAiiKWBU=;
        b=Mv8Go6jsYihhqngiNo6s7k2YTS2RicjtYIueI54D29axcch+Gp/TLaE9+g4SqZ7H4/
         Y7tYao04UpMPpuTlttMuFM7KMZvWoaFkoNCjJ9MVrv8rR/cX9QGossqmsu810RNVl1sE
         RbJcEN6jBiKrzIywBudmAscD/zh6k5oeHNJWnK3sVs4QicKzBl7FCj/tAxuftGyQ3GTB
         AssM6gNfwgfpodmZtoAEC2vny170pDflSkKuuhJAgpaFHs2jSImP1pwciiq4l6KDpw7l
         V7Y3yrmpwkqm/bodKyV2mcv5jXOTsq/km9Nx8ZtB1iuFtfUaIiWH9N3eSO1+1YY6w3QS
         91hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xin3lhPINgxQ/vw661cQaP/j5HNHxYnfWw/wAiiKWBU=;
        b=auv+BeiZF643vO5Mo7GHmFzpVnGveIKlqo1ocPAIPF7e64k4AAgrTpV94ZPggldbdW
         sIu2nO16qEMw+M2esbDHKnodM1AfxoTv04hM9yp1k4GRv6DDptzIEIrN5KoH8RB7Rv0q
         NWAxI6npb2mjaNHobbYtG1BybC+wJtAGEoCJahhW1gZEqqs4T848eS1ziARniOFAdNnP
         2y6qpWeSF2jlwRtgluzJCSyVr0HJkWr01lpDOrV8G9IWU3YT5QEMzqcchhRyibjev6mH
         UroTfbVuz7f3ECn+pAlDim46dNb7WLupN6GMZ4ELh68J+m+Pc9b/FcnZ4r7f5m/0chJT
         8CSw==
X-Gm-Message-State: AO0yUKUacTOQIoGSSOUFzWT52v80zTgC2y7F0NRddNlPVNyU6mYglawR
        2kFQ1qdn64eBUkSwh5jM3v1uo46JKfiiisei
X-Google-Smtp-Source: AK7set/22Bk2f8O7uDRyqdbSA3rbYZpAQQN6feIqzJyX0wcp+0o0X/PTnznuFEmWamCy6I/bWJkvVQ==
X-Received: by 2002:a17:903:12d7:b0:198:adc4:22a4 with SMTP id io23-20020a17090312d700b00198adc422a4mr5616290plb.31.1675981113720;
        Thu, 09 Feb 2023 14:18:33 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id a7-20020a1709027e4700b001943d58268csm2011010pln.55.2023.02.09.14.18.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:31 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOV2-1s
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcMS-08
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/42] xfs: rework the perag trace points to be perag centric
Date:   Fri, 10 Feb 2023 09:17:51 +1100
Message-Id: <20230209221825.3722244-9-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So that they all output the same information in the traces to make
debugging refcount issues easier.

This means that all the lookup/drop functions no longer need to use
the full memory barrier atomic operations (atomic*_return()) so
will have less overhead when tracing is off. The set/clear tag
tracepoints no longer abuse the reference count to pass the tag -
the tag being cleared is obvious from the _RET_IP_ that is recorded
in the trace point.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 25 +++++++++----------------
 fs/xfs/xfs_icache.c    |  4 ++--
 fs/xfs/xfs_trace.h     | 21 +++++++++++----------
 3 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 46e25c682bf4..7cff61875340 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -44,16 +44,15 @@ xfs_perag_get(
 	xfs_agnumber_t		agno)
 {
 	struct xfs_perag	*pag;
-	int			ref = 0;
 
 	rcu_read_lock();
 	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
 	if (pag) {
+		trace_xfs_perag_get(pag, _RET_IP_);
 		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		ref = atomic_inc_return(&pag->pag_ref);
+		atomic_inc(&pag->pag_ref);
 	}
 	rcu_read_unlock();
-	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
 	return pag;
 }
 
@@ -68,7 +67,6 @@ xfs_perag_get_tag(
 {
 	struct xfs_perag	*pag;
 	int			found;
-	int			ref;
 
 	rcu_read_lock();
 	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
@@ -77,9 +75,9 @@ xfs_perag_get_tag(
 		rcu_read_unlock();
 		return NULL;
 	}
-	ref = atomic_inc_return(&pag->pag_ref);
+	trace_xfs_perag_get_tag(pag, _RET_IP_);
+	atomic_inc(&pag->pag_ref);
 	rcu_read_unlock();
-	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
 	return pag;
 }
 
@@ -87,11 +85,9 @@ void
 xfs_perag_put(
 	struct xfs_perag	*pag)
 {
-	int	ref;
-
+	trace_xfs_perag_put(pag, _RET_IP_);
 	ASSERT(atomic_read(&pag->pag_ref) > 0);
-	ref = atomic_dec_return(&pag->pag_ref);
-	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
+	atomic_dec(&pag->pag_ref);
 }
 
 /*
@@ -110,8 +106,7 @@ xfs_perag_grab(
 	rcu_read_lock();
 	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
 	if (pag) {
-		trace_xfs_perag_grab(mp, pag->pag_agno,
-				atomic_read(&pag->pag_active_ref), _RET_IP_);
+		trace_xfs_perag_grab(pag, _RET_IP_);
 		if (!atomic_inc_not_zero(&pag->pag_active_ref))
 			pag = NULL;
 	}
@@ -138,8 +133,7 @@ xfs_perag_grab_tag(
 		rcu_read_unlock();
 		return NULL;
 	}
-	trace_xfs_perag_grab_tag(mp, pag->pag_agno,
-			atomic_read(&pag->pag_active_ref), _RET_IP_);
+	trace_xfs_perag_grab_tag(pag, _RET_IP_);
 	if (!atomic_inc_not_zero(&pag->pag_active_ref))
 		pag = NULL;
 	rcu_read_unlock();
@@ -150,8 +144,7 @@ void
 xfs_perag_rele(
 	struct xfs_perag	*pag)
 {
-	trace_xfs_perag_rele(pag->pag_mount, pag->pag_agno,
-			atomic_read(&pag->pag_active_ref), _RET_IP_);
+	trace_xfs_perag_rele(pag, _RET_IP_);
 	if (atomic_dec_and_test(&pag->pag_active_ref))
 		wake_up(&pag->pag_active_wq);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0f4a014dded3..8b2823d85a68 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -255,7 +255,7 @@ xfs_perag_set_inode_tag(
 		break;
 	}
 
-	trace_xfs_perag_set_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
+	trace_xfs_perag_set_inode_tag(pag, _RET_IP_);
 }
 
 /* Clear a tag on both the AG incore inode tree and the AG radix tree. */
@@ -289,7 +289,7 @@ xfs_perag_clear_inode_tag(
 	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno, tag);
 	spin_unlock(&mp->m_perag_lock);
 
-	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
+	trace_xfs_perag_clear_inode_tag(pag, _RET_IP_);
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eb5e49d44f13..1d99c30f66f0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -159,33 +159,34 @@ TRACE_EVENT(xlog_intent_recovery_failed,
 );
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
-		 unsigned long caller_ip),
-	TP_ARGS(mp, agno, refcount, caller_ip),
+	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip),
+	TP_ARGS(pag, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(int, refcount)
+		__field(int, active_refcount)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->refcount = refcount;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->refcount = atomic_read(&pag->pag_ref);
+		__entry->active_refcount = atomic_read(&pag->pag_active_ref);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno 0x%x refcount %d caller %pS",
+	TP_printk("dev %d:%d agno 0x%x passive refs %d active refs %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->refcount,
+		  __entry->active_refcount,
 		  (char *)__entry->caller_ip)
 );
 
 #define DEFINE_PERAG_REF_EVENT(name)	\
 DEFINE_EVENT(xfs_perag_class, name,	\
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
-		 unsigned long caller_ip),					\
-	TP_ARGS(mp, agno, refcount, caller_ip))
+	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip), \
+	TP_ARGS(pag, caller_ip))
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
 DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
-- 
2.39.0

