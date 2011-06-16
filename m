Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GEnN1R039880
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 09:49:24 -0500
Received: from mx3.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51BA4171D121
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 07:49:21 -0700 (PDT)
Received: from mx3.twosigma.com (mx3.twosigma.com [208.77.213.34]) by
	cuda.sgi.com with ESMTP id NZHj5FhsAjftxHRk for
	<linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 07:49:21 -0700 (PDT)
Received: from msxaoa3.twosigma.com (nfw1-1-dmz.twosigma.com [208.77.213.62])
	by mx3.twosigma.com (Postfix) with ESMTP id D2A3F66709
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 14:49:15 +0000 (UTC)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Thu, 16 Jun 2011 10:49:14 -0400
Subject: sparse file handling bug in XFS
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B561F@MSXAOA6.twosigma.com>
Content-Language: en-US
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>
Cc: Martin Bligh <Martin.Bligh@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>, Ian Baum <Ian.Baum@twosigma.com>, Stephen Degler <Stephen.Degler@twosigma.com>

Sparse files do not stay sparse.
Here's the simplest test case I've got so far.  I don't think it can get much simpler than this.

This did not exist in 2.6.36.  It appeared by 2.6.38-rc8.  It continued into 2.6.38.2.  It continues to exist on 3.0.0-rc3.

# for x in gogo xfs; do date | dd of=sparse-file bs=1k seek=4096; stat sparse-file; done
0+1 records in
0+1 records out
29 bytes (29 B) copied, 0.00151976 s, 19.1 kB/s
  File: `sparse-file'
  Size: 4194333                   Blocks: 8          IO Block: 4096   regular file
Device: 6809h/26633d    Inode: 12153368    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-06-14 13:56:43.826251881 +0000
Modify: 2011-06-14 13:56:43.826251881 +0000
Change: 2011-06-14 13:56:43.826251881 +0000
0+1 records in
0+1 records out
29 bytes (29 B) copied, 0.00152104 s, 19.1 kB/s
  File: `sparse-file'
  Size: 4194333                   Blocks: 8192       IO Block: 4096   regular file
Device: 6809h/26633d    Inode: 12153368    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-06-14 13:56:43.826251881 +0000
Modify: 2011-06-14 13:56:43.834252062 +0000
Change: 2011-06-14 13:56:43.834252062 +0000


For more fun, it even happens if we explicitly remove the file in between!  (It looks like this is just because the recently freed inode is reused and not properly initialized.)

FILE=sparse-file-99; for x in gogo xfs; do rm -f $FILE; date | dd of=$FILE bs=1k seek=4096; stat $FILE; done
0+1 records in
0+1 records out
29 bytes (29 B) copied, 0.00151841 s, 19.1 kB/s
  File: `sparse-file-99'
  Size: 4194333                   Blocks: 8          IO Block: 4096   regular file
Device: 6809h/26633d    Inode: 12153371    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-06-14 14:03:37.933888145 +0000
Modify: 2011-06-14 14:03:37.937888543 +0000
Change: 2011-06-14 14:03:37.937888543 +0000
0+1 records in
0+1 records out
29 bytes (29 B) copied, 2.1681e-05 s, 1.3 MB/s
  File: `sparse-file-99'
  Size: 4194333                   Blocks: 8192       IO Block: 4096   regular file
Device: 6809h/26633d    Inode: 12153371    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-06-14 14:03:37.941888722 +0000
Modify: 2011-06-14 14:03:37.941888722 +0000
Change: 2011-06-14 14:03:37.941888722 +0000


Here is a run on ext3.  Notice how blocks stays at 16.
# for x in gogo xfs; do date | dd of=sparse-file bs=1k seek=4096; stat sparse-file; done
0+1 records in
0+1 records out
29 bytes (29 B) copied, 0.00603038 s, 4.8 kB/s
  File: `sparse-file'
  Size: 4194333   	Blocks: 16         IO Block: 4096   regular file
Device: 6805h/26629d	Inode: 24          Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-06-16 14:48:32.480750867 +0000
Modify: 2011-06-16 14:48:32.480750867 +0000
Change: 2011-06-16 14:48:32.480750867 +0000
0+1 records in
0+1 records out
29 bytes (29 B) copied, 0.00125449 s, 23.1 kB/s
  File: `sparse-file'
  Size: 4194333   	Blocks: 16         IO Block: 4096   regular file
Device: 6805h/26629d	Inode: 24          Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-06-16 14:48:32.480750867 +0000
Modify: 2011-06-16 14:48:32.492751347 +0000
Change: 2011-06-16 14:48:32.492751347 +0000

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
