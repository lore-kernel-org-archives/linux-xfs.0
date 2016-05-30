Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D87B87CD2
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 08:36:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C651304032
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 06:36:56 -0700 (PDT)
Received: from mail-pf0-f169.google.com (mail-pf0-f169.google.com
	[209.85.192.169]) by cuda.sgi.com with ESMTP id
	T33mMYQaIsBwhp1S (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 May 2016 06:35:55 -0700 (PDT)
Received: by mail-pf0-f169.google.com with SMTP id f144so52193672pfa.3
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 06:35:55 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v6 0/8] block: prepare for multipage bvecs
Date: Mon, 30 May 2016 21:34:28 +0800
Message-Id: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@canonical.com>, NeilBrown <neilb@suse.com>, Sagi Grimberg <sagig@mellanox.com>, Steven Whitehouse <swhiteho@redhat.com>, linux-block@vger.kernel.org, Joe Thornber <ejt@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>


Hi,

Interests[1] have been shown in multipage bvecs, so this patchset
try to prepare for the support and do two things:

1) the 1st 4 patches use bvec iterator to implement iterate_bvec(),
then we can drop the non-standard way for iterating bvec, which
can be thought as a good cleanup for lib/iov_iter.c

2) remove BIO_MAX_SECTORS and makre BIO_MAX_SIZE as obsolete, and
now there is only one user for each. Once multipage bvecs is introduced,
one bio may hold lots of sectors, and we should always use sort of
BIO_MAX_VECS which should be introduced in future and is similiar
with current BIO_MAX_PAGES.

The only functional change is iterate_bvec():lib/iov_iter.c

xfstests(-a auto) over loop aio is run for ext4/xfs to verify 
the change and no regression found with this patchset.

V6:
	- rebased on v4.7-rc1
	- add reviewed-by tag
	- mark BIO_MAX_SIZE as obsolete instead of removing because
	dm-tree adds one usage now

V5:
	- use bvec's iterator to figure new base vec address and
	update 'skip' correctly
	- run xfstests(-a auto) on loop aio/dio for verifying
	the change in iterate_bvec(), and no regression reported
	- use stree-ng to trigger heavy swap over swapfile to verify
	change in iterate_bvec() too, looks everything is fine
V4:
	- make xfstests cover xfs
	- rebase on for-next of block tree
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


Ming Lei (8):
  block: move bvec iterator into include/linux/bvec.h
  block: move two bvec structure into bvec.h
  block: mark 1st parameter of bvec_iter_advance as const
  iov_iter: use bvec iterator to implement iterate_bvec()
  fs: xfs: replace BIO_MAX_SECTORS with BIO_MAX_PAGES
  block: bio: remove BIO_MAX_SECTORS
  block: drbd: avoid to use BIO_MAX_SIZE
  block: mark BIO_MAX_SIZE as obsolete

 drivers/block/drbd/drbd_int.h |  4 +-
 fs/xfs/xfs_buf.c              |  4 +-
 include/linux/bio.h           | 58 ++++----------------------
 include/linux/blk_types.h     | 22 +---------
 include/linux/bvec.h          | 96 +++++++++++++++++++++++++++++++++++++++++++
 lib/iov_iter.c                | 45 +++++++-------------
 6 files changed, 122 insertions(+), 107 deletions(-)
 create mode 100644 include/linux/bvec.h

-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
