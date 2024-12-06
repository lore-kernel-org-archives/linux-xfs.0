Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C441AAA24
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527817; cv=none; b=JRAp1/ohrC1ya10sfgrodcb/mDRDyZRi0mS91ApzWN1alSHnlxvMHSWEA5sp/16zRD1T7Fa4Lxe5dtFx9yAlrfjD8zZiJVFefU0JXy4gLqXlIJXjTT8sezA/xSqf8+oaVNfCA6KKioD+e+y7+c2Z0tOiWaQ/AnFgKbZqUJgQbgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527817; c=relaxed/simple;
	bh=jVc7FyzA78vPmgqhuFB8iAX/wZdr2HsbanBsJnOeThU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P65XsIWm0fzz05twYDA1/yUHCO2SRzpRD+vYUeGr2rUk+V32ZViyzCaXQkyCQED+OTgDw8WzqylKVu0IcC2sXNfB5sbSVFPakyYq+qCsUz68HmmSimyxrlagot5XuEUdC25lJ2cgjVT3rAWf1ZeLD2j7OS1jj92OEjUfz1/fZuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K42WqjQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K42WqjQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0ECC4CED1;
	Fri,  6 Dec 2024 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527816;
	bh=jVc7FyzA78vPmgqhuFB8iAX/wZdr2HsbanBsJnOeThU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K42WqjQuPZ9ljxVa63qUu2u9HR/xvHGNhnICg/LlV5TxPq14CZl8/O4xBMaXG59Ck
	 ame9/1eNY2X4iJ6naLrRfAwvN+dlpRihl/KuZEHrDfk/WblaQV+IrPhC+B6fMTrvyK
	 GR8O4WJ3bMYcH2gt566M4JTOtzrCSy+pDOa/tiij4LdUCheulOglcyTqV18glBgKuM
	 DGenJ6Ov+bOxFuvehBAdBVbXVoE8mEhJxcPKm8NU1IVXVPRFs5d3X5X0kA76q47cA9
	 oxUji40UCao1dsaQ94zfrPo3rCitqACvER623Wc+JU1cOChHjJPWzc2qNBhHRLUY/x
	 3FAdQRdR4zJBg==
Date: Fri, 06 Dec 2024 15:30:16 -0800
Subject: [PATCH 2/2] man: document the -n parent mkfs option
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746331.121646.4339047798362935705.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746299.121646.10555086770297720030.stgit@frogsfrogsfrogs>
References: <173352746299.121646.10555086770297720030.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the -n parent option to mkfs.xfs so that users will actually
know how to turn on directory parent pointers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index a854b0e87cb1a2..e56c8f31a52c78 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -902,6 +902,18 @@ .SH OPTIONS
 enabled, and cannot be turned off.
 .IP
 In other words, this option is only tunable on the deprecated V4 format.
+.TP
+.BI parent= value
+This feature creates back references from child files to parent directories
+so that online repair can reconstruct broken directory files.
+The value is either 0 to disable the feature, or 1 to create parent pointers.
+
+By default,
+.B mkfs.xfs
+will not create parent pointers.
+This feature is only available for filesystems created with the (default)
+.B \-m crc=1
+option set.
 .RE
 .PP
 .PD 0

