Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795657555;
	b=lAI3kf8HbfYOsji5zLIXXuzEAzuF/P21Hi8JDpzeJnjadDXnsDc503Xbtag738CAnSQt
	 p53cTbmWoKiKJkWKKZjvzWJzyJERJsmdvZosqBqPwVEozvoBysR8EoujfONMAR05+zYxk
	 MPBoKTauPTdoeGq6PvqEfU1f3QUA9eTPokmED9THcCQQdt4YErN7gV37EK/pbxRzkXbEG
	 M8rOz74Z/S+5d5aYT8xMwfRTdEW8EdyZi0+bOPyX+wo7SOJ4D+e8G9pfEJJPNMXQzKnGT
	 bc005D8MhAVGrMO8QIdOpMsNpQAT6drW91Pct360UrgstDx1vjmtditKxPS85qFDNfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657555;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=2vRcQUH4j6DCmTq6IZOsqNTflV8D2q9QUJ6I2py+lz8=;
	b=pOzTuk5eMViISmSffoixH/ZIOBKJ8oZ2gDscamwgoV1otLwMLEtIx4AOuBb8ClOQ1AWw
	 /UPP617pYQ+WfHt/a7P9eCkjH2RdneVqtFGl6ZBQ5oLa0B+vSE9O5SuigWXo/Amlj9al7
	 g19AF4Dar/oYVwWxFv95WGXgFA+C5EqFLZcpMWVv8nSUdT5+CFq2IAEmma2yeHiXBvSwK
	 qdQO/OUOSa8Voy9WAffp+jcOuCKXP2EhP1LYO9xPyjY7OAPpkzgHg/EEkx3WLQsa2t9dQ
	 CwE0bNw3n44U5TVVXpTBvnIjv47r7c6Kf8E5ooaf9Hu4TTKP7WyEa9PharD9eo9PFQg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDEI7KIb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9EE606A31E;
	Thu, 26 Nov 2026 01:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDEI7KIb
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795657554;
	b=TwQaCLiMfrdsaiAKSXQmQxBH9yAMymKzAKhV2fNaS9N0zLpEaaw6LzdBvxjQcgu4HNR2
	 uWhK5OTwK4ItCgzBvwX+jJc7ySnkibmShmY0knvgy8DPq4dywdOIv5askF1j8+VPRabWB
	 robhpz2Fg+7lWYnDJ/TVq49pslj2T6YsRp0EVYFkVOuTJMTUGgJp8e0OawqXrPSTeDZrN
	 /LxLrLAWr/+sNE1ujbzRu6BLUw/QUdaVTOHu4uo81P66QZIfdD3YNYZtlRjLVMRvBPqEU
	 22Id1SID1IH8X9O66Hpc0PHYMy+6011q5tWI9Znpeqz55AlN5iOZcp4hxeTk2kVWnUQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795657554;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=2vRcQUH4j6DCmTq6IZOsqNTflV8D2q9QUJ6I2py+lz8=;
	b=hB7JftuHfMmg7PfqKtTqbm2QhPI8BmlpXW1g0t1ZI7Rv8u1O3vTu+sNj84rzLBER/eap
	 SP95pa51bkpEBSviKsmjICKRDh2/+FC8qjqdAZp8mQUP438lzos5y4E/C7RgDnAZJ/aZM
	 kIi9pLhmJfXtDx4CypdAmQSrq/TA17sjb2bfaJa2c8KoIRmafGm1r56RUXzgRhKM2Od/w
	 mN7omrG1OJ1qmjHKkBcdQyTpxEjSdRoUC4LQ1+VPVC9dfo6fE13gRKKxqLD1MeM3jU1GH
	 JDXUSsNCMvD5s861PTXMNZ9gnf7O4Oyx++3cZwHi26y4ANui2MBp6yy33FPe1H95h4g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A88F71F000C4;
	Thu, 26 Nov 2026 01:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795657554;
	bh=2vRcQUH4j6DCmTq6IZOsqNTflV8D2q9QUJ6I2py+lz8=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=YDEI7KIbc7tAihOLz6JPpxV8P6q5z+vEdLg89HLqxOmUm+SqYQQKZJn1ezcgrITn0
	 0sTgtPiLjlWPgN0qRlHmqORaUPW527Fd4KA+3aS921y4ijPkUy8bsLXOmEeSHKB/ko
	 2LCIhxfCUSa2LyBnxaZJifBlRBTeSCz+8Jxy4nqUyCDzgbkCYlJyuL7ZGTJsbUGCTo
	 OpLi+Q5igEk3GV7Nr7u2Jytu/pG2if3TA/6fygs/ltFVB950sNfI06s/sCbAHkO7CG
	 /NRMOieshRwyyMW91AojbD0Wkf5Nk13iuK5AZ6UOmRN82RDr+Zr7EJ7+rQUhbnsMuM
	 Tt5EJS6g6Ewxg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3864F4D130;
	Thu, 26 Nov 2026 01:45:47 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 26 Nov 2026 10:45:47 +0900
