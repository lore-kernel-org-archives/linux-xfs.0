Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7172B285050
	for <linux-xfs@vger.kernel.org>; Mon, 30 Jun 2025 12:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751286877; cv=none; b=hPcO/EvAxjgAkX+Z9jmtonNyH9F6AJ5QhFwikF+toAxQtXILdIozGQh/l0y6nZydel58QpF+u78umm/ixHjq4Gs/DpzRTiyBU1tbuL+oP+5U4I7kEOle9HbmwYMx5a4OOpoXAipKVJDVEAbGQWRWRFsDB5NH21VmfAmh70Y49Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751286877; c=relaxed/simple;
	bh=X6s7+RLvc6LVZ3XNy4aEPtfSfwpKfM/tDbqIgj5QZNM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=crdQRynWJ87z96Yk05bgzECsMjWwbK5JU62dAPn9ddb1H55Kkg2en6b+AEBq0p1YRc3c6IUdrjPeWzHKVhm/XGUeGtlUIFLohpM4cIAIZJdtw10IKr7dpymwtxj5pxLwDIIoJRBCDoOKxFZhDkCwCxVlBA2gCOKwArqxi18uo+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlACbKA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlACbKA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521F7C4CEE3
	for <linux-xfs@vger.kernel.org>; Mon, 30 Jun 2025 12:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751286876;
	bh=X6s7+RLvc6LVZ3XNy4aEPtfSfwpKfM/tDbqIgj5QZNM=;
	h=Date:From:To:Subject:From;
	b=JlACbKA4+Iz7IevfiQCEZg7JzBZJTCfwOpMi54K7wK1u5HRnn79CimqqEIeiMUP91
	 dPGT2HT13Yu3uJAjukox+X7gwe8DhXzSDx1LwZdcmJ5iUPATG5pXfhAmk8AFRBoBuH
	 q98ZSME93CDMGzx/evaTr0nZO3wyVMr/zevxCN/uLK2nUOFH72uj++2czDcCY4tYO2
	 AN8syzZ8b/UTsjGaor8M60dsoDvDh7XX852/eZ8/IExWXp3riacPYAyLeOVvbZeC/I
	 ToNek3zKXQ0VTJjvY1xesWmP+/Thoi1d7zsdL5b3TSwn9ZzeKiXVHlMxHeYDPLcQpB
	 jY53Bd/9KFbOQ==
Date: Mon, 30 Jun 2025 14:34:28 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 481e99aa7221
Message-ID: <5kxt576lywgyeju2anobh3scl6qy2glbphz4yjweykud6kdl3c@r4x4jgbcnmsm>
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

481e99aa7221 Merge branch 'xfs-6.16-fixes' into for-next

2 new commits:

Carlos Maiolino (1):
      [481e99aa7221] Merge branch 'xfs-6.16-fixes' into for-next

Youling Tang (1):
      [9e9b46672b1d] xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags mask

Code Diffstat:

 fs/xfs/xfs_file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
