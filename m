Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A226F34D90E;
	Tue, 21 Oct 2025 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072062; cv=none; b=bomrpTgERGla3Hzj/gMDTm5zSPeocqHpooyGw0vMSRZdiAEPCgcA7p5U2lpK8U1no9tZogUpURuevyujkOplnUDfcviCkfyAobLnKV3/hoyjYbnXFFIf9etXi77y3i7dNy5Pg4LhTq9KANmrT6gw7e3W/ztVhyx9+pmBU1EmOeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072062; c=relaxed/simple;
	bh=n3idpf7sI27vZDBXLNp4sPpKOLJ2USSLUNo36EmFfcY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f46AnFZK9qCL8+DhCEVVwe0bRLv/hPJHfWOwP7CT/QELjdoxIW30OaPckIIBQhJEY7Tk2vlSXMYGj/uXbebbXkenDdedudoNOQmtwI9S4xKCGSxZxp6BdbJH4egH51NBZ8kSjJ21HyjIIkN/Hcq2WSlkJ8XP3bT2K5r5Szg7BSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxIjtlCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxIjtlCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB6DC4CEF1;
	Tue, 21 Oct 2025 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072062;
	bh=n3idpf7sI27vZDBXLNp4sPpKOLJ2USSLUNo36EmFfcY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fxIjtlCYvKeZSSShRHlnswKf1w+X4Nn+l6r5IG77YHzFnfK6Sp8aioTNID1kDir/K
	 HgUz5/XGXahmXOoYEJ2BboYhJIGngZPm4pVDitOYNw4JdWNoK+earXQD7ozfS1w6sE
	 a5zvDVibTPU+aN9DYAYx7JQrV7Dl2Ra1HVRfLIzBGAW5qVbUc1TmOQGUMWgdcbcCU/
	 /5tSfOkHoFw4qStwltLalFifUAL0ss9ZWiTJvxEkgaLVpuwDwU9GeuJPG+T/VcXaKm
	 abMH4RjXb2oysPIGQEsq3UroU60WypJUZ6r1JsOkwAbJXQtq7dNfL+RAKZOpHtUS4J
	 TdzzTnKlW8sxw==
Date: Tue, 21 Oct 2025 11:41:01 -0700
Subject: [PATCH 07/11] common/attr: fix _require_noattr2
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176107188796.4163693.621654982694454334.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

attr2/noattr2 doesn't do anything anymore and aren't reported in
/proc/mounts, so we need to check /proc/mounts and _notrun as a result.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/attr |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/attr b/common/attr
index 1c1de63e9d5465..eb5c862556d3be 100644
--- a/common/attr
+++ b/common/attr
@@ -241,7 +241,11 @@ _require_noattr2()
 		|| _fail "_try_scratch_mkfs_xfs failed on $SCRATCH_DEV"
 	_try_scratch_mount -o noattr2 > /dev/null 2>&1 \
 		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
+	grep -qw noattr2 <(findmnt -rncv -M "$SCRATCH_MNT" -o OPTIONS)
+	local res=$?
 	_scratch_unmount
+	test $res -eq 0 \
+		|| _notrun "noattr2 mount option no longer functional"
 }
 
 # getfattr -R returns info in readdir order which varies from fs to fs.

