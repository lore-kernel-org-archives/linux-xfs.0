Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B4447F62
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390003; cv=none; b=hZ+0xiLDNVWagD2zRCiMC6zmknzwBz8V6SrxYiUfdTsvZv/Ar4Ojfm7s0a864YN4uyWk6Bad6cUYX8MkhWVYf3T6FQYbiI1fl+9r5xtDrhR6BXT6YzM7bLKs5NzdDezQH2UaKtvKvHkw/9kyt282Q/dRY2xOw7eufky78G2oVj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390003; c=relaxed/simple;
	bh=VDttbx9llvoRS+pAx4UZyKJs+hNe4V040VNY2SBVvF0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFSxAWmlI08Nwl58+ekji/ObqkRyWEvL2CCrpYtFBo55YiQefaXq+Zxs/Nj3rB/VuTcSD/wKYHdAhlTR1tpsuSwiXdTT+YI0jOr0pe2H1bH0D5xJJ3Dgx/GWEe+RVD87yLaRPq8mCV3YnwVvXv7I8tfMWxWEXjzCDuaGC9mI4FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOyaiQel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOyaiQel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2502BC072AA;
	Wed, 17 Apr 2024 21:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390003;
	bh=VDttbx9llvoRS+pAx4UZyKJs+hNe4V040VNY2SBVvF0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cOyaiQel8XDhVR2i9+W+vhoG9fMfzBXmrSl9AkJKWH90EHsa1sF8HFyBIN6NdCgrB
	 L5BvSZJv3FQPEGWYzhfw68qYL2RafJkL2ZJaW2PgmheVXSlvXSt20HxGilsiBvnvPz
	 PAbMeavgJyk5UhADrg6uL1jjbrNpe+wCWYWBhT29uOvmO58yHdwvOb0nz8XV3J0Hv0
	 qLTtazc3vq8aRqkkhqG6el/2nqzsuokwHKCg86kb7fF5oExwIBLqmkk0UR9f8EhduD
	 hduoOh+LPGKVXPVMwo8sQJJ+R/huQ69USwwdoxWIJjk5nnA1FULW5S/nuoUpc6MKxK
	 TRQJZkzbT84/g==
Date: Wed, 17 Apr 2024 14:40:02 -0700
Subject: [PATCH 1/5] xfs_repair: double-check with shortform attr verifiers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338843994.1855783.13822938144858807764.stgit@frogsfrogsfrogs>
In-Reply-To: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
References: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
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

Call the shortform attr structure verifier as the last thing we do in
process_shortform_attr to make sure that we don't leave any latent
errors for the kernel to stumble over.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/attr_repair.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 01e4afb90..f117f9aef 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -212,6 +212,7 @@ process_shortform_attr(
 {
 	struct xfs_attr_sf_hdr		*hdr = XFS_DFORK_APTR(dip);
 	struct xfs_attr_sf_entry	*currententry, *nextentry, *tempentry;
+	xfs_failaddr_t			fa;
 	int				i, junkit;
 	int				currentsize, remainingspace;
 
@@ -373,6 +374,22 @@ process_shortform_attr(
 		}
 	}
 
+	fa = libxfs_attr_shortform_verify(hdr, be16_to_cpu(hdr->totsize));
+	if (fa) {
+		if (no_modify) {
+			do_warn(
+	_("inode %" PRIu64 " shortform attr verifier failure, would have cleared attrs\n"),
+				ino);
+		} else {
+			do_warn(
+	_("inode %" PRIu64 " shortform attr verifier failure, cleared attrs\n"),
+				ino);
+			hdr->count = 0;
+			hdr->totsize = cpu_to_be16(sizeof(struct xfs_attr_sf_hdr));
+			*repair = 1;
+		}
+	}
+
 	return(*repair);
 }
 

