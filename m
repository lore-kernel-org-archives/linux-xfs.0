Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E9F42901C;
	Fri,  4 Sep 2026 06:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503241; cv=none; b=FzNcVII1H+nNWFn3AlvmPjisEBUVqkDG0Yzw86dSpGV5J1o72//S7n9oDMG/onozdXTFxPWQq2F5r2T55cDFzI6fERiWiBH2l/7FrGuSUwH/Kfvfck1n3s0QKiGEodl/RraD8LUzEqcs+iQglH3WTZXrAoiDhQ74uiATomOD/PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503241; c=relaxed/simple;
	bh=N7Gbi3MvhZsfCkJF7cisTjWax1I+gC2Qnt1QGT8NlBA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rF2WzWJ2eV9wl5fJ6Nf98z+VqT7KKYs3GAO7q32yTJKkqE4puMBhiHn7oPwvVnzUFO+nsA7R700PLy2mDQ42/ikeUJ20quzvRa2gcD/3J73dNzT54emhIip1i5PYPd9S1/i/QOoNBvENc1LYaKfHzFkv28w2jTO4VqushIb02dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiXQFgXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiXQFgXX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3BAE71F00ACF;
	Fri,  4 Sep 2026 06:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503240;
	bh=XUeKHmaagLiaHVgW+7ZzeR7Sx2aOawdlbBdqOEvobkI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SiXQFgXXN4LswoOdYei8fPf1l8toQDNeZ7RGlUlls3LR3mAAcxOi6K9BLxvWTRrz+
	 6ALLjg0Mz0yBv10wsx6dxBgDpVOSUp9m1cWm+UpHEHXARGe++ATvNZfa6VSvvXM5Au
	 Em9BeLoR4dCTMtF3FJKC2Jy3WdG0GygE1mOlBmX2Z8oar0dOIPn1POLuJqIoFysWs1
	 +T7ENYhUqUMhEnvtZzQrGHehNzMo7xtFuqncYSu4rwGSVo0WvIxvoP1oyCFeTpsT4U
	 nx5G9kIS1bfAPynEcJVa8/A/FVI7xhlYPWKuEJjHlvWJ5assLDnWWSidjFOUSLLRMm
	 9NwM1sYKYhQUQ==
Date: Thu, 03 Sep 2026 23:27:19 -0700
Subject: [PATCH 6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>
In-Reply-To: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
can fail, but we don't check the result of xagb_bitmap_walk, so we
silently drop the error and proceed with inconsistent incore data.
That shouldn't be allowed.

While we're at it, fix leaking the used_extents bitmap if the disunion
operation fails.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 46c95354ca6438..a66b611588c47f 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -699,7 +699,9 @@ xrep_agfl_init_header(
 	 */
 	xagb_bitmap_init(&af.used_extents);
 	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
-	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	if (error && error != -ECANCELED)
+		goto err_undo;
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
 		goto err_undo;

