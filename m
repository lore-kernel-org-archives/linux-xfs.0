Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CA297F6B
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D233304039
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:46 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vQy2Ye092RPllwqN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:44 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/11 RFC] quota: Unify VFS and XFS quota interfaces
Date: Tue, 11 Nov 2014 22:04:14 +0100
Message-Id: <1415739865-2438-1-git-send-email-jack@suse.cz>
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
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

  Hello,

  this is a first (still partial) attempt to unify VFS and XFS quota interfaces
so that XFS quotactls work for filesystems with VFS quotas and vice versa.
This is useful so that userspace doesn't have to care that much about which
filesystem it is using at least when using basic quota functionality. In
particular we should be able to reuse project quota tests in xfstests for
ext4.

In this patch set I unify quotaon / quotaoff handling (Q_QUOTAON, Q_QUOTAOFF,
Q_XQUOTAON, Q_XQUOTAOFF calls) and fix some bugs in the Q_XGETQUOTA,
Q_XSETQLIM, Q_GETQUOTA, Q_SETQUOTA calls done by Christoph some time ago.  I
have actually verified that xfs_quota is able to work with ext4 filesystem
(after tweaking it to not check fs type) when these patches are applied.

What is still missing is unification of Q_XGETQSTATV, Q_GETINFO, Q_SETINFO.

Comments are welcome.

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
