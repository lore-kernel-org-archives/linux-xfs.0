Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D746535C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589789; cv=none; b=iE+Jh4scpew9+M+yBD4uIgR25sMZ/W7rzmRQx+evX/JsbjjA5JSBu1g9Kx7hf6stymU/luFXB59Mlo76jfy/2Tk5b1tpmcWBwvg86V8wev2S9Cuw1rIwTpmRX+7TQN6XhCXDaSQA58E/esbygEa6K9upu5aiD+TAzD61AR5P0ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589789; c=relaxed/simple;
	bh=7RrwGcD7/ZEz+ldEbHbwoDqPPF8KjHTRZ8GcH4yKZ6k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PYDi6sirUAhFKJlWKhQGPWkwpwAL3KxhSZbsaf6dXDqdYGIN5hYZzcDnTWyI7J5Pd9KSeDnCIdVEkpQYiUr2JWCe95UCqoW1VuJCOANJazQ4i6tMo+1NsEDJWV82gbE2HzzlzcFo6j2nP21ODwpVOqlcPBo2XbUOYu7vpDj/Q38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBfqWsHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBfqWsHF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 57D8A1F000FF;
	Fri,  9 Oct 2026 23:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589788;
	bh=26pvMU6XldnG77bwiHYuGjlMcB+rAYdoMUL9NZJ+4DE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gBfqWsHFO8ftQx4ojv/z8HIXrM7M8j2C8wwRkfJaVm2gKJO/czd1BVgHNVbkJOVcj
	 TOQTJyTVKKSIgdX7s6X1GTn9X6OsQ0etWlT6oX1heSwtiP5YEgam70ROtpDALIz1Eb
	 czjzv01VIj3P3dwiVTweo1JECX4PAo0HIXYykYzqVRcY5GlqvignwqRfS3UsNeeDUb
	 6Gpeu+yUd2+rPr0drqS04kITDVvpfS1Uxlgeb71fc1SFWmrbq19zK71SvPnwY+vXB5
	 GIM/JGqKaVkusssDZrYwGUYx8gvo6conrcECa9aP54QIlefdZgJqpXHSdvlR0mQlq2
	 5V2GQ0skH8kNQ==
Date: Fri, 09 Oct 2026 16:49:47 -0700
Subject: [PATCH 16/26] xfs: initialise args->total for parent pointer updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, floss@jetm.me, linux-xfs@vger.kernel.org
Message-ID: <179158947660.3719791.3371360207752076827.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Javier Tia <javier@peridio.com>

Source kernel commit: 8e4ebb6afaa34bd2e8ce52da231003d24111c2d6

xfs_parent_da_args_init() builds an xfs_da_args from a zeroed
xfs_parent_args (kmem_cache_zalloc), leaving args->total == 0.
xfs_da_grow_inode_int() treats that field as a running block reservation
and subtracts from it; because it is an xfs_extlen_t (uint32_t), the
first attr-fork growth wraps it to ~0U.  That defeats the free-space
check in xfs_alloc_space_available(), and when it coincides with an AG
that has exactly zero available blocks the allocation is clamped to
maxlen 0 and returns -ENOSPC, which xfs_defer_finish_noroll() escalates
to a filesystem shutdown.

Set args->total the way the log recovery path does
(xfs_attri_recover_work(), xfs_attr_item.c:706), in the add and replace
paths that can grow the fork.  Removals and lookups never grow it, so
they leave the field alone, matching that switch.

Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_parent.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 9420d8089e8c25..385fb4cafdc544 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -192,7 +192,7 @@ xfs_parent_addname(
 	const struct xfs_name	*parent_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -202,6 +202,10 @@ xfs_parent_addname(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			I_INO(child), parent_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	return xfs_attr_setname(&ppargs->args, 0);
 }
 
@@ -238,7 +242,7 @@ xfs_parent_replacename(
 	const struct xfs_name	*new_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -248,6 +252,10 @@ xfs_parent_replacename(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			I_INO(child), old_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
 
 	ppargs->args.new_name = new_name->name;

