Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F598143C65;
	Wed, 19 Jun 2024 13:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802550; cv=none; b=IhFQugWdiy7bmnukxEGLc/3VoQDWW2u86mdnUOJ/+WCNxcKMqnD+bKvvK68NJm3e5JkLmtfiUDVgOKn7WHKz81hn9+ecnpn6sx7wZQy2d7p9dHwqvWd/EbgeeEG1YpTMvFCu5cxjJrfieEpyIiQ5SxrYwMUZ5YYUA6F+9zN4Apw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802550; c=relaxed/simple;
	bh=uufU/yDy8njaMpWxmCpa01KyjI4YrqRdRnS4tGqUK3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9elFTY2TAlSf2VVEjrLa1SzX89KrIky5JMXcIiqzN3a1fpNlOq8Fe2dhBoSlcRcga858tsuGfEKgDZH867GCAD8wiGqU2AAPxu0GzwMFiJL/2X/Ql52ljsK9VyIXqENYVATzRCWcoKKt6HZhTNc39nTMJDPfrdC5RlCuai3t0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtKzvoiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtKzvoiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0F1C2BBFC;
	Wed, 19 Jun 2024 13:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802550;
	bh=uufU/yDy8njaMpWxmCpa01KyjI4YrqRdRnS4tGqUK3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtKzvoiOB33IInPsWjsf9Dm3sKCSyWjEtGA7gnmCAf3CR8OqYJLRm2Jndz4bF2DZD
	 /gqbMjNXTgOMF8DIVVVzplN8m5WClnUDI+5C5uAef1Dj1/Nvr6OwUCtv4SnSKB0AXR
	 BAUcACoN2Khoex4+Y2CGxzrfP5oGoJlAccE+qqCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 235/267] xfs: allow sunit mount option to repair bad primary sb stripe values
Date: Wed, 19 Jun 2024 14:56:26 +0200
Message-ID: <20240619125615.343040594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 15922f5dbf51dad334cde888ce6835d377678dc9 upstream.

If a filesystem has a busted stripe alignment configuration on disk
(e.g. because broken RAID firmware told mkfs that swidth was smaller
than sunit), then the filesystem will refuse to mount due to the
stripe validation failing. This failure is triggering during distro
upgrades from old kernels lacking this check to newer kernels with
this check, and currently the only way to fix it is with offline
xfs_db surgery.

This runtime validity checking occurs when we read the superblock
for the first time and causes the mount to fail immediately. This
prevents the rewrite of stripe unit/width via
mount options that occurs later in the mount process. Hence there is
no way to recover this situation without resorting to offline xfs_db
rewrite of the values.

However, we parse the mount options long before we read the
superblock, and we know if the mount has been asked to re-write the
stripe alignment configuration when we are reading the superblock
and verifying it for the first time. Hence we can conditionally
ignore stripe verification failures if the mount options specified
will correct the issue.

We validate that the new stripe unit/width are valid before we
overwrite the superblock values, so we can ignore the invalid config
at verification and fail the mount later if the new values are not
valid. This, at least, gives users the chance of correcting the
issue after a kernel upgrade without having to resort to xfs-db
hacks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.c |   40 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_sb.h |    5 +++--
 2 files changed, 34 insertions(+), 11 deletions(-)

--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -530,7 +530,8 @@ xfs_validate_sb_common(
 	}
 
 	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
-			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
+			XFS_FSB_TO_B(mp, sbp->sb_width), 0,
+			xfs_buf_daddr(bp) == XFS_SB_DADDR, false))
 		return -EFSCORRUPTED;
 
 	/*
@@ -1319,8 +1320,10 @@ xfs_sb_get_secondary(
 }
 
 /*
- * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
- * so users won't be confused by values in error messages.
+ * sunit, swidth, sectorsize(optional with 0) should be all in bytes, so users
+ * won't be confused by values in error messages.  This function returns false
+ * if the stripe geometry is invalid and the caller is unable to repair the
+ * stripe configuration later in the mount process.
  */
 bool
 xfs_validate_stripe_geometry(
@@ -1328,20 +1331,21 @@ xfs_validate_stripe_geometry(
 	__s64			sunit,
 	__s64			swidth,
 	int			sectorsize,
+	bool			may_repair,
 	bool			silent)
 {
 	if (swidth > INT_MAX) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe width (%lld) is too large", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit > swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sectorsize && (int)sunit % sectorsize) {
@@ -1349,21 +1353,21 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe unit (%lld) must be a multiple of the sector size (%d)",
 				   sunit, sectorsize);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && !swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe unit (%lld) and stripe width of 0", sunit);
-		return false;
+		goto check_override;
 	}
 
 	if (!sunit && swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe width (%lld) and stripe unit of 0", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && (int)swidth % (int)sunit) {
@@ -1371,9 +1375,27 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe width (%lld) must be a multiple of the stripe unit (%lld)",
 				   swidth, sunit);
-		return false;
+		goto check_override;
 	}
 	return true;
+
+check_override:
+	if (!may_repair)
+		return false;
+	/*
+	 * During mount, mp->m_dalign will not be set unless the sunit mount
+	 * option was set. If it was set, ignore the bad stripe alignment values
+	 * and allow the validation and overwrite later in the mount process to
+	 * attempt to overwrite the bad stripe alignment values with the values
+	 * supplied by mount options.
+	 */
+	if (!mp->m_dalign)
+		return false;
+	if (!silent)
+		xfs_notice(mp,
+"Will try to correct with specified mount options sunit (%d) and swidth (%d)",
+			BBTOB(mp->m_dalign), BBTOB(mp->m_swidth));
+	return true;
 }
 
 /*
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -35,8 +35,9 @@ extern int	xfs_sb_get_secondary(struct x
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
-extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
-		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
+bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
+		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
+		bool silent);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 


