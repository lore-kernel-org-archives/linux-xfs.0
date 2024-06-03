Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A3EF9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440692; cv=none; b=DNaK544SE4Cr2Gb5TyoxGxYHQz17qzk3sHlRJnZmU0dZr9Eu/GTlKoAz4qF2iBRb1eCMWcAkzBBACfj21fkkFO4i+ROA/r+4YairABA+icqlMjrl1qtFBKCg5OEXpKcyJBcVGOSEWfrolpSHc4WXMuQgnX+Ec56pK2kBiXdZeUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440692; c=relaxed/simple;
	bh=WWwIT5M/tzs+Feo4cLV5B7sbQMJZeJfo1czDP3f5HjA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AM1QIMaesqdgc5YgCrKsPC0GZJIMItyDnzdLEK3C0dvehPqKNTf61086xrPLDRbklM9AOAUpcrpoPZ6VQRzy/v0vxGR8QHMLMEV0ocsVBJ+TRm3gWe6Vi7TVJcxbv8HWWS0hv9odjQAdksfM3Vv+8bzDYYPmOMsU7aMydBcleww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/O1Dxq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/O1Dxq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B01C2BD10;
	Mon,  3 Jun 2024 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440692;
	bh=WWwIT5M/tzs+Feo4cLV5B7sbQMJZeJfo1czDP3f5HjA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A/O1Dxq5j4BfhSxCguNGRAiIauufGuulBYhGLkudszavKQpojTQKxIylEs1Bu/dnP
	 s5IG/+oxmLV2YMQ1CZFrRglEetrPQS3VJWQ1gaHP2o6xxkVFIRcvo2XW9f9XEk0rbO
	 BOJyZeAuk6mLHYVBt6IHFKsjs/FLrJ3x4NX/Hvsv0Y3xGPH//nczankflj+iPFWjXC
	 yVHElWkfcQM4qLP1Mcsm6pukH542fyFyk1v9F/dFaCzjUd2Ytb4FqR9E/Y0fzQe83Y
	 2nSF3HrX6Iz3od5pkMNhUbUB88+lP2QKnVd33VNzGY8q8o+9QCFEFVKZO33ULwb0D/
	 +PKfx39xpB6ig==
Date: Mon, 03 Jun 2024 11:51:31 -0700
Subject: [PATCH 1/3] libxfs: actually set m_fsname
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744038803.1443816.15899669983217056474.stgit@frogsfrogsfrogs>
In-Reply-To: <171744038785.1443816.16653837642691924792.stgit@frogsfrogsfrogs>
References: <171744038785.1443816.16653837642691924792.stgit@frogsfrogsfrogs>
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

Set the name of the filesystem before we actually start using it for
creating xfiles.  This leads to nice(r) output from /proc/maps such as:

7fcd0a44f000-7fcd0a450000 rw-s 021f6000 00:01 3612684 /memfd:xfs_repair (/dev/sda): AG 0 rmap records (deleted)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index 6ac9d6824..c9c61ac18 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -643,6 +643,11 @@ libxfs_mount(
 		xfs_set_reporting_corruption(mp);
 	libxfs_buftarg_init(mp, xi);
 
+	if (xi->data.name)
+		mp->m_fsname = strdup(xi->data.name);
+	else
+		mp->m_fsname = NULL;
+
 	mp->m_finobt_nores = true;
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
@@ -903,6 +908,9 @@ libxfs_umount(
 	kmem_free(mp->m_attr_geo);
 	kmem_free(mp->m_dir_geo);
 
+	free(mp->m_fsname);
+	mp->m_fsname = NULL;
+
 	kmem_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		kmem_free(mp->m_logdev_targp);

