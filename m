Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73317C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4899A22D57
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbhAWSxi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbhAWSxa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7D4622D57;
        Sat, 23 Jan 2021 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427968;
        bh=EfoxJg0PLIHVAdCt5QHuZeGuq37WQSQ53hfcypS3fU4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E4Lz3JETleSNTp3xskUMy0BlPo3M6qZ8527Jzbngn+nAe6hXZmAza3eWyN3gpm+Ph
         TcSXn35ibygKOH6m/0WljYPXk8hN8JNaDDrxbSR8wajb6EFUiig1xsqobIgE/JzH0V
         4BV/28uUnnp/Rfd249Yg6orRdfIxomOVx8l5K4HNXAYI3KGtm7YYe4WOr6aqMiuZMl
         IDu1sDreIBOeg3RtTpUWrmfmGGvxrRjdnvKm11q9E+8yqyqUpI5670CrvJCO6OYDvC
         FLgdtQ8e2EAcKCswLVw/4i7xoikw2TGPfuHZ+nGahYM2xED79D59tEWv9x72BBn4Gu
         OYNIRT4bQ8CYw==
Subject: [PATCH 09/11] xfs: add a tracepoint for blockgc scans
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:52:49 -0800
Message-ID: <161142796954.2171939.15250362023143903757.stgit@magnolia>
In-Reply-To: <161142791950.2171939.3320927557987463636.stgit@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some tracepoints so that we can observe when the speculative
preallocation garbage collector runs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c |    2 ++
 fs/xfs/xfs_trace.c |    1 +
 fs/xfs/xfs_trace.h |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 952eca338807..da407934364c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2356,6 +2356,8 @@ xfs_file_ioctl(
 		if (error)
 			return error;
 
+		trace_xfs_ioc_free_eofblocks(mp, &keofb, _RET_IP_);
+
 		sb_start_write(mp->m_super);
 		error = xfs_icache_free_eofblocks(mp, &keofb);
 		sb_end_write(mp->m_super);
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 120398a37c2a..9b8d703dc9fd 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -29,6 +29,7 @@
 #include "xfs_filestream.h"
 #include "xfs_fsmap.h"
 #include "xfs_btree_staging.h"
+#include "xfs_icache.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 407c3a5208ab..4cbf446bae9a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -37,6 +37,7 @@ struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
+struct xfs_eofblocks;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -3888,6 +3889,44 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
 
+DECLARE_EVENT_CLASS(xfs_eofblocks_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, eofb, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(__u32, flags)
+		__field(uint32_t, uid)
+		__field(uint32_t, gid)
+		__field(prid_t, prid)
+		__field(__u64, min_file_size)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->flags = eofb->eof_flags;
+		__entry->uid = from_kuid(mp->m_super->s_user_ns, eofb->eof_uid);
+		__entry->gid = from_kgid(mp->m_super->s_user_ns, eofb->eof_gid);
+		__entry->prid = eofb->eof_prid;
+		__entry->min_file_size = eofb->eof_min_file_size;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->flags,
+		  __entry->uid,
+		  __entry->gid,
+		  __entry->prid,
+		  __entry->min_file_size,
+		  (char *)__entry->caller_ip)
+);
+#define DEFINE_EOFBLOCKS_EVENT(name)	\
+DEFINE_EVENT(xfs_eofblocks_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, eofb, caller_ip))
+DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

