Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDD11F1506;
	Thu, 16 Jan 2025 23:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070380; cv=none; b=UZ2bDxfiTjWvmlAVgQeCYQR8/qxvOKaeASSaY2Et2D8F6LPCnw4iUjCxnFDwBnksc2Ih1LjntOP0f2wmZzxtmcztBwhsmdSYxdT4IGwCHuijlTIfAsyXsLIaN/E5ndRzhVSemYpiZKfU41AsV6Q4OfmhSlM3XzP9/okuSUGis2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070380; c=relaxed/simple;
	bh=fPByFgcfrXOKjgxEIczajVdAf9wwpSMjnthzSZtwCOY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyBZQo5zt36ER3UC1AM39yu5oSrZg0sqSAkF3GZP/pOi8an5Hv7CUdz3vXdpUVuJLcXVOBV0AuNJUfDCOdGw8c9396xGYyBJUvmMBIlatdbW72Y6Ug+sKlrOanqEocLx8AYQ2z+4tzsq+KwNJD/RY+iq+2utLclh+FvIAcp7BnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwQnk/oo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwQnk/oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA78C4CED6;
	Thu, 16 Jan 2025 23:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070380;
	bh=fPByFgcfrXOKjgxEIczajVdAf9wwpSMjnthzSZtwCOY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nwQnk/oo+F4Lu1Bels8U0wMD2f6TmOxupttpXfCogK4/5HhR2coj9caGOF3anQyuS
	 1lYT480AEFO1a8YvzmYaD3PeUnaemSfEEx0ndYwfxua7e5JqiyokkFPFjhbQEkXtJZ
	 S6aes8WtMI2AD/ciq9GJ/o7q+ORZSwDlFOpwesMs1UPeg65HextsuH4IPwjYyA2xec
	 0tkhEKWT8ib2SyQ+OH8fjYq1MVYjIKXepoAwwUaJ87FZIZc/muYlGjdx11L8mL0GDq
	 ItkUo9Lie2Ie8l6rPHxWVENXZzMzjoQe5/zOk7JdaWQVe8pzeQrVMWQUtF8GU5Ny7/
	 tnhn1ltLIZqfQ==
Date: Thu, 16 Jan 2025 15:32:59 -0800
Subject: [PATCH 04/11] xfs/206: update for metadata directory support
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975227.1928284.672339443089833194.stgit@frogsfrogsfrogs>
In-Reply-To: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
References: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Filter 'metadir=' out of the golden output so that metadata directories
don't cause this test to regress.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/206 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index 1297433188e868..ef5f4868e9bdca 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -63,6 +63,7 @@ mkfs_filter()
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
 	    -e "/exchange=/d" \
+	    -e '/metadir=.*/d' \
 	    -e 's/, parent=[01]//' \
 	    -e "/^Default configuration/d"
 }

