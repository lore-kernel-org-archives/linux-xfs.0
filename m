Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 900888108
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:35:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 82B038F8092
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:35:06 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cr5X08Mu6lTndm7i for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:34:59 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WXfXW-0000WZ-70
	for xfs@oss.sgi.com; Wed, 09 Apr 2014 09:34:50 +1000
Date: Wed, 9 Apr 2014 09:34:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to f994d14
Message-ID: <20140408233450.GL27017@dastard>
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

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

f994d14 xfs_repair: fix prefetch queue waiting

New Commits:

Dave Chinner (1):
      [419d647] repair: ensure that unused superblock fields are zeroed

David Sterba (1):
      [1b3c0d6] xfsprogs: add a missing QA header file to install-qa target

Eric Sandeen (2):
      [857592d] xfs_db: hide debug bbmap output
      [f994d14] xfs_repair: fix prefetch queue waiting

Mark Tinguely (1):
      [0a3717c] xfsprogs: fix directory hash ordering bug


Code Diffstat:

 db/io.c               | 2 +-
 include/Makefile      | 1 +
 libxfs/xfs_da_btree.c | 2 +-
 repair/prefetch.c     | 4 +++-
 repair/sb.c           | 1 +
 5 files changed, 7 insertions(+), 3 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
