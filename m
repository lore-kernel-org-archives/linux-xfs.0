Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 178F47F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 11:11:52 -0500 (CDT)
Received: from eagdhcp-232-136.americas.sgi.com
	(eagdhcp-232-136.americas.sgi.com [128.162.232.136])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F75DAC006
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 09:11:48 -0700 (PDT)
Received: from eagdhcp-232-136.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-136.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r56GBn5n002456
	for <xfs@oss.sgi.com>; Thu, 6 Jun 2013 11:11:49 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20130606161032.753011157@sgi.com>
Date: Thu, 06 Jun 2013 11:10:32 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/1] xfs: xfs_inactive fails to cleanup symlinks with
	attributes
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
To: xfs@oss.sgi.com

Found this bug testing extended attributes.

# make a big symbolic link that is in the inode core and mostly fills it.
# CRC enabled filesystem will use a 68 byte smaller link in the test.

ln -s 1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/0123456/a a

# the extended attribute will bump the symbolic link to a remote extent
# I think only one of these attribute is needed, but they are so fun...
attr  -Rs 1234567890ad a < /dev/null
attr  -Rs 1234567890ae a < /dev/null
attr  -Rs 1234567890af a < /dev/null

# the following remove will assert a debug kernel:
#  XFS: Assertion failed: ip->i_d.di_nextents == 0, file: fs/xfs/xfs_inode.c, line: 2036

rm a


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
