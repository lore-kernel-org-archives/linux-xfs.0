Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACE3196
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529958; cv=none; b=lsbGRyddQlfqYOp6Q4wG560e+bMqZs8V19EUtJ4f9l0togkQOTyOtGSx7MBTbEqekrQB3W98C3qf9MP5a6bUiWoN910x3Kyg4Yodul4X4Sr81TUtEdWR94HnnzbzH3MZ+uvHXP0FfkF14rqX27obtxGnt96CUJhVHyNOECFh+Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529958; c=relaxed/simple;
	bh=nQs3/+Fk9NspfYD88XUNK26MG7XYxgTXEL57VgCmTy4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t1mWUQvhGjqtDKwNvrfQqHciQ1jmRTE7mpaTClPUU9oOp9a4Qw5/l+TRDXu9Cd12SSCkOP323VbkdMVIQdr+ZGSJFJxfP7kT8NOY+F9OW69EtYbfsGof3/akPOwYeDKNX6l6jsSF5aqHimsAJyyUV9RtyeNbTeILXFHGeYMppFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJHRJYTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJHRJYTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2001FC4CED1;
	Sat,  7 Dec 2024 00:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529958;
	bh=nQs3/+Fk9NspfYD88XUNK26MG7XYxgTXEL57VgCmTy4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CJHRJYTNAMDkQ65/EQvQGaM9nkhzjP+AWIRI+aOct5nScgIBWr7z4ynBIChJa/OCO
	 LCGTvxKOiG02Z0otJEBSjoWW6oYVjjM/w2DlqfcFtIl/f67x/seMmQyVIlD0151iMH
	 +razDZGJQPkiaVZFitajAfcs3aOMgrLV0fIvEzNVEc9HKZbbhWJMGEnkIIFpjvfUd5
	 rZDriVuf23e41Mu82HQR6F1k7XpPkZlL/eYK3/IxNprKQ3Dh8mfUaSPiR38ZxEu9g+
	 qzZu+N7L2fsVuyLfmemWH50q+0nbmWoLxGjQSeK+zniT9Pej6SWW8nSTR86XqFlXa7
	 MrOCzDRnkEVtw==
Date: Fri, 06 Dec 2024 16:05:57 -0800
Subject: [PATCH 04/50] libxfs: use correct rtx count to block count conversion
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752007.126362.11650470586267839011.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix a place where we use the wrong conversion functions to convert
between a number of rt extents and a number of rt blocks.  This isn't
really necessary since userspace cannot allocate rt extents, but let's
not leave a logic bomb.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 01834eff4b77ca..5c896ba1661b10 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -1202,7 +1202,7 @@ libxfs_trans_alloc_inode(
 	int			error;
 
 	error = libxfs_trans_alloc(mp, resv, dblocks,
-			xfs_rtb_to_rtx(mp, rblocks),
+			xfs_extlen_to_rtxlen(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;

