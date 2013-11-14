Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C21047F37
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 10:18:17 -0600 (CST)
Message-ID: <5284F7D8.5030805@sgi.com>
Date: Thu, 14 Nov 2013 10:18:32 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/36 V5] xfsprogs: CRC write support for xfs_db +
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

This patchset has been committed.

Thanks
--Rich

commit 9b981421f503ba679097f8cd749af37cc42f5fd7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:41:00 2013 +0000

     repair: fix leaf node directory data check

commit 0cce4aa198f0470817bedb3781ea5b6955e43076
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:59 2013 +0000

     repair: Increase default repair parallelism on large filesystems

commit 61510437c627b529feb95ebffddd73df5ed5b104
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:58 2013 +0000

     repair: prefetching is turned off unnecessarily

commit ba3615fc784f03d9cb25fb7cc9240ea56b4b7a4b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:57 2013 +0000

     xfsprogs: kill experimental warnings for v5 filesystems

commit 7b5f9801f4d569ab9fdbdd1e39aa59585d296872
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:56 2013 +0000

     xfs: support larger inode clusters on v5 filesystems

commit 8ab75c4d9176d8831fd137cf0e7916032d8216da
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:55 2013 +0000

     db: enable metadump on CRC filesystems

commit 839dac7f06d54600b3092a7ad9cb903315a27f97
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:54 2013 +0000

     libxfs: work around do_div() not handling 32 bit numerators

commit ba9ecd40b3792961f12102af55c759d0432a6486
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:53 2013 +0000

     xfs_db: avoid libxfs buffer lookup warnings

commit 06d80a7c09287581002c275fd21cfecdbdefcc15
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:52 2013 +0000

     xfs_db: use inode cluster buffers for inode IO

commit d14bf4dda7f5a59ba3fbaed38cd829db5f68a105
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:51 2013 +0000

     db: re-enable write support for v5 filesystems.

commit 2847273f74b3b14ba3cb9ab876b910da12ed2dbe
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:50 2013 +0000

     db: add a special attribute buffer verifier

commit fc068a1902148eaaad7a7e5e9972155dd68a647c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:49 2013 +0000

     db: add a special directory buffer verifier

commit 66a40d020d7abb6fe09693f4392b6af2b30aa3b3
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Nov 13 06:40:48 2013 +0000

     db: verify and calculate dquot CRCs

commit a73b88f29a82a21ef6f50298d2d14ae1d91b321d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:47 2013 +0000

     db: verify and calculate inode CRCs

commit 0522f1cc3ab1638e18a636b6a8cf6db8b1d277f6
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:46 2013 +0000

     db: indicate if the CRC on a buffer is correct or not

commit 6fea8f830a6cc04d5429de31f40d15b94d0fe8da
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:45 2013 +0000

     db: introduce verifier support into set_cur

commit 72298d16b17776f7a57a5244776591653387846b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:44 2013 +0000

     db: rewrite IO engine to use libxfs

commit 800db1c1581d68cc3e44980b0be9c5ff7b7fd6d9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:43 2013 +0000

     libxfs: refactor libxfs_buf_read_map for xfs_db

commit 48e32b40a611384836e593251cbe9d840db00ac9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:42 2013 +0000

     db: rewrite bbmap to use xfs_buf_map

commit 2a8b3fdf37d30bd4e0bec834168dd4fd9d8b4f58
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:41 2013 +0000

     db: separate out straight buffer IO from map based IO.

commit 3a19fb7dce9d570e78deaf5c26c0ab8a4a5bef67
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Nov 13 06:40:40 2013 +0000

     libxfs: stop caching inode structures

commit 9aa5711629b47642bb5b688a6a1410d223456fc8
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:39 2013 +0000

     libxfs: fix root inode handling inconsistencies

commit 6aa3d87bc45348dc0948ae0cea57bf3033d64694
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:38 2013 +0000

commit c9522f4d8790ecd61c4e74746b607787485f2027
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:37 2013 +0000

     xfs: fix node forward in xfs_node_toosmall

commit 3e23516ae60421652fd41354307a6a5181d401eb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:36 2013 +0000

     xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()

commit 12864fd992dd5d6bc3c089aeb6422c8d235a28f0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:35 2013 +0000

     xfs: remove newlines from strings passed to __xfs_printk

commit e6d77a21f263ea403bef0940a524212e6fa03d04
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:34 2013 +0000

     libxfs: Minor cleanup and bug fix sync

commit f85fc6220f1c7fdb467a4d5b43e9bfbd2fb36c1d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:33 2013 +0000

     libxfs: bring across inode buffer readahead verifier changes

commit 2ceff9cee1f513ff633aa0d6997374da313c8c55
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:32 2013 +0000

     libxfs: xfs_rtalloc.c becomes xfs_rtbitmap.c

commit 9c6ebc42e2f1cf4b114c5cecbf373b8922959e69
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:31 2013 +0000

     libxfs: bmap btree owner swap support

commit 10851b189f50f357eab3ce787533e505babd00d2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:30 2013 +0000

     libxfs: unify xfs_btree.c with kernel code

commit 34b8c759723757e5b4a4c9da6c3a790eb405000f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:29 2013 +0000

     xfs: decouple inode and bmap btree header files

commit 32390f05a6a2c1a30b5f05141d705fb7c686079c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:28 2013 +0000

     xfs: split dquot buffer operations out

commit 4b1bcf9627153a77acbb2b0e6f0eb3d5b5102ceb
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Nov 13 06:40:27 2013 +0000

     xfs: create a shared header file for format-related information

commit 389b3b078ccc03da48d3cc0387fb5c5508e15d0f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:26 2013 +0000

     xfs: fix some minor sparse warnings

commit 270c31284f7d05557a31ef1304d582897bf4ffcc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:25 2013 +0000

     xfsprogs: fix automatic dependency generation

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
