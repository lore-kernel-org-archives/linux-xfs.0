Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 352167F6C
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 08:32:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 244D3304053
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 06:32:33 -0800 (PST)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id gFfsX2IEZh5a5iTK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2015 06:32:32 -0800 (PST)
Received: by mail-pa0-f44.google.com with SMTP id rd3so25883819pab.3
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 06:32:31 -0800 (PST)
Received: from dhruv-MacBookAir ([14.97.202.7])
	by mx.google.com with ESMTPSA id nj8sm4934684pdb.42.2015.01.28.06.32.29
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Wed, 28 Jan 2015 06:32:30 -0800 (PST)
Message-ID: <54c8f2fe.e87f460a.137c.ffffc28b@mx.google.com>
From: Dhruvesh Rathore <adrscube@gmail.com>
Date: Wed, 28 Jan 2015 20:02:24 +0530
Subject: [PATCH 0/4] xfs: xfs_spaceman utility rework
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


The original kernel patch that Dave wrote for xfs_spaceman implemented
FS_IOC_FIEMAPFS ioctl, here is the original fiemap extension patch:

http://oss.sgi.com/archives/xfs/2012-10/msg00363.html

These patches were not posted and were just forward ported to a current 
3.18-rc7+ for-next XFS tree and were pushed to the fiemapfs branch in Dave's
kernel tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git


The original xfs_spaceman tool that Dave wrote to call the fiemap
interface and make use of it is here:

http://oss.sgi.com/archives/xfs/2012-10/msg00366.html

Dave just updated it to the 3.2.2 code base and pushed it to the
spaceman branch in this tree:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

The description of patches in this series are as follows:

1) [PATCH 1/4] xfs: Accounting for AGFL blocks in xfs_spaceman
	This patch adds functionality in xfs_spaceman allowing it to
	account for AG Free List blocks. The previous version of
	xfs_spaceman failed to account for AGFL blocks as they 
	aren't found by walking the free space btrees, so we have to
	walk each AGFL to find them. A new function 
	xfs_alloc_agfl_freespace_map() is added which will walk the free
	extents in AGFL and account for these AGFL blocks by using 
	agf_flfirst, agf_fllast and agf_flcount fields.


2) [PATCH 2/4] xfsprogs: Addition in debug option -d of xfs_spaceman
	This patch allows adding a title for the contents which are
	printed when xfs_spaceman is run with -d debug option from command
	line. The titles added are agno, agbno and len.


3) [PATCH 3/4] xfs: Adding XFS_IOC_FIEMAPFS ioctl for use in xfs_spaceman
	This patch is concerned with the changes made in kernel space code
	for adding a new XFS specific ioctl XFS_IOC_FIEMAPFS in xfs_spaceman.
	This ioctl will replace a file based ioctl FS_IOC_FIEMAPFS, and allow
	us to modify the ioctl as per requirement in the future.


4) [PATCH 4/4] xfprogs: Adding XFS_IOC_FIEMAPFS ioctl for use inxfs_spaceman
	This patch is concerened with the changes made in user space code
	for using XFS_IOC_FIEMAPFS ioctl in xfs_spaceman, which will replace
	FS_IOC_FIEMAPFS and make use of fiemap plumbing.

Comments, thoughts etc are welcome.

Regards,
A-DRS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
