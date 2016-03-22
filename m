Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 883577CA0
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 01:12:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CFF28F8040
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:43 -0700 (PDT)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
	[209.85.192.196]) by cuda.sgi.com with ESMTP id
	wvrh8hEbc0gCqYBn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:41 -0700 (PDT)
Received: by mail-pf0-f196.google.com with SMTP id u190so34029349pfb.2
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:41 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 0/8] block: prepare for multipage bvecs
Date: Tue, 22 Mar 2016 14:12:21 +0800
Message-Id: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
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
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

Hi,

Interests[1] have been shown in multipage bvecs, so this patchset
try to prepare for the support and do two things:

1) the 1st 4 patches use bvec iterator to implement iterate_bvec(),
then we can drop the non-standard way for iterating bvec

2) remove BIO_MAX_SECTORS & BIO_MAX_SIZE, and now there is only
one user for each. Once multipage bvecs is introduced, one bio
may hold lots of sectors, and we should always use sort of BIO_MAX_VECS
which should be introduced in future and is similiar with current
BIO_MAX_PAGES.

xfstests(-a auto) have been run and no regression found by this
patchset against linus v4.5+.

 drivers/block/drbd/drbd_int.h |  4 +--
 fs/xfs/xfs_buf.c              |  2 +-
 include/linux/bio.h           | 55 +------------------------------
 include/linux/blk_types.h     |  4 +--
 include/linux/bvec_iter.h     | 77 +++++++++++++++++++++++++++++++++++++++++++
 lib/iov_iter.c                | 31 +++++++----------
 6 files changed, 94 insertions(+), 79 deletions(-)


[1], http://marc.info/?w=2&r=1&s=++[LSF%2FMM+ATTEND]+block%3A+multipage+bvecs&q=t


Thanks,
Ming

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
