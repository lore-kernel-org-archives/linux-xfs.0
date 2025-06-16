Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6774288C36;
	Mon, 16 Jun 2025 17:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096378; cv=none; b=s5wVVCtvu3SBmr1A9hL9ONVLt8UhNzsGOQkKPchF40jfjnQVAsR9TWtTy0qNyzUuc13zKGVOLa3BJPknz8cgP4bs799eCxIHCvQakdyvFF3dzog5wLfS7flpSm9ctkRp6PhxMi7LVahyrG8Ry4eonH2l50o8hYGYA17gZ7XkGDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096378; c=relaxed/simple;
	bh=tZK8sZhrRuJkUd94DOj0Da3QF8eQqbxhHLW8WZ0Xpww=;
	h=Message-ID:Date:From:To:Cc:Subject; b=NKSZwvDZ2GFuqhKQG3Rw2wR/8z6oy8oznyK6jxs6Zz/zmXSbHsAd34DE6Oafxn8KH50Y+Zq++Ad3ifYGVaZMIicZ8tV5PcnpOoIi6jR7ws/Mq8Z/E2YcDipmJGCFCOS8ncws/TSKy4ZxbBzuA1LqlbGaS6ILct4E51DYBV13EtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 628AA1D6E83;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id DCB1018;
	Mon, 16 Jun 2025 17:52:52 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0u-00000001KSl-2giW;
	Mon, 16 Jun 2025 13:52:56 -0400
Message-ID: <20250616175146.813055227@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:46 -0400
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
Subject: [PATCH v2 00/13] xfs: tracing: remove unused event xfs_reflink_cow_found
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: DCB1018
X-Stat-Signature: pcm5p1o6d9ehrao3yxj8mhp1t1eqgbmo
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX187sn21lbs88YuYah9C4XSDehXNxsM/QFs=
X-HE-Tag: 1750096372-767895
X-HE-Meta: U2FsdGVkX18XIL6B6qSaT+uXtfwF5NpCFUrZd6pWI88AYnQ81d8uoiGpwJrhSlkDCeDlyMmOTLgcbjcw2khbtwBuKCO9tM0Ss1y9E6klJCNY8czY4ajA4jQMo7pghxhYQ//5vFjUzWkuIgErta42PxO57NLNYHNH5xV09uVoiO7/q5jRm6ja95YP1yXHDiqwBDZj9NUiVrPe+fbr9/+S5Z/fRaoj61bV3Sze4vD1AD3pYuXvIDdt9nWwtA3phKguzXpjC9fPep9bK634mVNLIL3yVM8DfBjrPcNZh9ZBJyuUyZmKSwMakyIhiqkx0cDyW3b0Tmh2xIbU0JL4U8+EiaxecVPKxalRgwWLL7yvNH9OB0fEBce1heHoOkhGaPt5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>


Trace events take up to 5K in memory for text and meta data. I have code that
will trigger a warning when it detects unused tracepoints[1]. The XFS file
system contains many events that are not called. Most of them used to be called
but due to code refactoring the calls were removed but the trace events stayed
behind.

Some events were added but never used. If they were recent, I just reported
them, but if they were older, this series simply removes them.

One is called only when CONFIG_COMPACT is defined, so an #ifdef was placed
around it.

Finally, one event is supposed to be a trace event class, but was created with
the TRACE_EVENT() macro and not the DECLARE_EVENT_CLASS() macro. This works
because a TRACE_EVENT() is simply a DECLARE_EVENT_CLASS() and DEFINE_EVENT()
where the class and event have the same name. But as this was a mistake, the
event created should not exist.

[1] https://patchwork.kernel.org/project/linux-trace-kernel/cover/20250612235827.011358765@goodmis.org/

Changes since v1: https://lore.kernel.org/linux-trace-kernel/20250612212405.877692069@goodmis.org/

- Removed the first patch that mistakenly removed xfs_reflink_cow_found

- Change subjects to start with lowercase

- Removed xfs_attr events that are used in an #if 0 section instead of
  adding #if 0 around them

- I added: Reviewed-by: Christoph Hellwig <hch@lst.de>
  to all patches but the one with the modified #if 0 as Christoph
  said he looked at them all.

Steven Rostedt (13):
      xfs: remove unused trace event xfs_attr_remove_iter_return
      xfs: remove unused event xlog_iclog_want_sync
      xfs: remove unused event xfs_ioctl_clone
      xfs: remove unused xfs_reflink_compare_extents events
      xfs: remove unused trace event xfs_attr_rmtval_set
      xfs: remove unused xfs_attr events
      xfs: remove unused event xfs_attr_node_removename
      xfs: remove unused event xfs_alloc_near_error
      xfs: remove unused event xfs_alloc_near_nominleft
      xfs: remove unused event xfs_pagecache_inval
      xfs: remove usused xfs_end_io_direct events
      xfs: only create event xfs_file_compat_ioctl when CONFIG_COMPAT is configure
      xfs: change xfs_xattr_class from a TRACE_EVENT() to DECLARE_EVENT_CLASS()

----
 fs/xfs/scrub/trace.h |  2 +-
 fs/xfs/xfs_trace.h   | 68 ++--------------------------------------------------
 2 files changed, 3 insertions(+), 67 deletions(-)
