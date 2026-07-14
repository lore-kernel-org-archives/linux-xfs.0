Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1CA363C60
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 11:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028107; cv=none; b=JG5zXPr6Igs/dXp4Y6eZyN82rn8F9cSEAn4dhuZiJhYD+fAuUTilhMJ6ibWAVHWYpzg0OdH9WHoA21hPNL2fozLV0gXGQd6WNnffg564IvCkJ4WB6KS4d/gjo/Scx0IPFNBAp4ZrpbWmQ3GCDlH+BSMxtR5y1/6AwIVmDdYOCfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028107; c=relaxed/simple;
	bh=XGIFo90aDueG1ItvXZNRzEAp/W6uxnOev7Ey3bmeFUw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fqcJvXx1nsBdIwQi+LdBRGEcBGmGK4rCaXxMFouM3nD7Y5fV6ViGIxsqv7HOwulhnOOTPidItPHeVP77dp2m6aCtjYYrAbvvctXNOkuvMR3OrcX2bwoq5LJTzPgs+mo6xKI1EUePamCHoZdtEq0J/d4nbykiHJkH10aAbP1UFSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obiS3wTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obiS3wTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B134A1F000E9;
	Tue, 14 Jul 2026 11:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784028106;
	bh=BcS0iwb+wZLn3KgAuPsPkgliIQj4V5uQ9LJyqCchVyk=;
	h=Date:From:To:Cc:Subject;
	b=obiS3wTej01KJ88dc/mDZrmbJwH7LHNsO6oo63ktgpLAu00xKl3/2eXHLy1E/Ji16
	 ZdiWIJtx7M6QWhAV86qoLb/1sJBEcFamLh++XDFjSeB6fGXJdkpYD7x6Wq8nv5tTon
	 NY5QKQiyVFyKpdwQVue92Q6aIVsJWc5qCjuO8gn75BAWFn78h8FftI3ow28oBhcJy9
	 DYHnCOz0n1CoYS3b+uHfUFtLW4BsJqBlVTuOJr9cAfT0ICPKF8y4jv8KCxlIsUwphO
	 sLRo0Lgje0Xb+4NeYvRCgSVQi8Sqkt/H6KruyBY85HNsMhajyZhdm7rYz0x3q2+2oj
	 BT4oQWNWF3S0A==
Date: Tue, 14 Jul 2026 13:21:42 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, 
	msinguru@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to ee7dc67a6aaf
Message-ID: <alYa9kucIrL7LhOn@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

ee7dc67a6aaf2a7ec3e63ebe230a67541ca671a8

New commits:

Darrick J. Wong (1):
      [ee7dc67a6aaf] xfs_scrub: fix spacemap scan for data volume

Manognya Singuru (1):
      [992ef0086051] mdrestore: fix extent length overflow in v2 restore path

Code Diffstat:

 mdrestore/xfs_mdrestore.c | 12 +++++-------
 scrub/spacemap.c          | 13 -------------
 2 files changed, 5 insertions(+), 20 deletions(-)

-- 
- Andrey
