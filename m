Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE7A17F54
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 07:59:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5D078F8078
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 05:59:26 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QSoeWmy8si8MeG6x (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 05:59:22 -0800 (PST)
From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH v2 0/3] __btrfs_drop_extents() BUG_ON reproducer
Date: Thu,  6 Feb 2014 14:59:11 +0100
Message-Id: <1391695154-2039-1-git-send-email-ddiss@suse.de>
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
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org

This patch-set provides a reproducer for hitting the 3.14.0-rc1 BUG_ON()
at:
 692 int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
...
 839                 /*
 840                  *  | ---- range to drop ----- |
 841                  *      | -------- extent -------- |
 842                  */
 843                 if (start <= key.offset && end < extent_end) {
 844                         BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
 845 
 846                         memcpy(&new_key, &key, sizeof(new_key));

The first patch adds a small cloner binary which is used by btrfs/035 to
dispatch BTRFS_IOC_CLONE_RANGE requests.

This workload resembles that of Samba's vfs_btrfs module, when a Windows
client restores a file from a shadow-copy (snapshot) using server-side
copy requests.

Changes since V1:
- Use strtoull instead of atoi
- Print error conditions in cloner
- Check for cloner binary before running test
- Continue test on failure
- Add cloner to .gitignore

Feedback appreciated.

Cheers, David


 .gitignore          |   1 +
 configure.ac        |   1 +
 src/Makefile        |   2 +-
 src/cloner.c        | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035     |  77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035.out |   3 +++
 tests/btrfs/group   |   1 +
 7 files changed, 276 insertions(+), 1 deletion(-)
 create mode 100644 src/cloner.c
 create mode 100755 tests/btrfs/035
 create mode 100644 tests/btrfs/035.out

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
