Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445377;
	b=AnDpF7JLqOojYY7EKv/ho8+z7fswP7pBviZ78Yi8yBlli/r/rkMktB9Dwe2V6NhMCG/p
	 7zKH0pA+E9NMswlyhpnt6E9OmuxHLa89O27ocrXznR3RZ8xdKCehDrLuiCU5U98BbeSrN
	 WyTh5w5ATAKz0YEE8LYmyLHYAFScv97dbnD3TO2D9OcS1edMUWu+BCrP27sm9pJ0kFh9v
	 MCdg68tljNG73q6D12fn5OiYd+pWjdBGDGIKEhnQrqG2cnzJUO3vz8fPgCnfu+ntNgIBo
	 pVWMF/j+Jp2tIKB46TFWj6qd0lG4zQ15MzG49O40BIDeWrU6Pp90Nu+iJRcjEJinmgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445377;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7/w+AZxd+IIQx3RNgcyzCGCQQXUUF7P9lbhXcrnaHvQ=;
	b=BjDVgapirXawejtdF6O5DWac76oGPaGlLoGh0C/2fDQHtytT1qsLetvyD5go/O6xKRhL
	 ykMZvDtbVD8Kwxhm2XxQPn7Kg1rIyCZJtHuMb7g0b0Cq68rdrAQhDje0BBLjbn68k0wds
	 2LccMRHUKr3sDE7ensQW9PzR4mkOHWJYt8MDUfLhgD+L+eVKik0lpBtnQzXZ6s5x6k00D
	 MjgQG2TMiFd0rnVlRGOIgDOXuGa5wLsJyjE9611ZGYj+JUOk9V9LTtSS/bItRRAbHwcoK
	 0VeH11xSKEpQ7W95JOQvcPCGY2F+rp56n/50rnE4ReybwQZBGC2dAfoOhkQM2/b+/kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ACS8rQHo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB89960A3819;
	Thu, 12 Nov 2026 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ACS8rQHo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1781F00A08;
	Thu, 12 Nov 2026 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445377;
	bh=7/w+AZxd+IIQx3RNgcyzCGCQQXUUF7P9lbhXcrnaHvQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ACS8rQHocmLddM1txIpJRQ0Ql1J5779HEeEVQLwvSHjqwzDUeFijqV446ohb5cITo
	 i+ommKAkiBj5+Xy2WxOqWPPbRaz8JTyUznjnpJ2Br/slrhkj5UuqnDmV+bi1d/izM7
	 7yzBRPbd1MThsxsvi0THhxF+hRdf8agk09KUwjiFse2k9K2XLBiHVDG6glw/+v63XR
	 SmdFZdvqW+9+wjbD+v4OhN8SvOOGofIVyqoAmxd6U+8k2etAU4sp0pOG5n6sRNPGpp
	 wevkdgiZ3gexD4VG2lSqojlTGmMwWVeHvyDjuJMKHAJ6XrxLf4GiWpW2nwfCdtsPkk
	 Ln6DIy8etiNAQ==
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
Subject: [PATCH v8 15/15] xfs: don't enable DAX on zoned inodes
Date: Wed, 11 Nov 2026 20:02:44 -0500
Message-ID: <20261112010229.51029-16-mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
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

DAX writes in place, and zoned inodes are only written out of place, so
the two can't work together. XFS doesn't check for this: with dax=always
or FS_XFLAG_DAX, an inode gets S_DAX if its device does DAX, and an
internal zoned section on pmem does. The write fault then takes the
zoned path:

    xfs_filemap_fault()
      xfs_write_fault()
        xfs_write_fault_zoned()
          page_folio(vmf->page)     /* NULL in a DAX fault */

ftruncate() crashes in a similar way, in xfs_reflink_end_cow(), on
kernels without "xfs: restart faults racing with realtime flag changes".

The fix used here is to never set S_DAX on a zoned inode, and to refuse
to change the realtime flag of an S_DAX inode on a zoned file system.

Zoned files now use the page cache with dax=always or FS_XFLAG_DAX. A
file whose realtime flag is cleared stays without DAX until its inode
is evicted.

Fixes: be458049ffe3 ("xfs: enable the zoned RT device feature")
Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v7->v8:
    - New patch.

 fs/xfs/xfs_ioctl.c | 8 +++++---
 fs/xfs/xfs_iops.c  | 4 ++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f81b6e52ac40..8f042610db03 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -564,11 +564,13 @@ xfs_ioctl_setattr_xflags(
 
 		/*
 		 * If S_DAX is enabled on this file, we can only switch the
-		 * device if both support fsdax.  We can't update S_DAX because
-		 * there might be other threads walking down the access paths.
+		 * device if both support fsdax, and zoned inodes never do.  We
+		 * can't update S_DAX because there might be other threads
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
index d307ec97fac8..03ca1873b6d7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1373,6 +1373,10 @@ xfs_inode_supports_dax(
 	if (mp->m_sb.sb_blocksize != PAGE_SIZE)
 		return false;
 
+	/* Zoned inodes are always written out of place, DAX writes in place. */
+	if (xfs_is_zoned_inode(ip))
+		return false;
+
 	/* Device has to support DAX too. */
 	return xfs_inode_buftarg(ip)->bt_daxdev != NULL;
 }
-- 
2.55.0

