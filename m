Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A6AF7F5F
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 21:16:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 491CB8F8054
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 19:16:54 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id x4hinpP9D7VvJYY5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 19:16:52 -0700 (PDT)
Date: Wed, 2 Sep 2015 12:16:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the block tree with the xfs tree
Message-ID: <20150902121649.7a686b6c@canb.auug.org.au>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jens Axboe <axboe@kernel.dk>, Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: David Jeffery <djeffery@redhat.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi Jens,

Today's linux-next merge of the block tree got a conflict in:

  fs/xfs/xfs_aops.c

between commit:

  c9eb256eda44 ("xfs: return errors from partial I/O failures to files")

from the xfs tree and commit:

  4246a0b63bd8 ("block: add a bi_error field to struct bio")

from the block tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/xfs_aops.c
index c8637073ef25,c77499bcbd7a..000000000000
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@@ -354,8 -355,7 +353,8 @@@ xfs_end_bio
  {
  	xfs_ioend_t		*ioend = bio->bi_private;
  
- 	if (!ioend->io_error && !test_bit(BIO_UPTODATE, &bio->bi_flags))
- 		ioend->io_error = error;
 -	ioend->io_error = bio->bi_error;
++	if (!ioend->io_error)
++		ioend->io_error = bio->bi_error;
  
  	/* Toss bio and pass work off to an xfsdatad thread */
  	bio->bi_private = NULL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
