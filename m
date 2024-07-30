Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1CF29A2;
	Tue, 30 Jul 2024 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722352645; cv=none; b=d7VbqJ3XbMtQsYWYeOSr+Ls3PUP6hoj2QIprLT/kt9amGlKFHI1aZM0hzi96Je8HCw354rZiZ9nPI9xXbUYQp7HoWPC7WYNS83M1AwEeQl0GYm374A9ynotpjDqyC+UdCz0fkKjIcjwt/p70W+vTjd2UlYxK1nCcFFvh6PWM6/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722352645; c=relaxed/simple;
	bh=vWu0Diub1TRNjZ/jW742Kn7BUgxLuuip+5MVKdN9IvA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BIvNvv21k9mZlocTwu/sxmKQTWPUEnpJKxzaou+ZmaXCkpFS1luWzKI85e81FKmx59WqahhegIauJDsAUHClayQRKLY9NHAM+agtCJT1k91IEcJuLUCGKXRszu5SEQ8uvnwydQCEZyi7j/EVXB+XvUSfeY41apu1v3NhNudJRW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/LZnrE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/LZnrE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548B1C32782;
	Tue, 30 Jul 2024 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722352645;
	bh=vWu0Diub1TRNjZ/jW742Kn7BUgxLuuip+5MVKdN9IvA=;
	h=From:To:Cc:Subject:Date:From;
	b=n/LZnrE7akfepcW9wBTIiMI/Jg7JrZWIn/RhYgk7p1GKI/ORNIGAaC7ihTNEVIzku
	 b2kO473LDHBk5FYrAmRl8gkGl9LtWCnW2e5Jhb075qph3do3sd/yEJklJc4TeAwgXq
	 zLlW0eEMqEH86WofjqjpWrp8YTKGdciy7iGP5ubYQ756ni2kJeoy+qKs9HNdTsdcj/
	 vtvI+xydzaqc5BNmVPNMH2LcN8mQTtp11A05h7qaQfHRZVcfSgy4ZOdv9LcharuoKQ
	 TzP7VgkwLIR/Fvv1Ab4vZ20Ad0qfCQZZGQul6//9nMGdAaOUz6EnhLVnaN99F6EKye
	 aQOxVYEE9XXbg==
From: Arnd Bergmann <arnd@kernel.org>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	kernel test robot <lkp@intel.com>,
	Dave Chinner <dchinner@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: trace: replace strncpy() with strscpy()
Date: Tue, 30 Jul 2024 17:16:26 +0200
Message-Id: <20240730151716.2511975-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

I got a warning about an strncpy() with possibly missing NUL-termination:

In file included from include/trace/define_trace.h:102,
                 from fs/xfs/scrub/trace.h:3584,
                 from fs/xfs/scrub/trace.c:58:
fs/xfs/./scrub/trace.h: In function 'trace_event_raw_event_xfile_create':
fs/xfs/./scrub/trace.h:973:3: error: 'strncpy' specified bound 256 equals destination size [-Werror=stringop-truncation]

Use strscpy() to auto-size the output, and zero-pad the string
as before.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 3934e8ebb7cc ("xfs: create a big array data structure")
Closes: https://lore.kernel.org/oe-kbuild-all/202403290419.HPcyvqZu-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I'm not entirely sure about whether to pad or not, as about half of the
ftrace macros with strscpy() pad and the other half don't. We probably
want them all to do the same thing here.

If there is a chance of leaking kernel stack data to userspace here,
we need to pad the string, otherwise not.
---
 fs/xfs/scrub/trace.h | 2 +-
 fs/xfs/xfs_trace.h   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 92ef4cdc486e..6f7fa24e1273 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -970,7 +970,7 @@ TRACE_EVENT(xfile_create,
 		path = file_path(xf->file, pathname, sizeof(pathname) - 1);
 		if (IS_ERR(path))
 			path = "(unknown)";
-		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
+		strscpy_pad(__entry->pathname, path);
 	),
 	TP_printk("xfino 0x%lx path '%s'",
 		  __entry->ino,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5646d300b286..79d159fab2e6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4728,7 +4728,7 @@ TRACE_EVENT(xmbuf_create,
 		path = file_path(file, pathname, sizeof(pathname) - 1);
 		if (IS_ERR(path))
 			path = "(unknown)";
-		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
+		strscpy_pad(__entry->pathname, path);
 	),
 	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-- 
2.39.2

