Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1216F10E9;
	Fri, 11 Oct 2024 01:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611125; cv=none; b=i8o1fY5cqca5oqReXkDKkWUaD0PufocwoHsHxtWIk0BoNmZRn7xF+6UiOZcF64YEBbqHd3jnOsOOSbla8UVtY20SlGFigtsk0T749hIKOr8Vzd9dDYBtDRBuGWTS+ORi/r0l1K3q19yKoGGgqXnDtNv86xGr30PI3hhxgKA8/xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611125; c=relaxed/simple;
	bh=6ufvS2BdbchJ7il6c/Tcb9EZj+BexSqh1IitcvCunak=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WB1BKtZg43yjnDhNqxvdFwjEeR95XZbMc1joXZXMpbcj4xMnJd34/pgGoOSlz1qylmSgEaYOt1kJCp/TUv3mu7CJ3CR/Bbij3KlLqdP85nZjYsSjhDZqmQKiu0GzsIn4+gw0E9tVX5hF2Fx4lm5u9Py6g9J4haSWpB+UX8uBAzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ymc25nC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ymc25nC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE554C4CEC5;
	Fri, 11 Oct 2024 01:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611124;
	bh=6ufvS2BdbchJ7il6c/Tcb9EZj+BexSqh1IitcvCunak=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ymc25nC8qa5mPWFMKSOBBiJpU4ngBAPFLSXcNX55PWgZH56/Wmm8K5QhzXTQR/A1W
	 VCnm11HZX7xwNrdOpmgMNH6y6o5RNjO9Nbnm/cNtneFAOXEfhtu9Dcy1/RFU7nmk2P
	 EW+GEF5XoNLwHAxNlLnsuTOnQ+xx1i8AjM/IFhYKrllhaBgAK2UaUw8eli0PjGKkbJ
	 8R7IKXGo0Ot6xqsktyPXjvqJmmGFNnm0r+2vhSd6cA0atQ6Sp80lxPkSi6iMc/Bi/L
	 W+cC6pTO6ENWlsIcS2PFQmvMtwCW5Tb3x6WYm/GvACHy1GZ2U/gN2CkZ9LRythnpQr
	 oeOYrF8/tEHeA==
Date: Thu, 10 Oct 2024 18:45:24 -0700
Subject: [PATCH 1/4] xfs/122: update for segmented rtblock addresses
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860659110.4189705.11393328061722947918.stgit@frogsfrogsfrogs>
In-Reply-To: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
References: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
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

Check the offset of sb_rgblklog.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 18aff98f96ac46..3fbc4d4fc49ad1 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -36,7 +36,8 @@ offsetof(xfs_sb_t, sb_lsn) = 240
 offsetof(xfs_sb_t, sb_magicnum) = 0
 offsetof(xfs_sb_t, sb_meta_uuid) = 248
 offsetof(xfs_sb_t, sb_metadirino) = 264
-offsetof(xfs_sb_t, sb_metadirpad) = 204
+offsetof(xfs_sb_t, sb_metadirpad0) = 205
+offsetof(xfs_sb_t, sb_metadirpad1) = 206
 offsetof(xfs_sb_t, sb_pquotino) = 232
 offsetof(xfs_sb_t, sb_qflags) = 176
 offsetof(xfs_sb_t, sb_rblocks) = 16
@@ -45,7 +46,7 @@ offsetof(xfs_sb_t, sb_rbmino) = 64
 offsetof(xfs_sb_t, sb_rextents) = 24
 offsetof(xfs_sb_t, sb_rextsize) = 80
 offsetof(xfs_sb_t, sb_rextslog) = 125
-offsetof(xfs_sb_t, sb_rgblklog) = 280
+offsetof(xfs_sb_t, sb_rgblklog) = 204
 offsetof(xfs_sb_t, sb_rgcount) = 272
 offsetof(xfs_sb_t, sb_rgextents) = 276
 offsetof(xfs_sb_t, sb_rootino) = 56

