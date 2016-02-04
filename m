Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CE8E29DF5
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:15:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF21E8F8049
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 15:15:24 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8CS3xpUYjyFsWA22 for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 15:15:21 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2 v2] xfs_quota: allow operation on ext4 for project quotas
Date: Fri,  5 Feb 2016 10:15:16 +1100
Message-Id: <1454627718-19583-1-git-send-email-david@fromorbit.com>
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
Cc: fstests@vger.kernel.org

Hi folks,

This is a followup to the patch I posted here:

http://oss.sgi.com/archives/xfs/2016-01/msg00450.html

The first patch is changed to address Eric's comments about how the
report command should not change - I introduced a "-f" command line
flag to ensure that foreign filesystems are only available whenteh
-f flag is present.

The second patch is to address the build issue that occurs from the
newly promoted definitions defining the struct fsxattr and having
xfs_fs.h define it a second time. We have to still support builds on
systems that don't have the new VFS ioctl definitions, so it
triggers the definitions of the structure and flags based on whether
the VFS definition has been included or not already.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
