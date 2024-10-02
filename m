Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65599B66E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831443; cv=none; b=mmF5T74Os+JSWWDwLTg+UgVOrqQCr4/Uueez4W8noxi/SEBSrDG6W+u2Q+2JIhGTrjVGCbLnsksaptHLEIlFBjJTBAQSEbdeznlq2UX8TzoqelNU3kBzdTYpEy1evx6uWOlscdNb1JXCcj6t6f4AGUOj7FOxsAdpx318RioWfSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831443; c=relaxed/simple;
	bh=gup2IHPMv3A1DKDPPreCXc5h1ptZL7+LZDpu9w2sJhQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BBhMEGVwAJ39Ot/8Hj+3fHIQ3CaceOg6n0xAZWVi0ViSEGDHirAuBMR64H4x9hHsxtgJyZFEwSwzdr8w5pAAwSdE4z3BsjGJD7efa3Doh8tElabEtFrVcakRUwZJ1y5MqH4lXhqMlFiUWKm8/FMF/wkwougZN7YXeuTufIEHhkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ao3yvS4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ao3yvS4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9D7C4CEC6;
	Wed,  2 Oct 2024 01:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831443;
	bh=gup2IHPMv3A1DKDPPreCXc5h1ptZL7+LZDpu9w2sJhQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ao3yvS4o1spZB73nwApPvwy14JK2GxHjnoLJdGH1qMuOvVCqAMqgD8iFNCxkWYA6q
	 r0LffVbX6Rv6mHx1syDH5/FOJ/qnM3cuUVYedbOqNNWx02XwoHFaTgeOomdrLbbrP8
	 MpcYUJEk89DCzse71ralPMnfS/iAYIFaqIFOJU7a43SH+tifLyE0UpVtDRaEwAxYts
	 evDkxS7az6mssFapRX6mW8HLnqAI6Jc82sZ3JI7kWeULsfbTIphmNwNkse90RkoM5A
	 Ed5Q2I/SNl9HzvhTnetfI8o0rGu604oAZ/bR6pJMKMTo411Bp97+diw3aiGlBxJZX9
	 xKk/kwCgWiJdA==
Date: Tue, 01 Oct 2024 18:10:42 -0700
Subject: [PATCH 11/64] xfs: implement atime updates in xfs_trans_ichgtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783101947.4036371.10883237028797572122.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3d1dfb6df9b7b9ffc95499b9ddd92d949e5a60d2

Enable xfs_trans_ichgtime to change the inode access time so that we can
use this function to set inode times when allocating inodes instead of
open-coding it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_shared.h      |    1 +
 libxfs/xfs_trans_inode.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 34f104ed3..9a705381f 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -183,6 +183,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 #define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
 
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index f8484eb20..45b513bc5 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -65,6 +65,8 @@ xfs_trans_ichgtime(
 		inode_set_mtime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CHG)
 		inode_set_ctime_to_ts(inode, tv);
+	if (flags & XFS_ICHGTIME_ACCESS)
+		inode_set_atime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)
 		ip->i_crtime = tv;
 }

