Received: from mail.archlinux.org (mail.archlinux.org [95.216.189.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C80E1DACA7;
	Sat, 12 Jul 2025 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.189.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752332296; cv=none; b=h2ePPEpyyJa9UMO36EcZfdk67SM/rzs9SELdAyWQ9SDtHJoOPDUkUQ8jgO3DLRgZ81ExQKfXs5yqOom2FwIwq9yDoVPqWbXDro/DY+uctE7DWVrvcOH+Cayyfi3KTPDC7SyfLVqimepI8uImxA1+Wt3YsAKd5FyyPerO55Mazd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752332296; c=relaxed/simple;
	bh=4mG6y2LVPJZvV3RhJfiUQOfUbw/hHpSyWK747hg4o1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=neLHVJ+6BjDGezn1N6M0K8Z7Gt7fPQ3sNYBO9KkkapqRi1k2p43Elb9b9p3kjupAjvT6qTAMIx4mDr075zuD6orXY4BJ3cxbg5mfn5ulkGvDeq9Hw0HsbOEA7Xl6O1E2noCHjROH0r7Drc6Fsvhe8QvHaiYz5wrjWEjYm+3QLOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org; spf=pass smtp.mailfrom=archlinux.org; dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=kcqA1ujs; dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=10wg6mTD; arc=none smtp.client-ip=95.216.189.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinux.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="kcqA1ujs";
	dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="10wg6mTD"
From: George Hu <integral@archlinux.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-rsa; t=1752332291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vYwAAyA3dNGEIaLuK6evNsit/OEpEVCL2xljGucY254=;
	b=kcqA1ujsV5lCw5GJzgpRhodccX8/LV/MRoCrXQ/2xWxVMxnR+r61b04bW6YEOaeUgDTk5t
	JGT1kzcDUsARYxUfkcBpAupESw1A7/4I98MxIhv64edh9LT4uQ26/1tO7mtBcSD6qEO50Z
	90aBftzuTErdohdVaZnPdw8NGX33JBR3M/H5g2rTmYNjpVX9ZdUlkaSw2mZaTAQjIx4sRy
	YPYb9euU1BfuBAiTo3XMdNm5oi9bxfZHjqTeAub1gzr60t4oi7I3J9uzuKKHSNCPQakKHP
	nowJonWvm+d3007etwPo9Y5TeMOuza60YgfiwH8Aud8AiYaLOvcZU2MWoDAzojSu9RDJMy
	0UudivlANqHceosO+HZAcwvYyNCwjCbFxBWnR6uUfXujV7g2yCu4XWT3TaIpXtlRPR9nRH
	ULW19SMXTEyVfiyRkDYgK6eoKvi6eI6SQWUV9DsPCP33Ici7GksYzqMpT6kogt5/aToqy6
	uuVOupczXswzs7DDcUUcLEmWOBtr+Ku0Rr1oB6yp2+6HuNSjeFJXgACL9aCxaAG3q7JQvG
	PlKpEoNOCQUm0Dn0enGGLkrN3QR+LxxJTvcOnCgz3Tb83JAmLZ2UtginTMtkZIa+HkdlI2
	7jNvMOyJnhpDH96TJ0CmuRwmndZ00Mnc+GCCyAicyXyLNnkiaUmVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-ed25519; t=1752332291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vYwAAyA3dNGEIaLuK6evNsit/OEpEVCL2xljGucY254=;
	b=10wg6mTDbbgxZVZ8kvAezT37kPvG0G4YdfUMD1/rdFwKvJSL8zid6X+TPFnvhJrEwxFfzZ
	2LMp/SFt7xXg8QCw==
Authentication-Results: mail.archlinux.org;
	auth=pass smtp.auth=integral smtp.mailfrom=integral@archlinux.org
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Hu <integral@archlinux.org>
Subject: [PATCH] xfs: replace min & max with clamp() in xfs_max_open_zones()
Date: Sat, 12 Jul 2025 22:57:41 +0800
Message-ID: <20250712145741.41433-1-integral@archlinux.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the xfs_max_open_zones() function by replacing the usage
of min() and max() macro with clamp() to simplify the code and
improve readability.

Signed-off-by: George Hu <integral@archlinux.org>
---
 fs/xfs/xfs_zone_alloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 01315ed75502..58997afb1a14 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1133,9 +1133,7 @@ xfs_max_open_zones(
 	/*
 	 * Cap the max open limit to 1/4 of available space
 	 */
-	max_open = min(max_open, mp->m_sb.sb_rgcount / 4);
-
-	return max(XFS_MIN_OPEN_ZONES, max_open);
+	return clamp(max_open, XFS_MIN_OPEN_ZONES, mp->m_sb.sb_rgcount / 4);
 }
 
 /*
-- 
2.50.0

