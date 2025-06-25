Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D369B2877E5
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 22:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891806; cv=none; b=i//dTjTUyr6tAWGnYNiLRl9ePwxMXaUB8c8bG9656yMJdGm3mGcwtr8D8WWGQEISyHjWPtZB32MARAxRMOFGUw4ekVBhglZjcch3DlmwrnbOW4rceJuybkjKBNL7/8GdCAl7llsyK/Vpw9tj5vX9YkkBtsbcltIOmrKnZCzizgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891806; c=relaxed/simple;
	bh=9143z7Zs+JNMo+QJE3yGK921aK9+qjNmrqWp80EdO+s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFxZTvRCm03gNPz6L1n5OQ+rjtDHLyNknyMUU6furMZj8mwhNjjL19RnShpPdwFEbhEdHpoLrMPmuLLlb7trmsx6Jlx6uVBjDUZwqfNQwjRDU47GSTPuX721OJXi1UVZnljeFvQ3LL+YrJPS83qjunTRNlCjsdYypBDyQedpVrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=f80/M6tL; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="f80/M6tL"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-747e41d5469so547113b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 15:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750891804; x=1751496604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bkc3mvRmKsAmpgr3Dl0h7YR/9QXHyZh7YtpEtJuoJXI=;
        b=f80/M6tLlSs8jcL7ZJ4l2GyXK8DS/r5Jif2H4eEN0SVIUvPVLqRNRkZNDpLc79vydz
         uXfM67g2pHKkoRdtxhQdeNKF7kx6ZcDs2kPDe+6zVvfkfyT3szot3zIpXkTViKHABUCS
         bNTrILO5QHHw0jjL3KVM04zJK7sPEHV83+VSZgDuS2RcYjULgbW/+xunAQkGLDUN4Vig
         NXQyJ50NBb3vurPMeZr5PedH5LOtsxWs6nQ0Z5REbmK8c7EmGdkcclPWbmhQa5SSq3OK
         w1u12H435J4yrV/nTPFlAl6Z7XoWF7EQt9rNN7XusC7cc2G0rOtocp5XZGT29vW54AKn
         7ewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750891804; x=1751496604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bkc3mvRmKsAmpgr3Dl0h7YR/9QXHyZh7YtpEtJuoJXI=;
        b=BBitL4iTHYKdVQmUHaWAky+V8MhvxGFtkDyRQ1zdIHxHqXmix/u/TYPhfykSpMUACb
         S9eKnKUzC4vQkVh/K7CEaG4AesFMaIaU9TMNT5AZWyVjyiNSSgCZLPP00w+rLHytX6Ng
         EDDnW3TQsxMSUlCYhIW0IuLZSMu3B/6T6OAHRf3Njg6CQhH8E/fqubzNMrT2UZl5BnE3
         VJS593gR7t1dHPgQTIjH1pFGVeAT4V2AKI+acBr3Lkv3R9l4WQlmrCBU0X7wEBPL/pEl
         D6csuLD40hX4MOVKkx+NUj/g5vD4JmbCPaiGs6+mMNHTS9UPbL5b5igxyGLJ5k90DzBQ
         iKOw==
X-Gm-Message-State: AOJu0Ywe/yED4OSbTsyfptkpoW4Azya1gAWWHCdhDrwgO7+1PG9ijHM/
	2NN6XDzCmHgqBi8RQ0144mvvIZ1Yu9gF6Jh3sdUms6oSCdiziQrtWAKHK14MbNiVcjZf3x7/GcQ
	H2f2F
X-Gm-Gg: ASbGncuMkoN6cL1Nawo8LpPUdJpL9c7LkWN21QxqVSjrFVR3nKsW8XFHNuU5LXILMAO
	c/VD7fE9Ire3jMUaRFThtVvXiNCC9dBm7zVEJCUxPXIb6cQ9+CoPXATyEt4qL9khd3LjAnCc3hv
	9eKS0E+uuQ4asZ1EiCxJF+u5XnJ6K/95vk9CZrBuP3Bu96ebLNeVKn3NpkFUxhPcQBeOxRW/0LT
	jmzBzV7Hj00UmFTzMof0yxoarfp0a0vBTSsnCloM3ALaVwnLKi94gKxYkPYO0m166gRDhdj0oNJ
	xZHJt6erRc1nyrcMDiWfR6doxzaBUwQtXV1uv2TWXlbDdjL08pu4x1MD4SC5cqcNIoSSWx7BUez
	B2EZuMMwaFpRnlDBrV8PanZPWMVizPuLNzuBk
