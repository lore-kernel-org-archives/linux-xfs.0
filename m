Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D481D174D
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 11:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448603; cv=none; b=lIxbVnYEWSksIwiTmI1+6yug0s+HhgRVqi3m5bp7bSqxh5CAZhgYqK8ZGdLV09vq3h4H4NfOSIO6lZ2mVRvJrDLaB8x/UB41VGUFbRSbBmYMFv2Qp74YLoHBEdEHGuehIKEsSBnN7WiEaCBneRvsBEjaw9CmE2TO0yzzOTlcq58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448603; c=relaxed/simple;
	bh=aYpmmr/pqQosD2oZN6mnrahDl814HMUNKON5md2JpcE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IqMrHN3lVrI48oconmLYLXoU/qzjKN5PYeeZjmpBVILSvS8JHKu3eN+t3LTTfiN9cpaQc//gWmipZfb8JNW8X7leU9YNNcisYQBC/TMG0Px08AwekFU1yleCu9HJPLHCApzcRvUehRLbLVgEkli/ZdsdjAomPTdUn15Z4Z6kP+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akUK171Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akUK171Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221FFC4CED7
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 11:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725448602;
	bh=aYpmmr/pqQosD2oZN6mnrahDl814HMUNKON5md2JpcE=;
	h=Date:From:To:Subject:From;
	b=akUK171Qod/vNvoh7fE9422V3kCJIOCxKViFEWA2/avukYN9fibxsX1g5532Y+KEF
	 d+F+bTuktlNEcqW5So+B6gfUuAGA/tPGQzv2/eD+RlhqqsHUCvqkySEJCOwI36M5PS
	 ZyHeko0fqbCp1zAC72FANzuVgNh1hUxVxIPZyo7wAJECfPuwdjgrZ8fyqtbvxumSw+
	 nCOKUmQLS9wLB6rAEyNWLbYEG8Goi9+MaBp2GlGdgZ+IYh7U2f1BxgolGF655eSEFY
	 XO1mAYGh1Hul6IUfeXYyN1af0nnztLCRUWamojaBkdv9PgqjbwnIgB2FrvxeSx914M
	 m5KKUgKBkgViA==
Date: Wed, 4 Sep 2024 13:16:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs v6.10.1 released
Message-ID: <6nyeagcx7p6dtlyofzx2awrllemhvvtyyeefm5p2bupg7kggxe@55mwuah6sfrd>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is an exceptional release to fix the reported C++ compile errors on v6.10.0

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

fde42a497dba52bcf1faaf0f6ae50707a3d06b29

New commits:

Carlos Maiolino (1):
      [fde42a497] xfsprogs: Release v6.10.1

Darrick J. Wong (1):
      [1f19ad060] xfs: fix C++ compilation errors in xfs_fs.h

Code Diffstat:

 VERSION          | 2 +-
 configure.ac     | 2 +-
 debian/changelog | 6 ++++++
 doc/CHANGES      | 3 +++
 libxfs/xfs_fs.h  | 5 +++--
 5 files changed, 14 insertions(+), 4 deletions(-)
