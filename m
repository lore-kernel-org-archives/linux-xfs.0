Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DDABA7F3F
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 16:55:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AEA1A304070
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 14:55:57 -0700 (PDT)
Received: from chinook.cae-engineering.hu (chinook.cae-engineering.hu
	[213.165.74.136]) by cuda.sgi.com with ESMTP id
	IP5Pdk5EzVlKNN48 for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 14:55:52 -0700 (PDT)
Date: Tue, 14 May 2013 23:55:50 +0200
From: Andras Korn <korn-xfs@elan.rulez.org>
Subject: wishlist: xfs_repair should detect files with too small sizes
Message-ID: <20130514215550.GK17260@hellgate>
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

Hi,

I have thousands of files on xfs whose inode claims their size is zero, but
they have blocks allocated to them; du(1) reports a nonzero size. xfs_repair
3.1.9 ignores this. xfs_db can be used to recover the contents of the files
(using commands like inode 1234; write core.size 4567).

David Chinner explained to me that xfs_repair ignores these files because
it's legitimate to have blocks beyond eof (e.g. due to fallocate()), and
that unwritten extent flagging doesn't help because such extents don't need
to be flagged as it's impossible to read them.

My zero-sized files were likely effected by a crash (certainly not
fallocate()).

I think it would be useful to have the ability to distinguish between files
that legitimately have extents beyond EOF and files whose inode incorrectly
reports a too-small size.

Maybe an allocated-size field could be added to the inode, or extents
assigned to files via fallocate() could be flagged somehow? And if files
with incorrect sizes (i.e. where allocated-size div blocksize < number_of_blocks
OR allocated-size < core.size OR where a file contains extents beyond EOF
that are not fallocate-flagged) are found, xfs_repair could at least report
them?

-- 
                     Andras Korn <korn at elan.rulez.org>
            WARNING: Do NOT look into laser with remaining eyeball.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
