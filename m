Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F56EADA
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609610; cv=none; b=cKJyluGq4q3YCvjKj/HpSz79RzYH8JWT7L2kO3yp/ray7hP6QDeT2CRnckr0GJaW7U1isI7gNYleOvHr3DJhcZdTlbZGlnDyQGgvUjjyoWZNVOzu1oqK1uPWMQRnFOgBLz4K8EIabgjvmsz7jlh5VZhP9q3SOEqdsBz4UnI4NSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609610; c=relaxed/simple;
	bh=AFSIuPg8xNA42fNEYqfk7+JGvesyH64IpEMa2v24oKA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P8ATVPPm5493IFQr6LTf8+xkzOkoAy2E2hr2kAZ0qhzU+CONJQks09zEpUBA4I0tzkhq+ZjnYt/VoEqq2GFlxriJuyrdTu91+6vKL9uLKRAuyWn0dbkHjKIxzjRQ23A/HIUxyaMfnVd2E18f2T9uDaDIdZ63q0ApW93fwEIg1mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeUGohQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeUGohQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD87C4CEC5;
	Fri, 11 Oct 2024 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609609;
	bh=AFSIuPg8xNA42fNEYqfk7+JGvesyH64IpEMa2v24oKA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CeUGohQx1EVrX+FNPF1gzX8PfVI3sXgr6Gs30JsU+0im1Ljzjxel3xczbkRXgqlKz
	 u5s2HWiPfMmmwJIJUuwZZNUbwJqfPUy2eo4WrY3+7BSRvbA+cmYrRIdphjfug2W1C/
	 zGsYfLkal5R8NCK7sYUL5pG7P8/tfPG63vcNAY2QnuYtP+4bLw+zizRQ/isgqiuS0r
	 qAbH2JDm+crTopU++nbd7uuIyDsmiFmuYfD+xFLQjKuLFoUgo1ugag4VDL2I+5oJ56
	 TcRN+ayN4U9PgbRUYUxbjrcjANEQCOWQ4NASDsEFo9+Sr8ntLGDFSOm2CqfrAYBG5c
	 Cfp2phSQo+oCg==
Date: Thu, 10 Oct 2024 18:20:09 -0700
Subject: [PATCH 23/38] xfs_repair: check metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654329.4183231.6161847704126574260.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check whether or not the metadata inode flag is set appropriately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index cd4c8820854604..91507cf13c2690 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2331,6 +2331,26 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
 	}
 }
 
+static inline bool
+should_have_metadir_iflag(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	if (ino == mp->m_sb.sb_metadirino)
+		return true;
+	if (ino == mp->m_sb.sb_rbmino)
+		return true;
+	if (ino == mp->m_sb.sb_rsumino)
+		return true;
+	if (ino == mp->m_sb.sb_uquotino)
+		return true;
+	if (ino == mp->m_sb.sb_gquotino)
+		return true;
+	if (ino == mp->m_sb.sb_pquotino)
+		return true;
+	return false;
+}
+
 /*
  * returns 0 if the inode is ok, 1 if the inode is corrupt
  * check_dups can be set to 1 *only* when called by the
@@ -2680,6 +2700,27 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			}
 		}
 
+		if (flags2 & XFS_DIFLAG2_METADATA) {
+			xfs_failaddr_t	fa;
+
+			fa = libxfs_dinode_verify_metadir(mp, dino, di_mode,
+					be16_to_cpu(dino->di_flags), flags2);
+			if (fa) {
+				if (!uncertain)
+					do_warn(
+	_("inode %" PRIu64 " is incorrectly marked as metadata\n"),
+						lino);
+				goto clear_bad_out;
+			}
+		} else if (xfs_has_metadir(mp) &&
+			   should_have_metadir_iflag(mp, lino)) {
+			if (!uncertain)
+				do_warn(
+	_("inode %" PRIu64 " should be marked as metadata\n"),
+					lino);
+			goto clear_bad_out;
+		}
+
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
 		    !xfs_has_reflink(mp)) {
 			if (!uncertain) {

