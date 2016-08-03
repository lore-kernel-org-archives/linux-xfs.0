Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B2D87CA2
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 06:28:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E59C304032
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 04:28:19 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id ZupCb7LWGQKdck8M (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 04:28:17 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5 v2] fs: Avoid premature clearing of file capabilities
Date: Wed,  3 Aug 2016 13:28:04 +0200
Message-Id: <1470223689-17783-1-git-send-email-jack@suse.cz>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, xfs@oss.sgi.com, "Yan, Zheng" <zyan@redhat.com>, linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org

Hello,

this patch series is my attempt to fix an issue when user can clear capabilites
of arbitrary file he can look up for example by running chown on it (this got
assigned CVE-2015-1350). The problem is that we call security_inode_killpriv()
before checking permissions in inode_change_ok(). This patch set moves that
call into inode_change_ok() after permissions are checked - the only trouble is
that we need to give dentry instead of inode there and that is not completely
trivial in some cases - I'm still missing a review from Ceph people to verify I
didn't miss anything.

Anyway, I guess the changes are fine for merging. Al, you please merge the
patches? Thanks!

Changes since v1:
* Added acks for XFS and FUSE patches

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
