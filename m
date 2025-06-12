Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D126E2D4B58;
	Thu, 12 Jun 2025 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763505; cv=none; b=nbrhmmxZEIf9xm3kbFue9E4Z4JXyO1FejhW0hxDkBwt0rRImpJQnVZlWzBL1Ozk5aawYMsilTyHp+AYvLEQgdgw+fG8pN9FXSPa0VFXAnes+pH4z0FcQC+NvxK4tAN4m03f8fjrmfWS1l7tNTEHRr7K9tpxhE/mmKCtqG0Xn4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763505; c=relaxed/simple;
	bh=5npKsJuDpglGznd2LvzyObZv4jx5kLIPSqQk5d9O3YY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=ByteI5Noby+5rhklNYlwKNsHZKonxV5OLxzOqRa8SMTylra85CLhm28kadLq/kPVD6NG6wGYP8a6roDI6PmSpw0Vw6ABXGnux6j1F0Naz6zAsoF3G0eqVdcciDY8bGIGIvlYEjJ064jcU0I3KuUlIVSEkRfL3hzBkuT8Y8srLxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 096AA160239;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 7149820027;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRU-00000001tTQ-37hZ;
	Thu, 12 Jun 2025 17:26:36 -0400
Message-ID: <20250612212636.596101735@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:17 -0400
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
Subject: [PATCH 12/14] xfs: Remove usused xfs_end_io_direct events
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 7149820027
X-Stat-Signature: 4dncrjmp9j41jtw1ejbhy85o477bn94z
X-Rspamd-Server: rspamout05
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/RLTYgODuJnPrO2+ZqLM0v9CLzieCE59k=
X-HE-Tag: 1749763500-989544
X-HE-Meta: U2FsdGVkX18C+Qqh/OKuc8PhP+RerXeFA+TAPO168llKMLLnqTgmg7OdHZ1vgElrI1E/LUwQLB6SJoGi9vY29Zj72tMzlfzHdTSHUfPvNli5Lbt/Hgmh9p7xz65UNB2lrniY56ncw4bgFVCz5+RQy1+zSzgOdQ09zlXBrCXxnJBebx2ne2Hv7gt9MJkavq/6Ou2tIow41XTxkH758J8NhHvSAQBIiessNOi/KPO3yzF+0bCpEg19bmFW1Nf//PK20SaCLrbW+vl7fsz5tzghIDD5KA6TQc91c8iuAAs+bqE0kxy/oRSb8VQhxDORbFjPG0Q1GEaA9IsFuux9So79O6YDJyd9kqcFtuqLuK0R6gnVAypelTI6yoWVifl77TW/21xrEPTJAiCcLecStG8+/Q==

From: Steven Rostedt <rostedt@goodmis.org>

When the use of iomap_dio_rw was added, the calls to the trace events
xfs_end_io_direct_unwritten and xfs_end_io_direct_append were removed but
those trace events were not. As trace events can take up to 5K in memory
for text and meta data regardless if they are used or not, they should not
be created when not used. Remove the unused events.

Fixes: acdda3aae146 ("xfs: use iomap_dio_rw")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ee21ce3651a5..83d4ef8386a1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1859,8 +1859,6 @@ DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
 DEFINE_SIMPLE_IO_EVENT(xfs_setfilesize);
 DEFINE_SIMPLE_IO_EVENT(xfs_zero_eof);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
-DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_unwritten);
-DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_append);
 DEFINE_SIMPLE_IO_EVENT(xfs_file_splice_read);
 DEFINE_SIMPLE_IO_EVENT(xfs_zoned_map_blocks);
 
-- 
2.47.2


