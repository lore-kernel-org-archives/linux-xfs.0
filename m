Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07947E8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371642; cv=none; b=H8p4UWNZsGJD2ac07jox8+pY7uN8TABL4n8CA8LUYvgtz/2xad6qILfOgzvZEUg24dykv6BULZ1Rl86xR0E/T9NV7n6+wLCt11ZVu6TbKj/SuPiXE+ghtPxrwGUErOmmPg0UpQFgVqxX88ppt7B88nnK5ymfXT55fpwTOyAxCSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371642; c=relaxed/simple;
	bh=663RHkfiG9++76sDjm7S8m6yoRWdK81yDqvSMfb6Tv0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uT8U3x+xOEg+tBuXjV3oN/H2EQ8QK7cpK81BSkH5L188I9J9dYI9ymnUQVGWOctqliIuLBO7aj9bzOja9VlTalQEG/FfaD8hz3yUKMGll4GwRezw5FPh0Vg9wDvTVuKlD0q3Uit20X/EfapO8XRTUzY+xoRmX4KIG9oNfbID6hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKCoe2sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKCoe2sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D447C32782;
	Fri, 23 Aug 2024 00:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371642;
	bh=663RHkfiG9++76sDjm7S8m6yoRWdK81yDqvSMfb6Tv0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GKCoe2skRAxGX81uAGSa+oPuE9Rs2PpauwO3YsLVOlKpPh0UR/PsOdE0M7u1cU1NT
	 r8TPFy8VeegQBR93KRH7vNhGWyg779o+1tw/tuq4DOJ5C2dZhinGS/8WZph73gl1Pk
	 ZLJZDV4EZJ6hLnvwV+ekCKsfpb1rmeubzJ72wyaUIsaqJek67tfX5T4/tjDhXv3Zkn
	 RmGZl1bOAYBFTQEghTN8bynmPTHbpC3IntODeSfux3SSgtedfSeyfYZgrvw/biznxF
	 UVQg7HmEKSR/RF/MuMzZy9L9//5NzIDLLQCI7bsJLrlhy91tjLJ751edCjjF5TQbdw
	 KPljxj1tJSUtg==
Date: Thu, 22 Aug 2024 17:07:22 -0700
Subject: [PATCH 20/26] xfs: fix di_metatype field of inodes that won't load
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085518.57482.16444514043671384485.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the di_metatype field is at least set plausibly so that
later scrubbers could set the real type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c        |   10 +++++++---
 fs/xfs/scrub/inode_repair.c |    6 +++++-
 2 files changed, 12 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 45222552a51cc..07987a6569c43 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -443,9 +443,13 @@ xchk_dinode(
 		break;
 	case 2:
 	case 3:
-		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
-		    dip->di_onlink != 0)
-			xchk_ino_set_corrupt(sc, ino);
+		if (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) {
+			if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
+				xchk_ino_set_corrupt(sc, ino);
+		} else {
+			if (dip->di_onlink != 0)
+				xchk_ino_set_corrupt(sc, ino);
+		}
 
 		if (dip->di_mode == 0 && sc->ip)
 			xchk_ino_set_corrupt(sc, ino);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 91d0da58443a1..e3f9a91807de7 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -526,8 +526,12 @@ xrep_dinode_nlinks(
 		return;
 	}
 
-	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+	if (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) {
+		if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
+			dip->di_metatype = cpu_to_be16(XFS_METAFILE_UNKNOWN);
+	} else {
 		dip->di_onlink = 0;
+	}
 }
 
 /* Fix any conflicting flags that the verifiers complain about. */

