Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6D54ED1AA
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791999886; cv=none; b=M+7yO6FMAbvcpTuQy6qFXXLUZFo+dUUN0gxtG5rIoTZgJFF3Ip9sFGdJvv40J6Be9kWUgwazZDVhyCVRF65gYqJLoIapsAaZD0CjD1U1NYjDZszXmqSi0776jxcxvKq+IKlTh2AGDtjASftuPrTF1OOfKTcUhDfGX/QRcjHFcnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791999886; c=relaxed/simple;
	bh=pimHXPM7OSmkDIqg+vO53lmjmsefflZE2J1J28FNX4I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oQA4Svi20Y5wq5FX+Ei/yzmo5vcOaBfPr6qFhNQKB2hus3ONI1ckPxWIdRxM8Gs5IkXffnzV3CQkh8s5Z7bAvVFzCVS8EefevZdvDgFd5cKR/8eaKsSlKJul67UcHomakRN6iSgKwyfqcIgY4XnW/1O7SmHUcenQpGBW05btJk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HiRAEICz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HiRAEICz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 43E071F000C4;
	Wed, 14 Oct 2026 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791999883;
	bh=jIKyto3KYfDavBw0lGOEoPWlTo9UaPScrOEDTcXxyys=;
	h=Date:From:To:Cc:Subject;
	b=HiRAEICzktMMhLbZ9Eg8GUpONO1N0c3D+veFQUXwUnklDForkm8QEKfmqM11Byveq
	 i33iz+HsrElmKe2kzuPmG8HKl2D4SoI30olASeb+dxmSyIyjcIkhhk94gddU0T4ACH
	 +BxHkbwx9YcjQcHyqfI9xIkNUMq0PeYRPMmofIMdRchkMEhV1rfhnph4+7FiDMz/2q
	 tGa53F9sQqXxBwfKViTr4B1QRprg4Lm3428kicMOVaYHcdurU8ZDGzykfgVlcyU5+W
	 s+trt742geF1jVauqVM2BRvmzo6oLCho9M9ytuMnj8KnQBpPPlgilxW1fnJkpj5Abs
	 A3ucvLPprg5eQ==
Date: Wed, 14 Oct 2026 10:44:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs: fix compilation errors
Message-ID: <20261014174442.GK2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Add includes to eliminate warnings from -Werror=missing-prototypes.
It's not a good idea to let the compiler apply the default function
declaration.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/defer_item.c |    6 ++++++
 libxfs/trans.c      |    1 +
 2 files changed, 7 insertions(+)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 72d79b10d82064..c6ea292d3d6940 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -30,6 +30,12 @@
 #include "xfs_group.h"
 #include "xfs_rtgroup.h"
 #include "xfs_attr_item.h"
+#include "xfs_extfree_item.h"
+#include "xfs_bmap_item.h"
+#include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
+#include "xfs_exchmaps_item.h"
+#include "xfs_icreate_item.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 128e9f4431dc7c..c509ca1131116d 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -22,6 +22,7 @@
 #include "xfs_defer.h"
 #include "xfs_trace.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_icreate_item.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
 STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
