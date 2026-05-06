Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502D83E3C44
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 09:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778059774; cv=none; b=DPPQEhCGyOnRylYsHpm6sJIdA/EsJ6MosNmnkDA02+WRpM2KxlipnAH5hUu1ZYOQNu961mkG30YnWlcCUN4ORdFtzR1mJGnSRdfeydEa5nJn0F2junG1ZeCFb/n+j4mOsZ5D8N4rmhLO4Q9ktMVpIyijzj6NT+lu2aDbhcNsLik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778059774; c=relaxed/simple;
	bh=14kTBzqRLefHiFkjLu2F7anJiN3Y0osnT90SK9BS4Jw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SSpyydgAPBwwOo9EHapijOcQ9re231UXe7It62GXPNf8S7IXIoIWZ4TVle7JuwruZqS2551PyLB+bG5NBoK/IFi/wYrpqQ6Lsljk7vjghef0TkAzfsOdSxnN5YdtG29pNSSkL20OZAVP5M+hrsZhBDDNa8+Cd7leQQbn3EHR/fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfZdAnUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfZdAnUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47A5C2BCB8;
	Wed,  6 May 2026 09:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778059774;
	bh=14kTBzqRLefHiFkjLu2F7anJiN3Y0osnT90SK9BS4Jw=;
	h=Date:From:To:Cc:Subject:From;
	b=TfZdAnUOTJlOGzNMkskLaaulmGYsNc7CRPD8ZbAuRWqOkLDXkoJ6Fff9lGTrYEd6x
	 Mtd9BukOBLDcGB8JNQkkANGUjjLeyo0r6cR2fbEP19dFuSwALtS4DrlpVgJgXrHmgF
	 Nw4DxbLb6bzZ5gmW8snoNBi+zs+fAzwRgl7G8y9ZzAlypms8JqgmplZ3hZ5hwzmjaO
	 zdGsOuI3m5ZAX2TJBd/qVtFmHsvAoSeKhy+U2AhkjFiWoL078/zkTdZDM06J5sX4dc
	 vX3LMu4uLg3FeH6FlOjLcvU+cMzwgI0BBtbIgNKg+A5e1nXhg2yLuWLP8MpfGga19O
	 sgoLNN//uD2Tg==
Date: Wed, 6 May 2026 11:29:29 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org, 
	gedalya@gedalya.net, hch@lst.de, leo.lilong@huawei.com, linux-xfs@vger.kernel.org, 
	morbo@google.com, patrick.fischer@siedl.net
Subject: [ANNOUNCE] xfsprogs: for-next updated to 5f5d7fe4a7ef
Message-ID: <m7mxkvemekchswcoy42adzf6zt7zdaazmgllortupd5p2fsal6@jx5epriqap4f>
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

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

5f5d7fe4a7efbcdb7d046a09b739e78ffa468fdf

New commits:

Bill Wendling (1):
      [df91bc3bdc9b] xfs: annotate struct xfs_attr_list_context with __counted_by_ptr

Darrick J. Wong (2):
      [1c52b36e3234] xfs_scrub_all: fix deadlock if lsblk produces a lot of output
      [5f5d7fe4a7ef] xfs_scrub: drop the warning about mixed bidirectional codepoints in names

Long Li (2):
      [e7aab724c89a] xfs: factor out xfs_attr3_node_entry_remove
      [922f14a9b776] xfs: factor out xfs_attr3_leaf_init

Code Diffstat:

 include/platform_defs.h   |  3 +++
 libxfs/xfs_attr.h         |  3 ++-
 libxfs/xfs_attr_leaf.c    | 22 ++++++++++++++++++++
 libxfs/xfs_attr_leaf.h    |  3 +++
 libxfs/xfs_da_btree.c     | 53 +++++++++++++++++++++++++++++++++++++----------
 libxfs/xfs_da_btree.h     |  2 ++
 scrub/unicrash.c          | 29 +++++---------------------
 scrub/xfs_scrub_all.py.in | 13 ++++++------
 8 files changed, 86 insertions(+), 42 deletions(-)

-- 
- Andrey
