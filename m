Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED76396D15;
	Wed, 24 Jun 2026 10:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782296101; cv=none; b=EcRJRGHK0eXZckzXXUZXqyoVb5Nu/LabCHQycHW3vAsoYIrchzxeWAwPheyi1fZ4T2pwbedGneYp8/vG+C2rFj0nMUGSmLjHF7mqVi5MBsC482crvMQztbRwH2YjApSyv41YYpQFZr6CciaGwwjrbxrcOu52REn4di8NWdKyvjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782296101; c=relaxed/simple;
	bh=xgu5KnJ3tj5olbPYMJ7kXMfV15BbmukKbtx+Td4+5xw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T6VkrhRGfty9R7xXfYcQjQxIqW1cw2A75Qba3ylmGKUSj+pJRveNNqw3uZechghNivsszjka9xi9hB7EtHwUqS414JEz243tk/Wwjsb6s1soIUvbIaVqepgZWztRPyyBDU1S+0AZUtnznsptq6jx9qJy8/ygRyUrzdxaCqVV6CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGIi9bla; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGIi9bla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D731F000E9;
	Wed, 24 Jun 2026 10:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782296100;
	bh=tsdFRqB0xYYkP6vZl31C+sWQYtsFokxL51/KbUhHBfA=;
	h=From:To:Cc:Subject:Date;
	b=JGIi9bla8Gd5uyaVK6N0fW6UAOuUUSjIH/jxtm/h9t54zEPtEIpBc9QFtyjBwESQi
	 2j6CpvUBGz6ADjIVMwQI+oPk4GmHphWRgheP+lJQ3oyn8+jdZy18lqJ8NTsuoRphV7
	 Ml1LUR7r9e5Ap06kdkNhxJomy+mWoDyGcGJl2PtTZ9WCUlTkD9oclQDZz1P6jZULpj
	 zYxfDBY+cI8G3hdCPLnC9vr1V+Ix7x1xnn9truL10mUOQO0amYLTZLOFguEh/YNDsj
	 /h99gjob2Zc93EUq5raMc9tcpXw+mj3TN87m1R1anKObnwq4GA5FALKk7BwmYeVKfL
	 y+58ZV7gEYevw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	stable@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: [PATCH] xfs: fix capabily check in xfs_setattr_nonsize
Date: Wed, 24 Jun 2026 12:14:29 +0200
Message-ID: <20260624101436.362533-1-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

An user reported a bug where he managed to evade group's quota
by changing a file's gid to a different group id the same user
belonged to, even though quotas were enforced on both gids and the
file's size was big enough to exceed the quota's hardlimit.

Commit eba0549bc7d1 replaced a capable() call by a
has_capability_noaudit() to prevent unnecessary selinux audit messages.
Turns out that both calls have slightly different semantics even though
their documentation seems similar. Where in a nutshell:

capable() - Tests the task's effective credentials
has_ns_capability_noaudit() - Tests the task's real credentials

This most of the time has no practical difference but in some cases like
changing attrs (specifically group id in this case) through a NFS client
this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
bypassing quota accounting checks.

Using instead ns_capable_noaudit() should fix this issue and prevent
selinux audit messages.

Fixes: eba0549bc7d1 ("xfs: don't generate selinux audit messages for capability testing")
Cc: <stable@vger.kernel.org> # v5.18
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Reported-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---

If people do agree with the fix I do plan to send a patch to
kernel/capability.c to ad a new capable_noaudit() helper which would
come in handy here, but I believe we should backport this all the way
back to 5.18 and replacing it by ns_capable_noaudit() is the easiest way
to do it. Then if capable_noaudit() is acceptable we could just call
this instead. This should also be a test in xfstests.

The patch is still running on my testing suite, I'm sending it ahead of
having the testing finished for discussion/review, so for now it fixes
the problem but I am not sure it doesn't break anything else :)

 fs/xfs/xfs_iops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 325c2200c501..df0eba26dda3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -792,6 +792,8 @@ xfs_setattr_nonsize(
 	kgid_t			gid = GLOBAL_ROOT_GID;
 	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
 	struct xfs_dquot	*old_udqp = NULL, *old_gdqp = NULL;
+	bool			force = ns_capable_noaudit(&init_user_ns,
+							   CAP_FOWNER);
 
 	ASSERT((mask & ATTR_SIZE) == 0);
 
@@ -835,7 +837,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			force, &tp);
 	if (error)
 		goto out_dqrele;
 
-- 
2.54.0

