Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13AD28A1D5;
	Mon, 16 Jun 2025 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096383; cv=none; b=nklz6qNQLdRBUnx5KyLz7+E2OjFvjDIVUwgdn2fxLxukUDw0qjeIlcetCXREnqF/uygKjPe7cgo1vobSkTaXOO6AWZWqIhgkzyG+YwBv1YeSo+WMgDX+bngLwVY+kKFvJmDXSTE7NniK935ctXzljgNG65oT0wEStqUx2N6jh9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096383; c=relaxed/simple;
	bh=a/MfSuVozGAacAKmarZnQF0n0dIVocJeRNqB4nOy+Qk=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=ehGykZfhF+whfRpFLPjDzUkXh/NSCwn3H2Y2qppDm2ZvVkUmaIv0zg5cu2tjG4iNtkaadAfrPqcKjwFQwQaokoSW6IIlufWw6GTOt6iSxhCb7nX+QhbK2UApV4YXZDZUm+AjtZO5CZxEUCy8tYyKCihawesgiyUUnBh8VC/BS9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D7C11D6E7C;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id E3E6E20018;
	Mon, 16 Jun 2025 17:52:52 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0u-00000001KTG-3Qmh;
	Mon, 16 Jun 2025 13:52:56 -0400
Message-ID: <20250616175256.669462692@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:47 -0400
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
Subject: [PATCH v2 01/13] xfs: remove unused trace event xfs_attr_remove_iter_return
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: nxabk184tb74pc6weow7eq64r5xaidso
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: E3E6E20018
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/EBVT/ypkTxI/+Sgk7S8G9jwsvgq2z58Y=
X-HE-Tag: 1750096372-980939
X-HE-Meta: U2FsdGVkX1/WRZXHROWxbBSJP25HM2voSaVKtXS4/NIuXQOaf9kfU66N37DnmFa9KxpbhZnR3htCjIwIpZRXgAxnKL7AmQ1DtzozIbGsgsKHagnoyN3mkZ8tmbWplKNTS0XScc2TgoDV+M35g/cD2k76QTyy6w0yUXlIWqpjyNQho5SfWgx9u3hamKbaZ9+mhtZ4C9R0bLWYggDrJnvjxDzRFIYs3cVctb2cMHoanMz+3bCSyG5UbG9G8EcQ/S66HO1ITWG3ZSZ0TFF31SrpQpzLTHfnnmlDOU8lSVOvDHv7u6ZGc0XZ2YxeSUOh7I+hGYcDGp7rddX56GHMc+JaXU+8g/tjchTdTQ2RUWBXG+JlppnsGc+Usv3saAXxBlOl75WQnOO9529jrpl05caE4A==

From: Steven Rostedt <rostedt@goodmis.org>

When the function xfs_attri_remove_iter was removed, it did not remove the
trace event that it called. As a trace event can take up to 5K of memory for
text and meta data regardless of if it is used or not, remove this unused trace
event.

Fixes: 59782a236b62 ("xfs: remove xfs_attri_remove_iter")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 01d284a1c759..a8867f62ba18 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5077,7 +5077,6 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
-DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_alloc);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
-- 
2.47.2


