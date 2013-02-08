Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E38137F4C
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2013 08:48:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 831D3AC005
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2013 06:48:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4Zy7sLjeEIhDGQ7S for
	<xfs@oss.sgi.com>; Fri, 08 Feb 2013 06:48:14 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r18EmEVR029981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2013 09:48:14 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r18EmEf0022001
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2013 09:48:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/2] fix spinlock recursion on xa_lock in xfs_buf_item_push
Date: Fri,  8 Feb 2013 09:51:05 -0500
Message-Id: <1360335067-59999-1-git-send-email-bfoster@redhat.com>
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

Here is v3 of the spinlock recursion fix, based on Dave's comments here:

http://oss.sgi.com/archives/xfs/2013-02/msg00106.html

Note that I'm testing and posting this for review in parallel, given that v2
had seen several hours of testing with the log force bypassed in aild context.
This implementation removes the trylock log force entirely, so continued testing
will determine whether any regressions crop up and I'll post an update after a
few days.

Brian

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
 fs/xfs/xfs_buf_item.c |    9 ++++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
