Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454A5481B9
	for <linux-xfs@vger.kernel.org>; Mon,  5 Aug 2024 18:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722883535; cv=none; b=HkHIKgh33Lifj36NwqAUvlfH0SwhkXqmXo9dgJxnC9Mwcy9UMFwNXad/aHEehlCLC2d2u70NdBfPWrYbJaE/hwcPUnq7OaKUPjjOpos40yGMPu3NBrMqYh0Z7dGAZfIFNjU1KdYouCdBKhJAtzDPZ/28J3gGnikuEn6qaOXKkus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722883535; c=relaxed/simple;
	bh=Sa83C7JVDPmWI0x3KDRdBFPFhov//yWO7QZO3kk7LXY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pNLqXpflthEKWHLW6JWxZhl7xwq/3GvsKctBkfJ206sVZToQYvqkBO9jPH+NXaLdu6ejOoSOpwLoUSdCr/aJ9AzaFw+rRnOANPDuCv7QWKH9P4BP79CzP5fvq39X7/5x3ISHB+L1RzlXRDbtwpZSXD04W4u/8e1EVXoK6S+Jm00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIx3Hc8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIx3Hc8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DF8C32782;
	Mon,  5 Aug 2024 18:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722883534;
	bh=Sa83C7JVDPmWI0x3KDRdBFPFhov//yWO7QZO3kk7LXY=;
	h=Date:From:To:Cc:Subject:From;
	b=NIx3Hc8pZm/RV8TmqIYyzEOqLky3zkmiAmzH0MjAB9KRrDv2Mho2AdXgS3rMUavR+
	 1ad+Iv7SYxKOT7zkVu6wF7bAgiW3/RZ2LESlLHh76KiuNg/WspseJlDYj7p5Vq+6kL
	 V9RF3t9KGw7QpXZd1mIKq5f8VDarWlbdL+OEtn1laMvk64Hk9TVHF7fRFNcrmWSGuV
	 40ptrnSLfqIexY4XgZ9xCHORo9Rc59u9+2qe5AQBwbgjPbOcytuB6/e7/chwKAq/4Y
	 llLOeT5k2JvBwrkSAJXvZFZBpPxWOd1I0tQmG5M/YkwXM5xw8RO+bXCQxM/uWRh6PM
	 7+DPsNSd4lAPA==
Date: Mon, 5 Aug 2024 11:45:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: attr forks require attr, not attr2
Message-ID: <20240805184534.GA623957@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

It turns out that I misunderstood the difference between the attr and
attr2 feature bits.  "attr" means that at some point an attr fork was
created somewhere in the filesystem.  "attr2" means that inodes have
variable-sized forks, but says nothing about whether or not there
actually /are/ attr forks in the system.

If we have an attr fork, we only need to check that attr is set.

Fixes: 99d9d8d05da26 ("xfs: scrub inode block mappings")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 24a15bf784f1..5ab2ac53c920 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -938,7 +938,13 @@ xchk_bmap(
 		}
 		break;
 	case XFS_ATTR_FORK:
-		if (!xfs_has_attr(mp) && !xfs_has_attr2(mp))
+		/*
+		 * "attr" means that an attr fork was created at some point in
+		 * the life of this filesystem.  "attr2" means that inodes have
+		 * variable-sized data/attr fork areas.  Hence we only check
+		 * attr here.
+		 */
+		if (!xfs_has_attr(mp))
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		break;
 	default:
