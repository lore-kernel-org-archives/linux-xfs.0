Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAD234D90D
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 22:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191888; cv=none; b=JJKZWIicEO5kqAFWvZ2jFfFPORUs95GLjugkTmQS7FCDYQrL6flj7xYgNs9aVfsxjfmhqvART5BIiuEn5qWT2Au0HrgYXatvVyQiLknZi2q3xiSsytsY276KHlClXIeV9isIa6VzV80fgsiqNisNn4ERJa6AwaqOFaa61Y9p4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191888; c=relaxed/simple;
	bh=mNiLiWDomPSnGzmQL0qSRppDWFS8A85jri9Wrksd3vY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nNWroT176wuOjt50DAUz6mIGxMT0FAZLkruWmwjeZXDS44BxNBkAwC+XJaztG3IHTPgvBhzgHtnO9ahA3POG70VhqudUnT6JXR5xT13esKkivM2VxPHjuxF3F47Ku7wfSv9EFrlG7UL0STNs7+0K4bk4fg6VHmxmJ+xGHMSPjtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NpbvtjC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NpbvtjC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033EDC2BCB2;
	Thu,  7 May 2026 22:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778191888;
	bh=mNiLiWDomPSnGzmQL0qSRppDWFS8A85jri9Wrksd3vY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NpbvtjC4fUO/SrQBVXx5Vy8ORnTMkf73tXMAakUjr9QZXtwaUk7PhPT5766mB8OSd
	 JxFxhIu5ZWqWr/ebX3NEIkoPiTAXONZm/qaqsMVBTuK4+icjHb9AAt6fYvaOXUFzOG
	 KPdzlY3URD+MVPM+i0zb8fDl7Pm8W4PEGVCe9S+jUaBGuVr92OTS3zezSk+VbumZVP
	 1VNPykzy894XxFuFnUlHlBh1xxXpG4YKwvtj/9JB/puA40Td/+vYBh9fMD3yxxaHbQ
	 ziYeI77nLawo8+zcknRuNJdngLg48q51DGlWvG7p6vt04kcKDONVyUjtXTTAqTWrqx
	 DWVqbJdCgLSrw==
Date: Thu, 07 May 2026 15:11:27 -0700
Subject: [PATCH 1/3] platform_defs.h: fix __counted_by_ptr annotation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177819182658.3486034.17713563256078765686.stgit@frogsfrogsfrogs>
In-Reply-To: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The kernel userspace headers for Linux 7.0 provide the __counted_by_ptr
macro, so we shouldn't define it separately on those platforms:

  In file included from radix-tree.c:11:
  ../include/platform_defs.h:334:9: error: "__counted_by_ptr" redefined [-Werror]
    334 | #define __counted_by_ptr(member)
        |         ^~~~~~~~~~~~~~~~
  In file included from /usr/include/linux/posix_types.h:5,
                   from /usr/include/linux/types.h:9,
                   from /usr/include/linux/sched/types.h:5,
                   from /usr/include/x86_64-linux-gnu/bits/sched.h:63,
                   from /usr/include/sched.h:43,
                   from /usr/include/pthread.h:22,
                   from ../include/platform_defs.h:19:
  /usr/include/linux/stddef.h:73:9: note: this is the location of the previous definition
     73 | #define __counted_by_ptr(m)
        |         ^~~~~~~~~~~~~~~~

Do the customary ifndef wrapper thing.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: df91bc3bdc9b81 ("xfs: annotate struct xfs_attr_list_context with __counted_by_ptr")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/platform_defs.h |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/include/platform_defs.h b/include/platform_defs.h
index 5a829db66e0899..5d1bfb1baf94db 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -331,6 +331,8 @@ struct kvec {
 #endif
 
 /* xfs_attr.h */
+#ifndef __counted_by_ptr
 #define __counted_by_ptr(member)
+#endif
 
 #endif	/* __XFS_PLATFORM_DEFS_H__ */

