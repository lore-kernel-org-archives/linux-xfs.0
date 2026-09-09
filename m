Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5A130E853;
	Wed,  9 Sep 2026 06:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933861; cv=none; b=AWQXjy7FwmIKLDuQI2U1jWa7na/jLbhG5HRFafyGDUxiaCesEWsAbWttOxohnXje97ZhPU47JK/Dy6nvafk7Fd4sZmriekoUhpYqxBYhcOHr6zuppkkD5lW58VrsSqmc7KFXx7yqIQSeCS0gDmGe16lI/ja48UojmwQ/wy9P2Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933861; c=relaxed/simple;
	bh=5Je9zax/dRV4YMOHkV7smpnkSmdtX8VB6SJoVfopZvE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucTce91WXzW7PMCQBT+mUBcUS2gcVfWsNAyWlds5eeI2VGhNbH4DiiATTaM/sjYcSJ/O+KnNKR7/omf5/MtZkFnU9DhCuomImVibuff30OKz/ZHcTeIHULRRKjKz5qQ6gtFlAFm0HSeQ6+J9RM7yvnxQhDAK448TNkGB0Y95VCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgJBatGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgJBatGE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E1CA51F00A3D;
	Wed,  9 Sep 2026 06:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933860;
	bh=dTpOPFwj3aqz+FNv8bR1Yx241JmcOqPlcKiGf9xelvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KgJBatGEPx1NKgQog+rF7tygW5O3avFRzFxm/KEiHomQaYepJKrNcMPT09Cd33Uqp
	 YaTYLdv75huQWHluLlZV3VJlqpMgwXiv/ekTcgdsauvyhTRyBY21ASzQobv3JWGU+o
	 q+f6A4xNaZ3p99Zgs4xmhwi4tAEzMMzm1tQhiCVHBFiOgcLd6+ODHd36cC+UxOcFUr
	 VFPDSR+7kokAJpXPk84Xa5xvzcqCweCtlgxyrP0of0CIJ7LMGRotO9uK62gjjjyPpT
	 9pS4aaUaZDDIFbkaUm22MPFmsK/uWQwAYrNsh3S1xwVAL+cTVgNC+8MJZpnAlI6KRB
	 vppHDc4DtI6uw==
Date: Tue, 08 Sep 2026 23:04:19 -0700
Subject: [PATCH 6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936314.4057682.15625244798086521092.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
References: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
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

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