Subject: [PATCH] xfs: punch delalloc blocks past EOF before mapping a pNFS
 layout
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
Message-Id: <20261126-xfs-pnfs-delalloc-eof-v1-1-509deb79a255@samsung.com>
X-B4-Tracking: v=1; b=H4sIAEqPB2sC/x2MywqAIBAAfyX23EIaGfQr0cHHWguioRCB+O9Jl
 4E5zFQolJkKbEOFTA8XTrGLGAewl44nIbvuICephJAKX1/wjh2Ogg4hWaTkcV3MLNWkyRoLvb0
 zeX7/73609gHZHh15ZwAAAA==
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795657546; l=2347;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=V363AEekfhVNmNgFRwTSiV54vNvZ++lzcBIxwNKpDXM=;
 b=QfPaSk/iTM48NWJBRh6hlUOsMSA7R7UxCc8uUT+wcBjKEdN/6+kBRYDn5lz2DaJurf7YbBVY6
 0Rr+HhvA0+RBKhDcl7dLR0L0elHdE2IOn9l4rs4OZDH7AByGXEsCbco
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Writeback on fragmented free space can leave speculative
preallocation past EOF as delalloc. A LAYOUTGET over it BUG()s on
XFS_DEBUG kernels. Other kernels warn in nfsd and refuse the layout.
A LAYOUTCOMMIT past it moves EOF over it. Inode reclaim then asserts.

Punch it after the flush. Delalloc past EOF holds no data.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested with pynfs on XFS_DEBUG, with free space fragmented as in
xfs/538 and the bmap_alloc_minlen_extent error tag set. LAYOUTGETs over
the 512 KiB left delalloc no longer assert. Neither does eviction after
a LAYOUTCOMMIT past it. The pynfs block tests and fstests over pNFS
show no change (BLOCK3, generic/075, 112 and 127 fail either way).

xfs_bmap_punch_delalloc_range() takes the same arguments in the 6.18.y
and 7.3.y stable trees. Older trees need them adjusted (5.10.y and
5.15.y take a start block and a length).
---
 fs/xfs/xfs_pnfs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 945f7a3e11c..4a6c1a399d7 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -11,6 +11,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_iomap.h"
 #include "xfs_pnfs.h"
 #include <linux/exportfs_block.h>
@@ -192,6 +193,18 @@ xfs_fs_map_blocks(
 	if (WARN_ON_ONCE(error))
 		goto out_unlock;
 
+	/*
+	 * Writeback stops allocating a delalloc extent once the page it writes
+	 * is covered, so speculative preallocation past EOF can stay delalloc.
+	 * Delalloc past EOF never holds data. Punch all of it, as
+	 * xfs_free_eofblocks() does for preallocated files, so that a layout
+	 * never maps it and a LAYOUTCOMMIT never moves EOF over it.
+	 */
+	if (ip->i_delayed_blks)
+		xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
+				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
+				LLONG_MAX, NULL);
+
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 

---
base-commit: 5e7b6fe39324913f6416c854c6ed3a1793aaba8e
change-id: 20261126-xfs-pnfs-delalloc-eof-75b3260aecbc

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


