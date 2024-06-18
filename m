Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E88AEEA5;
	Tue, 18 Jun 2024 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671809; cv=none; b=gfHDg706VPJNDM1KEZiMqFyKM7j6pvl7I+M+EkgmBD71GEK3D6kgXionFS793jaxb2qRWogt8rjy5ADPZmNmk+UCyAsTmB59vASwvw6OtiPpZmAf1vp/VqEzEnXF11EmiXfj0qeSyTO6LPbflfgxm9UDj2KmvGe6hBpt3jy0CSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671809; c=relaxed/simple;
	bh=SmZ4Wm6u3LTmHJF+Bxruf1lo5IZY02YEubmnsad5Bz0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W9vDyFv9Cxs9ZmvnUKGgMWvKn85oGDdGDVZIhSYud9WSWSTtouHKXB/HRjQzNTerO+/qiHF0hOmAbUIA/FTyKSGOFCAbhlSO9OaMnyFZeshUVqoodasHs0Y+iKenQHtFMfvmxsdnHXG/4SkS/KQs/Ci67tFUBe36sZMIcYW+3u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oHCKmr9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oHCKmr9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA4BC2BD10;
	Tue, 18 Jun 2024 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671809;
	bh=SmZ4Wm6u3LTmHJF+Bxruf1lo5IZY02YEubmnsad5Bz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oHCKmr9+VohOumanyLI7Ee7sKlHHEt2lqWkdrh4Oy45QvPXjpP63NRb+djgfhK7Tq
	 TTTmZdpX83AIJrOIc5hLGKsXvj6FUHRLEOT03amXrExIDuQAMM5NNuTnKRBeCVxyqK
	 0YlYklNRpTm0zclb4jX0riqzM2IMCPkJkNJ+aDk3Ee3MayX96zUEcwlFhMPAkIEcCz
	 FdP6ryTjJDleaPs6U3WwY0VnNZ0/L0qZsNgCJ+T2l2dgmKZo1q5kF4ZBqAudQhPjcy
	 rigBNZAqRTpu4vyzKZPFYpca8GyihSpGs2zKhZK1ZP6wA7KGVC6j63QoKnFnIWaJEm
	 1BwQp/zWNk8EQ==
Date: Mon, 17 Jun 2024 17:50:08 -0700
Subject: [PATCH 03/11] xfs/122: update for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <171867145853.793846.10098023133879667583.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
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

Update test for parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 86c806d4b5..7be14ed993 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -100,6 +100,9 @@ sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_fsop_geom) = 256
 sizeof(struct xfs_fsop_geom_v1) = 112
 sizeof(struct xfs_fsop_geom_v4) = 112
+sizeof(struct xfs_getparents) = 40
+sizeof(struct xfs_getparents_by_handle) = 64
+sizeof(struct xfs_getparents_rec) = 32
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
@@ -109,6 +112,7 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_parent_rec) = 12
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12

