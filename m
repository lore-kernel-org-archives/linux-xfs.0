Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9462D8DB1;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763504; cv=none; b=dWqZejOU+Vvq47RjJlh6gAN80Wc5Lf22k4EPUaJXUhZcEkdPJjp/ULf3LjFvX/dC7MKAElZ0W0eXwE8HSpAEa4sBZWOabdwPPcF9w64Pa9qkKq7MMTpgI4kkSR0s5HnlFy5bgfFoJcW+2H1OTacyZX1lJyC8qXIXnUtHceHerg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763504; c=relaxed/simple;
	bh=Kv8GpNW1i9evYXPkzz691+faP6WezKd/Ck4ruwoW1ms=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=A3Nkk1DikS2vKyH2UhgBbOLG3bK3oTS5GmNxLXIdh798HwVIeGw6icz7WIj7X92QQERoEaMY3KcOzHs3Y0kbtwplBGpP3G1fjUcBly1NpR9vrGxHUhhGjKMGqRY+rC7jZIX6sklu3L4sAng36C+fAItSIENvvn8lyyKYS4atHXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 745D512023C;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id C898620013;
	Thu, 12 Jun 2025 21:24:58 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRS-00000001tO2-3kT3;
	Thu, 12 Jun 2025 17:26:34 -0400
Message-ID: <20250612212634.746367055@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:06 -0400
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
Subject: [PATCH 01/14] xfs: tracing; Remove unused event xfs_reflink_cow_found
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: u99ng4s9ctec46pi5c15k1ztqpzopjn8
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: C898620013
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/z/u/69sk8lvHox7glHELK/KNw9BH+XY0=
X-HE-Tag: 1749763498-158627
X-HE-Meta: U2FsdGVkX1/bN/RPUtxO0G/+1qNdyHRCWg398M5FK8FYggPLoL/wHC/USzHaE8Qde0XdUt1Gwfzwj7sdZpFVFg+EHwM/mtLJo+GcVngyqDFrntuBG7F6Sj1gpuMU9DjKuMyY8gca1BNV1qtZPvKDjFVCvyBS27YslGQfUq6GaeUo+5lsJ2wIQKJbaZFI6b9gKVyjVSjHnzZifxA0QVcpH2eEcyTQiT0byEhg9XlZ6zFIgITbCuPatX/1KfzUoRCNJ+vEATjj5VnoMZP1aKrsKacc2x8XuXrxfufEvYtqVF288/6RAdjfeA9qV/T8vnPYLbeQonrzyKQu17N1Te70QBB5bNHMqNdL6duQjmndMfKeGEbKx/e/T95UhcIb8kgO0XtHF++zrwCaFSCLRQXGRg==

From: Steven Rostedt <rostedt@goodmis.org>

Each trace event can take up to around 5K of text and meta data regardless
if they are used or not. With the restructuring of the XFS COW handling,
the tracepoint trace_xfs_reflink_cow_found() was removed but the trace
event was still being created. Remove the creation of that trace event.

Fixes: db46e604adf8 ("xfs: merge COW handling into xfs_file_iomap_begin_delay")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 01d284a1c759..ae0ed0dd0a01 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4242,7 +4242,6 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
 
 /* copy on write */
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
-DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 
-- 
2.47.2


