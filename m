Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E47C47F5F
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 04:35:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6DD5304066
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 02:35:51 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id KTmoFjCeHgafWU9U (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 02:35:46 -0800 (PST)
From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH v3 0/3] __btrfs_drop_extents() BUG_ON reproducer
Date: Fri,  7 Feb 2014 11:35:38 +0100
Message-Id: <1391769341-20688-1-git-send-email-ddiss@suse.de>
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
Cc: linux-btrfs@vger.kernel.org

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

Changes since V2:
- Remove explicit write error checks

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
