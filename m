Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D843390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497153; cv=none; b=OkuVM6TQ9KDw4UW1sSq0YN/Wnz4Z8y+gdWtFuSr6MRiXH0SgG8Hlf2A2Ya667omzV8pIwVsiwbuQf5WKhbYjUlFl1qaFvSKzmm8ygTmilk8ThlP+wg+FKCgU5xOL16uu0YWCRLfFkMYQaZlmANlEMST4yBOtSxYN4A+r3UsXWOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497153; c=relaxed/simple;
	bh=QZ2wH1Um2G7tYr/e4sJfasK3kgzrplTRpSQShK6xqq8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rJo4HB/axFxrsnN1ImOhFO+cGIZp/FBCgUYtqAF8R37fytWrzRtjy9C4DKm4YJrw4mXpy5LnRjJXlObOvX80IeI6HOiqjnYbMZFPs0XPTLSExMm0uYhd2+bg+65BHa3Kwk2ekf76PdpxyltoSocFsjuVdoLUtdYql82iDdIQB0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRtY4JeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRtY4JeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1A4C19423;
	Tue,  3 Mar 2026 00:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497153;
	bh=QZ2wH1Um2G7tYr/e4sJfasK3kgzrplTRpSQShK6xqq8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PRtY4JeKqT84kV/y5gojaVlk4LO2g8JadjKTfWUSRAxeTSWxr32jOysJZLlBXaC47
	 HHcEKnoMNBSnd4tCsmWv9d1jCfHUAgThk7hpAolc9Skit1oib4LSgm66Tyc/VlIYnl
	 CN+GW5xcxmU2KxtAL24W4haAbrUpyyJU6kT1M9ywZQIfIWvujv2YRwnmjVdemtrma7
	 1e9rIABB38dTB5mc4A62uRiAG9nxLK6JkXdGEwlD8jQ6ZrBjAdiUBLoeXqdMCbF/7F
	 q+KujB/1fp3ELxdWGo7JgvqXDxC8UcF8KYUWIxAnKR62qSxY0ksW/+NGxCg2yBsQOM
	 tq93yNhcrXsMQ==
Date: Mon, 02 Mar 2026 16:19:12 -0800
Subject: [PATCH 27/36] xfs: add zone reset error injection
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hans.holmberg@wdc.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177249638275.457970.17073098279246177406.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 41374ae69ec3a910950d3888f444f80678c6f308

Add a new errortag to test that zone reset errors are handled correctly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_errortag.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index b7d98471684bf1..6de207fed2d892 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -74,7 +74,8 @@
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
 #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
-#define XFS_ERRTAG_MAX					47
+#define XFS_ERRTAG_ZONE_RESET				47
+#define XFS_ERRTAG_MAX					48
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -135,7 +136,8 @@ XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
 XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
 XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
 XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
-XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4)
+XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
+XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
 #endif /* XFS_ERRTAG */
 
 #endif /* __XFS_ERRORTAG_H_ */

