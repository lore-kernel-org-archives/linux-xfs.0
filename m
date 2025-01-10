Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8461FA15C
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 09:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500845; cv=none; b=hfXrhs5ZLPmwD8l88pUVORNz8VzJrOAHen5MQUn8P4rMh2k/1+NT2InXcE7NhxfUBfQnwN0ue825k2mvJw64AAc1iaNE1JVuOjOmGmm3+Qkr79Xcvcuy5JRXKvjD5LOrZvk/iPjgUGefvp19POTnn/gxCRzPOvnBDoPtULs9QPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500845; c=relaxed/simple;
	bh=pvnd1CJZi1xY94hRivcWtLtADs7MmspeWiFRUKXa1nM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JvyJ9k8GtS7shyA6wUjgS9TTUTCJ1k3n5C+noXe1x9/4PoauYoUrK2Cr9f+EVGQ6pCzDl4CsPHt8/INQlXXkq0ZplN/8xzK9L6cHRhw8Bsw1hJOFLmIufiTjyEuhF7Fxgq4H9jBNQVMMd7t8jplMcd8ML73n0BvsUs9zLSegJYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBCaHyji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBCaHyji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5830C4CED6
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 09:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736500844;
	bh=pvnd1CJZi1xY94hRivcWtLtADs7MmspeWiFRUKXa1nM=;
	h=Date:From:To:Subject:From;
	b=vBCaHyjitFNWeKMC/8XldQPACNvWCv87d+g9JftbUyZ5X6pRTTaN+bbHw51yoHfsN
	 Bn1Vo7bcvckbFQMTnKhDv0LeABJHk0HqGAQP9evNFThCkUwr3tmzosFreMSWvy5KTl
	 sbIFkiT19HgAgHO1RLg+Tb4nel5Ixleirn2oP+gU6q3OoarHFlr+08Q89o3PkLjVqg
	 8Pr5OoLN/AwHKfhZI4i8tad/8Odr7IkkG0sD7UqBELvx1wWXO1NeX8I/XNiyDVGbvM
	 F2BjMYKqy7DTuxgLfe/QwsUsxImTR8RK26mMp25Fm+qlJVeX1y5iEDpMEHpmU90PUW
	 2EUmPJcsriITw==
Date: Fri, 10 Jan 2025 10:20:40 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 111d36d62787
Message-ID: <isdn7drud2qyvuyoohmg75oi75yed25oxfmq6zl2fyml6eqdaf@le6dhaucmmzm>
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

111d36d62787 xfs: lock dquot buffer before detaching dquot from b_li_list

1 new commit:

Darrick J. Wong (1):
      [111d36d62787] xfs: lock dquot buffer before detaching dquot from b_li_list

Code Diffstat:

 fs/xfs/xfs_dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

