Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA40211464
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738622456; cv=none; b=myfeME8vdToKBR/r+Xx9H1w5ntsuYJvw1yL0LKFiMWaukZU1azPL25jzLS/V62EUpbivW/iAsxEaz+ijE50+E32dc1T8m2y2eHQhGae5XuPyHCeRaJ3lSM4xgiJOEUYkE7WVNLS0J0txlp46C2oHy6t9LX7F2r1IVy5T4rOXNLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738622456; c=relaxed/simple;
	bh=At4/aYvvzlno9xVoygEuLtzkOwdigoDfydVvvfdjOWU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sx5mJmMet6Mlgse8NLl4yZshUgPqPxogI4wqj3hpxmDDEo0bbzRrSojFzYPqECqYG9sbxSxz69qZrDxvx42EXgJ9ZaqY8NVkv1l+vMi71dfux4cBPsHz/0Iu2HtBU8qPBMbDeC6rw5sG4h/Y+Mi7MVGjYdTc6LjCOE0X9KNkBAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=em/TrR3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="em/TrR3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FE5C4CED2;
	Mon,  3 Feb 2025 22:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738622455;
	bh=At4/aYvvzlno9xVoygEuLtzkOwdigoDfydVvvfdjOWU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=em/TrR3jdbHx1tzCOD3b2c/hqKWZjX1QLikhHdu/ll0KwS1DdvKrsPlggZd/br8iV
	 vkg+uqUMxPCmmv0LiHQyPZ9TJ9foCE0/LfP9M7L9iP8A/bi/nhHzsfn7/2biNtuFfP
	 YpAGh4LIsUkNE9o0wIJzJ8L2pfU5eHwJ7uwU6tXCbV7H2POF1eg3EXSjuHvibUbXby
	 MFjq5G92LmRtn8/aB2z/4oAdtGCpxz9dPfGMrAbyAuqSMTJqKfQM9UwTVfIb6emqU4
	 JJYogonLunc53Hvcz9ZS5z/KK3cK325UbcwMBDMZo/k6dEWSpkyDMap5XENHqJg2e0
	 t1jIU8d7UYaLA==
Date: Mon, 03 Feb 2025 14:40:55 -0800
Subject: [PATCH 3/3] xfs_protofile: fix device number encoding
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173862239078.2460098.2761986507883680426.stgit@frogsfrogsfrogs>
In-Reply-To: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs>
References: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Actually crack major/minor device numbers from the stat results that we
get when we encounter a character/block device file.

Fixes: 6aace700b7b82d ("mkfs: add a utility to generate protofiles")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_protofile.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
index 356d3d80b32521..e83c39f5325846 100644
--- a/mkfs/xfs_protofile.in
+++ b/mkfs/xfs_protofile.in
@@ -54,7 +54,7 @@ def stat_to_extra(statbuf, fullpath):
 	if stat.S_ISREG(statbuf.st_mode):
 		return ' %s' % fullpath
 	elif stat.S_ISCHR(statbuf.st_mode) or stat.S_ISBLK(statbuf.st_mode):
-		return ' %d %d' % (statbuf.st_rdev, statbuf.st_rdev)
+		return ' %d %d' % (os.major(statbuf.st_rdev), os.minor(statbuf.st_rdev))
 	elif stat.S_ISLNK(statbuf.st_mode):
 		return ' %s' % os.readlink(fullpath)
 	return ''

