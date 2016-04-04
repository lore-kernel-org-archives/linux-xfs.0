Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D7597CA0
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2016 01:56:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5FCA6304032
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 23:56:45 -0700 (PDT)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
	[209.85.220.41]) by cuda.sgi.com with ESMTP id 34BuJrDD2ADLCcR8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Apr 2016 23:56:43 -0700 (PDT)
Received: by mail-pa0-f41.google.com with SMTP id zm5so137948501pac.0
	for <xfs@oss.sgi.com>; Sun, 03 Apr 2016 23:56:43 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 0/8] block: prepare for multipage bvecs
Date: Mon,  4 Apr 2016 14:56:26 +0800
Message-Id: <1459752994-2205-1-git-send-email-ming.lei@canonical.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

Hi,

Interests[1] have been shown in multipage bvecs, so this patchset
try to prepare for the support and do two things:

1) the 1st 4 patches use bvec iterator to implement iterate_bvec(),
then we can drop the non-standard way for iterating bvec, which
can be thought as a good cleanup for lib/iov_iter.c

2) remove BIO_MAX_SECTORS & BIO_MAX_SIZE, and now there is only
one user for each. Once multipage bvecs is introduced, one bio
may hold lots of sectors, and we should always use sort of BIO_MAX_VECS
which should be introduced in future and is similiar with current
BIO_MAX_PAGES.

xfstests(-a auto) have been run and no regression found by this
patchset against linus v4.6-rc1-next-20160329.

V3:
	- include kenrel.h & bug.h in bvec.h for fix comiling failure on arm
	as reported by 0day ktest
	- build test on arm & arm64

V2:
	- rename bvec_iter.h as bvec.h
	- always include bvec.h into blk_types.h as suggested by Christoph

V1:
	- don't move BIO_MAX_* to bvec_iter.h as pointed out by Christoph
	- run xfstests against v4.6-rc1-next-20160329
	- add Reviewed-by
	- for 1,4 and 5, Reviewd-by not added, Christoph still expressed
	'this looks fine to me.'

 drivers/block/drbd/drbd_int.h |  4 +-
 fs/xfs/xfs_buf.c              |  4 +-
 include/linux/bio.h           | 52 -----------------------
 include/linux/blk_types.h     | 22 +---------
 include/linux/bvec.h          | 96 +++++++++++++++++++++++++++++++++++++++++++
 lib/iov_iter.c                | 30 +++++---------
 6 files changed, 110 insertions(+), 98 deletions(-)


Thanks,
Ming


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
