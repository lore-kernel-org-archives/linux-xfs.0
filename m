Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A32DCC12;
	Thu, 12 Jun 2025 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763506; cv=none; b=cM3puxVNDIZ3xIvl8F8u1tjqk1AO6kz+JtqaFZxmdWz0uBcHJK7EaIPbWGc9UeVK7XTqG9IMX383LJde7JZIMamyjUWyJyd34l5nILZDYZYKcq5BpJoW5hxjj8J8CsmiMKuvEhfwo3FbMPS06nVesOVrvABr6vsCNs3/UQdy3Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763506; c=relaxed/simple;
	bh=w6Uo262VhjHbfeaV/nb5W81D7WAIexobDSw1kv1idQo=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=qo5dL6DR7bwYc0SOu1lYdarAt/M8x0RbUfgwmsxFM/i1V7cILPKY+/VLH/Txwj1ryMgwz7Cs4RTzXZs3yJBGenUt+X+LBvLA8xOvLiW1x3csY2AfcbsD/BMyZgl8692vrur5Op7Fo47PLsG9HEGfRreZlmug2eSsTATHpEIh6Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50DFD57998;
	Thu, 12 Jun 2025 21:25:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id A10E22002C;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRV-00000001tUO-0K7r;
	Thu, 12 Jun 2025 17:26:37 -0400
Message-ID: <20250612212636.933500763@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:19 -0400
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
Subject: [PATCH 14/14] xfs: Change xfs_xattr_class from a TRACE_EVENT() to
 DECLARE_EVENT_CLASS()
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: A10E22002C
X-Stat-Signature: ncatgiqa6b4xu14ce5mf68kh7rqtg38c
X-Rspamd-Server: rspamout07
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19GzQHBVNlOhxtGSB/EBRDqpj/Xw+XXV7I=
X-HE-Tag: 1749763500-549411
X-HE-Meta: U2FsdGVkX18amOI4PfLEoWEmG8qlq+xcoA+Pt10mkf80y+f75woyTcea5EsdlyMXMEtyXe8Jmtyd3mW8wA/rp5JdknzG0kQ51KxUMp/jpbkU50ZAmvBbRKdxzibruDnJtHb8XhWj7+e7siXDoZ4cYZPP7alqLg0/BNZLbJ6BiaVWTbvu+gcvxe5qGXzm7f8usRmK0WLkld6XOPWTslKsbG5zxnNLnY9N7Qoyn2lQ6Njo4XuraCf+ZNIJg6otNPLJH7pmxcgZe6ks5e4wcFl+xnRwg9olzyqDE+osMwjjpiw06AuoIejnn05vw98Ygp0r5vHbv7YO/1FeqzEuNJSGb55WgDEn/qGV21K7K3RRQSqYDEMeajvWl6O2d/miZ4dSs7JZXdPvNDPioM+C6wsYig==

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


