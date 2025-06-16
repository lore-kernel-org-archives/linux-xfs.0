Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1295B286D69;
	Mon, 16 Jun 2025 17:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096378; cv=none; b=COb4kKPYWEh94omr/b2mhzHFxVBZx7iwUuo22obwMCp9JPji/Lez3gl6Z+IvOyDdSaxSnw0AOY+PbqCy6tqoZlFmXZD8no/5FGuADlITj4LbYUMMgOA1QwPiYoCXyhj5RnSkJdS6ec5xDCBnZNXYbU79Y3xtWOxwMzzJB4Imfi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096378; c=relaxed/simple;
	bh=CYlQXKUC/k4zUgCaV2OcyF0QZlscFj2OAaCfrAxSlTE=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=GZbHdOJ+STdcpRvRo/O/OLwVKGhKJWXOMnJaEN3qtcxfy0xaJgLHH4T7a/5sb4IMVX3vOlrwaJPFMxwjEzFQbQZtvqfl7PjpgHTWm41WvA4YiGWwmUlBzLASrxmUnDY3Ey4uUR8laqhgXl+s8Kkkxfj/Lr+9rWI7wTlY5+lmoUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15FBC1A0B2E;
	Mon, 16 Jun 2025 17:52:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 5D47A20030;
	Mon, 16 Jun 2025 17:52:53 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0v-00000001KVD-24A3;
	Mon, 16 Jun 2025 13:52:57 -0400
Message-ID: <20250616175257.347133467@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:51 -0400
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
Subject: [PATCH v2 05/13] xfs: remove unused trace event xfs_attr_rmtval_set
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 5D47A20030
X-Stat-Signature: fpx5h43nbm9ytpfeggtat4prb66fxuw1
X-Rspamd-Server: rspamout07
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/cuPiYW/TAvrROxey7zFty0wbljByrxvs=
X-HE-Tag: 1750096373-943156
X-HE-Meta: U2FsdGVkX1+EAisccI8NqaLL4Fb8JVQqxVRAVke+C9JezXVqVSzTUhNL/hE7w1av+UUEJ6v0Sy1mXDKOfmMswfqsZI4j5Xl05HRAHGjRNkFjPEbifVxdZ738zCebTSEZ4kCBXp8hyEI/nSpPc1DHoIfeNv7MChK0AaKl2wOpxbYimigSj6iJZE2OLMLnjWqe8XhgJw6gRyV2u2DaIDXBQL8ScgW618UlIHosuzkCJkTpQK7ka83ZcsecJglEVeCYiMw3TfsUHoZQGLwmeo/LHuEV4nVLdu/64JXsJTvFdhPPEKAhss7FQQaQi5NnLP4mO5IO5ywPkxgnH9wx2nVtwUYxgBDnSpCIUZAw+xNQzOIa2l+zbJOvnnYBhGRbkTCBi5bWnGyoxk6EqvflERNdeA==

From: Steven Rostedt <rostedt@goodmis.org>

When the function xfs_attr_rmtval_set() was removed, the call to the
corresponding trace event was also removed but the trace event itself was
not. As trace events can take up to 5K of memory in text and meta data
regardless if they are used or not they should not be created when not
used. Remove the unused trace event.

Fixes: 0e6acf29db6f ("xfs: Remove xfs_attr_rmtval_set")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6ba8cf1a52c5..f62afb388189 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2471,7 +2471,6 @@ DEFINE_ATTR_EVENT(xfs_attr_fillstate);
 DEFINE_ATTR_EVENT(xfs_attr_refillstate);
 
 DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
-DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
 
 #define DEFINE_DA_EVENT(name) \
 DEFINE_EVENT(xfs_da_class, name, \
-- 
2.47.2


