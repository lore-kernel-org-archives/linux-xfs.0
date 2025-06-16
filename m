Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77DF288CB1;
	Mon, 16 Jun 2025 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096384; cv=none; b=eLJvd+Y/CV8qpDSpphZjmdPn6GPM45W39bjYSRWtEE7S9DCfd/QDVZw5wP34bQV1ST2809zlJqEwAdIesse9nxI5bUJf22msaxoIYkewOcUUM+WfGYphXOiSu6LJj4y4nltUGwLeoQyHwfXWHM5ors0a+UXd1hlk8EtDyx3HC88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096384; c=relaxed/simple;
	bh=EybPv4tas+Ze5YJV/bsT0f6tTifbCg+q6oyv8QKWYmg=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=hqcu75t5bE//Dmft5nnxq4rJ5HiUthXqwt5qncHpqaJBo36rvWBrGs2ir3RgLmGnv5jKMJBAAmGscbvMY146rLIuw3y+uKb30wnS5Su1+3ZHnY3vZ+cHz1tlxJGdlO7E7U3mpBCrQhOMlvS456NZvscAgHEUbQg/iINMBrO/PEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 756861A0B30;
	Mon, 16 Jun 2025 17:52:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id A2C5B2000E;
	Mon, 16 Jun 2025 17:52:53 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0v-00000001KVh-2mn4;
	Mon, 16 Jun 2025 13:52:57 -0400
Message-ID: <20250616175257.512380287@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:52 -0400
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
Subject: [PATCH v2 06/13] xfs: remove unused xfs_attr events
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: A2C5B2000E
X-Stat-Signature: u3bn6zaeyx8gx7wmwsaqnio9gpsn5gr6
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+Lo/MqJBkcEwSF4ph2FmKZmRoOgzNjPvg=
X-HE-Tag: 1750096373-925209
X-HE-Meta: U2FsdGVkX1+rAs6/EWy2qXve9KgcaSliuvGGmwVPqKsSjoHhjdgtYy8zTv6xSTaVLYR2EDWLZLchpCvxlcdRoO2U+viSxY8/nQNsgL0bLw6SGTlviUBk2gb9jgrQ7CS/gaS6tWjLHZJ2cmYmRy1yGaPPVpHXP2VDVzlv8A8WaxKw5RTIJAx3t02dKFimuxNeFTv1EAqw0z08cm960XQ6YH5Gl3QfosRb5yjGMB33LOEzs1tcI2aJAszS81EuZVp+VwEYvtsPDluCS/4HHeYhLXB49/bKNlYyhFXT55xrBqZJQxXm0ZGsDxOuiK7zNNTF+OzIskxoxnsXcoKEWsw9lHfvmdPFPGLPzgYB02MVPQO2aiUZktI8hU2kDLDImOzBdfoqPXJtyNFkEmOZHZiCzbzgr3Ykg4OVJrtQBs9nAnQ=

From: Steven Rostedt <rostedt@goodmis.org>

Trace events can take up to 5K in memory for text and meta data per event
regardless if they are used or not, so they should not be defined when not
used. The events xfs_attr_fillstate and xfs_attr_refillstate are only
called in code that is #ifdef out and exists only for future reference.

Remove these unused events. If the code is needed again, then git history
can recover what the events were.

Suggested-by: Christoph Hellwig <hch@lst.de>
Fixes: 59782a236b622 ("xfs: remove xfs_attri_remove_iter")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/20250612212635.748779142@goodmis.org

- Remove the trace events from the header file instead of #if 0 them out.

 fs/xfs/xfs_trace.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f62afb388189..d41513c76652 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2467,9 +2467,6 @@ DEFINE_ATTR_EVENT(xfs_attr_node_get);
 DEFINE_ATTR_EVENT(xfs_attr_node_replace);
 DEFINE_ATTR_EVENT(xfs_attr_node_removename);
 
-DEFINE_ATTR_EVENT(xfs_attr_fillstate);
-DEFINE_ATTR_EVENT(xfs_attr_refillstate);
-
 DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
 
 #define DEFINE_DA_EVENT(name) \
-- 
2.47.2


