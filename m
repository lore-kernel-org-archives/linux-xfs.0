Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8177929E03
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 01:37:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 467DE8F8040
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 23:37:25 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id XrDGoLlPUx41jwky for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 23:37:20 -0700 (PDT)
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 0/4] xfs: Allow user to change project id in un-init userns
Date: Wed, 4 Sep 2013 14:38:33 +0800
Message-Id: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
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
Cc: bfoster@redhat.com, dwight.engen@oracle.com, ebiederm@xmission.com, Gao feng <gaofeng@cn.fujitsu.com>

This patchset add two helper functions to convert user space project id
to kernel space project id without any struct changed.

Since the projid_map of user namespace has limit the range of valid project
ids for user namespace, we can safely allow user to change file's project
id in un-init user namespace.

Gao feng (4):
  xfs: add helper function to convert project id between user and kernel
    space
  userns: ioctl: convert project id between user and kernel space
  xfs: allow un-init user namespace to change file's project id
  userns: eofblocks: convert project id from user to kernel space

 fs/xfs/xfs_icache.h |  9 ++++++++-
 fs/xfs/xfs_ioctl.c  | 26 ++++++++++++--------------
 fs/xfs/xfs_linux.h  | 19 +++++++++++++++++++
 3 files changed, 39 insertions(+), 15 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
