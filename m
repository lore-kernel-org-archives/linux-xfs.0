Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819A22BF017
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754913327; cv=none; b=E7O0VhqdvJjsjHnKMgEqcLsG3cXk6cbzvhf3xlspGnLOnWeWjckWa5/35vtj7WIEFzZkbhdnLEs8wgDQYrPpd/Vm54drExBSJ7eSy9mBZco3/4JezveYdh6VtSVE9r1gfD1V1BppfPH4FSDeO12UCoAV61I/+3XOxFphNNVRNeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754913327; c=relaxed/simple;
	bh=Ib5R3CZkbSBctrBi0sz6R+OIM42dbOiyNBwa/xIE1L8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=u5xaCIgKmQQdG/PAoKRwqGq3mwJKdieNbfJD+6tOlnAxEo/qGdIVK5viAEJTUB/hUtuSswNMwRWLWh74R+TvnvufKYWdMT0nCr6ux/1wQnrudqp68jRklAsJ5xZwbFlcbyW8/xdSiFiYTi4MOdx8H2emALxkrFK26QK7Vqyy8l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSq3h/pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSq3h/pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07DBC4CEED
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754913327;
	bh=Ib5R3CZkbSBctrBi0sz6R+OIM42dbOiyNBwa/xIE1L8=;
	h=Date:From:To:Subject:From;
	b=lSq3h/pXQhr1Rxyn3qz5xABDtxF8HOnqGHNsMT6vxPTqsDoD5MeG3rfBoHgOo1RWp
	 uNwDBfdiRe7jr4LJ4MfsCB2rt/+iefuIc/EbOTI3BVc+OuIm1zBW50pOHBJjpN4hST
	 ylxcDY89tYDFv4nwG0TpuWYZmYBBiIG6Gvh7ULFQ22bfVDP7Gfo6GhtCoz5uWOzD8f
	 kpdpquwad83U1Jwy2Ya9ne5QZhzKnat/U2TvASc1yaf1G2MwG/69NKCYmlvmSqZ5bj
	 cXpYXVzzNughGi23EgodlnKuudnlOREtI/6eiFn7Ukdjosejrunv5a7Iib89nB6jpM
	 Nxks68NhRirjQ==
Date: Mon, 11 Aug 2025 13:55:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8f5ae30d69d7
Message-ID: <mew4mufokge65du52v7jjjw3migs7gyys5amqbwablmru2wcjv@patyl4rf2xkk>
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

This update just resets for-next branch to v6.17-rc1 to start the new
-RCs cycle.

The new head of the for-next branch is commit:

8f5ae30d69d7 Linux 6.17-rc1
