Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9663D566F;
	Fri,  4 Sep 2026 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538385; cv=none; b=nHxnYadbAj/JADVuEGrXJjWzkAjktKKuVxmIMnW4FHj241zMTPbF+xe0f2QseXrdgIJVaYTS1nBDRPnKtcM34Gy6CmYnUWJXNDrfL4WmA2J65WVC3WopTIgEntT+3A9XjMWvonKhJ8LZKk6Vlzx/Spax/FqteJelxiA96DVcP2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538385; c=relaxed/simple;
	bh=MfzDYfBz/67gctXlPTuqKXZlXocnfNYA6JNf5kuunjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZFD6y9jfC8l9OZlWm/VY7hCuAsFE3+St6SzCdjAM0rWUmZE4BSxc6gKTZS5EN4vsLMfpOsncaj2m4NRGS0O+Bucmjp/n4umM+tHXwUAyDcP4hmLsvwTx37e/0oZE0bx7XnxTUhNNiaCMqG/ZQehJZOAi6Or4tDeRPKts086NaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oax3rC21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oax3rC21"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3637A1F00A3E;
	Fri,  4 Sep 2026 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538383;
	bh=am4CVog7UF7J22bjOFHhna+YXn5fCe3cBYGzvY+85ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oax3rC21B0zE1OY4fWreI8cco6KKmsbwym4m5Pm50aOdAgfr8GVTJQFFJH6URc1CN
	 DTi8e2bjwtJ2yHSm/XKjWQ/VNv/Izh5LkqqZqiMGGWHJnR9HQOs2DEMSndnXOqk1eY
	 R0IsK74J70Dd3tLMgOXWkcab4z+8mRF12TRexjUbP6+q1Yn3k1duQLiEuBDW7xAqte
	 HWyL0Vt5x6IunuMTanvyM2nMO7NzgHKVHubIKaTXE119Ed6BYGu6vUQXN02p6i/pg7
	 ZfH/wJxvhelgu5tKuDFStkoG39oZmpG5tlD/39TM4IMY51BJQ/qVRl9w6WIks+uVWH
	 tf6VH5Q8Ei1LQ==
Date: Fri, 4 Sep 2026 09:13:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
Message-ID: <20260904161302.GC1933798@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
can fail, but we don't check the result of xagb_bitmap_walk, so we
silently drop the error and proceed with inconsistent incore data.
That shouldn't be allowed.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
--
v1.1: fix commit message
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
