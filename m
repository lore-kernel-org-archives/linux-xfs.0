Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909BD1E51F6;
	Tue, 29 Jul 2025 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819742; cv=none; b=saQT09H7P6+QkSzrIN0Y3ht1NwvOBOFabhXX2yTlqNZ+cD/82Pf15iuaXOXK6BmPu3thvuVBokzpDj/AHXQAbBfNn144C7nADURaNPfO7KlXw20QaPf+HkcJYgUgi8Bwfut5Rq/9L0P6mtiygT5K3kYW+x6/V6qzUYp3yzW6ogA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819742; c=relaxed/simple;
	bh=xQRuJbk4y32m4ZZf6Cm9K/QFH6QbQlSLWCVrMiniktU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kw8wr+Pkhsf/VNfhasbQsLE08LoxnYMsYplONfXIEUFQuPt6oxmMIdh24466xyR55LPJ/+A9LYSrKoYdcZeSVG4P6V7DYxRGVet+G4YWtiTKUv42G1A6kU6Pe6f60vHnnHt0/Wp5XHDX8ocj+dyGVnIh53XdM4FD0HKTfs5KCJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFNJj12f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFNJj12f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F92C4CEF6;
	Tue, 29 Jul 2025 20:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819742;
	bh=xQRuJbk4y32m4ZZf6Cm9K/QFH6QbQlSLWCVrMiniktU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UFNJj12fUpZmfa1r4v/YuzGpfR9dxQAmMp67nHlVnNjWW+rg5+N52+6L2ywUNw5Co
	 ZDwlrV2qu1NUjtynyJ1gkZ80yhLlGaUY13F75ep1IWzaaSTqQJhtwhsIZZinkjrneP
	 pcg5rLVuF+5eHsJxoXDKdloXMz9qMvyVh9HRE1/jEZRRZfodHimxTFwO9BG52/tn0i
	 lsZOWafw0Y8wak533gTWaSLVdBRD8Zi2/COAw9Bdh7oiL7WFnMMZpsz2anwioOtP9S
	 EZCrxbdggEdA+zzlilejjIB8WLQXUuyTwtqVwB2oSH4nk4SJHY6GBaflqVnEgqLIWS
	 f2hFPU6gCD5zQ==
Date: Tue, 29 Jul 2025 13:09:01 -0700
Subject: [PATCH 3/7] generic/767: require fallocate support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <175381957955.3020742.3992038586505582880.stgit@frogsfrogsfrogs>
In-Reply-To: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test fails on filesystems that don't support fallocate, so screen
them out.

Cc: <fstests@vger.kernel.org> # v2025.07.13
Fixes: fa8694c823d853 ("generic: various atomic write tests with hardware and scsi_debug")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/767 |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/generic/767 b/tests/generic/767
index 758222f4f8666b..31d599eacfd63b 100755
--- a/tests/generic/767
+++ b/tests/generic/767
@@ -23,6 +23,8 @@ _cleanup()
 _require_scsi_debug
 _require_scratch
 _require_block_device $SCRATCH_DEV
+_require_xfs_io_command "falloc"
+
 # Format something so that ./check doesn't freak out
 _scratch_mkfs >> $seqres.full
 

