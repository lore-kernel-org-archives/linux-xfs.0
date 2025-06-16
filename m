Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD44E28A1DB;
	Mon, 16 Jun 2025 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096383; cv=none; b=uMo9ZtGnx+gDdtZigR9UyoN6fSMfFQmy3WTS1bqE8sEbPUYywQCgIxXf7tPsD+zGvaGuNdAEPrijXAXPoodVNf7qCQFmnmbnLtgKk0htuQgHQ/eJZTw/jKO5XonglFYTnOeEtSyO5jPtpEG5jCTOT8kl7XzTneCeD5Dz0tbf9TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096383; c=relaxed/simple;
	bh=mLvPZZP61oay+IscZv9tkm2Gs3ZjQaoIJgaLGEYX/hU=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=ZRtht9+UK8uDs6l8yrXdp1FiLI3h6uE8dHmSQmjOsC61pgKRGeyvSboWMFFkLSgbuPLw51kTvfXP5DeOJti1NBwYMnU0Xk8X1sFW7LN1UfAak3fJjemBKIAJlmibxscbspLEL6NTFQosBIhhsZO9pOtK2PDF3SA9uljJF7lenwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A88F7120AE1;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id EAA8E60010;
	Mon, 16 Jun 2025 17:52:52 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0u-00000001KTj-49Xa;
	Mon, 16 Jun 2025 13:52:56 -0400
Message-ID: <20250616175256.839740146@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:48 -0400
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
Subject: [PATCH v2 02/13] xfs: remove unused event xlog_iclog_want_sync
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: EAA8E60010
X-Stat-Signature: ec3rbhqom87ts3188j6pqbpd9jg8h1ja
X-Rspamd-Server: rspamout05
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19VVEMzjf2QpB/ZfvWAE/b4HOi2l7+cTcw=
X-HE-Tag: 1750096372-822555
X-HE-Meta: U2FsdGVkX18UQPxgTBPAbOf8BTJ7oAdNJWvqdYSu74rPotqdc7B1MkJOZNV4iY1/VCl8bd7phyVLPf1otbYIMZK8BxEtssdxm3UZ7A+0hh7MfA2ri4DGWrGy60hyT7r+A2knqryHhOGTM4sP8xnDhde7NMWLNM0D/07TrszbLLpv205qJiPTHEuwHUNqpQBUiNLxcPz3agdJLQjNv4MaeBGePOp0wmFrWiM6F+aPAngDDmLdoJU1BRa8nvMxYjO3LpTWGlWl77M8sya5mnWwkMqdRrmAs3wlrU1rK8vj0R6kL9Ifk8d5Hdg1Qqm0TdxGpKX2ysDdu1Xm2i1aPZ9wqGgMKiH+QDIdvpIqrJLmsdq0kJIh7yUYU4ye8NfRVIbqXPmxpBV6zjoRS81jkZO6JA==

From: Steven Rostedt <rostedt@goodmis.org>

The trace event xlog_iclog_want_sync was added but never used. As trace
events can take up around 5K of memory in text and meta data regardless if
they are used or not, remove this unused event.

Fixes: 956f6daa84bf ("xfs: add iclog state trace events")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a8867f62ba18..b78676f44750 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5028,7 +5028,6 @@ DEFINE_ICLOG_EVENT(xlog_iclog_switch);
 DEFINE_ICLOG_EVENT(xlog_iclog_sync);
 DEFINE_ICLOG_EVENT(xlog_iclog_syncing);
 DEFINE_ICLOG_EVENT(xlog_iclog_sync_done);
-DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
 DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
 DEFINE_ICLOG_EVENT(xlog_iclog_write);
 
-- 
2.47.2


