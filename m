Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C6D2D0292;
	Thu, 12 Jun 2025 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763505; cv=none; b=XKDHvayYWP4DceOca+s/bebvVe99i7AdhRTX9zpEoKziU/mdaanS6W66+c7A89uWxcyeIqUBcoY2eP2kpjOp8BK+OM2SaHL2g5gBioCBqvgwoaIyCgv1a9QV8dQngt/UitJ4GuT5QD/rd2rdbw/YBBbkvBb8pmLUFSmGj8zQniY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763505; c=relaxed/simple;
	bh=v1sG8BmYEnPIfc5CTC+a/SlCTBrRKoIo4CT6uG6u9ws=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Qjs/o0WBCYWmby4fhPCbtkTYV9D3RALjv9ZJz9v5WJKRpvyWu/gJs9cfS3OEgNZKCvdNZETTM8pDQ1t7mJkGKNllRvYl3W7Va7Zmdh3aZ9kpm2TFpXKXnCvjIuE4FCY8+O+wyLT+BmcU+BcMysAt2LErjZfwjFJ37ocLczapIPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16DFCB7528;
	Thu, 12 Jun 2025 21:25:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 784462002A;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRU-00000001tTu-3pN5;
	Thu, 12 Jun 2025 17:26:36 -0400
Message-ID: <20250612212636.765270044@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:18 -0400
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
Subject: [PATCH 13/14] xfs: Only create event xfs_file_compat_ioctl when CONFIG_COMPAT is
 configure
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: gjwhakpb6ai165ws88afyxaa6w8ueg5g
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 784462002A
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19u1AuwmCiKQZCNpszhinM9Y4P5VefYxXI=
X-HE-Tag: 1749763500-923667
X-HE-Meta: U2FsdGVkX18BqC2LRgKV3GdOVtsHGlmwrTw9HOFrtXZgn1IbSXt/+DqtSGZ1VfQhfXJPn7IOtbgbPMjk2S3n4pzrL9FmZhZdoG6Q8a8Xse3zvbE78VTRRi/+VMxCM/Nf4lyTe78RgDcG7erVUd7QaikRdy66tMZACK6rbBhBo0mswkcwMr6n+JS8jm8FN05ku4VkdOTIdyQvyFpcyYTgIJGhZDcbdXF2if1hD0coh1Qnm75KuA+J5X/H+IRzyi8YY551ItOIr5dzngtRvR6szh69dKk1a2c2QBJZe9lMfH0HLmqrBi9Na4FE89ZSd1FJXz/q74jU8anrassN5R8vZqJSCRMQ/joeIHBwH+TJuL0IOfNUp1lWHZCjDS69YJJCC9AK94nZ/N2Au3oIASgr7Q==

From: Steven Rostedt <rostedt@goodmis.org>

The trace event xfs_file_compat_ioctl is only used when CONFIG_COMPAT is
configured in the build. As trace events can take up to 5K in memory for
text and meta data regardless if they are used, they should not be created
when unused. Add #ifdef CONFIG_COMPAT around the event so that it is only
created when that is configured.

Fixes: cca28fb83d9e6 ("xfs: split xfs_itrace_entry")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 83d4ef8386a1..76928583549a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1083,7 +1083,9 @@ DEFINE_INODE_EVENT(xfs_get_acl);
 #endif
 DEFINE_INODE_EVENT(xfs_vm_bmap);
 DEFINE_INODE_EVENT(xfs_file_ioctl);
+#ifdef CONFIG_COMPAT
 DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
+#endif
 DEFINE_INODE_EVENT(xfs_ioctl_setattr);
 DEFINE_INODE_EVENT(xfs_dir_fsync);
 DEFINE_INODE_EVENT(xfs_file_fsync);
-- 
2.47.2


