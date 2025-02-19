Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9D625761;
	Wed, 19 Feb 2025 00:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926564; cv=none; b=RCj1Oj0gofSZdQOxu7is0twudYnnDeE00bF2AkykWItKl+iJiyk6zhdR/+sqxXw9NJGp6NaaqwDwpaA1ll/A9f1RZ3TmLBSIHn0DAeKEBC3buF098XXIy5aOcdM19m3UXCkpU6DMywjjIjf47Pt0UxRsZODSFsiGdu018N2TN/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926564; c=relaxed/simple;
	bh=Q8Njvk8D6kDQ3abzvEziLAnEihgS+6Zk+gKkrxLSflw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W+TMnTJ41vDqouXI6RUaaXtL3WAS/+lQS6wra4ue2NFdZRL2qSIPBKhGnWSupjRDpN8owsUy9as1v+6c/wUkYTdvVG4YmEC7VFv6xXbcQntoSG2mwZFsQ0DyoYS4aF/q3iVprDifGd6Jj4cWePP2orbXNOAXcOdSpRpgwjP0Jds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ttjaa0F8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ttjaa0F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85A4C4CEE2;
	Wed, 19 Feb 2025 00:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926564;
	bh=Q8Njvk8D6kDQ3abzvEziLAnEihgS+6Zk+gKkrxLSflw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ttjaa0F8TKL1+NQamXGeZT+9/Uf+H80frri32bkFdzKyu8xpV4XR5I5Yc58djWowF
	 hcmsIxcu8MIcLnW7FMYXa6VTPlGk8SrIEJriwFHFx9llbH4w1Z35kHyrWREctBUCXz
	 3jIvmYwyrR9AR0s1RgrX0Ja9TSpLtDZb9hMdeFF8VYB8SE003q8lGXRs0X/Bc0BBVT
	 8es8k6chJOj9vRWtuPVWXqa1t0dfvKb1nju7EPzvh75eL5vr10r9dr1AnlSBJrNXsj
	 2uYQfyZ/B51mcSvZdJjPV68Fy0bEGwFNbw2mmAKzJ2XJyuULQjCXqbteJThVQ2W+hk
	 2GEhTNHdgh6ig==
Date: Tue, 18 Feb 2025 16:56:03 -0800
Subject: [PATCH 10/12] common/populate: label newly created xfs filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588245.4078751.18091181818919832636.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

When we're creating fully populated filesystems, add an obviously weird
label to the filesystem images so that it's obvious that it's a test
filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/common/populate b/common/populate
index c907e04efd0ea9..7690f269df8e79 100644
--- a/common/populate
+++ b/common/populate
@@ -280,6 +280,10 @@ _scratch_xfs_populate() {
 		esac
 	done
 
+	# fill the fs label with obvious emoji because nobody uses them in prod
+	# and blkid throws a fit
+	_scratch_xfs_admin -L 'I❤🐸s'
+
 	_populate_xfs_qmount_option
 	_scratch_mount
 
@@ -537,6 +541,10 @@ _scratch_ext4_populate() {
 		esac
 	done
 
+	# fill the fs label with obvious emoji because nobody uses them in prod
+	# and blkid throws a fit
+	$TUNE2FS_PROG -L 'I❤🐸s' $SCRATCH_DEV
+
 	_scratch_mount
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="${blksz}"

