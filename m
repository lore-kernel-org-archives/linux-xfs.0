Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D721FECBA
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782325012; cv=none; b=Ww5o3lUIUchtxaXwjEKP6mEHagWlNHnrf6vs7RjoweLqTz8DeVWg94mndjM6KP2AmJy6Gp/eGHsWX/alD8jOMslOARuvTn+PaIqwmQod1lIRn/9jF+AzREJZc9+i0OowtBTox/nHMiGKS1KwP/IWLygr45rCTqLjivj6u3aLVo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782325012; c=relaxed/simple;
	bh=sgoCA8tdsA6LeIUmwRAsPPh8FZPT2eY+Qof3ZeKGEM0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyOZIQfpntg2oxLFr5wZMfi2n0xBZuNduRQzSr9sWIH8Lm9df5RCyDj6vsxI6nemEdLnQukOqhHIOGslbVvukTfS71+n7cL03HG2kcAJjS2nk4HaJIxs+P3cWcJ2da1LBRXy3aCNwIxxIrADq07EXi7VkgGV4dFIo9boU9nnHdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKfOBi6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKfOBi6L"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 51D6B1F000E9;
	Wed, 24 Jun 2026 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782325011;
	bh=nhv3x8SN+kz095acOY/KnegP8wP+L3UyRvDB6j4iWMY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=GKfOBi6LIMJY5qSkbufSM00UdV9VREvuGNDZqIHlZZt30FgadU4gszLdmH5aarS4M
	 ynkfKSSRjVnk7bBCKHwcPz19cCuW/E4FaxNrq3xHQU429P8E9+7zxPqhtkm9ULaxYw
	 F1E9xl26mFmEE8eycOUvXzslRF1lU/eJok6jxEe9CcYWhcA9z60QOLpLT/k3YfT/dv
	 YRxbSbep9MD7hOF5QUL5nhor1Vp8hXZhY8wvEGLtu0Ybrs8Zkfg49fqm2Ns/r/tryG
	 czhesa3kwnRslyNAPVDfTTP8LGjdb7txFVdprxdSydZrQV9IIFir6R/DZ2Pi6QufFL
	 vo40yD6jYAF/Q==
Date: Wed, 24 Jun 2026 11:16:51 -0700
Subject: [PATCH 09/11] xfs_scrub: account for reflinked realtime file data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484605.915780.11173864238259682348.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we added reflink to the rt device, we forgot to account for
multiply owned space in the phase 7 accounting.  Luckily, Codex noticed
for us.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase7.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index 4a25c521fa0c76..375ba0632c353b 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -27,7 +27,8 @@ struct summary_counts {
 	unsigned long long	dbytes;		/* data dev bytes */
 	unsigned long long	rbytes;		/* rt dev bytes */
 	unsigned long long	lbytes;		/* log dev bytes */
-	unsigned long long	next_phys;	/* next phys bytes we see? */
+	unsigned long long	next_dphys;	/* next phys bytes we see on data dev? */
+	unsigned long long	next_rphys;	/* next phys bytes we see on rt dev? */
 	unsigned long long	agbytes;	/* freespace bytes */
 
 	/* Free space histogram, in fsb */
@@ -120,16 +121,21 @@ count_block_summary(
 		break;
 	case XFS_DEV_RT:
 		/* Count realtime extents. */
+		if (counts->next_rphys >= fsmap->fmr_physical + len)
+			return 0;
+		else if (counts->next_rphys > fsmap->fmr_physical)
+			len -= counts->next_rphys - fsmap->fmr_physical;
 		counts->rbytes += len;
+		counts->next_rphys = fsmap->fmr_physical + fsmap->fmr_length;
 		break;
 	case XFS_DEV_DATA:
 		/* Count datadev extents. */
-		if (counts->next_phys >= fsmap->fmr_physical + len)
+		if (counts->next_dphys >= fsmap->fmr_physical + len)
 			return 0;
-		else if (counts->next_phys > fsmap->fmr_physical)
-			len -= counts->next_phys - fsmap->fmr_physical;
+		else if (counts->next_dphys > fsmap->fmr_physical)
+			len -= counts->next_dphys - fsmap->fmr_physical;
 		counts->dbytes += len;
-		counts->next_phys = fsmap->fmr_physical + fsmap->fmr_length;
+		counts->next_dphys = fsmap->fmr_physical + fsmap->fmr_length;
 		break;
 	}
 

