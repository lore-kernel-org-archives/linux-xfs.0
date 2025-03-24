Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6002641D8
	for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742836192; cv=none; b=Mmt2HEEhmZbBz4T02adpg6f8w2epWrer+7dDZOjPfNyLdB0LraIK8OWDMwoKlT/kdiu2/ZeNY1tm4T3efPrUntTGc33JGCh8aY/IuQ5e2A8a9J6mVGvCKh4TTKI5iVJQ6x92wz2uFbrWLbxhPqGG+gZBJDQlzI4L4nuUod1DB80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742836192; c=relaxed/simple;
	bh=uAwr/KqfqiBsRC/Dv76YJSwPFkonSlZdErhXZX8UiM0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XxOpnA/eWU8ka4dq5gkc5lqJuainw52Ga5wukBqDOs21gh2PjDn46OwZZTqWt4VhheoCPNB5GxyZilAXFYYqYCTBUEB+hjYbay1k6jpbcxX7qMSeB5i7HW9je131BYZFX0r5e03IivLZX/83vTxoRDCsyyX7KZVk8n2c1FF4Pjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ia13b3DD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ia13b3DD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12222C4CEDD;
	Mon, 24 Mar 2025 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742836192;
	bh=uAwr/KqfqiBsRC/Dv76YJSwPFkonSlZdErhXZX8UiM0=;
	h=Date:From:To:Cc:Subject:From;
	b=ia13b3DDecDNxvM5t61cVGwwBN8dpLpWk3v3wYHDwDhMsjqSa0RgDBT6bbf7PzVRu
	 awHVMR4eXGO6Y64L0emSwRELTwg6Ra4EQfCV5raJciTR+mtgAlHEoA9AGT5qvNMve6
	 uF2lHgMGx+N4EAj/5OfM80UhhbkZZEgYmbJaa0Y1p6lBuTKQI3Sibu70f1NI7B8/Iu
	 kqQyHfxm0iNgXXpniaiLRUD4AT/XtPvojcXFUW+RW+i6xERADpHVPZ7aK+Ds1CG2PE
	 gxTb/h7Qv41YUCVydKu/Zg4qXIhLbRZQFl25cvOiKscqDJQ6w4GxVDUN399CzAhmbj
	 RA1amFR5J7xlQ==
Date: Mon, 24 Mar 2025 10:09:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH] xfs_repair: fix wording of error message about leftover CoW
 blocks on the rt device
Message-ID: <20250324170951.GR2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fix the wording so the user knows it's the rt cow staging extents that
were lost.

Fixes: a9b8f0134594d0 ("xfs_repair: use realtime refcount btree data to check block types")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/scan.c b/repair/scan.c
index 86565ebb9f2faf..7d22ff378484aa 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2082,7 +2082,7 @@ _("invalid rt reference count %u in record %u of %s\n"),
 				case XR_E_UNKNOWN:
 				case XR_E_COW:
 					do_warn(
-_("leftover CoW rtextent (%llu)\n"),
+_("leftover rt CoW rtextent (%llu)\n"),
 						(unsigned long long)rgbno);
 					set_bmap_ext(rgno, b, len, XR_E_FREE,
 							true);
