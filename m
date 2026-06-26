Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4553EEAC4;
	Fri, 26 Jun 2026 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782469794; cv=none; b=D/Yzwykok+X8HW54q7FCfrWC2q2e1rYfZZekmXv5g45FhBtgvQWWNJOY6eIb+AeSAKpCMHV4Tf8QnEpJS1f96w4S7Vs/oYTPpFTaCsFtLvn+dDVFXtWH72bBt+67pF/kxgUUA/of0R9KG25yjbIJSKSxHu01bNyNgYd1FUneaBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782469794; c=relaxed/simple;
	bh=EsCnv2zmPQtUII0ivM5AHcOr5T7brTfAfOxKCs5CIts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxgjqsPWzOiJ15krYutUewz272bL25qRac4NS4gccjnhO2/UPO+/PH7/MGewQiwS+lFBi4COd0qKF45XkfKuhQEoiP5ubXUEF/uTkoIEKZFIUK+JAuxGKgPs8BO8L1tTGCWovf1wJanky54GBa3RMBVJIEqVJczmx2zcTSCUlMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRmOXlfN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRmOXlfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D091F00A3A;
	Fri, 26 Jun 2026 10:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782469790;
	bh=cvducXg29uuJnpCPgKOHgyWH7lcPyLlmDYyWrhgzOjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRmOXlfNBznIxjyH7lRRO76bIPs4WnnU4R99ybql2ZMYtGqMAaW0sojoWDwtVsofB
	 VSJk5Bh4xUPH72eYQPe4hOJVKFtzJ0cKcKIimP4TWopA2KoIcQMaM0inqTMmwPMO4v
	 o+dnQGoy1zSIoTvtzuyD0Ld57BlvXfxpgMLToMG7m+aONE+IlLxJvyQ8FtbcXj5533
	 EPvOY2eSfZrGtAJPgNFx6iA1rwQWd9ZBPbQlsuoo5tU2QFkizU1c+MpxdrMWHeTQDv
	 GPiOK+RdnJrZjZECbvRdfbNbb5VuOHf4KUGhL5fhE4a3GD0YIwibMQRGvAPY4Xbcow
	 HtVkhGgBw9kfw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	stable@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: [PATCH 1/2] xfs: fix capabily check in xfs
Date: Fri, 26 Jun 2026 12:29:24 +0200
Message-ID: <20260626102934.57834-2-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102934.57834-1-cem@kernel.org>
References: <20260626102934.57834-1-cem@kernel.org>
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

This also fix the remaining calls to has_capability_noaudit()

Fixes: eba0549bc7d1 ("xfs: don't generate selinux audit messages for capability testing")
Cc: <stable@vger.kernel.org> # v5.18
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Reported-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_fsmap.c | 2 +-
 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_iops.c  | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index b6a3bc9f143c..7c79fbe0a74c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -1175,7 +1175,7 @@ xfs_getfsmap(
 		return -EINVAL;
 
 	use_rmap = xfs_has_rmapbt(mp) &&
-		   has_capability_noaudit(current, CAP_SYS_ADMIN);
+		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 96af6b62ce39..852ff2ab4531 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 325c2200c501..9db9ef1d8c3a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -835,7 +835,8 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+				ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
+				&tp);
 	if (error)
 		goto out_dqrele;
 
-- 
2.54.0

