Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603A02DCBE4;
	Thu, 12 Jun 2025 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763505; cv=none; b=sdu1T2tXVHtoGisUkVaOIM/avEV/oFkMFAO3He4doq6Tmdwfu8Fr69FdTAQ5VXZFpfFshsqAujECI3IPbmNC04smPgIE8AA8uCvcuR7OQ/Wy2Sc9/dT5fUjTxc+GGOTM4Jw2e5Vd508k4rx6v5hZmPVbnDJZpIjtIQovv/NqfkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763505; c=relaxed/simple;
	bh=zRnYHNw1IkZxk/dBgC0osXHFs/qpnb5lqXbr0izsgqE=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=EJZ5mjlVtYG2yxO9Od/SYTbpYghruf/cZaeNPu+3dgKa/0KzuE61NPkrUcjmOlgltW7kazdtcjzVHLSd7ud1KcOA9qnsrQgnCm6N3/QGcgAobmksLr7pI7tb87kr7j/iAEpFo9NI3w5uLXpwCYr6oawiHVeQe9j/E/rNCtXDRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DD1412023A;
	Thu, 12 Jun 2025 21:25:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id B859920023;
	Thu, 12 Jun 2025 21:24:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRU-00000001tRT-0FV6;
	Thu, 12 Jun 2025 17:26:36 -0400
Message-ID: <20250612212635.916651164@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:13 -0400
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
Subject: [PATCH 08/14] xfs: Remove unused event xfs_attr_node_removename
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: 5m1a4pwrf6tfcigetmrakcdqarri9u1w
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: B859920023
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18OIw2FF8TdDdPXyr4KM5DiiLb9E2yrGwc=
X-HE-Tag: 1749763499-341034
X-HE-Meta: U2FsdGVkX180+/Ybqn2q8J6nsyJy0JJb4oN6BzAf+TBUsnro2JryN/aMq4vdUrSUL4SCcoqCutZe2adrqA9pO6UOzuKI2EpiifHS1KKLd0Dk6rOeelXiqesMaPPbsSEMpj8UE8Ml6wKQJzsCI7bWVWPvD/87Y6GGb9uXGaXLonvKKUK4Ic61Yn4S4XyRWcfu21Sa66OQBcY/YdZrjPeBvDI99GyQjtpN65jDaVsXf/svE2rP9LEdCj218OpRak7zwW92fig0oBV9j8w7BiKrn1SsQqhGiBm9OiWCWfmhaYI3y2cFZ7KgudK2BFct+Xqlyyr87Wb+/XEyYUnF4d8wkEdBAnaWx1FQY+bdo8FTkFMS4d97PpVCw4krgnvh99QY49MTcEQTVs7oZAeYK47d6Q==

From: Steven Rostedt <rostedt@goodmis.org>

When xfs_attri_remove_iter() was removed, so was the call to the trace
event xfs_attr_node_removename. As trace events can take up to 5K in
memory for text and meta data regardless if they are used or not, they
should not be created when unused. Remove the unused event.

Fixes: 59782a236b622 ("xfs: remove xfs_attri_remove_iter")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bd4e5a727b73..3c15282b2a8a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2465,7 +2465,6 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_toosmall);
 DEFINE_ATTR_EVENT(xfs_attr_node_addname);
 DEFINE_ATTR_EVENT(xfs_attr_node_get);
 DEFINE_ATTR_EVENT(xfs_attr_node_replace);
-DEFINE_ATTR_EVENT(xfs_attr_node_removename);
 
 /*
  * When the corresponding code in xfs_attr.c is re-enabled
-- 
2.47.2


