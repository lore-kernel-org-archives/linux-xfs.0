Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AEA2FF147
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766137362; cv=none; b=hq+Rlv0xZphE5BDIEaCOXaFUzL/T8dtoUMu4nJMbssbBs8udlal+x2svVBCi7c/61RYt3qNoHn0zZLWdbQlemebs7/rLwzKFVv+v4jLOtJ0q8UhEDB4VrukXEIcy8d6V6oe/PVtv1+DgqvGlhoR2Cx/s7ZTV0upgxMuMivNCRG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766137362; c=relaxed/simple;
	bh=5YENZ+jIWB1IhUegHACL5MtUuqDlBKHzPu9sENRlb9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nneC10vCKBq7RQ10YQZCdULFa3f/5eZvQzWlMtzqEchxN+QK7cDyp+PsXDBN+SHa1ra7tWxazgev2iIi96345fNPNsfX/+TZMa5CImx+20NenKyGfsfJnBUL1Elx/2up9CvPT8js4dRLr+89AdUY0unbDVJ54yWw9sOcsjGpFq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3lSGIZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3lSGIZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50309C116D0;
	Fri, 19 Dec 2025 09:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766137361;
	bh=5YENZ+jIWB1IhUegHACL5MtUuqDlBKHzPu9sENRlb9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3lSGIZp50RYr4GEpNS8FzvCzsRl5iGz70oOD7cbHO0Z7rg/fF/vLM8xOldcOmRZK
	 B4aAA/TcE2YQvbNbiYUXENru0aPG62W+sbfwwtdT44jl0tEV6KqU2RfcDETwf/wyQN
	 WM/+ZdRhefu7pVBMTX+1W+o5U0WhYPUmLd473yeDfd9FWkHZHq0SvDUfiEa6TZuYxQ
	 017BvMkh+ru7BV6BpSKhvt3shcQbEcUBvFASYGgiieUpx29w2R8Gn+Gtzb18HfLk2u
	 BCQeMi0UMj40xZcajkG3KxMePmJ3r6BmIDUjqTxZORElESmbXUJI9I+GjBpDi2EE4Y
	 NOiMZl6neqs7Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v2 3/3] repair: use cached report zone
Date: Fri, 19 Dec 2025 18:38:10 +0900
Message-ID: <20251219093810.540437-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219093810.540437-1-dlemoal@kernel.org>
References: <20251219093810.540437-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use BLKREPORTZONEV2 ioctl with the BLK_ZONE_REP_CACHED flag set to
speed up zone reports. If this fails, fallback to the legacy
BLKREPORTZONE ioctl() which is slower as it uses the device to get the
zone report.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/zoned.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/repair/zoned.c b/repair/zoned.c
index 206b0158f95f..1e4891c483ee 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -82,8 +82,13 @@ check_zones(
 		memset(rep, 0, rep_size);
 		rep->sector = sector;
 		rep->nr_zones = ZONES_PER_IOCTL;
+		rep->flags = BLK_ZONE_REP_CACHED;
 
-		ret = ioctl(fd, BLKREPORTZONE, rep);
+		ret = ioctl(fd, BLKREPORTZONEV2, rep);
+		if (ret < 0 && errno == ENOTTY) {
+			rep->flags = 0;
+			ret = ioctl(fd, BLKREPORTZONE, rep);
+		}
 		if (ret) {
 			do_error(_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
 			goto out_free;
-- 
2.52.0

