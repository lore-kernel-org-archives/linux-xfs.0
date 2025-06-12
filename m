Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76F62D8DDF;
	Thu, 12 Jun 2025 21:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763504; cv=none; b=kABnKZnM7/8wqgGk8SKN+be25sYP6DVPRfVXiNKfGX0/oWP+BWYxPpbih/gvCW0sEgqrOEa6Inb3yhWc5zqTlmPy3nMi2CElM724JBTwukaWQ+b072AMFwXDa2ydczw9A7O+xvwM95Y3TLygQPUsqbVRA3HeIkUAHeWjxm3EHUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763504; c=relaxed/simple;
	bh=4l3kvVo4cfZ3K+FLvtLpoePJnS6GtWwUUo0+jAAGrMQ=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=kLThxcoX/w+U8dkokpihqBMbKe1OWy++YsDdmR3ALybJfqPKFb1Pm0qP4wklUgfOgyYyIbcfJprLDIrCZt4HmsqRYooPATbb4jHqMKpHaNaPUIPf0A9JeGX4yjEUHbRZ+lq8v1SyswF039HWVb1P09r6gl36hqt76JYUPM6V0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 332875797F;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 78DC36000F;
	Thu, 12 Jun 2025 21:24:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRT-00000001tQz-3lDh;
	Thu, 12 Jun 2025 17:26:35 -0400
Message-ID: <20250612212635.748779142@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:12 -0400
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
Subject: [PATCH 07/14] xfs: ifdef out unused xfs_attr events
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 78DC36000F
X-Stat-Signature: 1utj44zzuw5br316xpcfjk5zcjm6ch3b
X-Rspamd-Server: rspamout05
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+70v1B4gCQRQSAQWGzzZ3vC3aBvg7avbk=
X-HE-Tag: 1749763499-862500
X-HE-Meta: U2FsdGVkX1/1hnysNfa5zsbZin82bbtuFgMe7yngO5DHHkHezDEa50Hhcj1J4MXCc+mCvuWRtLriMc08/AwYX7eQMXw5lmOSsEdhrjmCxJnxldNR0EAQjnHhenGvsI91xOrtXAG/IbBQLnfUe7g6uR0U8+wi/oJJ7xBTmXWB8lFozZOQfUL/gmXFtI/e/9sHeoTpD+n1AcknKKjLK+VgaDg99Xx8lOxbNMal0Y3Gcg/lBlNIjDczXqDGjaY4gmAtUjDzmbey04PbW70IZk9amFRiwhZt+MC5M6puZmXaIGxvaFQFq34XqETB13Nk71NyhD0p1D0vCTvoIMiBIgsl9NeILxuHNkI3OLj9M6Tm7+6F5cv+PBa0Ihy4ICjBpZ4LCjzm/kKv3tdnrwIvVFUWGQ==

From: Steven Rostedt <rostedt@goodmis.org>

Trace events can take up to 5K in memory for text and meta data per event
regardless if they are used or not, so they should not be defined when not
used. The events xfs_attr_fillstate and xfs_attr_refillstate are only
called in code that is #ifdef out and exists only for future reference.

Ifdef out the events that go with that code and add a comment mentioning
the other code.

Fixes: 59782a236b622 ("xfs: remove xfs_attri_remove_iter")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cdc639198bb9..bd4e5a727b73 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2467,8 +2467,14 @@ DEFINE_ATTR_EVENT(xfs_attr_node_get);
 DEFINE_ATTR_EVENT(xfs_attr_node_replace);
 DEFINE_ATTR_EVENT(xfs_attr_node_removename);
 
+/*
+ * When the corresponding code in xfs_attr.c is re-enabled
+ * then so can these trace events.
+ */
+#if 0
 DEFINE_ATTR_EVENT(xfs_attr_fillstate);
 DEFINE_ATTR_EVENT(xfs_attr_refillstate);
+#endif
 
 DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
 
-- 
2.47.2


