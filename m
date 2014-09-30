Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3E338016
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 20:46:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BBDB5304066
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 18:46:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	uQf1QTxmoglZK2ik for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 18:46:23 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: cleanup XFS_IOC_SETXATTR behaviour
Date: Tue, 30 Sep 2014 11:46:03 +1000
Message-Id: <1412041565-18873-1-git-send-email-david@fromorbit.com>
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
Cc: iusty@k1024.org

Hi folks,

A while back Iustin Pop sent a patch to fix a problem with being
unable to set extent size hint values on directories. That patch -
along with new xfstests functionality to always check the scratch
device after a test - has pointed out that we allow certain
directory only inode flags to be set on other types of inodes (e.g.
regular files). It also pointed out that we could set extent size
hints on inodes that don't have extent size hint flags set.

This patchset does not attempt to fix the original problem, not add
any new validation of what is passed from userspace. Instead, it
simply ensures that what we end up with on disk is valid. That is,
directory only flags are only set on directory inodes, and extent
size hints are set if the inode flags are set, otherwise it is
cleared.  Hence we don't end up with "invalid" state on disk, and so
xfstests doesn't get upset with directory only flags being set on
non directory inodes.

Further followups will be needed to address the original issue of
changing extent size hints on directories and handling invalid
flag/value combinations from userspace. I have not attempted to
solve that problem here because it could have impact on userspace
application behaviour and that's a different issue to ensuring we
end up with valid inode state on disk.

Thoughts, comments, flames?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
