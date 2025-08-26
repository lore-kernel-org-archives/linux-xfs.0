Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEE92248A5
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 10:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756205778; cv=none; b=hY4PYx9qk5JsfS+/FnWQDW5cOyBBNyMIFs2M2l6A3Mu94FNVw0LiaxTcurlVNVg2I1TRJmDDD8rYykmDS/HJ0Kc8Kqt4oDpklAipYdcQ1bMVSLCkcsWIyB3w9uT2rwHeZE4Z5JY4ZlGXxK3wFosWXVhKigvNvkB/4jVXDObNU8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756205778; c=relaxed/simple;
	bh=9ubCZ5rCx2geAR6/QLY3sSuRsqVjwFsO8gOqv2TwupI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UziRkcEGrUIBadKkKU5UEQZIcZ4TPTW8eclGWSJSMWrPNrSWfMoRMd8k3G+E/ASgDM5VdLJyZ+V4+OpGaIrW5J8qlF9h6k7Jc++4C4JPryY9aP6bP9TuQx9S1SqpcTDSv1hRI6oUdi1AQskdX6bh1MTF0/zJ8AZjO5DgXFVVfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCn66cXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCn66cXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CAAC4CEF1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 10:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756205777;
	bh=9ubCZ5rCx2geAR6/QLY3sSuRsqVjwFsO8gOqv2TwupI=;
	h=Date:From:To:Subject:From;
	b=mCn66cXiTwD38v+wC4fz8996BoE/IF4VibELThPpz2ot16aIiBLNtLMk/S8+teoa+
	 lRXEI15oF/NPNJEvJRROTvlw5mge508KpjWkmQzz+h8WwOCLAUqjALVTeLTGTKTVx7
	 kicvow3uZhNqRfHEczDG5n04Wd7wgRXxHTIfNzjVZEfBeqTbJkRB1O3Qi1AOLw1V7v
	 IsOCWgHhVnME5Ej30RovsOjco0uuVwg9dFNEql8g0tJBNvHuIEhBn1SWG68HFZk4sV
	 UREFDxGymTO6eN4lDMx+SrjL3jgHJCPvKo2vzP9v8nCKxD3/98suv8kjExsN7KBdyi
	 N/EybmzD+S93Q==
Date: Tue, 26 Aug 2025 12:56:14 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to ae668cd567a6
Message-ID: <4yibblpz3mmu4uuzgr6sn5ulpzplprne36mgebketqeobhmzb5@bv2cdy5nvodu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

ae668cd567a6 xfs: do not propagate ENODATA disk errors into xattr code

1 new commit:

Eric Sandeen (1):
      [ae668cd567a6] xfs: do not propagate ENODATA disk errors into xattr code

Code Diffstat:

 fs/xfs/libxfs/xfs_attr_remote.c | 7 +++++++
 fs/xfs/libxfs/xfs_da_btree.c    | 6 ++++++
 2 files changed, 13 insertions(+)
