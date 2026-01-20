Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BCA33ADAB
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931449; cv=none; b=u1UybDhrGZX+3yd/KXZDww1138xI6cH1mA2KxcipOluSOQAxUqszYaB3cVOusTEMDSwHj63cjZzTjeM39/WkgvwfWVPj4whLpCsLOkPZ0qmhpy9X8xSJ5vbYQTnMsoHwRrLRBAb27PoDtPqU9VRzfKqkWTq3faKLjVLC8nkTOdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931449; c=relaxed/simple;
	bh=j7xojW866yafR4dCo5mwPktqd649/K9nE6/GtzrOtvA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JquOu7pVDuCSlE5rGiXRrUZVOHD8JS2pN5bnK4cGZ/+re/7RzPQ3hLMBtm+2lvRl0N2/WMR5FX/fPCOtqZV8Vtvff/U6hpeb5Eb0Q9fRIe7aETHO11bJKF03Kj2WcOm5dmIbosNyYD5lr49nsrW/m0po8GYq7vbjSfiHO/yphfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GyhjlCO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GyhjlCO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3457FC16AAE;
	Tue, 20 Jan 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931449;
	bh=j7xojW866yafR4dCo5mwPktqd649/K9nE6/GtzrOtvA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GyhjlCO7kvkWOxH4KwMRBPtoERL247rO+b+JDqOanAgKfTWlzO8wMKSBCGIuKyQgi
	 QZBMxX0KN+efCdCqj5ndK8v5SNo9AD2v7zO92JvqofJe2Kna8ptPWdCN8L4Fk1ldGR
	 zHxhQ0ele3MTl9wbP23hsHrJGaRDGjdBz+fFC9tshnCfx58Q/yHcvAtNL9YJsI7dsy
	 HJ27zPAAVUcCRzl9UEcbSMnNn1F7Ws1kJ3jRKwQaULyb+KI9QDRIoppnCkR/ovyKYp
	 1sAuOdHQLRzdQcr3IrOr3hQm2BaFel7MV/o9X917iO0lO7ixfuRfSO9G0cBpn3fKsW
	 mAjPEwlrrILNQ==
Date: Tue, 20 Jan 2026 09:50:48 -0800
Subject: [PATCH 1/5] mkfs: set rtstart from user-specified dblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176893137089.1079372.9346420785447726442.stgit@frogsfrogsfrogs>
In-Reply-To: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

generic/211 fails to format the disk on a system with an internal zoned
device.  Poking through the shell scripts, it's apparently doing this:

# mkfs.xfs -d size=629145600 -r size=629145600 -b size=4096 -m metadir=1,autofsck=1,uquota,gquota,pquota, -r zoned=1 -d rtinherit=1 /dev/sdd
size 629145600 specified for data subvolume is too large, maximum is 131072 blocks

Strange -- we asked for 629M data and rt sections, the device is 20GB in
size, but it claims insufficient space in the data subvolume.

Further analysis shows that open_devices is setting rtstart to 1% of the
size of the data volume (or no less than 300M) and rounding that up to
the nearest power of two (512M).  Hence the 131072 number.

But wait, we said that we wanted a 629M data section.  Let's set rtstart
to the same value if the user didn't already provide one, instead of
using the default value.

Cc: <linux-xfs@vger.kernel.org> # v6.15.0
Fixes: 2e5a737a61d34e ("xfs_mkfs: support creating file system with zoned RT devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b34407725f76df..a90160b26065b7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3696,6 +3696,36 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
 
 }
 
+static uint64_t
+calc_rtstart(
+	const struct mkfs_params	*cfg,
+	const struct libxfs_init	*xi)
+{
+	uint64_t			rt_target_size;
+	uint64_t			rtstart = 1;
+
+	if (cfg->dblocks) {
+		/*
+		 * If the user specified the size of the data device but not
+		 * the start of the internal rt device, set the internal rt
+		 * volume to start at the end of the data device.
+		 */
+		return cfg->dblocks << (cfg->blocklog - BBSHIFT);
+	}
+
+	/*
+	 * By default reserve at 1% of the total capacity (rounded up to the
+	 * next power of two) for metadata, but match the minimum we enforce
+	 * elsewhere. This matches what SMR HDDs provide.
+	 */
+	rt_target_size = max((xi->data.size + 99) / 100,
+			     BTOBB(300 * 1024 * 1024));
+
+	while (rtstart < rt_target_size)
+		rtstart <<= 1;
+	return rtstart;
+}
+
 static void
 open_devices(
 	struct mkfs_params	*cfg,
@@ -3720,17 +3750,7 @@ open_devices(
 		zt->rt.zone_capacity = zt->data.zone_capacity;
 		zt->rt.nr_zones = zt->data.nr_zones - zt->data.nr_conv_zones;
 	} else if (cfg->sb_feat.zoned && !cfg->rtstart && !xi->rt.dev) {
-		/*
-		 * By default reserve at 1% of the total capacity (rounded up to
-		 * the next power of two) for metadata, but match the minimum we
-		 * enforce elsewhere. This matches what SMR HDDs provide.
-		 */
-		uint64_t rt_target_size = max((xi->data.size + 99) / 100,
-					      BTOBB(300 * 1024 * 1024));
-
-		cfg->rtstart = 1;
-		while (cfg->rtstart < rt_target_size)
-			cfg->rtstart <<= 1;
+		cfg->rtstart = calc_rtstart(cfg, xi);
 	}
 
 	if (cfg->rtstart) {

