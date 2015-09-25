Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E2FC07F37
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 08:07:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D983AC004
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 06:07:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id chD7tUEL6WgCCuEr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2015 06:07:53 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id BF799C0B1B3C
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 13:07:52 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8PD7paZ000474
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 09:07:52 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/3 V2] xfs_io: implement 'inode' command
Date: Fri, 25 Sep 2015 15:07:44 +0200
Message-Id: <1443186467-20110-1-git-send-email-cmaiolino@redhat.com>
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

Implements a new xfs_io cmmand, named 'inode', which is supposed to be used to
query information about inode's existence and its physical size in the
filesystem.

Currently supporting three arguments:
-s	 -- return physical size of the largest inode
-l	 -- return the largest inode number allocated and used
-n [num] -- Return the next existing inode after [num], even if [num] is not
	    allocated/used
[num]	 -- Return if the inode exists or not.


I decided to split the implementation in three patches because I thought this
would be easier for review and understand the logic of each argument, mainly
regarding the '-n [num] / [num]' implementation where I'm not sure if I handled
it in a good way.

I also didn't send the man page patch because I'm sure I'll get some points to
improve, and I'll write the manpage for the next revision.


Carlos Maiolino (3):
  xfs_io: Add inode '-s' command to query physical size of largest inode
  xfs_io: add inode -l argument to return largest inode number
  xfs_io: implement inode '-n' and [num] argument

 io/open.c | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
