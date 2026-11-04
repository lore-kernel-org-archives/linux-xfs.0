Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801463;
	b=TINlbjRaFO/3YlpTh47hDCmlpXWYnhG3KU65WVhdgYT29GPTuiIBK8m/7jYXtt2tzDiN
	 jVp8aQLHGj8zDpOoFUy1a+hQsVqDlSmLhzsvgA1i0Nml4supLEEU7EjXvjYlvJgxjOacC
	 XS5R5HQktoUmEKrbh+X/+zsr6RH0RbvPr9Ce/GoxH41zgsgxwPPX4vBGoshogw2xwW9Nl
	 9fAonv5aJFyTHvMGMw+kjz1RNgKwsdDnpIrZEUf+MtLQjawMHvIAPf983x8si9VWQ/fmc
	 wBSF2wgwp6FLcAOpmrgqfkoZ4VM6liP9ISvAAN9Gzh45soeoV3Nc/iWgqhpS3VSqVZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801463;
	h=Received:DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=8MIhXSWNxdGAVQ1nble9yA7VL27az03poCcY2Wff0Sk=;
	b=evo3o4mIz5wvlhU+ow+FHyJ2o8I72Mq0fXYDQy+YhcbALIPmdGqACbjug5VGmj4o58pR
	 RCBNWGaVasYGXP9fxJLG44RBEKOs3Tt+CRV/mqP6hw1s23gEcu/ePmvdRv1wBwuXc3fVE
	 uqGXyp5EGo78CYkFd0b7mSrIgWnWlJ1OZ2dLwGTjUBOnhyyoUFIESvwGTnbGVryLlKCRY
	 cP+FDlzKxSEgLuBCbxlPoarMhms1HxeWqvQLfcRepj+TMuDMedgXBDycsUOoi5YYZikef
	 6x+tNdmz9N72Fs5q2N+F16Smso9wlwHr83OXqSlP4Oas4J2uPDheVZWAru4FQKkNs9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ig4/hDkM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE14B606A31B
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ig4/hDkM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDFC1F00A02
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793801462;
	bh=8MIhXSWNxdGAVQ1nble9yA7VL27az03poCcY2Wff0Sk=;
	h=Date:From:To:Subject;
	b=ig4/hDkMR6u3nKtNYu1tNiQmh+1G0xPVhWKakQiObF1mWqvuuqMdLwxAxMvTuOwko
	 LSUacEl1aPJRaOabz57P23bQUpKw27H4I+q3iLFSzdAJ55njhFvf5lkgj3DDyZ5f3d
	 7rVJhOYwvBU1xkFUAQteDqFTibRmV5SkqsCI898Nte2iNlzrDxOZw2C32hZ/b+g0cZ
	 YSWzZojdBCol5Qib/UKE4muCP4h40Kpmi2Z5a/Cm9NOXHmCgcufLlc1v84DNf3wcpC
	 6y6BZfREktrxQbFbXuLyBHYbFEQcA4i5O5aDN6YJF/vOM2pGdK3KVFHaJeYuH2lOHf
	 2Ylckn2GR01Mg==
Date: Wed, 4 Nov 2026 15:10:59 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: Subject: [ANNOUNCE] xfs-linux: for-next is now 1e17fc56469d
Message-ID: <aus8olxsvTBXr-aW@nidhogg.toxiclabs.cc>
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

Follows the list of staged patches.

----- Fixes for v7.4 -----

Anthony Iliopoulos (1):
      [1e253beed534] xfs: skip iunlock with empty iolock flags in xfs_file_dio_write_aligned

Binbin Deng (1):
      [0344a9492efa] xfs: set healthmon mount cookie before publishing it

Christoph Hellwig (1):
      [30bb61651d2d] xfs: fix recovery of partial attr removals

Daejun Park (11):
      [595e67d72616] xfs: don't skip free extents in later batches of a whole-AG FITRIM
      [5745f4f10a1a] xfs: don't skip free extents of the longest length in a whole-AG FITRIM
      [8b8e26599155] xfs: mark the inode preallocated for pNFS write layouts past EOF
      [f3ca3498dfe6] xfs: add a flag to convert unwritten extents without allocating blocks
      [bcf0b7f18ad1] xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
      [d8c2bc88460f] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
      [66d1ce09ebd7] xfs: cap the block count of xfs_iomap_write_direct() at one extent
      [29f3c1be4e55] xfs: clamp the pNFS layout range to the maximum file size
      [23ba20ef280c] xfs: take the invalidate lock while mapping a pNFS layout
      [199eee7c677d] xfs: add datasync and log_flushed arguments to xfs_log_force_inode()
      [9cc3b0eda94d] xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync does

Jianyun Gao (1):
      [2bbca049deeb] xfs: fix temporary cursor leak in btree shift corruption paths

Kefeng Wang (1):
      [7ba9663607b3] xfs: kill xfs_trans_set/clear_context() helpers

Ravi Singh (1):
      [bde0010631a2] xfs: mark i_mode=0 and shut down on attr fork inactivation failure

Reid Downing (1):
      [b7eb276a39b1] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()

Wilfred Mallawa (1):
      [7e31d6dd3419] xfs: fix unwind handling during xfs_mount_sysfs_init()

----- Next Merge-Window (v7.5) -----

Adrián García Casado (1):
      [976d3cd5b0a3] xfs: add __printf attribute to xfs_buf_alert_ratelimited()

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
