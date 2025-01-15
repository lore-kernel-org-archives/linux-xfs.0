Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20A08BE7
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 06:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736922256; cv=none; b=XwmAk/MANDDkn/PDgqmvS9UgBduqUpjS0SxbGXCpoN/ZAtmZKrW7i4/+eFPzpWqln+3gtKZ+J4swkNMb+AlLNcv3XuZVsjKroxR7aqBZ2Pb1ODyOcK4TEBK6H4/27ALvHcXej7EzQiE+UgDIMff5aAH5/Af8xxnC/K50TaPYXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736922256; c=relaxed/simple;
	bh=RSCs2pxHs55T+5TLS5rocfcyU4RKb1OYil61Dh7FcdI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OBzqZ6u3ZvRvPA21BErdQU+dLpTh0TyUtLs+JsQvbfNHjI9NLBmlaeHT+YRKNBSNywkMM9u4pUt0el8G7PHiWD6WHmzaStp6gjbx0CfCP0obnziyUemavDzAOmr94gn6uteWJPCH8mmkgPui6oWIbku7zDCHQa6bu10ItlyfO0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fw3Qg8fQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fw3Qg8fQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC13C4CEDF
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 06:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736922255;
	bh=RSCs2pxHs55T+5TLS5rocfcyU4RKb1OYil61Dh7FcdI=;
	h=Date:From:To:Subject:From;
	b=Fw3Qg8fQrhkIzYWRclxszrsiKwUB9VY+dK7JpUM7siLShQFkStx1Xh8I+hKNma8c9
	 6Kfj8xwB+hzHIaPUjY6QsgqAa/LhI8Gta+j+9g4Pgxeu1Og/z4TDPvJzUyYgPHTo3O
	 5QPEpwsREIFM6Vh8WujZkYN6varnVWT9N7g0cNPhDN5BaMAnNVaSfhh5+J/dLFskQ1
	 gWlv60i7ISfzB1/Wb7pG+60vJnwHuChQFmJ6Q3nKnqS6Rj61vAnoNDxVbG+aLauyvz
	 fuKrdvyU0Op5+9R8U18fPZKTVHwB5BwAEv1ebrRRqa7uf0XdULhIg7LRIAk/8uxngL
	 3umOTuLT5ZzSA==
Date: Wed, 15 Jan 2025 07:24:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 4e35be63c4ad
Message-ID: <sg4xgobqg2lrc2ema5pqld3rayvm4in3pcypuqhus6viohy2n5@vd2wq735zu7r>
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

4e35be63c4ad xfs: add a b_iodone callback to struct xfs_buf

15 new commits:

Christoph Hellwig (15):
      [cbd6883ed866] xfs: fix a double completion for buffers on in-memory targets
      [83e9c69dcf18] xfs: remove the incorrect comment above xfs_buf_free_maps
      [411ff3f7386a] xfs: remove the incorrect comment about the b_pag field
      [05b5968f33a9] xfs: move xfs_buf_iowait out of (__)xfs_buf_submit
      [eb43b0b5cab8] xfs: simplify xfs_buf_delwri_pushbuf
      [72842dbc2b81] xfs: remove xfs_buf_delwri_submit_buffers
      [0195647abaac] xfs: move write verification out of _xfs_buf_ioapply
      [8db65d312b57] xfs: move in-memory buftarg handling out of _xfs_buf_ioapply
      [fac69ec8cd74] xfs: simplify buffer I/O submission
      [5c82a471c2b7] xfs: move invalidate_kernel_vmap_range to xfs_buf_ioend
      [6dca5abb3d10] xfs: remove the extra buffer reference in xfs_buf_submit
      [819f29cc7be6] xfs: always complete the buffer inline in xfs_buf_submit
      [46eba93d4f58] xfs: simplify xfsaild_resubmit_item
      [4f1aefd13e94] xfs: move b_li_list based retry handling to common code
      [4e35be63c4ad] xfs: add a b_iodone callback to struct xfs_buf

Code Diffstat:

 fs/xfs/xfs_buf.c        | 511 +++++++++++++++++-------------------------------
 fs/xfs/xfs_buf.h        |   9 +-
 fs/xfs/xfs_buf_item.h   |   5 -
 fs/xfs/xfs_dquot.c      |  14 +-
 fs/xfs/xfs_inode_item.c |  14 +-
 fs/xfs/xfs_trans_ail.c  |   9 +-
 fs/xfs/xfs_trans_buf.c  |   8 +-
 7 files changed, 194 insertions(+), 376 deletions(-)
