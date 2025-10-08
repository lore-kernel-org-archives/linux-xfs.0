Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512BD17A2E0
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942598; cv=none; b=FydmuOFtQcQyS4SKfYx/SrUYlsisPtDAV6j0fo3hay/IrSo9/PnyZF/Yuhqp5sd4NURz4+Js/KOsQvy08ktw7iW/l7FgvteN/zxlzHhWAn8SyNFzONhwga9gc0IrsIVXQS0tzlWNrUbNiD5eidH3fJ8521l4aLQ8IsVisc0WaEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942598; c=relaxed/simple;
	bh=fYgWUOeTBR8v8NhwroHEfLeivYm2tktB35tQ5QVkW80=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLmo8PtJK5Rs46RiwFHNKgJ3+M2IWlIqD5aOu8bCpX2Iz/K0hqcfIKoJZobxXMWqvofyQ2h72divrR87afO1jIdGDTXhavv1IbOGF6bmPT7eaJ3Exc3E2gNOHbEx5LWUe4yiwn1rxLDg/sMNd4PyxH55MuK+3CVR96b8nuKlHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151ECC4CEE7;
	Wed,  8 Oct 2025 16:56:35 +0000 (UTC)
Date: Wed, 8 Oct 2025 18:56:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH 8/11] [PATCH] xfs: improve the xg_active_ref check in
 xfs_group_free
Message-ID: <ip55didmvyhl5eu32rvy47med2pjxmadllrnrhfx47zo2uezcr@ac4n7u6ffpzq>
References: <cover.1759941416.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759941416.patch-series@thinky>

Source kernel commit: 59655147ec34fb72cc090ca4ee688ece05ffac56

Split up the XFS_IS_CORRUPT statement so that it immediately shows
if the reference counter overflowed or underflowed.

I ran into this quite a bit when developing the zoned allocator, and had
to reapply the patch for some work recently.  We might as well just apply
it upstream given that freeing group is far removed from performance
critical code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_group.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index b7ac9dbd8e..03c508242d 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -170,7 +170,8 @@
 
 	/* drop the mount's active reference */
 	xfs_group_rele(xg);
-	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) != 0);
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) > 0);
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) < 0);
 	kfree_rcu_mightsleep(xg);
 }
 
