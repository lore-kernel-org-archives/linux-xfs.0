Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795657951;
	b=KSU6Bz2x/uX0d8HxtZPL7qWoeI0ZeyNmsk8sdiiNiSpgl4uevo6CyIy0wdYqG0MAf5lk
	 ocT8EYs1xnnJXLdn7HOyvt7TiOtO/Xmp/gFtm038+7iV7B0O36LKv0V99nGc4Db86lvRx
	 /UFm2WdaQ56azddmcEnK3y2eoUoThcvEfrHG/EKKh0rtX5As5taNEeEoMmVoPeQPgcLeS
	 FXHAfUla7uZ1TY7CO2MFCN9sr7RkTJwSlVrVcTWZihq9USW0Yt2pFqSjfahibJFNvKoJG
	 tpwnRRwihpovkU6gE50o9Pkr1nIdRKttWz5W8Caa9NG4pG4VjSdPT18I7/1DbXUsUvQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657951;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=BYrIjamICZ6Y7Hb8ow5GXwmCuZ59CdnDiz69auQltyc=;
	b=C+YLp1gPRqPufo9/EBmkMyamn0k4eCEec8gtwQiDXaUEsbGHTVsF9xH4tF2Pf+kci7PL
	 1ag8sluFDnYJngL/SUAsM8HVjQw6mukKNbK3696FrBwsnp+nNFl/LNFBPUu/wL6EbyrwY
	 W8t+aILCEMAQXsOTIKaIqcRXNvZM0SO9A/A7y2aaa00PWseDNsThATLjlzlrDpWyMi8GX
	 mTMz+Mi+bL+ep+jBKA2nZVfVDm//4iRi4oSGLN17QaVf3xnKQLpV3TCDpksAFIOhAv+iW
	 kAEOx7otr3WGhTS73V4vx7PDQ5W9uQNUMqnmsxdW+eHg8wVV5n887wa8M2xtzVznSPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YWhdxqap;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C132606A31E;
	Thu, 26 Nov 2026 01:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YWhdxqap
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795657950;
	b=Qs7O2LQcCSQEABRwfcWBwiJ7ME6Zi9dZJIapvBJqfUYKueYRa8f0MqstT5kRBKWID+fE
	 +LSkNYldmCC90xHFGUjqz9O7BFDfKH+j1SxLMfl29FNh+cPFzwgQFnKWb+5jbNeNHOCe8
	 oryWO4J+PG75We5jlCHW4ULV2XaOBNz1D5fBKjrmhnZBAKCMANKqc4wNNPRQrNCNmFfNG
	 qydSkSJUTdzgMCkgniRsD7SQoF93lE9fkCjbzHdMOM6o2uzDAlLFBvudn4POTseR7dV7P
	 QoW0jeizdhIFxSV13guHAM2S/4+UhuCk7rGO1aGynxS+7dcuodkR6DpgGNPWM0W++3Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795657950;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=BYrIjamICZ6Y7Hb8ow5GXwmCuZ59CdnDiz69auQltyc=;
	b=alXtimJy3pSUowUnlMMOB5J6RPereH0QFvXdc1qhS1KCk4tbvH/mgR6QjKRwDn9aAeGQ
	 UDNcm+BkiQNw9etkTA++IIrO306ZyMQdNC8JvWBQAmXkKklk7zE/k35CxfFjuxnV1zHMs
	 AEbEUyvwX94QPDNlsPBGBUh13m9I7eFxpOeKVcbFO0KmNd+WPzBVXi4iQbrGfvFTXG7jX
	 unuT+KX3Y4Tko8car+GqVF1Yh4IUGdxYFhdZ94yM94c+b5kNjgPcWc4wjGgZqCTqys8QU
	 Cv/NY16mrxcVHG7agJHB7cAI3D1JhpkuxB7I202pZSlAy9Lmyp96T6bT0+q9vsf+9kw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AFD7C1F000CA;
	Thu, 26 Nov 2026 01:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795657950;
	bh=BYrIjamICZ6Y7Hb8ow5GXwmCuZ59CdnDiz69auQltyc=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=YWhdxqap+QFEfp7sQFfS3N7ZLRUR8G75uf9wQTpp3c6Hr8msWkWv+4DoRbqEVONAc
	 3uIRu75oEObhokjU44XwqGtoO/P6jo6wdlOknwCCArNj9NqCBxcoEb+RsMopAsM3kY
	 Fm2N6Wie6AyrRFn2pXe062R1vzK5MoUSAdmrFNZntwoz38ArPotWB0UABe3EmjDwGJ
	 N3eYEjPqaAbyM/rMjvJcc1fL6/w/vQOgg/FNSo2lt2S1dXLAXANF2MbZSzWxIvPSB/
	 CRYHHNfZUr8vaGQxnZrsWwDYvBqjZX0hwXe3xGW9OQ+XmOIu/u4Soy9eCiBAQqwjq6
	 TjtjKFVG2oKsA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0EE824D174;
	Thu, 26 Nov 2026 01:52:25 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH v2 0/2] exportfs, xfs, nfsd: map a whole pNFS block layout
 in one ->map_blocks call
Date: Thu, 26 Nov 2026 10:52:24 +0900
Message-Id: <20261126-xfs-nfsd-map-blocks-v2-0-6d85b1388739@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANiQB2sC/32NTQ6CMBSEr0Le2mfaBqpx5T0Ii/4BjbYlfUowp
 He3cgCX32Tmmx3IZe8Ibs0O2a2efIoVxKkBM6s4OfS2MggmJGfsittIGEeyGNSC+pnMg7DlF9t
 pqZRrBdTlkt3ot8PaD5VnT6+UP8fJyn/pf9/KkWEnWe0Ya4yWd1KB3nE6mxRgKKV8AbAM9Le4A
 AAA
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
 Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Christian Brauner <brauner@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795657944; l=1642;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=CHe9NdNoNWMN3OZLg6eYv1P0qljzfmwefVyC+JLRYlU=;
 b=Z1FcxTUa6ywlKOAf0WRvfAHZbKqu+vWqFtZRcueStNEhUsXV3vakq9dGoNWDBwzG/KlU8r7Q7
 seKi7tbjqBQCux9qLbNB9S3rpkBy3JzalZsPbA2BSFwjjDr8yGL9zQL
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

nfsd gets a pNFS block layout from XFS with one ->map_blocks call per
extent. Patch 2 lets one call return all of them, as Christoph and
Darrick suggested, and patch 1 prepares XFS for it. fstests and pynfs
give the same results with and without the series.

The series needs four fixes. The first two are posted separately, and
the other two are in nfsd-testing:

- nfsd: stop a block layout at the maximum file size
- xfs: punch delalloc blocks past EOF before mapping a pNFS layout
- nfsd: do not return overlapping extents in a block layout
- nfsd: do not allocate blocks for an RW layout with a minlength of zero

Once they are in mainline, I will rebase the series for the VFS tree,
as Chuck suggested.

Changes in v2:
- Drop v1 patches 1-3 and 6, now in mainline (2 in another form).
- Fold the interface, the XFS loop and the nfsd caller into one patch.
- Allocate the mapping array with kvmalloc (Chuck).
- Keep nfsd's trim of a mapping that starts below the offset, instead
  of refusing it.

---
Daejun Park (2):
      xfs: factor the mapping of one pNFS extent out of xfs_fs_map_blocks()
      exportfs, xfs, nfsd: map a whole pNFS block layout in one ->map_blocks call

 fs/nfsd/blocklayout.c          | 137 ++++++++++++++++++----------------
 fs/xfs/xfs_pnfs.c              | 163 +++++++++++++++++++++++++----------------
 include/linux/exportfs_block.h |  17 +++--
 3 files changed, 187 insertions(+), 130 deletions(-)
---
base-commit: 25527067098f9d95562244fd64749ebaae3077f9
change-id: 20261008-xfs-nfsd-map-blocks-417d5b6aae42

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


