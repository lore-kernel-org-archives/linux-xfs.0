Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABE5C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6TeGtlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00DBC433C7;
	Sun, 31 Dec 2023 23:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067126;
	bh=Bbxf+hc4Drv/Wkxmt3khgGC1/HU2eY4ogA46Y7k6VIY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g6TeGtlMoOfkfO9M8geXI1TYzK+zd7tjTc2xlEGTkp0Mj3iVw41s7v1AR/VjKRukK
	 oTcDOiyIHA89qAw8tKOuse+9/D8EKbcrdv3hmEkirASobkZrTmIueHEcSGeblIgaIk
	 7bUZOi0A3eo6WlUUnGX7Tp0c8g6GUDvTefLpOjA8cVT5LhzWhg3wc801dBes4DS7qE
	 EbpNtCWlE0CMeFcUMV++/cxZ770UaUchvyGpV09ZMp5pCm+/7GDW1WnZWR/TUrwiwK
	 0yUGlKkVKuzNx9aersPYLOHfcFQaah9ZMBy+Jk6vFpclrISAQnZ4rZblFiS9I/E6w3
	 RaXevx0FUz9Iw==
Date: Sun, 31 Dec 2023 15:58:46 -0800
Subject: [PATCH 43/52] xfs_io: display rt group in verbose bmap output
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012739.1811243.15253133197830212877.stgit@frogsfrogsfrogs>
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

Display the rt group number in the bmap -v output, just like we do for
regular data files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/bmap.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)


diff --git a/io/bmap.c b/io/bmap.c
index 722a389baaa..11bbc0629cf 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -264,9 +264,16 @@ bmap_f(
 
 		foff_w = boff_w = aoff_w = MINRANGE_WIDTH;
 		tot_w = MINTOT_WIDTH;
-		if (is_rt)
-			sunit = swidth = bbperag = 0;
-		else {
+		if (is_rt) {
+			if (fsgeo.rgcount == 0) {
+				bbperag = 0;
+			} else {
+				bbperag = (off64_t)fsgeo.rgblocks *
+					  (off64_t)fsgeo.blocksize / BBSIZE;
+			}
+			sunit = 0;
+			swidth = 0;
+		} else {
 			bbperag = (off64_t)fsgeo.agblocks *
 				  (off64_t)fsgeo.blocksize / BBSIZE;
 			sunit = (fsgeo.sunit * fsgeo.blocksize) / BBSIZE;
@@ -295,7 +302,7 @@ bmap_f(
 					(long long)(map[i + 1].bmv_block +
 						map[i + 1].bmv_length - 1LL));
 				boff_w = max(boff_w, strlen(bbuf));
-				if (!is_rt) {
+				if (bbperag > 0) {
 					agno = map[i + 1].bmv_block / bbperag;
 					agoff = map[i + 1].bmv_block -
 							(agno * bbperag);
@@ -312,13 +319,20 @@ bmap_f(
 					numlen(map[i+1].bmv_length, 10));
 			}
 		}
-		agno_w = is_rt ? 0 : max(MINAG_WIDTH, numlen(fsgeo.agcount, 10));
+		if (is_rt) {
+			if (fsgeo.rgcount > 0)
+				agno_w = max(MINAG_WIDTH, numlen(fsgeo.rgcount, 10));
+			else
+				agno_w = 0;
+		} else {
+			agno_w = max(MINAG_WIDTH, numlen(fsgeo.agcount, 10));
+		}
 		printf("%4s: %-*s %-*s %*s %-*s %*s%s\n",
 			_("EXT"),
 			foff_w, _("FILE-OFFSET"),
 			boff_w, is_rt ? _("RT-BLOCK-RANGE") : _("BLOCK-RANGE"),
-			agno_w, is_rt ? "" : _("AG"),
-			aoff_w, is_rt ? "" : _("AG-OFFSET"),
+			agno_w, is_rt ? (fsgeo.rgcount ? _("RG") : "") : _("AG"),
+			aoff_w, is_rt ? (fsgeo.rgcount ? _("RG-OFFSET") : "") : _("AG-OFFSET"),
 			tot_w, _("TOTAL"),
 			flg ? _(" FLAGS") : "");
 		for (i = 0; i < egcnt; i++) {
@@ -377,7 +391,7 @@ bmap_f(
 						map[i + 1].bmv_length - 1LL));
 				printf("%4d: %-*s %-*s", i, foff_w, rbuf,
 					boff_w, bbuf);
-				if (!is_rt) {
+				if (bbperag > 0) {
 					agno = map[i + 1].bmv_block / bbperag;
 					agoff = map[i + 1].bmv_block -
 							(agno * bbperag);

