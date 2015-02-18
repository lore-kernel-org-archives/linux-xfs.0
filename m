Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF5797F72
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 07:48:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4DB1DAC001
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 05:48:24 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0FZGeDmblbH681wJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 05:48:21 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/8 v5] quota: Unify VFS and XFS quota interfaces
Date: Wed, 18 Feb 2015 14:47:46 +0100
Message-Id: <1424267274-11836-1-git-send-email-jack@suse.cz>
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
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com

  Hello,

  these are outstanding patches in my series unifying VFS and XFS quota
interfaces so that XFS quotactls work for filesystems with VFS quotas and vice
versa.  This is useful so that userspace doesn't have to care that much about
which filesystem it is using at least when using basic quota functionality. In
particular we should be able to reuse project quota tests in xfstests for ext4.

The patches are based on top of Linus' tree from few days ago which already
contains initial part of the original series.  The patch series can also be
pulled from 'quota_interface' branch of my tree [1].

I'm sending the series as there are two XFS and one GFS2 patches which still
need review before I can add them to my tree for the next merge window.

								Honza

[1] git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
