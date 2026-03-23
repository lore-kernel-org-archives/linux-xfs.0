Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC1F3BED59;
	Mon, 23 Mar 2026 17:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286530; cv=none; b=YlcQnQTvd4z2jwotunrVAK8xwiyudjD9ll7zzIfQlubxVTQyIOk4BgQW8eykEdUUNowXUa5rNURGsMbvA62uv2ftQ3WpGcHLHFMJ16ihME5+CXhPZW+Mt+TVvW3Q92S2n+rEwaAchUwq+DDlx3w/Jj1MHf2aRWmLfI0XYxjvnxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286530; c=relaxed/simple;
	bh=sJh27ACHhMobpUq8jC5k7ysmfrpJATZRBiIZaWg4O3o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s/1LNFSHRy2UhdIq5BWub27077db1CmF2ckJyDcHdutLpAfZAaAL0wXJFZ2g59mhoIiSL5fHRuURJmM48ugQWeWhWm+DbPi0L06/5L97fjcOnC0h0Q7TUzOK7TXd1mJf4HGcKNdHaA/qp+Kz2nMAN22P5dQ/VyTxvr6Hn0tKVSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dby7Vm9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dby7Vm9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65394C4CEF7;
	Mon, 23 Mar 2026 17:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774286530;
	bh=sJh27ACHhMobpUq8jC5k7ysmfrpJATZRBiIZaWg4O3o=;
	h=From:To:Cc:Subject:Date:From;
	b=Dby7Vm9dM02Ac4qaNL70qRL/55VnycO8naCzatwpmUOEzKCjPVxcgzlfFLG2kMjse
	 GcmsTwJJGWCFGKSexeK0Sshd2x2eHG08sMEyBPHD43kKc0hqmVmghNKLa+KdeWaTmv
	 J5tTqcsF+Au3FPeipV7A+rGNuycVFvWXGGkfrkepjrBNc3XP8cteR9z/aq2shtSWW/
	 p6QIRVuvKbT9NM3yVo5+o2SmSLRoTjLZQes/uAMNfE5XSC2MFzEmxkVARWkrj3AOPd
	 hUfVsOR8OIomxrr35RicBui3RH9F1ykFzUZ4T6gNYHctLDOxDrfJncXksRwiEj4yqV
	 dVwPUoJtlU+jw==
From: Kees Cook <kees@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] xfs: Replace strncpy() with strscpy_pad() in tracepoint error paths
Date: Mon, 23 Mar 2026 10:22:09 -0700
Message-Id: <20260323172204.work.979-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2194; i=kees@kernel.org; h=from:subject:message-id; bh=sJh27ACHhMobpUq8jC5k7ysmfrpJATZRBiIZaWg4O3o=; b=owGbwMvMwCVmps19z/KJym7G02pJDJkHyw7UyMonhBqGXfu3e6lgs0NW/pLCldvzN/9Zca5T7 z9bW5NrRykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwETsIhgZWicWPdxYX3Nsq2n+ 6Wu5j/dHhInItk7Kfs42kT0/4AXvOoZ/mho7LjzfO3EJB9uKrTuzijc8sf3N0j/394sZXamSB7Q ecwAA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] strncpy() with strscpy_pad() in the
xfile_create and xmbuf_create tracepoints.

Both tracepoints use file_path() to resolve a pathname into
__entry->pathname (a char[MAXNAMELEN] trace ring buffer field). On
failure, the error path overwrites the buffer with the string literal
"(unknown)" via strncpy(). The original strncpy() zero-pads the
remaining 246 bytes (MAXNAMELEN is 256, "(unknown)" is 10 bytes
including NUL).

strscpy_pad() preserves this zero-padding, which matters because the
destination is a trace ring buffer entry: ring buffer slots are not
zeroed on allocation, and the raw buffer is readable by userspace via
tracefs. The zero-padding ensures no stale data remains in the
buffer after the error path overwrites it.

The source is a 10-byte string literal into a 256-byte destination,
so there is no behavioral change.

Link: https://github.com/KSPP/linux/issues/90 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
 fs/xfs/scrub/trace.h | 3 +--
 fs/xfs/xfs_trace.h   | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 39ea651cbb75..46c420f51129 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -980,8 +980,7 @@ TRACE_EVENT(xfile_create,
 		__entry->ino = file_inode(xf->file)->i_ino;
 		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
 		if (IS_ERR(path))
-			strncpy(__entry->pathname, "(unknown)",
-					sizeof(__entry->pathname));
+			strscpy_pad(__entry->pathname, "(unknown)");
 	),
 	TP_printk("xfino 0x%lx path '%s'",
 		  __entry->ino,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 813e5a9f57eb..9f9fb86097ed 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5101,8 +5101,7 @@ TRACE_EVENT(xmbuf_create,
 		__entry->ino = file_inode(file)->i_ino;
 		path = file_path(file, __entry->pathname, MAXNAMELEN);
 		if (IS_ERR(path))
-			strncpy(__entry->pathname, "(unknown)",
-					sizeof(__entry->pathname));
+			strscpy_pad(__entry->pathname, "(unknown)");
 	),
 	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-- 
2.34.1

