Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F7E97CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 06:04:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6006030404E
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 04:04:34 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JM7lIGFUKHce9SjX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 04:04:31 -0800 (PST)
Date: Mon, 16 Nov 2015 04:04:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: clone ioctl return values
Message-ID: <20151116120431.GA2860@infradead.org>
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
To: darrick.wong@oracle.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Hi Darrick,

your new generic/157 xfs test brings up an interesting issue:  error
returns forthe various clone failure cases.  It seems like this case
was written fo the XFS case which differs a lot from the error chosen
by btrfs and mostly followed by NFS.  I'd say it might be a better idea
to follow the btrfs example as the btrfs ioctls have been in use for
a while.  The only shortcoming I see in btrfs is that id doesn't
explicitly check for non-directory, non-regular file items as the
source.  I have to admit I'm kinda surprised that it doesn't blow up,
given that NFS instantly did when I removed those checks.

FYI, output from the test on btrfs below:


--- tests/generic/157.out	2015-11-14 07:56:31.000000000 +0000
+++ /root/xfstests/results//generic/157.out.bad	2015-11-16 11:58:52.879078894 +0000
@@ -2,24 +2,24 @@
 Format and mount
 Create the original files
 Try cross-device reflink
-XFS_IOC_CLONE_RANGE: Invalid cross-device link
+reflink: Invalid cross-device link
 Try unaligned reflink
-XFS_IOC_CLONE_RANGE: Invalid argument
+reflink: Invalid argument
 Try overlapping reflink
-XFS_IOC_CLONE_RANGE: Invalid argument
+reflink: Invalid argument
 Try reflink past EOF
-XFS_IOC_CLONE_RANGE: Invalid argument
+reflink: Invalid argument
 Try to reflink a dir
-XFS_IOC_CLONE_RANGE: Is a directory
+reflink: Is a directory
 Try to reflink a device
-XFS_IOC_CLONE_RANGE: Invalid argument
+/mnt/test/test-157/dev1: No such device or address
 Try to reflink to a dir
-/mnt/test-157/dir1: Is a directory
+/mnt/test/test-157/dir1: Is a directory
 Try to reflink to a device
-XFS_IOC_CLONE_RANGE: Operation not supported
+/mnt/test/test-157/dev1: No such device or address
 Try to reflink to a fifo
-XFS_IOC_CLONE_RANGE: Operation not supported
+reflink: Inappropriate ioctl for device
 Try to reflink an append-only file
-XFS_IOC_CLONE_RANGE: Bad file descriptor
+reflink: Invalid argument
 Reflink two files
 Check scratch fs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
