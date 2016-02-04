Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 03DF77CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 08:28:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8EA08F8039
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 06:28:09 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id mOZ4auvL0Y8wUx7T (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2016 06:28:07 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 v2] Q_GETNEXTQUOTA support
Date: Thu,  4 Feb 2016 15:28:04 +0100
Message-Id: <1454596087-6814-1-git-send-email-jack@suse.cz>
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
Cc: Mark Fasheh <mfasheh@suse.com>, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

Hello,

the patch set below adds support for VFS quotas for Q_GETNEXTQUOTA quotactl
and thus repquota(8) doesn't have to iterate over /etc/passwd or LDAP database
to report all quota limits. ext2, ext4, reiserfs, jfs, and ocfs2 support this
quotactl (and Q_XGETNEXTQUOTA as well) after applying this patch set. XFS
bits will likely get merged independently through XFS tree. If nobody objects,
I'll push these patches to my tree in a few days.

Changes since v2:
* Added get_next_id() operation to dquot_operations to allow for cleaner
  support in OCFS2
* Added OCFS2 support

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
