Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C0D260578
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556739; cv=none; b=XhKzF4sLp1vuWFeeJaGDyGzROW9ToHjinMCYKfy/Q/LQ7ZvzCjlOdxC4Q7SmbEk6ANuE/SgWw8TjPLSXgS/54ThXQs1BEZ1+sx+eRtSAGTgZ7LJYZiC+0c7PA4aYIEu6PzISPwyLZI0s4d6y7h5J8Bfwv4B7aeI4ttjBRcSCBI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556739; c=relaxed/simple;
	bh=l6usV31D0VG/Jqt/yz1yYYtpc6gOQX8LeF+GrplSSHg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/mgzP8qsz12ZIUtmddbiUb12LmRR3PQ5nsN095vOLbRf0Y5YdZ0wj9ThBnEcGqcSQtykGyC8C0MfD7SxsDFmv54WYoiu3G+YZep8MHJ2C+DvH0k8RofiBMBia1BcrKZXywlfjVrLUrCcxNHLixElNZU8lONv648Im9SWk1ADlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEuTjL1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEuTjL1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376F5C4CEE3;
	Tue, 15 Jul 2025 05:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556739;
	bh=l6usV31D0VG/Jqt/yz1yYYtpc6gOQX8LeF+GrplSSHg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eEuTjL1Zd1C4ltpuf5zKv15kig149hi2FS2Ef5KIGfiqMN/YDxb5VKetsGFV3+IDD
	 uTtgu30OUt9sFmy4MRfz4ojZSTqJtRqTi2JWh9JAYZwi7ouELnFTZ0PbBmaNvPTAdI
	 YHF4+d66UHQDXjCy9vyMctoTEyjpw/FmdM7WLRP1+z1wiPqXTHToDyb6M7kFdrerlj
	 H9AiZZGR32/zskUgPylEEMxm6EW9lYBe4FesYV+dSI7cYDemr4TyELXA/nugiu/ULj
	 lUcm7QjSF0mjp7BsSqZG6Dk69o+GZUbDu36lF29q+ZvbA6avDJK6BLKRAy4INeVIdi
	 t9x3p8V/Tcprw==
Date: Mon, 14 Jul 2025 22:18:58 -0700
Subject: [PATCH 4/7] mkfs: don't complain about overly large auto-detected log
 stripe units
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, john.g.garry@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <175255652528.1831001.4886923245781681144.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
References: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If mkfs declines to apply what it thinks is an overly large data device
stripe unit to the log device, it should only log a message about that
if the lsunit parameter was actually supplied by the caller.  It should
not do that when the lsunit was autodetected from the block devices.

The cli parameters are zero-initialized in main and always have been.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: 2f44b1b0e5adc4 ("mkfs: rework stripe calculations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 812241c49a5494..8b946f3ef817da 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3629,7 +3629,7 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
 	if (cfg->sb_feat.log_version == 2 &&
 	    cfg->lsunit * cfg->blocksize > 256 * 1024) {
 		/* Warn only if specified on commandline */
-		if (cli->lsu || cli->lsunit != -1) {
+		if (cli->lsu || cli->lsunit) {
 			fprintf(stderr,
 _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
   "log stripe unit adjusted to 32KiB\n"),

