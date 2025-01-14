Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4904021322A
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 21:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890870; cv=none; b=QfB4Ma0t4KnhlCtyZhxArJAuK9o1Q0+pgOk+p9tDEzzcvmk+6LwxhABav+/9HDQRJ/yKxMiKGHqK6tuRg/1/2w2/YFf20kAIWDtYseVU4JOuBtwzseoYDFx+6J4kJrqEZJdMTmGGubOxkMKTfYmICxlkwA5FNtDfkmNxULDw4FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890870; c=relaxed/simple;
	bh=HhIakbguhjSvzIyjUQWXNglItuB2Ko8xFViSBjMk/g8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oWuUl9E4/TCDRqfxiQvDkNy/RjWeIlqpmpRCkxWKiy5RHVmaif1av3D4yXZKlzgeD8ryWuVPe/2ayZcbVHZJT3sSMRxUEG+R5AMGB1t2YNOl0JXoPIaUa0OJAtZF2V3G+4abC4RlJ2husUWRbAhBN0cQIQRaDvQoF75Bz7jGWhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKB/qIaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKB/qIaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B6FC4CEDD;
	Tue, 14 Jan 2025 21:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736890870;
	bh=HhIakbguhjSvzIyjUQWXNglItuB2Ko8xFViSBjMk/g8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HKB/qIaODyje5V4+CKGd1ERt7bv3LByfhYIkH3x/P+I9eTbiKPXu6RoXJ0FHvDfZo
	 XaSqEQbN/cK2nVMPLnOw/SE8E6n93DeFI3pRJffeSwrY32t/5prlyhAryJ+iIomBlM
	 Al1DYbLVyrQv2NvpnxWzuM15RzYXVLDsr7uea7GFhVZDbTvrGgBcsMmkF10LtfJvFY
	 iLklQ28R9l7sshpVte0gJFdvKrPb/Rs5HvXlfLuc0r13cYepWiYn/w4QtfW+JwChLs
	 d653GQM4FHe8+WDv3My/GqUwo/RVEDgKmdOOz7QHYcoyqGPoOjFd2ytADoNFujTw30
	 fCKIoJGlY86Jw==
Date: Tue, 14 Jan 2025 13:41:09 -0800
Subject: [PATCH 3/5] m4: fix statx override selection if /usr/include doesn't
 define it
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173689081926.3476119.12874616172883806766.stgit@frogsfrogsfrogs>
In-Reply-To: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the system headers (aka the ones in /usr/include) do not define
struct statx at all, we need to use our internal override.  The m4 code
doesn't handle this admittedly corner case, but let's fix it for anyone
trying to build new xfsprogs on a decade-old distribution.

Fixes: 409477af604f46 ("xfs_io: add support for atomic write statx fields")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 m4/package_libcdev.m4 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 6db1177350b643..4ef7e8f67a3ba6 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -112,7 +112,7 @@ AC_DEFUN([AC_NEED_INTERNAL_STATX],
           need_internal_statx=yes,
           [#include <linux/stat.h>]
         )
-      ],,
+      ],need_internal_statx=yes,
       [#include <linux/stat.h>]
     )
     AC_SUBST(need_internal_statx)

