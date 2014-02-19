Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C1EB27F59
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 18:55:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41602AC004
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 16:55:56 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5DhuEISTXoITj918 for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 16:55:55 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WFvRn-0001fo-Gd
	for xfs@oss.sgi.com; Wed, 19 Feb 2014 11:55:35 +1100
Date: Wed, 19 Feb 2014 11:55:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to e13d0f7
Message-ID: <20140219005535.GJ13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

e13d0f7 xfs_db: fix attribute leaf output for ATTR3 format

New Commits:

Brian Foster (1):
      [eecbd58] xfs_io: set argmax to 1 for imap command

Dave Chinner (1):
      [e13d0f7] xfs_db: fix attribute leaf output for ATTR3 format

Mark Tinguely (1):
      [dc15132] xfs_db: fix the setting of unaligned directory fields


Code Diffstat:

 db/attr.c  |   2 +-
 db/bit.c   |  84 +++++++++++++-----------------
 db/write.c | 170 ++++++++++++++++++++++++++++++++++++++++---------------------
 io/imap.c  |   2 +-
 4 files changed, 148 insertions(+), 110 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
