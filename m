Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D2288C3F;
	Mon, 16 Jun 2025 17:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096380; cv=none; b=b8BDD/aiDHRMgC2DipFfneaZ5SFJPtbuKLMgx7g8inx5AwLJBsd53aQ7SKs6lA4Br8URzfYH0cMNCGjeCgBc5dUesiQgi6X7Ha/91f9um99hu61l2f3HZbZaXITE6+Ay6/Cv0l2FIPchkJKch34HrzrnzHMHNILYuBQQRStN0Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096380; c=relaxed/simple;
	bh=AVp114dx6LIJj9Vd/bX8lpwcQYfC2mGHedvxI2YWSDc=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=P2BlYlq2BCl6QzDN+bRzrXkpPk36Xu6nEkkrKeoV+JsRHeq6zU2e/civXPkejt6R4uJrHkbGRGPsXtvO4f2OdiKTrhAPRMe1T7/qLLElsQ9zGB78Iy+6fNaiJWot1KP4jiQoyRqv2adEB3WePB6Lrt8bkzY/6pu+UFPhMLDX0YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24D92BD4CF;
	Mon, 16 Jun 2025 17:52:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 6169820031;
	Mon, 16 Jun 2025 17:52:53 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0v-00000001KUj-1NFk;
	Mon, 16 Jun 2025 13:52:57 -0400
Message-ID: <20250616175257.180775864@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:50 -0400
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
Subject: [PATCH v2 04/13] xfs: remove unused xfs_reflink_compare_extents events
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 6169820031
X-Stat-Signature: 8ebu6r87hmzjy94ce4huz546yxirojhq
X-Rspamd-Server: rspamout05
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+09dk2fJxNMYcf0HeQDLz2wZnw6nwyG90=
X-HE-Tag: 1750096373-741816
X-HE-Meta: U2FsdGVkX19Z3P0KrrHzWZRue+GgVdvYI4OP2XZ4COW9H6U4/8ML0uXAPbclnNmzyRIkgCcHPYMQ2yTFNhTnLwIAgukcPh0Nh154NcUTzXJyz9uMY7XxL87DocTTyd0hPgnQCeK3maB2aKYG5E6ui/o1oW+aUej96z9eHpaDB+j51UaE6C/VCLgJTNWAGJUY5GFiWvDo/8Bj6JkKBj+rTCLpegIgPdIiuHkSH4Q7wc51ilE4/x4vrtGtuU9W+RevL/c1bOM3K2Ialv+R6VVroc8KTC9GE9stOZNG6JA868ZB7csOWqAsxMRlZyuUZZnOyw9VWugCbwT8WCyGs8Ivoh2rzGgymsMmWwH+raJZSqcxojTrqnejGITYt+SpEJolgEekLMT/FBYlRyYMeU+wlQ==

From: Steven Rostedt <rostedt@goodmis.org>

When the clone/dedupe_file_rang common functions were refactored, it
removed the calls to the xfs_reflink_compare_extents and
xfs_reflink_compare_extents_error events. As each event can take up to 5K
in memory for text and meta data regardless if they are used or not, they
should not be created if they are not used. Remove these unused events.

Fixes: 876bec6f9bbf ("vfs: refactor clone/dedupe_file_range common functions")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 993397f4767c..6ba8cf1a52c5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4206,10 +4206,6 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_src);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
 
-/* dedupe tracepoints */
-DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_compare_extents_error);
-
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
-- 
2.47.2


