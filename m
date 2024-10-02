Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0B5227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831191; cv=none; b=Q5R5nzT5ZDT59kMGS/1ZgIvyIGe+CCPJI66k3rJeR9RaUrjZrUXaVnfLyxKUIV7TuRg4FyuKSKxX3ZGmX2UDCBwAI3jEbbkq4VhhT2Cl+WRJlQNTygKmohKSyTcH2Ptaj6C+S5HP+iRi42lF1q7JiHZPe0DkcW+dOGWQuNk4GCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831191; c=relaxed/simple;
	bh=myAW+urpNlgh95hFDz6v/bvDzbRF4mH5lg1bcBcpiVM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cr/bmORI707jqHIxJ81UHJWoAR4sIHb4pw846qDNfWmVBKGQk+ivD0g8wMzLVhFYjTwSOaylhQMvQ6RzfVTOiYgdF/t89n345+ArLrTU4QYAw/dKJ/+KXCqRkOOu9gl7PkAt/L3q1m41/E8meVd3s5rd1w3/byLr+wFzIfmPqh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATVpRUVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATVpRUVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D64C4CEC6;
	Wed,  2 Oct 2024 01:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831191;
	bh=myAW+urpNlgh95hFDz6v/bvDzbRF4mH5lg1bcBcpiVM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ATVpRUVmL6JUnNvKXickxlUwk/oArCAIYbn4uZrpw0Cl8CSBYYCBjY8vpNlGQHCUA
	 MsSwEUdmctzFHIw23Xo8qfK7X9DU1Bj41Ds+zodCDTjjIy5kObBpwSovRrUVDFAAbv
	 3+I/HimLkUCg6aaU8g1wQaj+Ct4YdkQFJOqlE/9Tg6ubYBiDX4ETdQhyFv2/UOFiOI
	 T/n8qszXf5oXCiWtAhZZL+pfSxL1ar/y70wkKQLJQtZ3YH9oMlGtNLVMa7mLIdRUEk
	 uDPHqS/dQpyhQD87dIqj37eLXwGQ2LKFeyWLn9kuRgFWM8eG/yO2D0GeiSeSRwQvBB
	 jW0xabkrAUoHw==
Date: Tue, 01 Oct 2024 18:06:31 -0700
Subject: [PATCH 3/6] debian: Prevent recreating the orig tarball
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Message-ID: <172783101015.4034333.3134414531654309278.stgit@frogsfrogsfrogs>
In-Reply-To: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
References: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Bastian Germann <bage@debian.org>

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |    1 -
 1 file changed, 1 deletion(-)


diff --git a/debian/rules b/debian/rules
index c3fbcd262..98dafcab8 100755
--- a/debian/rules
+++ b/debian/rules
@@ -103,7 +103,6 @@ binary-arch: checkroot built
 	$(pkgme)  $(MAKE) -C . install
 	$(pkgdev) $(MAKE) -C . install-dev
 	$(pkgdi)  $(MAKE) -C debian install-d-i
-	$(pkgme)  $(MAKE) dist
 	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
 	rm -f debian/xfslibs-dev/usr/lib/$(DEB_HOST_MULTIARCH)/libhandle.la

