Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10C847F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 14:06:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4587304062
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 12:06:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TnQVTcmXNJudiuCY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 12:06:40 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id D819D8CF40
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 19:06:39 +0000 (UTC)
Received: from rage.redhat.com (unused [10.10.50.192] (may be forged))
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7QJ6brm013519
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 15:06:38 -0400
Date: Wed, 26 Aug 2015 15:06:36 -0400
From: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] xfs: return errors from partial I/O failures to files
Message-ID: <20150826190636.GA16540@rage.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

There is an issue with xfs's error reporting in some cases of I/O partially
failing and partially succeeding. Calls like fsync() can report success even
though not all I/O was successful.

The issue can occur when there are multiple bio per xfs_ioend struct.
Each call to xfs_end_bio() for a bio completing will write a value to
ioend->io_error.  If a successful bio completes after any failed bio, no
error is reported do to it writing 0 over the error code set by any failed bio.
The I/O error information is now lost and when the ioend is completed
only success is reported back up the filesystem stack.

xfs_end_bio() should only set ioend->io_error in the case of BIO_UPTODATE
being clear.  ioend->io_error is initialized to 0 at allocation so only needs
to be updated by any failed bio structs. This ensures an error can be reported
to the application.

Signed-off-by: David Jeffery <djeffery@redhat.com>
---


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3859f5e..b82b128 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -356,7 +356,8 @@ xfs_end_bio(
 {
 	xfs_ioend_t		*ioend = bio->bi_private;
 
-	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
+	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		ioend->io_error = error;
 
 	/* Toss bio and pass work off to an xfsdatad thread */
 	bio->bi_private = NULL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
