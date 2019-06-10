Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56991 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfFJESc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 00:18:32 -0400
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/2] block: fix page leak by merging to same page
Date: Mon, 10 Jun 2019 12:18:17 +0800
Message-Id: <20190610041819.11575-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>

Hi,

'pages' retrived by __bio_iov_iter_get_pages() may point to same page,
and finally they can be merged to the same page in bio_add_page(), then
page leak can be caused because bio_release_pages() only drops the page
ref once.

Fixes this issue by dropping the extra page ref.

V2:
	- V1 breaks multi-page merge, and fix it and only put the page ref
	if the added page is really the 'same page' 


Ming Lei (2):
  block: introduce 'enum bvec_merge_flags' for __bio_try_merge_page
  block: fix page leak in case of merging to same page

 block/bio.c         | 32 ++++++++++++++++++++++----------
 fs/iomap.c          |  3 ++-
 fs/xfs/xfs_aops.c   |  3 ++-
 include/linux/bio.h |  9 ++++++++-
 4 files changed, 34 insertions(+), 13 deletions(-)

Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
-- 
2.20.1
