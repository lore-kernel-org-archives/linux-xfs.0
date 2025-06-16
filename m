Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127728A700;
	Mon, 16 Jun 2025 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096385; cv=none; b=DSxt+yf2E3spudvw56xfZSa9YA04j3NsIRhKjBbqO+wIWEFEN29rCLQqm1yjS8zrWloDdJtKNeVkBU8O02ifahn6UM2KygI/a2Wasp7bwWb3zLXCLbRHHk8naXQZsplBnC7ypwiXCTlIVthhnVfQGOUsjW5l775nxDS6YCvNing=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096385; c=relaxed/simple;
	bh=xbKdr4UBDoWUn/whTov2So+kzSlACZlNew8aZc77WNM=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=KadXIv2N0uEJDHoOnhN4Q1YwN1uvcn8Gxyq4TvOAYqB827BT/+GF5wTkcWu6w2Onc+tH+kH2TEpS+nLJPPH/5inAx/WEm8bwONIWl7IqVJIpqMpSi2c18rEmF0ulihp4K5DAJn8aUTQAsRGNbC8fCJfEeoeTKVroLhWO1IxaLGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DD41120AF8;
	Mon, 16 Jun 2025 17:52:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 784192F;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0w-00000001KY7-28Nl;
	Mon, 16 Jun 2025 13:52:58 -0400
Message-ID: <20250616175258.365535825@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:57 -0400
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
Subject: [PATCH v2 11/13] xfs: remove usused xfs_end_io_direct events
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: zgpj3qg3c6um4ikrwd8fpk4q8734mcy5
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 784192F
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/4PB4uBbxO380EckpeIKqeGmX9eWdEUTE=
X-HE-Tag: 1750096374-48307
X-HE-Meta: U2FsdGVkX18cnjKRSo6bVcu1N+4t8YY/rZxTl9e31jefmEE1KBHoFuJE++QxLo2jA3IzZNnxUg7MFw4ALBHHfCD3aJKKYgXxlVQdcQxNf2JTrVV6xdZ4xTQe5iv6c1okpgT5namd2ChcIaraPaQy2e1uR129MMC6Gs+cOm9dO2bv3AfEMck0rO5dwDCkQvMljxEpH7XPq67ikVBMAHZBcqJoeXla091TyA8UHaORsPV5jO7DFXQtqhQ7MmbW/uSgAPLDQeEYDdU5NddKT939YwUgYjv5YDA5r4s3CL5oIXYrzDigciLYaPQ8KxDFs2Ock1HSZ9J7N9sGTaXFkw7gHLFszAuR3bQoZc6YTE8BsbhzvAz5vpCurL+k96h05INShCCh5FkzcILup3OdJ+LRTg==

From: Steven Rostedt <rostedt@goodmis.org>

When the use of iomap_dio_rw was added, the calls to the trace events
xfs_end_io_direct_unwritten and xfs_end_io_direct_append were removed but
those trace events were not. As trace events can take up to 5K in memory
for text and meta data regardless if they are used or not, they should not
be created when not used. Remove the unused events.

Fixes: acdda3aae146 ("xfs: use iomap_dio_rw")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 098ef23598fe..7977af7c6873 100644
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


