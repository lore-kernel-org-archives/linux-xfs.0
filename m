Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3198BE5
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609953; cv=none; b=DCTnWyIcoP+xWYdr5RqaIzK7qRHdnSiHw29+Nd2QR4sxsmA1ujSZGiazi4z3hxTJB3f03aw50BcvcX1gV+XXm2vm140zrTw+PsrXySZWeUUM8+HampYFKyErnSqULk+RzsxNShRgU1LCTO9OV/b2XdxvU4QVPZBialNhFWd8Wkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609953; c=relaxed/simple;
	bh=3/cF656yoI07wozhdH3dCJa5F/qq5f8OoLwB/MUUyXQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jbIz7Y4EPWsC0TfvAwBn9W1TPhFFLMqx+Fl2JPdFfQfv/CtzGFaGmQzHV13Iik+CMjqwfMbyEyS01FmJ+Q/9ihJ45/oXylEW6tkQ8HdSsLuIHTE1VdXYYqznhDABkHO+BsxSyKYzn2E6Qqq8Xc3LIz6KKpKRtAUbrN6PtS0nLuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cW3TYBo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cW3TYBo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB6DC4CEC5;
	Fri, 11 Oct 2024 01:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609952;
	bh=3/cF656yoI07wozhdH3dCJa5F/qq5f8OoLwB/MUUyXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cW3TYBo4JU+Dy0AQjXOQlCwBqlLA7VvoDVeksIuC6wEd20taVeDQ3vLyFrorTYXmk
	 lMM+fA/EoFbvtf4Zk8qOeHQGW+eq0OLkLYS/IWD3mtT6BNmv9NYG95+RuIwQIQ1ZOd
	 nlDjHwwGhjHbzCqtPrY7pxjT2FnEqX4gbzihUZ5r9/iPSABCyMGhAQxC8aOJ4NOk55
	 NbCOREG/Yzp+ZEYs2wZwcH1ISFUpMgXzJgJWY+I54UE8lwzE5xJ+0fM012/VYNDhGF
	 GH+LlKQU6+QPfSVam14sINe9z6+jvpKTyra5JOguTG8RqiqtGe7rVFBUGbedRr4b91
	 2zGN4UXmxOpNg==
Date: Thu, 10 Oct 2024 18:25:52 -0700
Subject: [PATCH 05/43] libfrog: report rt groups in output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655443.4184637.11620659508188444880.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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
index 67b4e65713be5b..9c1e9a90eb1f1b 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -67,7 +67,8 @@ xfs_report_geom(
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d, parent=%d\n"
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
-"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
+"         =%-22s rgcount=%-4d rgsize=%u extents\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -82,7 +83,8 @@ xfs_report_geom(
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
 		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
-			(unsigned long long)geo->rtextents);
+			(unsigned long long)geo->rtextents,
+		"", geo->rgcount, geo->rgextents);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */

