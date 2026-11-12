Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519991;
	b=2XYZ8SuufCZIT3iJWJkDCApakN16DewMNaper4poYoHLzF2mXeifPuAST2+eFBgTYS58
	 8LQdwgYyZEVTMEEPu/FrgTr/3DN1RYU5oks8S2guD6Mg6bxxUnyhopgN2igTR1uNmR46e
	 aINrdqL3MvBJlzgJjNq/+7EdgvmIBtkRIrqTHua0KSeXjt1NEvD8ZKOsDneD5ZOh1swTp
	 zD9YVHVECBCFJCAWtBD0mu/n1eIRFBP2XWUe3faKg+ZzsFRhk9HXsf30O3vwLrZ1qxwEt
	 OzHuRjO0mrpdoZj9fA1rTHzwVToXl7GzStHJSuzD9C0Du+jr/tXjsDbBAPfASNJotVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519991;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9M7tjtD0z2+HWzcxTNlE58HbSH+XbPuIDRBiX2N9YqM=;
	b=2w3rWKgHsMMX80qnoyFssRxE8FrMr79Bdv6oM0GeXKJg8b7Ohjd25pvetXZkqzJ8Ssl6
	 NrxFxlYakxjx/zODJi7HCRVFRfcqoJvUoYM/NnDg/+aVdlLOFVHXxfS2wCBAMCr3NlgWy
	 iAVJ6f7VKbHdVRBw0mfPFKf5vTbxGHSWG3eTL4gUn9MbMPVfmTh4LFmO1JUPJaLMlXe4U
	 hgkJZ7RTwMpSKmQW7e7SE0aaztcaNnH/6le3unGZDNfhioYlu9Z37UhsNYy06tU4DCmzt
	 nZS24s9/zICxg5l/k1pXWY0I4+wf1BBHuUkhC/FwO1oBINn8ML8fHiNl6w/w2lZigVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTqG09y7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9A2606A897;
	Thu, 12 Nov 2026 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTqG09y7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B7B1F000C4;
	Thu, 12 Nov 2026 21:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519990;
	bh=9M7tjtD0z2+HWzcxTNlE58HbSH+XbPuIDRBiX2N9YqM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=LTqG09y7aowQ7R91qxe/b3QTf2b6nmYp0X00QFH1qJU13d0QPGcXh0WR/5tMJ2CkE
	 5wblJFm/meeRMAPlH5OltQzdJibl3Xe9EilRT2nXeg16ezH4L23m1pJeGhysDBJ9xS
	 UeATPXn47/dwPNSGNEh7u2QsMqqKxlYSrePONU8ahK/oBIPrhR7hjn4CcTjIjbTl8P
	 KEaN9r72YK+N+ARMuGi0Tq7W5BBT3QcYYRF+GSk66PCpqJ+vs781Pf7fQzsnIK6/f/
	 +OjOX7B4hE94ICt0mLqg5RLWguvEEK1CROI23yY/JPslbIPHfVgegWSNhXPkuKSdUf
	 QvVCWBBSX+WiA==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v9 13/14] xfs: don't enable DAX on zoned inodes
Date: Thu, 12 Nov 2026 16:46:17 -0500
Message-ID: <20261112214604.67875-14-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A store through a shared mapping can dereference a NULL pointer if the
file is zoned and has S_DAX.

The zoned code does not support DAX, but XFS doesn't check for this:
with dax=always or FS_XFLAG_DAX, an inode gets S_DAX if its device does
DAX, and an internal zoned section on pmem does. The write fault then
takes the zoned path:

    xfs_filemap_fault()
      xfs_write_fault()
        xfs_write_fault_zoned()
          page_folio(vmf->page)     /* NULL in a DAX fault */

ftruncate() crashes in a similar way, in xfs_reflink_end_cow().

The fix used here is to never set S_DAX on a zoned inode, and to refuse
to change the realtime flag of an S_DAX inode on a zoned file system.

Zoned files now use the page cache with dax=always or FS_XFLAG_DAX. A
file whose realtime flag is cleared stays without DAX until its inode
is evicted.

Fixes: be458049ffe3 ("xfs: enable the zoned RT device feature")
Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v8->v9:
    - The commit log and the comments say that the zoned code does not
      support DAX, no longer that it cannot (Christoph Hellwig).
    - The commit log no longer says that ftruncate() only crashes on kernels
      without an earlier patch of the series. That patch has lost the test
      that stopped it.
    - Was 15/15.
    
    v7->v8:
    - New patch.

 fs/xfs/xfs_ioctl.c | 8 +++++---
 fs/xfs/xfs_iops.c  | 4 ++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index af13ad6784b7..49ba762ea969 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -564,11 +564,13 @@ xfs_ioctl_setattr_xflags(
 
 		/*
 		 * If S_DAX is enabled on this file, we can only switch the
-		 * device if both support fsdax.  We can't update S_DAX because
-		 * there might be other threads walking down the access paths.
+		 * device if both support fsdax, and the zoned code does not.
+		 * We can't update S_DAX because there might be other threads
+		 * walking down the access paths.
 		 */
 		if (IS_DAX(VFS_I(ip)) &&
-		    (mp->m_ddev_targp->bt_daxdev == NULL ||
+		    (xfs_has_zoned(mp) ||
+		     mp->m_ddev_targp->bt_daxdev == NULL ||
 		     (mp->m_rtdev_targp &&
 		      mp->m_rtdev_targp->bt_daxdev == NULL)))
 			return -EINVAL;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d307ec97fac8..a84a4c1c3fc2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1373,6 +1373,10 @@ xfs_inode_supports_dax(
 	if (mp->m_sb.sb_blocksize != PAGE_SIZE)
 		return false;
 
+	/* The zoned code does not support DAX. */
+	if (xfs_is_zoned_inode(ip))
+		return false;
+
 	/* Device has to support DAX too. */
 	return xfs_inode_buftarg(ip)->bt_daxdev != NULL;
 }
-- 
2.55.0

