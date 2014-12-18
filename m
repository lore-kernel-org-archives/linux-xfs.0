Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E903B7F58
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:37:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76FAEAC00D
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:37:52 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4RJCigh9xpUzzOMU (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:37:51 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/25 RFC v2] quota: Unify VFS and XFS quota interfaces
Date: Thu, 18 Dec 2014 16:37:14 +0100
Message-Id: <1418917059-23870-1-git-send-email-jack@suse.cz>
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

  this is the second attempt to unify VFS and XFS quota interfaces so that XFS
quotactls work for filesystems with VFS quotas and vice versa.  This is useful
so that userspace doesn't have to care that much about which filesystem it is
using at least when using basic quota functionality. In particular we should be
able to reuse project quota tests in xfstests for ext4.

In this patch set I unify quotaon / quotaoff handling (Q_QUOTAON, Q_QUOTAOFF,
Q_XQUOTAON, Q_XQUOTAOFF calls), fix some bugs in the Q_XGETQUOTA, Q_XSETQLIM,
Q_GETQUOTA, Q_SETQUOTA calls done by Christoph some time ago, unify
Q_GETXSTATE, Q_GETXSTATV with Q_GETINFO, and also wire up Q_SETINFO to work
with XFS (and Q_XSETQLIM for id 0 to modify time limits for VFS quotas).
So after these patches xfs_quota can manipulate quotas for ext4 filesystem and
similarly quota-tools can be used to manipulate quotas for xfs filesystem.

I have also verified that xfstests pass fine both for xfs and ext4 so
hopefully I didn't introduce any regression in the current functionality (I
also did a couple of manual checks for timer setting etc).

All the comments to the first version of the series are hopefully addressed,
except for Dave's request to reduce number of copying of dquot information -
I have benchmarked that reducing number of copies from 3 to 2 brings just 2%
improvement in speed in my test setup and getting quota information isn't IMHO
so performance critical that it would be worth the complications of the code.

Patches are against Linus' tree as of today - I know XFS tree may have some
conflicting changes (I think Dave even picked up some XFS patches from the
beginning of the series) but I wanted the patch series to be self-contained.

Comments are welcome. I would like to merge the patches via my tree in the
next merge window but before I do that I'd like some review...

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
