Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92002421D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000671; cv=none; b=KbCKAnA45txwbFggmt+NzkxWfQKtpW2NDWgvoC1+p3LU9ZwTPeQlKVISEB+8AWd5LyHD1IdEbOO3LLWZICgcDM4YSpGAoKwVVoIT6FfSxogLgVSP57l/7+fh1OR9xkPPL25y0c4bJ3Cd2YxnSEi0mgODxs864xJh24605PUtrDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000671; c=relaxed/simple;
	bh=LAdjwVChe1zhN0+CuaRHZy4DTmqE3kQC+T2SLwSVjDU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FRCyjhJza+1NGptnDkgo8BYwpiYz0OMOZweK69lv+J0YFttzLuzHUDdoxydUj9URtBkgeyNIasNoJwVt2v2GTUU89Ng/BSIDdIgaaw/MmcIQxxy5iax5DYukcmbf27Fi3Nlx0OUdHLzkBh/o7geMZOeTzVKw99NjB1ECP/SQyl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MatGWCZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MatGWCZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F6FC433C7;
	Tue, 27 Feb 2024 02:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000671;
	bh=LAdjwVChe1zhN0+CuaRHZy4DTmqE3kQC+T2SLwSVjDU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MatGWCZbCLLipPWlXAOEz70OnEBuIwRH6EbiaBVQGg0+TyuEtjOvt28m7jQB5hyYR
	 JMpIECRCtvUE+9SzB9MITMGJw7fHgXPNxbmex92RdjRhDQbq+4vmdZUfir+Q7Wg7RA
	 uw4SxhzwmkUcYGoZqy3DZuESEomlQqzSIEk4rbUU3sLwJCPlx4xeA9VT8PQYE59hsq
	 XXnI5aOrO/hA3uTzkQO1rxFbqu5j10XihDqm4CcpbA8GVfRKr1lwmowgbtGy5Taidd
	 EVF8NqGE9d+jp+LMl/ZMGSziHYd2GPjgbp5UBlwb1BOUp9hqsf4xdxrsib2wJYl0VS
	 PIvYZleiokgvQ==
Date: Mon, 26 Feb 2024 18:24:30 -0800
Subject: [PATCH 14/14] xfs: enable logged file mapping exchange feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011871.938268.5781764407461752680.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
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

Add the XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS feature to the set of features
that we will permit when mounting a filesystem.  This turns on support
for the file range exchange feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 753adde56a2d0..aa2ad7e04202b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -398,7 +398,8 @@ xfs_sb_has_incompat_feature(
  */
 #define XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS (1 << 1)
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
-	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
+		(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS | \
+		 XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(

