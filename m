Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C551531E3;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763503; cv=none; b=VSVQIzigm7hyMGePXg/JEQmh3l/aJbViMIf+jXPbRO061lwW8O4Jvsgb/A8q9xDD3fCO+7MYZcJB99qDHn1xKFDCQPH+5y/u8xbLBE3OufPezDvWGtWbM7qZP6gbL626SYz4dAQRJQFJtWrwvChGR99jPQ7O8lWE5rQ9/cTNsvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763503; c=relaxed/simple;
	bh=7SjvAXjeJ0nvuBZiDMxwdfwjUnxYr0x5jRK9wVLeXJE=;
	h=Message-ID:Date:From:To:Cc:Subject; b=LozoHXts6AzZ/5taC1SZowETXHKteheQZy4tNqtVqa5FbY4lBFgwIUPPP4JdhQ+jJHq7xmiKzOTqGaroeD4kFltuWZdLFRczTOxsmSIIT24mHnPpYPaTj1m+w2t4oQ8aF6/oABivXQ6XlLilRX3hhtFhTiTxd99JLVonmYD3NGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33DC080204;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id B558C1C;
	Thu, 12 Jun 2025 21:24:58 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRS-00000001tNX-30QH;
	Thu, 12 Jun 2025 17:26:34 -0400
Message-ID: <20250612212405.877692069@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:05 -0400
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
Subject: [PATCH 00/14] xfs: Remove unused trace events
X-Rspamd-Queue-Id: B558C1C
X-Rspamd-Server: rspamout08
X-Stat-Signature: wq675b79rdphqfgqixpukxw3d3un663f
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+Ax5MAjOcJ29EVG3gfU5XX0sRHeHtqIZA=
X-HE-Tag: 1749763498-748952
X-HE-Meta: U2FsdGVkX1+0SqhOynDNGn1BljA160RXa4HqQqH6JyR76BE5xw3NTCp+KJRY07mQFtWFkK9W5ZsPkFlRKgAoUZBtZELTWoCY34sfh/1q2YLTdUTX8Y44d7w1U7dro1pKVrcWiN72AwovAgUg6ERCiuO7M7TcFADEXOEFF0Jgt71DklNLAm9KoSlhUirrMTGjsGsy2QDaDxyCliFDqD9YnVqSF/cIDnrdJVUyhQLhyLTGL/0KoLc2h9rPQP5WL8HchDtSAQPXhDkxqoCjcQE2AW0NgvQxVEg/4TUeTCA4uPs=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>


Trace events take up to 5K in memory for text and meta data. I have code that
will trigger a warning when it detects unused tracepoints. The XFS file
system contains many events that are not called. Most of them used to be called
but due to code refactoring the calls were removed but the trace events stayed
behind.

Some events were added but never used. If they were recent, I just reported
them, but if they were older, this series simply removes them.

One is called only when CONFIG_COMPACT is defined, so an #ifdef was placed
around it.

A couple are only called in #if 0 code (left as a reminder to fix it), so
those events are wrapped by a #if 0 as well (with a comment).

Finally, one event is supposed to be a trace event class, but was created with
the TRACE_EVENT() macro and not the DECLARE_EVENT_CLASS() macro. This works
because a TRACE_EVENT() is simply a DECLARE_EVENT_CLASS() and DEFINE_EVENT()
where the class and event have the same name. But as this was a mistake, the
event created should not exist.

Each patch is a stand alone patch. If you ack them, I can take them in my
tree, or if you want, you can take them. I may be adding the warning code to
linux-next near the end of the cycle, so it would be good to have this cleaned
up before hand. As this is removing dead code, it may be even OK to send them
to Linus as a fix.


Steven Rostedt (14):
      xfs: tracing; Remove unused event xfs_reflink_cow_found
      xfs: Remove unused trace event xfs_attr_remove_iter_return
      xfs: Remove unused event xlog_iclog_want_sync
      xfs: Remove unused event xfs_ioctl_clone
      xfs: Remove unused xfs_reflink_compare_extents events
      xfs: Remove unused trace event xfs_attr_rmtval_set
      xfs: ifdef out unused xfs_attr events
      xfs: Remove unused event xfs_attr_node_removename
      xfs: Remove unused event xfs_alloc_near_error
      xfs: Remove unused event xfs_alloc_near_nominleft
      xfs: Remove unused event xfs_pagecache_inval
      xfs: Remove usused xfs_end_io_direct events
      xfs: Only create event xfs_file_compat_ioctl when CONFIG_COMPAT is configure
      xfs: Change xfs_xattr_class from a TRACE_EVENT() to DECLARE_EVENT_CLASS()

----
 fs/xfs/scrub/trace.h |  2 +-
 fs/xfs/xfs_trace.h   | 72 ++++++----------------------------------------------
 2 files changed, 9 insertions(+), 65 deletions(-)
