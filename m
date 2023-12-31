Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37BFC2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKU5BsH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5E7C433C7;
	Sun, 31 Dec 2023 23:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066798;
	bh=24PpUKairK07QikcU/G+jOPbXm/DyAwRluDi3eCc5a8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gKU5BsH/s9FcmqisoQVe2HUZDyTtnCIXmsAN9ynfRNUsxyD69BgPvzfQqDp2fpjrZ
	 NdmXGxeKjZS4TLXkt0Ga03cvBFYIh5qx7FbWfV7sehmH5GP9s2OS0RnuI5A2Mhba0m
	 bBEf/RkVuOMkEzhluIkszIFJjMMUt8lfstZi1rSHXjpAGwlwTYdeGRXm2soDsots7P
	 nTJXmM/Hh4Gh20N2nr4mtazWdAoCN/aKM8Syc4JEEChdFxUAc431E0Yu+p4k6t9Irv
	 L5c/wFnjSlo7yy+OwFkxohPxcpKO4POmosrk/yXUZVi2GlbponR3LuZPNyCH+3S3Eu
	 LylhHLc33AdIw==
Date: Sun, 31 Dec 2023 15:53:18 -0800
Subject: [PATCH 22/52] libfrog: report rt groups in output
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012462.1811243.15399432470974419886.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Report realtime group geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index e2732fb7a09..b9618661427 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -65,7 +65,8 @@ xfs_report_geom(
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d, parent=%d\n"
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
-"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
+"         =%-22s rgcount=%-4d rgsize=%u blks\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -80,7 +81,8 @@ xfs_report_geom(
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
 		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
-			(unsigned long long)geo->rtextents);
+			(unsigned long long)geo->rtextents,
+		"", geo->rgcount, geo->rgblocks);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */

