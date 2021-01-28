Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D2BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 511A164DDC
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhA1GD5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhA1GD4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B050564DD6;
        Thu, 28 Jan 2021 06:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813795;
        bh=+ZWyKlkPeQc916QH+8eI08QJ9wQ+LtihIZo5vR2WQDg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PxOXIGTvzs0jXusYpxRWks6JArKVwQ/bz0R6oiOU0vHK6DCJ3VQbd7FBxpnt4+yYt
         Y58CugyPIV3hkYqUxxVc0/ta1DjxmhH/RviR3+G+qGbPu4IAVhyZ9rtitFEL7pwU/S
         w+UT8N1YQJNqWM1HXNv0TZBHjrdMCI+/tvLOg4IaG0GAU3AUDT5t+eJuQmiRVS2EbD
         LjVSkZsmSIAv+xUqtKu51Xv1ZLzlQ/n88Zi/K11nRkXkLPGqXPrkxUaO+W4VQFozko
         yzk2UqMydZf17+MdGKTh7Bfj0+Em/hFTX8AtdVmRDPvLdXJeVTDJtClNPccR1s7bmo
         /dg8+R/T5S1Hw==
Subject: [PATCH 09/11] xfs: add a tracepoint for blockgc scans
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:12 -0800
Message-ID: <161181379197.1525026.7178194644298359955.stgit@magnolia>
In-Reply-To: <161181374062.1525026.14717838769921652940.stgit@magnolia>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
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
 fs/xfs/xfs_trace.h |   41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6adfc8541d61..cc6ddc6d22a0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2355,6 +2355,8 @@ xfs_file_ioctl(
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
index 407c3a5208ab..38649e3341cb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -37,6 +37,7 @@ struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
+struct xfs_eofblocks;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -3888,6 +3889,46 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
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
+		__entry->flags = eofb ? eofb->eof_flags : 0;
+		__entry->uid = eofb ? from_kuid(mp->m_super->s_user_ns,
+						eofb->eof_uid) : 0;
+		__entry->gid = eofb ? from_kgid(mp->m_super->s_user_ns,
+						eofb->eof_gid) : 0;
+		__entry->prid = eofb ? eofb->eof_prid : 0;
+		__entry->min_file_size = eofb ? eofb->eof_min_file_size : 0;
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

