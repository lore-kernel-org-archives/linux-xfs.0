Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761231990C8
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 21:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729547789; cv=none; b=N3nJaZVGgJGiAlEJEGTgs9EaHAqm2T48yVFWV1wmItR2d1S67rSMJ5QFNOf4WnAxgXDMNkAyniCPL8W57BiOloNo/6B0i0VIHlewHb/rtfxcimNA2FoaP1Hjvaj+mzwdzsyyRoAakBwuF6vT/w0ovPWjtA44vB6/aVUWIKCBFCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729547789; c=relaxed/simple;
	bh=54+7t1hLq12VoFEdyLrUjpp3VRJ4rngKRIX2iGUxQAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LUCv9AKvPnna5wuORuwQIxPMJBAVlZsyu2g5A78ZWEveQQ9Fx5WM1o8YTgDaOd71rtSCPqXctxnu3D3gZ0hZbkF4qgWhY3EZU6a/b88t3ztHqOHaX/MUHlpEqiH/r/Soqg/tOCsCxoIotXcSd0+LxPU6pgsmDv7HRHVZwXGoHEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBth9tzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBth9tzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A2CC4CEC3;
	Mon, 21 Oct 2024 21:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729547788;
	bh=54+7t1hLq12VoFEdyLrUjpp3VRJ4rngKRIX2iGUxQAQ=;
	h=Date:From:To:Cc:Subject:From;
	b=IBth9tzMIjszaAbZ0TdXMHNoVXT8U7QppKKDETOyWHo06OUPr/TFweyleFsupuf4X
	 sF5Bj1jiGqotBR+8MLGuYYzFrmK81O0NX8FUtQAoxJ57gzKi09/gCDFgGbkmTJ/cSA
	 JIuDH4+t31y9N9Lm3tCwu8TXEwWTMsrwGKtqpOoCac/wGTKhnHCJY7elU4SQvg6wgQ
	 9r8cF4dPuF2oeNZ3fBJeEqktFNBTl/c/mapMUZyHxhNGJsS7MaZ5jyNAo7EISedO2m
	 xBMPr8PRsD/jop8BBz9dPR7cpG3ntZkuyzUO+x1Fv69P/C0+ZgI1zx5RrvwuwP2beE
	 6VfDBbetBrssA==
Date: Mon, 21 Oct 2024 14:56:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB] xfsprogs: catch us up to 6.12-rc4
Message-ID: <20241021215627.GC21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

Here's the libxfs sync to catch xfsprogs up to 6.12-rc4.  I have a bunch
of tool changes as well, but I'll hold off on sending those until dave &
hch have a chance to look at last week's kernel patchbomb.

The only unreviewed patches are these:

[PATCHSET] libxfs: new code for 6.12
  [PATCH 01/37] libxfs: require -std=gnu11 for compilation by default
  [PATCH 03/37] libxfs: port IS_ENABLED from the kernel

The first patch brings our C usage in line with the kernel; and the
second one is needed for a bug fix that got merged between rc2 and 3.

--D
