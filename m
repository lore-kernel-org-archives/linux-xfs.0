Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700568;
	b=bxgMyIP9WpsAknalwkUpWUsdU8nMXmLJ4KeA4AF1oFUpoa84DfF/K+MhyblhnVGM2fNx
	 durgmdGt5UnjOcUecC+Pacg1hMOb5SwxmBDX8xr1RLb/Jn20MGMl+GhfyikZs5VoV7Fnh
	 GFJDnFM2BRtvQCBSIi7UmEh97PVhqq9MUPcTJs/hNyCpr8O1wM2ke08xAjws0ET10lk+f
	 cgHI3fBdIcWLEM6oL3m4adBaX2WMRkf9f7VMFaVcLHIufh8Ag5yIq69DnLtZkpSCpdtS3
	 BdwBIVVS1NynqkGHei2/65XCiiTpOPOeyKNu8gl0k68+OuW8W7p8Lm1v+LsFzMau84Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700568;
	h=Received:DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=eAXDg7FHSWLsk46nlc1so4Du6jyg0OECLL/lFYpeT30=;
	b=C6l/+UztffqtN/+7R9irVOseTJcOmV7hLNP4q10ke2RkSVu+Pg2muUVz/g2Y8BIGRLxP
	 fOY2vmna3EsdOeyRnOzYKivTDl1HjXFre3W2X7Wl9SyW+2I88kMjROFzCakXG0DlK+cSP
	 2kmKC/MmxVwAxq2eweaaswZPhs7yTzerD4gBMMQ2DxUnfPzybUsMHQeB2++FM54D7/yIx
	 tA4Fp9OiOajflqC+EHmtVsNVUkLUWxN7e43mr07XeKbeEA4qvqRUA0ANiqfyucA75JI7S
	 LOCduNOt24IYSZ/J1UNCeJEIURPVpyUmIUCJNxIJ/Rz+CtWgPJfZ1vgxtFIeW0tSkRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkSNVeQH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62EB606FAF5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 10:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkSNVeQH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F84A1F000C1
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 10:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700567;
	bh=eAXDg7FHSWLsk46nlc1so4Du6jyg0OECLL/lFYpeT30=;
	h=Date:From:To:Subject;
	b=jkSNVeQH32qxe/c5cKFznVl5Eo8pYW36U2bKa4wTxOFBBs+N8BQ3mnhQYBbzvpTIu
	 P72RP311cNh6wYSpUmr+DHLqXHjuSFaLKz4kL7hveXhlp0LgHVo6bPMLLv7l7qpv5u
	 R7cLkxnhudaPjdre6wkS4sdi6K4WPuobHeTvvfkCDJlGoikcv5TpzlxwfVt+nxp7iT
	 ugctX5peS/Ik1Hl/YMT8ANTnyy53/gSg6wdI5rBRMyVBzE4Aa6EgxYvlyHCp1W+VqD
	 YIl76pFvViixf0E7uVJ4EMqMlbeDJzcZ7CTfjkzSEtnLZj4IwfoxoLWWqHC9HL2RKI
	 dYXAsrUWElEbw==
Date: Tue, 3 Nov 2026 11:09:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: Subject: [ANNOUNCE] xfs-linux: for-next is now 9dde020e1968
Message-ID: <aumw9Gazayh1SxZh@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi folks,

The xfs-linux/for-next branch has just been updated.

Patches often get missed, if your outstanding patches have been
reviewed, are not already merged in the mainline and are not
listed below, please give me a heads-up.

Yes, this is a new format for the announces I'm experimenting with,
expect it to change in the near future.
Giving how dynamic for-next has became, ISTM it would be more useful for
such announces to contain a list of patches staged for integration other
than the most recent patches pushed into for-next. Comments/suggestions
are welcome.

Follows the list of staged patches.

----- Fixes for v7.4 -----

Anthony Iliopoulos (1):
      [1e253beed534] xfs: skip iunlock with empty iolock flags in xfs_file_dio_write_aligned

Binbin Deng (1):
      [0344a9492efa] xfs: set healthmon mount cookie before publishing it

Daejun Park (2):
      [595e67d72616] xfs: don't skip free extents in later batches of a whole-AG FITRIM
      [5745f4f10a1a] xfs: don't skip free extents of the longest length in a whole-AG FITRIM

Jianyun Gao (1):
      [2bbca049deeb] xfs: fix temporary cursor leak in btree shift corruption paths

Ravi Singh (1):
      [bde0010631a2] xfs: mark i_mode=0 and shut down on attr fork inactivation failure

Wilfred Mallawa (1):
      [7e31d6dd3419] xfs: fix unwind handling during xfs_mount_sysfs_init()

----- Next Merge-Window (v7.5) -----

Adrián García Casado (1):
      [976d3cd5b0a3] xfs: add __printf attribute to xfs_buf_alert_ratelimited()

Daejun Park (9):
      [77d5d75d727a] xfs: mark the inode preallocated for pNFS write layouts past EOF
      [e0fbfbec7d5b] xfs: add a flag to convert unwritten extents without allocating blocks
      [faf5f20d6c00] xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
      [351fccff2881] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
      [cefa7c7b065d] xfs: cap the block count of xfs_iomap_write_direct() at one extent
      [e4211f8034ce] xfs: clamp the pNFS layout range to the maximum file size
      [d58a23e183d5] xfs: take the invalidate lock while mapping a pNFS layout
      [c92cc6514b9c] xfs: add datasync and log_flushed arguments to xfs_log_force_inode()
      [c3b00a553cbb] xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync does

Eric Sandeen (8):
      [20496da47af3] xfs: remove redundant stat checks after xfs_btree_insert()
      [e2293d89c56b] xfs: remove redundant stat checks after xfs_refcount_insert()
      [87f5edcd7190] xfs: remove redundant stat checks after xfs_inobt_insert_rec()
      [cfad3431d3ad] xfs: remove redundant stat check after rcbagbt_insert()
      [25b97ffb8111] xfs: remove status parameter from several btree insert functions
      [c71f58e4fde5] xfs: add stat check to xfs_btree_delete and remove caller checks
      [12be672e210c] xfs: remove redundant stat checks after xfs_refcount_delete()
      [01b68405c7f0] xfs: remove status parameter from two btree delete functions

Siddh Raman Pant (1):
      [13257daacb8f] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
