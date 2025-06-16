Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC86128851B;
	Mon, 16 Jun 2025 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750096384; cv=none; b=GyuxL91/uWk84laY6QAnP54Nf7YAD5Vlyh4YBegdQY0D3gODzFdvXvnEYyifVw4zR4i8s04EoZsIiyLe+ZfUBC92isJaocWkrlZrpOcWMyNxujJYURAAeDyFBGLE9Zq50ibws7GBRU5NaZGmEY5pYtVj+M8aEpLc7m5RjAudKWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750096384; c=relaxed/simple;
	bh=Ft7TEOjSPV7cu5J28HR+aHJg0uFasyhK+kE65FHn+Ig=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=J7Ym0liZRpzlbQKQqv9k3AMcLxoB/YliCvDC0NBr5ji5F2ftrII7XYK2RwAtxH4bMrBtuDPhIUvnVPHLEBkVYcNEd0wbat1ZG6MV3tMWBOCFNKxuRZRVZbzXApo3khUYG0LrS+rEexO+B6NRBI/xi7HkwazPeJr4AxR4dOZWX1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BBAF120A41;
	Mon, 16 Jun 2025 17:52:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id D65BD20015;
	Mon, 16 Jun 2025 17:52:53 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uRE0w-00000001KWf-00a0;
	Mon, 16 Jun 2025 13:52:58 -0400
Message-ID: <20250616175257.853108895@goodmis.org>
User-Agent: quilt/0.68
Date: Mon, 16 Jun 2025 13:51:54 -0400
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
Subject: [PATCH v2 08/13] xfs: remove unused event xfs_alloc_near_error
References: <20250616175146.813055227@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: D65BD20015
X-Stat-Signature: ij5anbu7ccs4okso3kid1ywa3nzqif9w
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/T7ax2EFuzHCt0wI5Y2fSq6akM66aq+fc=
X-HE-Tag: 1750096373-849181
X-HE-Meta: U2FsdGVkX18i5CCehyCiL2XsJ/BA3vsQeKcflUX5hUhOe5rHnnSd5uev1svm4VOQw8PGPzU3xTq2/I/8Rio3glXWjTvY1tXubHnDNzaNUQBXclqKUVeLdJ3zFfaFcEwRvMrzIhxcYyfZUqiwo7TmdmTmZLAav1G4tVfOgBKzF8wfbiIhW+FD97YGolaybV8cL5jA1nebplXSAzdxH5/Vtfgm4e5CaZuC7n5RxtPzBjSFv/B9Z1yiQrvr66/Vi2KuEJfrwGC7V0sxzzgKWKw5v3tOTIJD1uYFmwomXVWDrIo+ic3EsoredO1m1MZbOIYg7J4+ywcL7rsMaghjnVK8ztJqeNh3EmD/rEshD9lq+PaYEp1GNTUKq91fTfo749vMBCRMAqPhMvhL/ItXKg0Z4A==

From: Steven Rostedt <rostedt@goodmis.org>

Trace events take up to 5K of memory in text and meta data regardless if
they are used or not. The call to the event xfs_alloc_near_error was
removed when the cursor data structure allocation was introduced. Remove
it as it is no longer used and is just wasting memory.

Fixes: f5e7dbea1e3e ("xfs: introduce allocation cursor data structure")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 41a46f7d3fd6..d4004e21d0c5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2270,7 +2270,6 @@ DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
-- 
2.47.2


