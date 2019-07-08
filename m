Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37247 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404695AbfGHVfR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jul 2019 17:35:17 -0400
Date: Mon, 8 Jul 2019 23:35:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: memory leaks from xfs_rw_bdev()
Message-ID: <20190708213515.GB18177@lst.de>
References: <1562616489.8510.15.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562616489.8510.15.camel@lca.pw>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qian Cai <cai@lca.pw>
Cc: hch@lst.de, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

We actually have a discussion on that in another thread, but if you
can easily reproduce the issue, can you test the patch below?

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 757c1d9293eb..e2148f2d5d6b 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -43,7 +43,7 @@ xfs_rw_bdev(
 			bio_copy_dev(bio, prev);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
 			bio->bi_opf = prev->bi_opf;
-			bio_chain(bio, prev);
+			bio_chain(prev, bio);
 
 			submit_bio(prev);
 		}
