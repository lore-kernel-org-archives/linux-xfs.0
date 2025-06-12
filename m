Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E74629B227;
	Thu, 12 Jun 2025 21:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763505; cv=none; b=P+HldpyijcwRLWSyi6Miby5KqKq0yOdWTExUpUHpzvQ4YG/iS/lKy/Au9gjU4cBNc90zUsg0X9aN3sUquWr19pg3Gu8mr1IZgW/gDTCe5rxLOo8nWv7FMzWj8CSTG1GLgAm8R/vGr9bHJAbTWKOM2DAcjC89x+SFKfmUYLW6PkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763505; c=relaxed/simple;
	bh=R6GDH+pi/TisbmmlM1tiP9Ycm3BzPweSXNUekosIhWY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=poTWTGuiVyBVArkkRpvvveXlZqTT/h2Z6aFlaPzu4fxgYf0zLzmXVvGJnEM5cjrQ5wI8WMk5bKRHp3Uak6MccwT2HfErfq5htb1VLwR5ulG204wYN8IIsuBH7nO6y5+NCsGdft8gDlVbppg4opfZPLYyFlWpoC4kMVxe/5NePlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7239AC018D;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id BFCBC17;
	Thu, 12 Jun 2025 21:24:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRU-00000001tRx-0ySj;
	Thu, 12 Jun 2025 17:26:36 -0400
Message-ID: <20250612212636.080305835@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:14 -0400
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
Subject: [PATCH 09/14] xfs: Remove unused event xfs_alloc_near_error
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: BFCBC17
X-Stat-Signature: ze8ij1s4gbrm18ajk6destqyspmp1s3y
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/76CYWaDEPaZq/fnOJc1E46idQL/K51hg=
X-HE-Tag: 1749763499-949767
X-HE-Meta: U2FsdGVkX1/h0PsnFAhUIB6OuHqyBecE2q+w3FXEHtSeX8H57hw+FS1mDWMsATw7n+TCD5kZyntCSlF5kDkCMFDmao5e7Oxd8WUJ8h36s1QfGPgLFL9+U6deZwFJHVv6eRb4u1PteUj8Zzvgf3myDjmuS0J98ZwT9DscpxclULYZo4dFhQrzT1yDxIdCkBsszwYXg8ADl5tpNtOBFSMXnc8s8oOTlSfCVPAwaNuVoX9B94ZZC47q/kgYieClDFkoVF9AYNMo4rQkZ3GwqczUhBgcAIJlwjU4+UsYPHJsyLYR8oBv0PrMvT4H7GtDGeTu5oAi+U/p1zHMpDXETYBD4LoMIY/2N8I+DEBSzxWFHnvLGC7PB76YCLpGtYYqlhR9mplvq0hN/riNjVYtd1y1VA==

From: Steven Rostedt <rostedt@goodmis.org>

Trace events take up to 5K of memory in text and meta data regardless if
they are used or not. The call to the event xfs_alloc_near_error was
removed when the cursor data structure allocation was introduced. Remove
it as it is no longer used and is just wasting memory.

Fixes: f5e7dbea1e3e ("xfs: introduce allocation cursor data structure")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3c15282b2a8a..6ec483341bc4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2270,7 +2270,6 @@ DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
-- 
2.47.2