X-Google-Smtp-Source: AGHT+IGjUgmNYLDyAsq8H2mWGNrNTtiONe/70UlNTtt162Jcs8MTpsEF6uHcx18Rwql8bNvLcDKj2w==
X-Received: by 2002:a05:6a20:158d:b0:218:59b:b2f4 with SMTP id adf61e73a8af0-2207f31ce05mr7284175637.42.1750891804103;
        Wed, 25 Jun 2025 15:50:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34c44b39bdsm101834a12.68.2025.06.25.15.50.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 15:50:02 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uUYwK-00000003FOE-0g6s
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uUYwK-000000061eS-0CWJ
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: add tracepoints for stale pinned inode state debug
Date: Thu, 26 Jun 2025 08:48:57 +1000
Message-ID: <20250625224957.1436116-5-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250625224957.1436116-1-david@fromorbit.com>
References: <20250625224957.1436116-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

I needed more insight into how stale inodes were getting stuck on
the AIL after a forced shutdown when running fsstress. These are the
tracepoints I added for that purpose.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 5 ++++-
 fs/xfs/xfs_log_cil.c    | 4 +++-
 fs/xfs/xfs_trace.h      | 9 ++++++++-
 fs/xfs/xfs_trans.c      | 4 +++-
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c6cb0b6b9e46..285e27ff89e2 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -758,11 +758,14 @@ xfs_inode_item_push(
 		 * completed and items removed from the AIL before the next push
 		 * attempt.
 		 */
+		trace_xfs_inode_push_stale(ip, _RET_IP_);
 		return XFS_ITEM_PINNED;
 	}
 
-	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
+	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp)) {
+		trace_xfs_inode_push_pinned(ip, _RET_IP_);
 		return XFS_ITEM_PINNED;
+	}
 
 	if (xfs_iflags_test(ip, XFS_IFLUSHING))
 		return XFS_ITEM_FLUSHING;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f66d2d430e4f..a80cb6b9969a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -793,8 +793,10 @@ xlog_cil_ail_insert(
 		struct xfs_log_item	*lip = lv->lv_item;
 		xfs_lsn_t		item_lsn;
 
-		if (aborted)
+		if (aborted) {
+			trace_xlog_ail_insert_abort(lip);
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
+		}
 
 		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
 			lip->li_ops->iop_release(lip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9f0d6bc966b7..ba45d801df1c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1146,6 +1146,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		__field(xfs_ino_t, ino)
 		__field(int, count)
 		__field(int, pincount)
+		__field(unsigned long, iflags)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
@@ -1153,13 +1154,15 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		__entry->ino = ip->i_ino;
 		__entry->count = atomic_read(&VFS_I(ip)->i_count);
 		__entry->pincount = atomic_read(&ip->i_pincount);
+		__entry->iflags = ip->i_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pS",
+	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d iflags 0x%lx caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->count,
 		  __entry->pincount,
+		  __entry->iflags,
 		  (char *)__entry->caller_ip)
 )
 
@@ -1249,6 +1252,8 @@ DEFINE_IREF_EVENT(xfs_irele);
 DEFINE_IREF_EVENT(xfs_inode_pin);
 DEFINE_IREF_EVENT(xfs_inode_unpin);
 DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
+DEFINE_IREF_EVENT(xfs_inode_push_pinned);
+DEFINE_IREF_EVENT(xfs_inode_push_stale);
 
 DECLARE_EVENT_CLASS(xfs_namespace_class,
 	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name),
@@ -1653,6 +1658,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
+DEFINE_LOG_ITEM_EVENT(xlog_ail_insert_abort);
+DEFINE_LOG_ITEM_EVENT(xfs_trans_free_abort);
 
 DECLARE_EVENT_CLASS(xfs_ail_class,
 	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c6657072361a..b4a07af513ba 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -742,8 +742,10 @@ xfs_trans_free_items(
 
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
-		if (abort)
+		if (abort) {
+			trace_xfs_trans_free_abort(lip);
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
+		}
 		if (lip->li_ops->iop_release)
 			lip->li_ops->iop_release(lip);
 	}
-- 
2.45.2

