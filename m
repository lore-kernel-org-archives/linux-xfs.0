Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2FE2D8DC4;
	Thu, 12 Jun 2025 21:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763504; cv=none; b=sLZwnSC8YeahP2/Xlw0xHZ0967l/VbGDepHELGATNeEHZEt4mcKLFoLffFt9PweGPpguJKsQxkiex1+XQ6/iRFbmTxS5GEiBoI1lfP6TaOgIZ4q2Yc9C2qzb3hfY9/8fBJPGcMDDZMR+b6Ui/pRC29AfFIOWcP/PbLgu6GvU8go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763504; c=relaxed/simple;
	bh=sTjUFbUTnZj6r5VIFanu14zWxsRNcBHcaFhuwK3QYNw=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=e7cGxYspm/j1/gLNYjfLh7Es+257jbwBzbDY0dg0sd5FUZigppGRlef2T9B/qfqysM3fYW5etnvHhGLfFNuFQ2/pK0K41uLWnB+MPwYSc0KMRiNp4SUL4oeriw5yQBP6D/cYkzU0+5lMLueUs3ACSI9hHxE04Z0bx7mV5BRKV1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F1E91CE2E6;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id DC95060009;
	Thu, 12 Jun 2025 21:24:58 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRT-00000001tP1-0v6w;
	Thu, 12 Jun 2025 17:26:35 -0400
Message-ID: <20250612212635.074800207@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:08 -0400
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
Subject: [PATCH 03/14] xfs: Remove unused event xlog_iclog_want_sync
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: bm94qr67shj5y3zw5niwwfrppign4zqa
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: DC95060009
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19WQ5TFx4lPmkyvFW7xtcYWehn3QuQamq0=
X-HE-Tag: 1749763498-114303
X-HE-Meta: U2FsdGVkX1+QP1pRCP+sX55XLIdGKEpH7e1qaO1aaJW7/HH8yDjX+IObwx8dnxKO8zdph+acOvsscmsaSxI779jK8RQRRRE95g9mz1BroyuEbat1XULajBIlWYf1fbyi91SIqZtB5jVVN/4+oqu83eiB2laRzdjuosDpuEfYB0sSybjW5FLwXiKJhxZs1/ZYggEBp05aILjEUhLMFxSXbSwq0NfPAYzOYgSK+0K4A4VkQ4sD+wyIGrKYzVAAtDZgtm7xBSMLe5memiUTYmnWtEA/pkTwbFlG+AkSbhe2Wbexbmcq9mFUp2eBzSG6PkW3f0wPLhJiF3sbj5uQq5Uy6qo5DZ3I+onwEwuA9q+vArMeV86fmXgsdfedeIJACqVjHfxnJxXNifXu7EYhrvHGtA==

From: Steven Rostedt <rostedt@goodmis.org>

The trace event xlog_iclog_want_sync was added but never used. As trace
events can take up around 5K of memory in text and meta data regardless if
they are used or not, remove this unused event.

Fixes: 956f6daa84bf ("xfs: add iclog state trace events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 67bdcab9ff47..049bf9e34063 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5027,7 +5027,6 @@ DEFINE_ICLOG_EVENT(xlog_iclog_switch);
 DEFINE_ICLOG_EVENT(xlog_iclog_sync);
 DEFINE_ICLOG_EVENT(xlog_iclog_syncing);
 DEFINE_ICLOG_EVENT(xlog_iclog_sync_done);
-DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
 DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
 DEFINE_ICLOG_EVENT(xlog_iclog_write);
 
-- 
2.47.2


