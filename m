Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AB92D8DA1;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763503; cv=none; b=OQ7978/BTtAwEE6tCLKkha/FeUjntc4UKxQUec7Xq5B1LBBLMKmsqf2IdD3pkKlf1CgNf+u3TD/2AretD583yUTflPFmXPSCsy+yZ0e6ffK8uR9q3uCowA1Fc/0Hfg7hztTNlt8i9Tx5lnmDILGl40/CQBH9KV6owD/0rgtDHtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763503; c=relaxed/simple;
	bh=+VnxRD5xgKbSbKAayVo76MzO4o48C8v5QVinLZE+2NM=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=YA77KjwoE1k4w6yUA8GzVA9IDGCD00LFMEfx7hhFeu8njU9hf2cpyNJc2oePiNZrHyMIoVhLuiIIAWKgDKmTW5wkoUJj9JtYpBhpKT3csVHaH5sGeLUHSr0DbLqjjdr7zt52Pky648SALa2YtWDh8NuMn1tBoqChuH42n7g95sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5DE5B6D1A;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 19D6817;
	Thu, 12 Jun 2025 21:24:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRT-00000001tPV-1dpx;
	Thu, 12 Jun 2025 17:26:35 -0400
Message-ID: <20250612212635.247519894@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Carlos  Maiolino <cem@kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 04/14] xfs: Remove unused event xfs_ioctl_clone
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 19D6817
X-Stat-Signature: kx8igcgjwy9gpbhui7ifb7upcfhgmnig
X-Rspamd-Server: rspamout06
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19ue6BR7hXq+rMopguYaK4WKcIAj67jf8w=
X-HE-Tag: 1749763499-217513
X-HE-Meta: U2FsdGVkX1+NcEH23Na+DHN4SSRC7qXmptdij8TmrSYUjrlbz7/3CCnAUcTCcp1V1+3ru9u3IULozNrp43vLUv+CSxAzp7g/A4tzaQSBhmiQd1fKNI6Igr3L19WKH/W5Xph5n0MLYq8sT1tEA9KRAQafB0U6kqGCGb0OTXFq3KOJk2FCqky0xG6SW5TbS+7C/1dm5F2kFjLFnx12/0PvSofd6bwpgr8h5exBUPKNrPiAL6Obg1gwWwg203NosqjPMgWqojsq0VZkMSj+xMT45HLcsjus8GyBquBgyaC56CXk9BtyyvWytR6BvTdFAk7mo3h+M1uSU9yeUvRftbs8sFTXTwz4r+i5+V1y1R1i6ubqhqyH6XOc0tloldL5wdP6khlRsoM3N7x6fg+l07ZF9A==

From: Steven Rostedt <rostedt@goodmis.org>

The trace event xfs_ioctl_clone was added but never used. As trace events
can take up to 5K of memory in text and meta data regardless if they are
used or not, remove the unused trace event.

Fixes: 53aa1c34f4eb ("xfs: define tracepoints for reflink activities")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 049bf9e34063..ad686fe0a577 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4210,32 +4210,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_compare_extents_error);
 
-/* ioctl tracepoints */
-TRACE_EVENT(xfs_ioctl_clone,
-	TP_PROTO(struct inode *src, struct inode *dest),
-	TP_ARGS(src, dest),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(unsigned long, src_ino)
-		__field(loff_t, src_isize)
-		__field(unsigned long, dest_ino)
-		__field(loff_t, dest_isize)
-	),
-	TP_fast_assign(
-		__entry->dev = src->i_sb->s_dev;
-		__entry->src_ino = src->i_ino;
-		__entry->src_isize = i_size_read(src);
-		__entry->dest_ino = dest->i_ino;
-		__entry->dest_isize = i_size_read(dest);
-	),
-	TP_printk("dev %d:%d ino 0x%lx isize 0x%llx -> ino 0x%lx isize 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->src_ino,
-		  __entry->src_isize,
-		  __entry->dest_ino,
-		  __entry->dest_isize)
-);
-
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
-- 
2.47.2


