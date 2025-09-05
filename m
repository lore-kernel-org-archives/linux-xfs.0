Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F8315D2F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 19:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757098972; cv=none; b=NmdTWA3qjz1YvwKGULTTCHXUpwIMHsM3+rFLgbbtYdr7Ni0jc3hA3TKaMw/BdWctld0gPV4j+plS2tlXEZQ0P98Rj97DgS5CBahJGZ3uknV4vfopdzBWoAbEpNXMrsIyKhabmi3eP/FS5nQh83u+YlVERgVRpfpxwve61neT1cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757098972; c=relaxed/simple;
	bh=2u7x47aPkuagqOtkUFKr6SPD+L5Yjo6AJGrCdajEzo8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Fq9KW+bf39F70/43m/LnmCX9NUtsohzyruYnZE0yxlARt+blnp/Gr//+e634Nyr6JoGzX3B2VBtqy4RZ1PSidW+fbZGhnlO6lVALcUfdxiwcRzRdTZ4ag0NH1lxOefFBjggeoxWbGjhu4kAwYWMK5P+PdGbfkBrg/zdP0Eb/S44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uKqTAXg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uKqTAXg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078BCC4CEF1
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 19:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757098971;
	bh=2u7x47aPkuagqOtkUFKr6SPD+L5Yjo6AJGrCdajEzo8=;
	h=Date:From:To:Subject:From;
	b=uKqTAXg/WRJsN47n4Qc1rzd6uVCRhH32LsiWw88M1SR7FOaeqfUCbhtg4y+rTP9AD
	 wcoMDBm7ia7j7NJRlp6KcaNXmxn05mUZ4yepV5NdrlmVPufDyuRSOjqfBpyhg+qGdW
	 +caYre3oOXi+Z8T0OeJjrV8VDay4/WjFUc1Wy5lH4vNM2CcauA+/FKM9fAr6cV8whR
	 /8/NFvwZ5TLtev2E4/YAVzQZSmfvMVcyyIqgWJ3HCQnxYtBoG3RgwhAOfeIlViJB/E
	 qLqxWmKItluvX/54GggpdE9J4KFvf73jlfD3hYpNx52kq4Dc74cE1S1j0UwkMyYdG6
	 Yg+PXdrDDBbhg==
Date: Fri, 5 Sep 2025 21:02:47 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e90dcba0a350
Message-ID: <tlssviszjkgyji4fdobpjzzlh47so5xaxalzhbz7sdbjjuwwfc@m553xai7qqtq>
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

e90dcba0a350 Merge tag 'kconfig-2025-changes_2025-09-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.18-merge

15 new commits:

Carlos Maiolino (2):
      [482c57805c72] Merge tag 'fix-scrub-reap-calculations_2025-09-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.18-merge
      [e90dcba0a350] Merge tag 'kconfig-2025-changes_2025-09-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.18-merge

Darrick J. Wong (13):
      [cd32a0c0dcdf] xfs: use deferred intent items for reaping crosslinked blocks
      [82e374405e85] xfs: prepare reaping code for dynamic limits
      [ef930cc371f0] xfs: convert the ifork reap code to use xreap_state
      [b2311ec6778f] xfs: compute per-AG extent reap limits dynamically
      [442bc127d460] xfs: compute data device CoW staging extent reap limits dynamically
      [74fc66ee17fc] xfs: compute realtime device CoW staging extent reap limits dynamically
      [e4c7eece7676] xfs: compute file mapping reap limits dynamically
      [f69260511c69] xfs: disable deprecated features by default in Kconfig
      [b9a176e54162] xfs: remove deprecated mount options
      [d5b157e088c9] xfs: remove static reap limits from repair.h
      [21d59d00221e] xfs: remove deprecated sysctl knobs
      [07c34f8cef69] xfs: use deferred reaping for data device cow extents
      [0ff51a1fd786] xfs: enable online fsck by default in Kconfig
