Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A822DA76C
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291182; cv=none; b=QvzjgdzQf7aNTzoMVszTWdcUtJkL+4vSZlGp1Zzny3RiiexpcZJYh6BzTLClnA0AcXmJBsEzOKFPnjcXIfR3vLnARlHmeULFgz/aRf0GjRT+r5dc6SOMHV2K4Pd4H4cl09QXPATrnQJTPRWOm3WILq0xOK8gwIS8NFPdiPB6kww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291182; c=relaxed/simple;
	bh=b3wgw2/ER5H/zK4P+Y0G3i1rPo2LzKu9oGGNxzHXxjU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NyhsOuwfphS3jG+84lcJAGaN7dq89m1jpkL8nCfa7JtiURNPz/j87DW2SBfFR2UmVd4AK/EQKDTR35qr8t8Si8E6ofp9iGZuiivh5mx0SZIKxH0FwN/Mc6O0K5qmberKX5ASwoOcvihAJk8Pz6UQJxta2EHrF5rUFyUREf5YFOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjehUHgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjehUHgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6181C4CEF7;
	Mon, 23 Mar 2026 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291181;
	bh=b3wgw2/ER5H/zK4P+Y0G3i1rPo2LzKu9oGGNxzHXxjU=;
	h=Date:From:To:Cc:Subject:From;
	b=LjehUHgV0obRyNEwPIg44LxbN4sypiwboizMKuAbYU0WNPBV3z1kid+cCUJR0aR4A
	 s2irAwxRF0jyBQmfCyhh7CesD5emuWxeIHNbiq0d+exPlmCoXQzZg0rrxLT16+A7JC
	 AUoxgbiZIiB4nt9KBUagWgvypHFxFfxHMJRI+EWLoyTu1wYy1SgPGq+fSEneMaXCUg
	 AHM6we/pLa/m5KzTvuqnqMKQ2p4v5AcYrdGSpoPFvCN5rLR7SNUN/EmAZE4n473tTY
	 s1/xmRuPZ9a+TkPLtyraGGtgAUVKa0zVjAboiVS9StjYUpQK1euBILnBi/Ews78Z9U
	 kPWsfL/U5lGlA==
Date: Mon, 23 Mar 2026 11:39:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: [PATCHBOMB] xfsprogs: rollup of libxfs-7.0-sync patches
Message-ID: <20260323183941.GJ6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

Now that xfsprogs 6.19 has been released, here's a rollup of a couple of
pending bugfixes, a pre-cleanup of the kmalloc API wrappers from the
kernel, and all the libxfs ports patches, with new review tags.

Unreviewed patches:

[PATCHSET 2/2] xfsprogs: new libxfs code from kernel 7.0
  [PATCH 01/38] libxfs: fix XFS_STATS_DEC
  [PATCH 02/38] libxfs: port various kernel apis from 7.0

--D
