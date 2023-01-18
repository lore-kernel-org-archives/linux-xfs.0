Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFFEC38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjARWp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjARWpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:16 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD08E63E30
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id jm10so527700plb.13
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZlJuun7fbj9t0bGBLGRzQARvJ3Wnft9vSoK15nvUeHo=;
        b=ZJCdUGc3MMXR6hCQyWJBQ+hSE2m0qEEp7pfOXILH/JQDAki055OKjgCu29TN6xXCZd
         R+GB5yy8ME7kcLZtFFPOG2x1ACHE8nbZeU7/KQueVgbuSeWwmvsZln5HXM6qm6YcFuzJ
         B9R0z0pdVSxjA0Ja72VQykiDjFPOraeT0miImmSWT97Szw2Q1m3uPNvNBRP1Fj9CCaq5
         jcVAYHgFWai6koo4xs/aOqzdUQDsKEeEHSrq+0EmtAK4FpS8DrZAIfFIHDRShqqn0iC6
         xRrM5KAKTOFQ44cBXHhCr0lSMxoD3TaJiSMZzbIBkD+anrj/efpoPaRzpBsCRCGphjSy
         EYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZlJuun7fbj9t0bGBLGRzQARvJ3Wnft9vSoK15nvUeHo=;
        b=bA9WkNivIpYhoBlEAVlXC2nBBUlJOcxUqJ8OEJy3YtO+wlDi8tCRb9EGMEzhO/XBpi
         Oci+8MPEyS5rgdQAMHmvyG2MD80X42gm1lNeLGlRVDfn30SLVGJLAcVk4Xd8PH65IDgq
         bt1HfUZFcqqX8QI6C2XVUkSs3WkSgC1LB/rQhbcj3k0WUIBpa6UTSqkAgLN4wUO4r/mH
         3YJZpvz/vSknnhiZF4K7CcDni7odoJRl4lCHj9USAvpPFdj1HIH1cENQrr9t1wJ20cCk
         Q85JNmf+400Zk6ibIx2WwJuAJY0orthnAgJnm65Nsy98NxTSBl5Ui/FzuCBUTWWKT22T
         emdg==
X-Gm-Message-State: AFqh2kriv0T+vPKyY8CLoefDxdOCR0d28GzHAWBcb90tJoGkVRYhN/Mn
        3EjXpRrP5NkxGhOmSmBxIfpK+nP83HOAVED/
X-Google-Smtp-Source: AMrXdXuoHQZf2EIyKVLKZNkz1WcH81/aGOX2gwKas1V9MPmScMLw+Cl7bFebRiIm8VOADZty/NFokQ==
X-Received: by 2002:a05:6a21:9998:b0:b8:2e75:c973 with SMTP id ve24-20020a056a21999800b000b82e75c973mr13376476pzb.49.1674081914187;
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id 8-20020a631448000000b004b25a51d6f4sm16526185pgu.36.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iWz-0f
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FD9-05
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/42] xfs: rework the perag trace points to be perag centric
Date:   Thu, 19 Jan 2023 09:44:31 +1100
Message-Id: <20230118224505.1964941-9-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
index f0b62054ea68..c921e9a5256d 100644
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

