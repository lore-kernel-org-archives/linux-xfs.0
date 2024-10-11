Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5782BAF9;
	Fri, 11 Oct 2024 01:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610938; cv=none; b=rWdW9aIjFt8yD+L0MmHLbAs0fOitIuJI7Oww2/dZ8qcwrpXIPVqs1k7duIPE+TcR8fWODoOvEPyP6pnWVZ4ZKlTeDlJKtKQZWs2wg/7atCXaZ5hb5zvxsoklCVHGj1hNmoXXqJJd2VcEDZDOdI0WB7Jw15tlcrhv915voEce3Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610938; c=relaxed/simple;
	bh=ckwOgN2cxXvoy3HwMlPkQtdEJIRYZO0/yZzFlwGYp0E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qSJcuDz2+XpXf30kg8kS2bbuannwkVsrAS67lCgevsbZ31nhJq2iGliEbdaET5Xb0NIMdJC4vPNl8MG+YgBrtWrPSunybYEG88jOMtbe4loReffJanZbgsBK9yGDDrR/C0wbZU/snWiYHLN+7xs0p2M2nMkoeLkFayNv7h5ZaJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CESIHzQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CESIHzQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4DFC4CEC5;
	Fri, 11 Oct 2024 01:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610937;
	bh=ckwOgN2cxXvoy3HwMlPkQtdEJIRYZO0/yZzFlwGYp0E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CESIHzQ+T2T8VdfOYl9iNM3CfT/c5YbmnF48czH/16VKkUTUFSHCPbL0ExEaKIu7G
	 JuUjFla2BwqRykdB041Tu4SQ2MI9+i7z/inN6/2K++SvFL+grx0gUaZzSErybdZfRq
	 pB5xfiYamKvVk+kU5hwoHtWW9LGqNWEneV5NwrO4REeiC6bGFgWI4mz3DBbNllifs+
	 +qhQQdu7plogjmv5JfzqwIOsQvxhlrRlf8gMmAlOWfMm2KaUiv5YVk1FTBBKKgNimB
	 00ukHNJb2a9IIwQRJvljosvQ7npUfSjvPP2SZ2qX1EJvVxYiWVDPqd7OkzIufX4aAN
	 DmJAM8WSRwWJQ==
Date: Thu, 10 Oct 2024 18:42:17 -0700
Subject: [PATCH 05/16] common/populate: use metadump v2 format by default for
 fs metadata snapshots
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658597.4188964.16216384974639853164.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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

When we're snapshotting filesystem metadata after creating a populated
filesystem, force the creation of metadump v2 files by default to
exercise the new format, since xfs_metadump continues to use the v1
format unless told otherwise.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)


diff --git a/common/populate b/common/populate
index ed3ee85ee2b6db..b9d4b0fad5999c 100644
--- a/common/populate
+++ b/common/populate
@@ -55,7 +55,12 @@ __populate_fail() {
 	case "$FSTYP" in
 	xfs)
 		_scratch_unmount
-		_scratch_xfs_metadump "$metadump" -a -o
+
+		mdargs=('-a' '-o')
+		test "$(_xfs_metadump_max_version)" -gt 1 && \
+			mdargs+=('-v' '2')
+
+		_scratch_xfs_metadump "$metadump" "${mdargs[@]}"
 		;;
 	ext4)
 		_scratch_unmount
@@ -1043,8 +1048,12 @@ _scratch_populate_save_metadump()
 		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 			logdev=$SCRATCH_LOGDEV
 
+		mdargs=('-a' '-o')
+		test "$(_xfs_metadump_max_version)" -gt 1 && \
+			mdargs+=('-v' '2')
+
 		_xfs_metadump "$metadump_file" "$SCRATCH_DEV" "$logdev" \
-				compress -a -o
+				compress "${mdargs[@]}"
 		res=$?
 		;;
 	"ext2"|"ext3"|"ext4")

