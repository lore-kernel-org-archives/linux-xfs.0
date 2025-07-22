Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C492857CF;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215632; cv=none; b=g0F8/tlcuiS8ws1JK+2sMk3U6S0LZht4k15SFqgsFCU8VkuZpMubgBZRAfOJ4E8Thi8Tb1holkwF+5faSnwmLRCjiIlYZxKNeS4EPnwRoEq6Y0IZHRgoxTSDQXY9gMkClCh5q3+lBKeDl7X25faaLKparRrzddtIslqtWXCfjjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215632; c=relaxed/simple;
	bh=wBR0+P1gjCOSCENPtBV7Ah8gY16/RWgDe9xN4dTCRBk=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=rOILGl2lsGyZ3ejA9ruf3Mfw7vPAK1NANn3SIdvVf3KP8HW+3n5EPx++qObqJYe2+AmyIjW6nKy7wyjHAw2PlMeE8d1WbVQ0n25h5npkt/muFFT3vKD1PljEtohezSISNQlHE6pDdNfxz0lmz1JFsot9ULzzhmrgyOVZNQDMSWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+zQN/nV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+zQN/nV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B4C4CEFA;
	Tue, 22 Jul 2025 20:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753215631;
	bh=wBR0+P1gjCOSCENPtBV7Ah8gY16/RWgDe9xN4dTCRBk=;
	h=Date:From:To:Cc:Subject:References:From;
	b=H+zQN/nVv4o6xPuA5fEVQMFNMp6Euz+P3K9gCWZiAgIXZcWN32Xvlwk92T3fRKdRC
	 7msF4Lxju+LMPa6pZgzVYILSW2cKM+yxKk2Gv+XF9sgw7+s2ZHyhAdRxYPmEv92f09
	 qdOpt/1idsoxHWOCcan4bVLBDx4ToyZxYr4zWPl/J24fbHiex9PDFze5skaImk6PZr
	 Xjgh4uqN06H37qw0bUXuXfj1873UjFiNkPm3JCPmzrLBbI/PCG7jPg1fuuIETV1wQo
	 UMunLBOqAKOFDiPkrAX0xpSacmCkLgOBw1G8Xcs19RgVh8IssNTlEpNK3zN3/d4Fbv
	 hnRZSHMLIgz5A==
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@kernel.org>)
	id 1ueJTS-000000001OH-49nd;
	Tue, 22 Jul 2025 16:20:30 -0400
Message-ID: <20250722202030.847917487@kernel.org>
User-Agent: quilt/0.68
Date: Tue, 22 Jul 2025 16:19:10 -0400
From: Steven Rostedt <rostedt@kernel.org>
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
Subject: [PATCH 3/4] xfs: remove unused trace event xfs_discard_rtrelax
References: <20250722201907.886429445@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Steven Rostedt <rostedt@goodmis.org>

The trace event xfs_discard_rtrelax was added but never used. Remove it.

Fixes: a330cae8a7147 ("xfs: Remove header files which are included more than once")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4ce8689ed839..1061992da144 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2858,7 +2858,6 @@ DEFINE_EVENT(xfs_rtdiscard_class, name, \
 	TP_ARGS(mp, rtbno, len))
 DEFINE_RTDISCARD_EVENT(xfs_discard_rtextent);
 DEFINE_RTDISCARD_EVENT(xfs_discard_rttoosmall);
-DEFINE_RTDISCARD_EVENT(xfs_discard_rtrelax);
 
 DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),
-- 
2.47.2


