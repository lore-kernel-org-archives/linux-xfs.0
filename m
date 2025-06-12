Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B372D8DC5;
	Thu, 12 Jun 2025 21:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763504; cv=none; b=Vr21f+GDGrikcRaTY+M3BfrUMFhU8pIXUs/hIARDNyvR1sEpnMs9PiR4gS9E6SC7P+SPj+dOXntDDxni8Si4DWwvPQ0OTxputEONAULKM2rXXKTsOr313lc3Vk4JjdftOr40YpK67mRIEwVYrn4EpfrGFKBaSCDLP2w+IrehB5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763504; c=relaxed/simple;
	bh=IJ78fjClEcTPz7L5WLA2FwSnFv3v0R2KlHOf4dlR5TQ=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=gI70oI7AW0WChVr4GUPEJRqgha4rbbwAACbLo3X0dRLPx2Yk6+AnU1EiC5tz9+DEHiW/OqX7oh+srCqG6NMaMUb1gV+fgZjjix+tcAIbZDdmxrtLxNgYGHJOq1/jo45UQUuagSkttgLEa7ee6PsfarS35pL5Bx/bUK891M4/VC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1ACF1CF094;
	Thu, 12 Jun 2025 21:25:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: nevets@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 3D5D180012;
	Thu, 12 Jun 2025 21:24:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@goodmis.org>)
	id 1uPpRT-00000001tPz-2LNx;
	Thu, 12 Jun 2025 17:26:35 -0400
Message-ID: <20250612212635.411754637@goodmis.org>
User-Agent: quilt/0.68
Date: Thu, 12 Jun 2025 17:24:10 -0400
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
Subject: [PATCH 05/14] xfs: Remove unused xfs_reflink_compare_extents events
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: sgkdc7hi81b6j3nge8xc1qory3xrmey3
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 3D5D180012
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19nDpZI/ee7iSofY8en9RmKM+4l953O1ao=
X-HE-Tag: 1749763499-917816
X-HE-Meta: U2FsdGVkX19txEltUpPBpqHkjHOwNFv96fbMoIJjwPA18ONC84nLxPPWIs1jFa97vusRGzT8bATvSALu9/ITSkPybCQ6YfAiZH/U0We1cldBq+9tDnDBlJ05OnWu82cngOFCv48PG50awE/KkefnFZlMB7hbyIpG5x6jmPjWZIyek7I0/X48j8uHiFLpQMxOyRJ+lMWfgYsc5uMtmDC7onE6C8Wm28GqQ0uFFV7LfC+HKjv21duyvgydy2QOBS7CyRDCBBXPj6WcK4T9oV9thOOT4+9wDaBBggvBnh2fDMhYIja321ErbQAG7fCn4xBSbAWabECVRZE38YC7akyTK2QKM95W8y+i+R2kWbNwswKh6ws6wPnG85Etm5182h0G8Dxv1s2pc5yDKbQMp3XDVg==

From: Steven Rostedt <rostedt@goodmis.org>

When the clone/dedupe_file_rang common functions were refactored, it
removed the calls to the xfs_reflink_compare_extents and
xfs_reflink_compare_extents_error events. As each event can take up to 5K
in memory for text and meta data regardless if they are used or not, they
should not be created if they are not used. Remove these unused events.

Fixes: 876bec6f9bbf ("vfs: refactor clone/dedupe_file_range common functions")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/xfs/xfs_trace.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ad686fe0a577..fe22f791de6e 100644
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


