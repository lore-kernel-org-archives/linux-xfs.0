Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D919FC1D;
	Wed,  4 Dec 2024 03:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733281429; cv=none; b=JOfR8ZI4VkJt1O2h7+WOWLp03dNahg+UI/zu966HANn8yMwb37fN0HXuYcJRrs/VNLy+8055XDc/ZX9GZ3uUIyGtkZRdPM7vUW1HbW+hD7sVhy3o6HQrpu1CN+SvMqhjr3n+nfJLet83l7K+qnYhEj0n6W+1ddZemd690oKalXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733281429; c=relaxed/simple;
	bh=TJmM8W5+K0zg3aoxdfu/AUtLBWfrSjomVR1p+yNid3Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRE1UmJu7w4e25ZYDkjf1eRasK3KUQ+QZr8oWlARRHemPf+iaNC++fUnF0MWz+pvTnkK5C9/WYbV/JDLO+ImxZ7Mcr36A5/FmaYNf5Y/EBj5NPQVtxw2oCeR4kPgcAA1SPMZOmo2zaX4HcwCqPVM2Kdi+XbJbq5yK+tTT3+mIus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bvk0R5Ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bvk0R5Ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E1CC4CEDC;
	Wed,  4 Dec 2024 03:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733281428;
	bh=TJmM8W5+K0zg3aoxdfu/AUtLBWfrSjomVR1p+yNid3Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bvk0R5EvQblLJNUhJd81FBaG9mAaW44Hla5OTVaAgBCQPWuT0SQXac3I1y/efVLPp
	 EuLfOKQngSyyi5yXZv4nMfGyFxwqoT7X0HL8jnDx50MfnIn8I5w7me5WGpEeHAj222
	 F84+MiF4DshltB+etQP3Sg2xOsiglSPM0ztj/GC1mA3V9lcGqM2ojzgG4kWw7lIhBn
	 PRzbvWfuh/8cHbqYAHKbhm4YkOmL0co4wN8kIfb5aHoLiulB8xQwh0qsFK0tRpF/Rp
	 zAJOtR/WZADh0R2VUj8AjGRUQ8tewfItF98vEo0azL9qKJrLnu7xKGti+a8oVImvO6
	 ljGcizlELmPKQ==
Date: Tue, 03 Dec 2024 19:03:48 -0800
Subject: [PATCH 6/6] xfs: port xfs_ioc_start_commit to multigrain timestamps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: jlayton@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
 hch@lst.de
Message-ID: <173328106685.1145623.13634222093317841310.stgit@frogsfrogsfrogs>
In-Reply-To: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Take advantage of the multigrain timestamp APIs to ensure that nobody
can sneak in and write things to a file between starting a file update
operation and committing the results.  This should have been part of the
multigrain timestamp merge, but I forgot to fling it at jlayton when he
resubmitted the patchset due to developer bandwidth problems.

Cc: jlayton@kernel.org
Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: 4e40eff0b5737c ("fs: add infrastructure for multigrain timestamps")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_exchrange.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 9ab05ad224d127..dd24de420714ab 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -854,7 +854,7 @@ xfs_ioc_start_commit(
 	struct xfs_commit_range __user	*argp)
 {
 	struct xfs_commit_range		args = { };
-	struct timespec64		ts;
+	struct kstat			kstat;
 	struct xfs_commit_range_fresh	*kern_f;
 	struct xfs_commit_range_fresh	__user *user_f;
 	struct inode			*inode2 = file_inode(file);
@@ -871,12 +871,12 @@ xfs_ioc_start_commit(
 	memcpy(&kern_f->fsid, ip2->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
 
 	xfs_ilock(ip2, lockflags);
-	ts = inode_get_ctime(inode2);
-	kern_f->file2_ctime		= ts.tv_sec;
-	kern_f->file2_ctime_nsec	= ts.tv_nsec;
-	ts = inode_get_mtime(inode2);
-	kern_f->file2_mtime		= ts.tv_sec;
-	kern_f->file2_mtime_nsec	= ts.tv_nsec;
+	/* Force writing of a distinct ctime if any writes happen. */
+	fill_mg_cmtime(&kstat, STATX_CTIME | STATX_MTIME, inode2);
+	kern_f->file2_ctime		= kstat.ctime.tv_sec;
+	kern_f->file2_ctime_nsec	= kstat.ctime.tv_nsec;
+	kern_f->file2_mtime		= kstat.mtime.tv_sec;
+	kern_f->file2_mtime_nsec	= kstat.mtime.tv_nsec;
 	kern_f->file2_ino		= ip2->i_ino;
 	kern_f->file2_gen		= inode2->i_generation;
 	kern_f->magic			= XCR_FRESH_MAGIC;

