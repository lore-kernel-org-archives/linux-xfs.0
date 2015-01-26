Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2BF318012
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 08:34:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07A51304032
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 06:34:42 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id pBZgKbLdI4UUVxif (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 06:34:41 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 00/16 v4] quota: Unify VFS and XFS quota interfaces
Date: Mon, 26 Jan 2015 15:34:17 +0100
Message-Id: <1422282873-3381-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

  Hello,

  this is another iteration of patches to unify VFS and XFS quota interfaces so
that XFS quotactls work for filesystems with VFS quotas and vice versa.  This
is useful so that userspace doesn't have to care that much about which
filesystem it is using at least when using basic quota functionality. In
particular we should be able to reuse project quota tests in xfstests for ext4.

The patches are based on top of 'for_next' branch of my tree [1] which already
contains quota cleanup series [2] and XFS cleanup series [3] I've sent
previously. The patch series can also be pulled from 'quota_interface' branch
of my tree.

Since the previous version I have addressed all Christoph's comments (dropped
patch for Q_XQUOTASYNC quotactl, moved some code around) and also put the fix
for Q_GETQUOTA vs Q_XGETQUOTA breakage at the beginning of the series and
added CC to stable for it since some users have hit the problem in practice.

The patch series got already reviewed by Christoph (thanks!) upto unification
of Q_GETXSTAT[EV] with Q_GETINFO so if noone objects in a few days, I'll push
the reviewed part of the series to my tree in the second half of this week (so
that it gets some exposure in linux-next before the merge window).

Review of the remaining parts is welcome!

								Honza

[1] git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git
[2] http://www.spinics.net/lists/linux-fsdevel/msg81903.html
[3] http://www.spinics.net/lists/xfs/msg31389.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
