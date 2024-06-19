Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45291442F1;
	Wed, 19 Jun 2024 13:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802541; cv=none; b=uBsvA0PdVVvaxvHXLXEINTJHhOYLOVkMdqhYzPYLcjBrUQrCfFclkH+cifd3UYelEctumNeNzRUpIRxaJiCDaY0X6z5Ao09Qw3co+bKItjN+F3NV8efyLl9Tz91FDm9q92bRdGrt5OECPv8ZrQ+6bmGDhqhc72qfI6Te1UhuUzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802541; c=relaxed/simple;
	bh=b+tBdHVMoCRTjSldnw0N0JUddTvynjYAFxce9CcgIiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+FBWv1vyp+OZ/ZkR4VwlH/ZswtmLHXixW4HzR5cE13yTlUrXgwxSmqaaAZ0EuGnyZ02CKdQVPFwuPQ9ywN7CINZAkLi1mFVuQYDTByeS3MnHM2vnLHbSOEXxsRbII6UBKnHVhfdj+1hC5W0bUle9K47ghj49g7s88XFW5nphS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGE0wogK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGE0wogK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58D0C2BBFC;
	Wed, 19 Jun 2024 13:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802541;
	bh=b+tBdHVMoCRTjSldnw0N0JUddTvynjYAFxce9CcgIiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGE0wogK/py2C1LkT0TY0dSJjuJa6pYGyGa+5ARJzllJ5w4wB7dCV4MU52pYmZmJT
	 KJGjcAvLhw5TLy1jD+OqXBte6Az9yW03KHkFxY3BeZ97kPUGbX2nYIS+3YB07yC46S
	 DJlaV/meYJByzgRRlS8xXSsBxLJRhhAy8zlHi6+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 232/267] xfs: fix SEEK_HOLE/DATA for regions with active COW extents
Date: Wed, 19 Jun 2024 14:56:23 +0200
Message-ID: <20240619125615.229835689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 4b2f459d86252619448455013f581836c8b1b7da upstream.

A data corruption problem was reported by CoreOS image builders
when using reflink based disk image copies and then converting
them to qcow2 images. The converted images failed the conversion
verification step, and it was isolated down to the fact that
qemu-img uses SEEK_HOLE/SEEK_DATA to find the data it is supposed to
copy.

The reproducer allowed me to isolate the issue down to a region of
the file that had overlapping data and COW fork extents, and the
problem was that the COW fork extent was being reported in it's
entirity by xfs_seek_iomap_begin() and so skipping over the real
data fork extents in that range.

This was somewhat hidden by the fact that 'xfs_bmap -vvp' reported
all the extents correctly, and reading the file completely (i.e. not
using seek to skip holes) would map the file correctly and all the
correct data extents are read. Hence the problem is isolated to just
the xfs_seek_iomap_begin() implementation.

Instrumentation with trace_printk made the problem obvious: we are
passing the wrong length to xfs_trim_extent() in
xfs_seek_iomap_begin(). We are passing the end_fsb, not the
maximum length of the extent we want to trim the map too. Hence the
COW extent map never gets trimmed to the start of the next data fork
extent, and so the seek code treats the entire COW fork extent as
unwritten and skips entirely over the data fork extents in that
range.

Link: https://github.com/coreos/coreos-assembler/issues/3728
Fixes: 60271ab79d40 ("xfs: fix SEEK_DATA for speculative COW fork preallocation")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1323,7 +1323,7 @@ xfs_seek_iomap_begin(
 	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
 		if (data_fsb < cow_fsb + cmap.br_blockcount)
 			end_fsb = min(end_fsb, data_fsb);
-		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
+		xfs_trim_extent(&cmap, offset_fsb, end_fsb - offset_fsb);
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
 				IOMAP_F_SHARED, seq);
@@ -1348,7 +1348,7 @@ xfs_seek_iomap_begin(
 	imap.br_state = XFS_EXT_NORM;
 done:
 	seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_trim_extent(&imap, offset_fsb, end_fsb);
+	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 out_unlock:
 	xfs_iunlock(ip, lockmode);


