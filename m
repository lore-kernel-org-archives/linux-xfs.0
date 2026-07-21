Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6EA78F26;
	Tue, 21 Jul 2026 03:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604290; cv=none; b=oeK2b43svaQ7Li/tlVmVonw4yvUzpZAeYxnVmg6yVqaByPmsQOPkOUdFjvlTmJxJdo8IbRtACgRZQZayCkHSzwgraoYIHaUdtwQbSyLABzL/HCC+BeeXX2K5RP+7OFeckUra4KJZIIQknvgImGmjGv+4RgXakq40jspDOQav9HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604290; c=relaxed/simple;
	bh=DD0Ac6bPvJ5PBjUDyE4kEbPnWsIgS49fX+lBvPlKYLk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmodEIqEg7InVd46ggP3FHCCf5NuNEmDKDvLN4yiQgwHN3U0bys9XkNmBOHIwFgNSulSkOW/YdveWP5CnW/uIPxF6aKCGVgrLNNhjLHVSAuq3e8HFF3c6AlCUoi2SwaJy2ShBQEh3RG36zKYuJOPN2LBUmvl4r5KA+WLwyqcqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hd8KXJuv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hd8KXJuv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 241241F000E9;
	Tue, 21 Jul 2026 03:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604289;
	bh=VwnIvhG7lgCb3kocBxjU1VBrMmPfaAWLLC9PeQsqVWw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hd8KXJuv90QeuxtprBZ7n63806grrqZbT9/pyQOJCQRLjJcJokXIzgVb6Uq7mOLK4
	 s5rHztuaw/0Cv+8hFz6CV3SfJ+3qt6kmvgNg7w47wcQxoo1i1T5ETp+Z/+C8Liew+3
	 AnHcGT4gZqa3iKIZlJoBwm6lOOy6HC25VTK0QwHGzh+XMswGftj6mk+sKjJxqqaK6w
	 QpDSm1r7l4yihC8VmAY/TSXgeV5n80IBNcDSFlAAunWpNiNjnRAt1YV1ZPpWDeM/CB
	 eumcJiFRcQC5mnXHIy4S3VgjoBf1SyZDpUnIQNYp/6aTZnnVdLSt/8Hrz19Tz+6arm
	 7obGabMVnni+Q==
Date: Mon, 20 Jul 2026 20:24:48 -0700
Subject: [PATCH 5/5] xfs: mark nonzero sb_gquotino as corrupt on metadir
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419191.830618.14205271438820277478.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
References: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On a metadir filesystem, the superblock gquotino field is always zero
because we find the quota inodes through the metadata directory tree.
A nonzero value is therefore a corruption (as pointed out by LOLLM) so
mark the failure as such.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 06b20ef09ba163 ("xfs: check pre-metadir fields correctly")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 9ed053b5f06125..62ed5eaf08fbc1 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -266,7 +266,7 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 
 		if (sb->sb_gquotino != cpu_to_be64(0))
-			xchk_block_set_preen(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 	} else {
 		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
 			xchk_block_set_preen(sc, bp);

