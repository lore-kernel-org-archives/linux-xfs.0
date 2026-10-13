Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC8249AA34;
	Tue, 13 Oct 2026 06:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871704; cv=none; b=QyDpoo7KQkOTD9HLczFhfyzs3GblwfmC5VYvSa/+YNiVijkfiuGmgj3dY0To6BA0EnRAnLnKlLrds4ncudTUvX75K7LnndvQILvq+eLNChI7gBIHZQxuzFHOQbE4hC37at4EINA5j4mNPvIs4fcO/FSHl7C18He3p3aS19BP/AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871704; c=relaxed/simple;
	bh=42CX/vvCBuZfCT1S0Dg64e+2ng3GL7y812Bjj6hDMM8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SbNtyPq9D0c6l3Q3rJiyBdOT33Zz6ICEViN5Npw4fm3xIsW75qE7qzVVWiYI5Xu0dovk1mF+yiIaQ/jG6UWAlrDFlKf8J99C40YFQSSi/u80BbDyXsuDvLR9pw7XrJXA5G3slECiN1EqosJZqISHW9Ii3pDy1+9phIJn8UtWzZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2A51BOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2A51BOZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BCC491F000FF;
	Tue, 13 Oct 2026 06:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871700;
	bh=rhfhIizBT68zPrduNFgl2kOU8AcvU/jVQHr4wwLLb1I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=O2A51BOZ20czJlCkeR1rlQkhd4KKtvrCIbNciautuyqgMb64zdyhLX+MJiSRca914
	 DzcY+bHf8G2q/qA9AnXgQc3BZAgNjkeyQw/y6jrm++A1CFVzB3J6p+6N1i4nR+V9Nt
	 Pk29QInuRuDo4/QPlpD/utLkF00eVVI3pO2SrZWDHmX9KdaWrJjrn5Z7dnBEKstcBh
	 cS3Kv6ExoTbW+31/HooyT8h3eanq3OevDLbmkTXIi1dI1nkN6wm9E/JFEhcQY6+gz5
	 1bX7Pz+YDg8vssGbVB68V4HWWj3I6hA5E3rpdKTMOgtiD75T0+QpVbIgg2LaA9Bpvk
	 jl2xjCu49hrjw==
Date: Mon, 12 Oct 2026 23:08:20 -0700
Subject: [PATCH 12/12] xfs: don't scan across metadata/regular directory trees
 for dirents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107398.1898400.18070593851298719870.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that the directory repair code should never scan files
in the regular directory tree when fixing a metadata directory and
vice-versa.  Amend the scan predicate to check this condition.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 4f3d4dd1b04b2b ("xfs: define the on-disk format for the metadir feature")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 2cfcf1c35679ea..4a0b912b657696 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1189,7 +1189,9 @@ xrep_dir_want_scan(
 	struct xrep_dir		*rd,
 	const struct xfs_inode	*ip)
 {
-	return ip != rd->sc->ip && !xrep_is_tempfile(ip);
+	return ip != rd->sc->ip &&
+	       xfs_is_metadir_inode(ip) == xfs_is_metadir_inode(rd->sc->ip) &&
+	       !xrep_is_tempfile(ip);
 }
 
 /*

