Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4219E288C2D;
	Mon, 16 Jun 2025 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096380; cv=none; b=RCU7tCw0fgzlG/YJcRltPrUj6HZpyAGoICeq7gJ+P9eAGja97R5xT4wcbCWc4NvcF0SIcKNawLueuH/Vw6mv5EPiimt8LnJh/aMI7j5obFbsSbihhCI1sFkIGhCzRApCmrbvC+INUHxw6N8UP2K5iyCvT/ApjsVk1TN2A8Wg6zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096380; c=relaxed/simple;
	bh=GkX6+5ssbSsWC2eRweu5p5dS6b/weFQGhxl3Vz1yWm4=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=scRzjFWl2njWgnCzZ04rY67l5OFJNlDrHObsiZsM0GoTGZmYnP/oir+EaSFiefQxExxaLe1wyc3MUJp3l+7YQ2fgvfuVryGrVu5Lq1Ojfkn9oizaG+e50YL+WVtWte633ILTUqhKPBArGDDp4XkBN84q4A3WOLLZ6yGO02GGmKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98518C0AF9;
	Mon, 16 Jun 2025 17:52:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id CFDA12002C;
	Mon, 16 Jun 2025 17:52:54 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0w-00000001KZ6-3XJ8;
	Mon, 16 Jun 2025 13:52:58 -0400
Message-ID: <20250616175258.691664401@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:59 -0400
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
Subject: [PATCH v2 13/13] xfs: change xfs_xattr_class from a TRACE_EVENT() to
 DECLARE_EVENT_CLASS()
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: CFDA12002C
X-Stat-Signature: 6151eycwd9aj61x8fugb3hnroagoiz49
X-Rspamd-Server: rspamout05
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19GNZDWZ6rXSZs0MgWJEFXBUVhlRJNZ5b4=
X-HE-Tag: 1750096374-804361
X-HE-Meta: U2FsdGVkX1+g5hTChwKkEzGc6weI1MJjDnZc/XzwPe7Mykeii7LOaV5B+syfA7Zl0zJ6NUf6pv49P1IZ89eBtI94uTBoT/jLlWB26uu+EeNbBhvXSr2gngHPGIV+yAtoRtO+dwLs4z0L7GnlBKbp8cf7Xm0pGaoIIpSrJs45tQ/gjUacW8fxzL8b9jhWLHm/iUGRSwFQhBZcp7UBd9lQqtz8Mlt3JOkvZoS9iSzhbQqlbb8aCyZs/tMHyot7vmZqeVoU6nP1eAZcZFL2qc9DNpgBcbEf/mO4jEgBb97lizzVEFRKwCzvEt9ZGJxs9baTbxngz1//Kh48zSyuXEStKdTMtyHCGMMt2gn8aj7CgGcndRXmB1SiZK+Nwq2eIkE4tQ0FfbIredHRI+PhKSeAfw==

From: Steven Rostedt <rostedt@goodmis.org>

xfs_xattr_class was accidentally created as a TRACE_EVENT() instead of a
class with DECLARE_EVENT_CLASS().

Note, TRACE_EVENT() is just defined as:

 #define TRACE_EVENT(name, proto, args, tstruct, assign, print) \
	DECLARE_EVENT_CLASS(name,			       \
			     PARAMS(proto),		       \
			     PARAMS(args),		       \
			     PARAMS(tstruct),		       \
			     PARAMS(assign),		       \
			     PARAMS(print));		       \
	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));

The difference between TRACE_EVENT() and DECLARE_EVENT_CLASS() is that
TRACE_EVENT() also creates an event with the class name.

Switch xfs_xattr_class over to being a class and not an event as it is not
called directly, and that event with the class name takes up unnecessary
memory.

Fixes: e47dcf113ae3 ("xfs: repair extended attributes")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/scrub/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d7c4ced47c15..1e6e9c10cea2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2996,7 +2996,7 @@ DEFINE_EVENT(xrep_pptr_salvage_class, name, \
 DEFINE_XREP_PPTR_SALVAGE_EVENT(xrep_xattr_salvage_pptr);
 DEFINE_XREP_PPTR_SALVAGE_EVENT(xrep_xattr_insert_pptr);
 
-TRACE_EVENT(xrep_xattr_class,
+DECLARE_EVENT_CLASS(xrep_xattr_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_inode *arg_ip),
 	TP_ARGS(ip, arg_ip),
 	TP_STRUCT__entry(
-- 
2.47.2


