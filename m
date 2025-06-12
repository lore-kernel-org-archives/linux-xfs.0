Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552FE2D4B7A;
	Thu, 12 Jun 2025 21:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763506; cv=none; b=VCi+Fm4IBTDtyBb1AX+5cs2ugpRsfwnuifiSiLrgeFyCmeRPYYOtQeCJCMNnykvRWfKGnSRNHtiLsyFcPBSRQ/p9Qmyx4tArLty+9gQgnuV/LT22gtY6O9jr9y0lo96VQffMnDTpXXlwvZZRSUd1sXh5gD5ULHLJ+L3dO7ywbjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763506; c=relaxed/simple;
	bh=HuMjZINpKSUcmI84cW4j+vLlDWcteElTKOayabQOjQY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=QClrcU0IEdV6PKgzZ6TwJXRhsNv9UclJvx1BEsWnAkmywPB3PcniMM5fyzAngCM8sGkuiLyyFCUfOxOJiUG1mQ1hgdpN+LyNx0NBh7xk1CiA8TUfqPigWHGOmufuoeXOH6odzzaaOj0pnqr3fVhlSlWQTpRoCT4aLZp1jLofsoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24740120242;
	Thu, 12 Jun 2025 21:25:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id 43A8220010;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRU-00000001tSw-2Pc2;
	Thu, 12 Jun 2025 17:26:36 -0400
Message-ID: <20250612212636.430882263@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:16 -0400
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
Subject: [PATCH 11/14] xfs: Remove unused event xfs_pagecache_inval
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: u9qzqba3sbjuss5rnceuh3fo6gok7das
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 43A8220010
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19FFybcoQc1IEhFothZu6rsSnE/QAd4I/U=
X-HE-Tag: 1749763500-295858
X-HE-Meta: U2FsdGVkX1/j5UlrzR+HDEpRPi6KS7T4Ux1FzgznzSfyAYaaxe2IbU60ruu+rJ2SvfXxQ8XmQ3LE0Rc6+XRuoLFG2kAdiwchKTUmviC9MEdxcZrWfOu+7BBkTS9vVFiF9898NdTt6v9LFIgdsMg0LJK16ReU9Gk6S+FK7MhWMHRkhNY6cNB5F04jFqvf72TgJyTMRj7966xIgretl0rpgrM8i47XcnjcGm+XfRpky4Le2AsoIjdizg0DFCRSECrYNDm5PXBEDcArriviLzx72M9LNyLAsOahxUDoD6AHB9Snl4QPYepIXv1DPjOooaWQzfPmuDLZ0WAsVT8lMitKm15eqzduyKNmGlmyctPy90uu+b9NVAZ0k05XjgaHDFhlMgyoe1Nhsvb/zxGNTc6b/w==

From: Steven Rostedt <rostedt@goodmis.org>

When the function xfs_flushinval_pages() was removed, it removed the only
caller to the trace event xfs_pagecache_inval. As trace events can take up
to 5K of memory in text and meta data each regardless if they are used or
not, they should not be created when unused. Remove the unused event.

Fixes: fb59581404ab ("xfs: remove xfs_flushinval_pages")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 277402801394..ee21ce3651a5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1893,31 +1893,6 @@ DEFINE_EVENT(xfs_itrunc_class, name, \
 DEFINE_ITRUNC_EVENT(xfs_itruncate_extents_start);
 DEFINE_ITRUNC_EVENT(xfs_itruncate_extents_end);
 
-TRACE_EVENT(xfs_pagecache_inval,
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),
-	TP_ARGS(ip, start, finish),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fsize_t, size)
-		__field(xfs_off_t, start)
-		__field(xfs_off_t, finish)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_disk_size;
-		__entry->start = start;
-		__entry->finish = finish;
-	),
-	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx start 0x%llx finish 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->size,
-		  __entry->start,
-		  __entry->finish)
-);
-
 TRACE_EVENT(xfs_bunmap,
 	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t fileoff, xfs_filblks_t len,
 		 int flags, unsigned long caller_ip),
-- 
2.47.2


