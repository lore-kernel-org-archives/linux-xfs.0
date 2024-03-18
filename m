Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C157C59B45
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798480; cv=none; b=OdpWIHVM1rIspwoX4vJjDX7G92l9OpUMrSEXio0dzpnBWED/6dVG+MiUzO0vPa1n7XMUYYMWXUmdGp/KSuzg5h3xgt4nI8PsTEQVrkBrIEMN3cG6MPQMtgwcg89M4BswQ4gRbTVWawPaTRTs+vYfygsCzubAXCvD/+VMXJji0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798480; c=relaxed/simple;
	bh=IyYE0egG/ZKt/BsHxHUiYEnJml+4lNycW18Xa1Mtfgo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFphRyhFfDZL9AkdmjRLyOuxBVU5wQ5bJUq9wuYn/YQhEdkubpxHfp8fyDSRUOhR1xPGAjsHta7g7LR73wD0HgsRUQYWP67cAysxv77i3VTmtnuHOl0ftbB8IwRp+Cm2Q1CLRZjHDnoejHikV1EAZGnS4EKTqCmjWcm7zwbSawk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0HpEg+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0HpEg+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BF2C433C7;
	Mon, 18 Mar 2024 21:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798480;
	bh=IyYE0egG/ZKt/BsHxHUiYEnJml+4lNycW18Xa1Mtfgo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i0HpEg+qCOdO/YQ0fE5v5PIwQhAmDtuoU13LVEpfc/Y7wkdMsR/vbWPf6VeNhAzD+
	 wWSkSb7qa3e+7yN8NMU51PoRNgbYaJAxYin9JMIWaYb1uqiPXPawJo1R7ldm+xhZHu
	 bLX29ITupwAR8klehXz39yCa6Cuugwf/sYp+/obxbBq+4yjj7iT8SU/uISl0bxcVj4
	 PFj8HB1mOASDwhqu5XOzMt0OW3aTdN1F1vOHP+w08J+fiUR/fxIl3Mf51+dcboAVX2
	 RcH6E+yIBZgOhodlbL/qBuGP79yVD6bCBTWjuV95Scw3TWgy3quPIfj7imCLsAEWBr
	 AbEi5NyBu0Fxw==
Date: Mon, 18 Mar 2024 14:47:59 -0700
Subject: [PATCH 23/23] xfs: make XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS sticky for
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802249.3806377.3291293823520148572.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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

Directory parent pointers make directory repairs practical.  However,
online repairs of directories (and parent pointers which are embedded in
extended attributes) must commit the repairs atomically by building a
replacement structure in a temporary file and then exchanging the
contents.

Although there's no hard dependency between parent pointers and file
mapping exchanges like there is with logged xattr updates, these two
features will likely go hand in hand.  Make sure we always have the
exchmaps bit turned on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 62351fdde2c80..348aa9e9d439a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -635,6 +635,20 @@ xfs_mountfs_set_perm_log_features(
 		 * updates.  Set the LARP bit.
 		 */
 		mp->m_perm_log_incompat |= XFS_SB_FEAT_INCOMPAT_LOG_XATTRS;
+
+		/*
+		 * Directory parent pointers make directory repairs practical.
+		 * However, online repairs of directories (and parent pointers
+		 * which are embedded in extended attributes) must commit the
+		 * repairs atomically by building a replacement structure in a
+		 * temporary file and then exchanging the contents.
+		 *
+		 * Although there's no hard dependency between parent pointers
+		 * and file mapping exchanges like there is with logged xattr
+		 * updates, these two features will likely go hand in hand.
+		 * Set the exchmaps bit.
+		 */
+		mp->m_perm_log_incompat |= XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS;
 	}
 
 	/* Make sure the permanent bits are set in the ondisk primary super. */

