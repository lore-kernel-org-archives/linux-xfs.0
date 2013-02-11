Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E5F67F74
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 09:05:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 966BEAC001
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 07:05:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JOnmDWRxlW2o7r5p for
	<xfs@oss.sgi.com>; Mon, 11 Feb 2013 07:05:34 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1BF5XNG010470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 10:05:33 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1BF5Xig018766
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 10:05:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 0/2] fix spinlock recursion on xa_lock in xfs_buf_item_push
Date: Mon, 11 Feb 2013 10:08:20 -0500
Message-Id: <1360595302-15865-1-git-send-email-bfoster@redhat.com>
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

Hi all,

Here is v4 of the spinlock recursion fix. The only update is to the comment in
patch 1. These changes have been run through the reproducer over the weekend
without a failure.

I've also run another xfstests run while including the following patch from Dave:

xfs: xfs_bmap_add_attrfork_local is too generic

... due to seeing the same issue Lukas reproduced in test 013 (I saw it in 070 as
well). That problem no longer occurs with this patch included, but I have hit
an error in test 178 that didn't fire in my baseline run. It persists if I revert
back to TOT, so I'm posting this set as is and I'll see if I can trace where that
one came from...

Brian

v4:
- Fix comment in patch 1.
v3:
- Patches reordered and revised to:
  1.) Add the race detection in xfs_buf_item_push().
  2.) Remove the log force from xfs_buf_trylock() entirely to fix the recursion
      and rely on xfsaild to issue the log force.
v2:
- Patch 2 is reworked to detect the potential race and defer the log force to
  xfsaild by returning XFS_ITEM_PINNED.

Brian Foster (2):
  xfs: recheck buffer pinned status after push trylock failure
  xfs: remove log force from xfs_buf_trylock()

 fs/xfs/xfs_buf.c      |    2 --
 fs/xfs/xfs_buf_item.c |   12 +++++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
