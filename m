Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A1713FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992078; cv=none; b=NYkQ+XSBn25B2ycil2qyPC/qSgEr0EaDRQYm3sPe5+HHuSpn7VSmZJ/U3lBb0c1kd5gc48yRVGivZg6YR3bjIPYOwdKMRrzwGY91ZEJV2AhQ/imET/U6PRJrh8Cq8Vgk4nGs5amvhqi4nPYuSImAudjuc8WA19gmAsam6PW98lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992078; c=relaxed/simple;
	bh=xKAYeRHbOCy9Ki2+NPyQAaFllc6bRNf2NEFIALxmBKE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=axWHUosWxlS3k1qhQrgjB5XhQo7vgeY1WgkT5qlXLHmS4sqeCxwdvttAQGZYjREcIu03wKJdpZok4eKzOyXR8fNX80wWCgGzCf6MWa+Az9+u2DDA/XRdH6qKmwigewOBsPYSY+LFZdhSVfFqdwiKxmmh7ZVOSEEOqbY989SqtxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Quh8H0Lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Quh8H0Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD79C4CED3;
	Mon, 23 Dec 2024 22:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992078;
	bh=xKAYeRHbOCy9Ki2+NPyQAaFllc6bRNf2NEFIALxmBKE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Quh8H0LzimosWJuSUb8Pc5Pq8mpcySh306BpwkNOVEuyMZVxsY2uwkeSyCI7swRNf
	 J1dPwKtM449/xX9KrI6gQnSDWxo0GqBrFdsPx9lHyY3Wuc8wsuoXCyVKZG/QBmxu2+
	 BhB2F6tyD04VAyCFqRLvCGcq7QKPkZAXbusioDcEbjmVCcWaRknmp4fSw6dMHnkwiW
	 ciUYc7Z3ns/11KYV4zW7H/JFDgSWy7t0b1LN57bDBr4UGuS2j6fq2j2v/IDj0o+FT2
	 ElvLWAeANkItvnxH1ZUYsA0UUR1oQ05sqqO08XBnzIKpWCaAI43+rL1583UytJkRoM
	 We6HuAFQhfxrA==
Date: Mon, 23 Dec 2024 14:14:37 -0800
Subject: [PATCH 11/51] libfrog: report rt groups in output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943972.2297565.8634272081467299980.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report realtime group geometry.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 67b4e65713be5b..9c1e9a90eb1f1b 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -67,7 +67,8 @@ xfs_report_geom(
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d, parent=%d\n"
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
-"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
+"         =%-22s rgcount=%-4d rgsize=%u extents\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -82,7 +83,8 @@ xfs_report_geom(
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
 		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
-			(unsigned long long)geo->rtextents);
+			(unsigned long long)geo->rtextents,
+		"", geo->rgcount, geo->rgextents);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */

