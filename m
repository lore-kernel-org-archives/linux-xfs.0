Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA2A288532;
	Mon, 16 Jun 2025 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096379; cv=none; b=D9vNyU264oA2T3NNOP2qUcNvrxOMBee7xlLwHtRh7YJ0pYZVb/R0CfzB/akQIr0uiz40Kb/hMIjoHODXoBrbnKmCVUI4nakUrtU1Sp5TqH4Bm6E22WGdwHFf2inbt3/qrXZ3rdFkVIqXn0TVN4dAWgHxvQPcHT9IbTrgKtfvDms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096379; c=relaxed/simple;
	bh=nXjhwOy8tzQp6nc5tHLyk3cIZz5UAvrds1r3i5/ROJg=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Mw+lNVY5IBlqTsPidHcoPryNMoEXDwNaQWO3vBwz80GOpCt+/aknaMvLGGMq/KSMsdDO1WTcfrHGvqbvJHLaoGnhBfJvm3v4sg1V+edZDOQ9cHxBC5dLCyVuibY8dsanYBQnjjfNQ4bW/AkIyi6gHR9l7ljNL6nQCrma/yGiMMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD0B8101393;
	Mon, 16 Jun 2025 17:52:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 33D346000F;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0w-00000001KXd-1Rrk;
	Mon, 16 Jun 2025 13:52:58 -0400
Message-ID: <20250616175258.192340775@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Carlos  Maiolino <cem@kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2 10/13] xfs: remove unused event xfs_pagecache_inval
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 33D346000F
X-Stat-Signature: odzq8fcughxp5x6gyewd9xsj8otacz9y
X-Rspamd-Server: rspamout05
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+gCdUWe4wjocQ+NG57bKJaUPrzIofJ22o=
X-HE-Tag: 1750096374-455171
X-HE-Meta: U2FsdGVkX1+HVuVCc+xnFo/FfJVkUtB09FX+HzAbr6wW9RL2lRvbDEq4HRPyDqzzvClHvdmm8W2qmNxuF1SYRQuYtTLOE9+pbJjzYIBdIOgkLnp8NOh0qWL9aI1E5p7SPz84MDdmxJoXBgdo8VLeYTrtNO8Ws+9ylHA/iLHP4jroNuuMBg47WFiu34sJN1qCnccbMQtv7b3ScE251L7pZn/3kpgj0UsFvlUwXwyBM7fxW1DeR6aaZPZGTeLEd4I8uUBm7/wLfrTSJrjwxtbhvAyQaJ9W46i7ChAy7FyI2782nCq1kWCh7W0uE9qY9nja8oZ110/SvtQq16vZDdpN0+8ZQqWRyOH/m5ygidHKBwQQlLMln3kiyse0SQErwKheFwK/5K63LcxXFPCXCrC1Qg==

From: Steven Rostedt <rostedt@goodmis.org>

When the function xfs_flushinval_pages() was removed, it removed the only
caller to the trace event xfs_pagecache_inval. As trace events can take up
to 5K of memory in text and meta data each regardless if they are used or
not, they should not be created when unused. Remove the unused event.

Fixes: fb59581404ab ("xfs: remove xfs_flushinval_pages")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e629ee44a9a1..098ef23598fe 100644
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


