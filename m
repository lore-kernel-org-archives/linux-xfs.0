Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409EB1A01BE
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776091081; cv=none; b=mdv6JWUJwr3jPlf/RnAhesfXyW8x+cTYAYYQaA2pOMWOj93eGoM/CAwktSDSP1PHGmTghqRfPMpzc5pthiruS8DgV70uRN3XPPUrM0dV2NTGTSiKDrUo47rSraiSNtQixCmXFYbc3brNNrKGxEtMSvXPFqYGc9Fv6wz33HnDvzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776091081; c=relaxed/simple;
	bh=GJZMyZyYVSYtU/zaFHePoPvfEBOau2Gb4qz2C8FJ+7c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ee5i0Xt3aje8ghm7Xz8rluUwEda7LS6U2xdInZP9dYojxSdG3jkqk2BgurOs7c/siL6M1bKZ6wu2kfAkbLVGgaBdhZAIqz/hDczuBinwe1hRaj+gf2bKnTp5OSIAuJHEbI4+qzXghRv6MM/p/gP+6hRz/USfT7hf/Pniz+uUazA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4clDeug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4clDeug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF36C2BCAF;
	Mon, 13 Apr 2026 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776091081;
	bh=GJZMyZyYVSYtU/zaFHePoPvfEBOau2Gb4qz2C8FJ+7c=;
	h=Date:From:To:Cc:Subject:From;
	b=A4clDeugPiPcQgs9U94n0l6uO7D3Um4v9+nAFL8MYmnHZ01e4O9bixV8jroHHBWKN
	 Lw0XQG2pPB/nK66XQVePH30O1dZRLFC2tniNnyV+kno09t3zxHFsQkMht4wZ9ITd1S
	 agms8Ec5NTR1XXPhTdpcnyqvPT2T1iZRYCTWIIl1XQgBh/QqcPQWEUXlEHHZHBbHCD
	 7JjXjlB9bLeCHnoMjxJ8LCCeLHFjYR19lozre9HZbCno8fphzFFquSGOh2eUI/y7kw
	 h13i0fZ8cVzoBTxh2tX8nNN6vJCvIL1L4mDGModb8UdE9MOtQHbjO1jTKgfJ91Ly5g
	 HccV0s32Qltow==
Date: Mon, 13 Apr 2026 07:38:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Carlos Maiolino <cem@kernel.org>, Andreas Tille <tille@debian.org>,
	XFS Development Team <linux-xfs@vger.kernel.org>,
	Anibal Monsalve Salazar <anibal@debian.org>,
	Nathan Scott <nathans@debian.org>
Subject: [PATCH] debian: add version control tags to control
Message-ID: <20260413143800.GI1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Add some vcs fields to point to the official sources for the debian
package (which is to say, upstream xfsprogs).

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 debian/control |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/debian/control b/debian/control
index d50960fba205bb..738f3a15fefe79 100644
--- a/debian/control
+++ b/debian/control
@@ -18,6 +18,8 @@ Build-Depends: debhelper (>= 12),
  uuid-dev
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
+Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
+Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master
 
 Package: xfsprogs
 Depends: ${shlibs:Depends}, ${misc:Depends}, python3-dbus, python3:any
