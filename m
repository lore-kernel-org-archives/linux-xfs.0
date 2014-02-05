Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 215A67F54
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 05:17:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09CCB8F804C
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 03:17:01 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id JoiP2Nesn4o8E7BI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 03:17:01 -0800 (PST)
From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH 0/2] __btrfs_drop_extents() BUG_ON reproducer
Date: Wed,  5 Feb 2014 12:16:47 +0100
Message-Id: <1391599009-2402-1-git-send-email-ddiss@suse.de>
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

Feedback appreciated.

Cheers, David


 src/Makefile        |   2 +-
 src/cloner.c        | 168 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035     |  76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035.out |   3 +++
 tests/btrfs/group   |   1 +
 5 files changed, 249 insertions(+), 1 deletion(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
