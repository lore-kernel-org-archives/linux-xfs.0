Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6giwn067046 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:42:44 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wVQOD0TbXmbHdLVA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:44:50 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6inVu002778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:44:49 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6imng003866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:44:49 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6imKL010451 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:44:48 -0600
Message-ID: <50A5E0D7.6030500@oracle.com>
Date: Fri, 16 Nov 2012 14:44:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 00/15] xfs: shrinking support
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
To: xfs@oss.sgi.com

Hello,

These days I have tried to implement shrinkfs feature according to Dave's previous design which can
be found at:
http://www.xfs.org/index.php/Shrinking_Support

Here is a very initial patch set, it only support shrinking up to the latest empty AG since
I have not add the data moving and extents swap functions to the user tools.

I know the current patches definitely looks stupid and there have many places need to fix.
I'd like to post it eaiser to seek any directions so that I can continue to improve it, especially
on inode swap semantics, AG metadata removing as well as the command interface.

- xfs_reno(8) 
The following two links are referred to a couple of untested patches of inode swapping for xfs_reno(8).
http://marc.info/?l=linux-xfs&m=119552278931942&w=2
http://marc.info/?l=linux-xfs&m=119582841808985&w=2

The user patch does extents swapping after swapping inodes, I was confused because xfs_reno only do
modify the inodes from 64bits to 32bits, inodes swap should be sufficient to perform it since it
don't need to move the data extents(i.e. perform extents/blocks allocation for target files like
xfs_fsr/xfs_shrinkfs).

- AG metadata clean up
For now, I only wipe the pre-allocated sectors/blocks out of an empty AG, I guess I missed something
for btree info updates.

- xfs_shrinkfs CLI
I observed Dave has posted a patch to fetch the FS freespace via FIEMAP, but for now, I have to get the FS freespace
via shell script(wrapper of xfs_db).
And also, I didn't add the data moving functions because there still has issues on inode swap routine, it would
failed to swap directories :(, so it can only be used to reflect my current stupid ideas.

Last but not the least, I have not add the placeholder for log area shrink as well as compat_ioctl32 functions since
this version can only be considered at input comments stage.


Any suggestions are appreciated!

Thanks,
-Jeff


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
