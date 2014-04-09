Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E96318152
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 19:28:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D18763040EB
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 17:27:58 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iSSFLgZO51IAwZv8 for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 17:13:39 -0700 (PDT)
Date: Wed, 9 Apr 2014 10:12:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to 610e44c
Message-ID: <20140409001210.GO27017@dastard>
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
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

This update fixes the SCRATCH_DEV_POOL config file regression.

The new head of the master branch is commit:

610e44c check: fix wallclock wrapping problem

New Commits:

Lukas Czerner (3):
      [f00a444] config: Fix SCRATCH_DEV_POOL handling
      [7407717] config: Unset SCRATCH_DEV when deduced from SCRATCH_DEV_POOL
      [e0f5daf] config: Fix setting FSTYP automatically

Wanlong Gao (1):
      [610e44c] check: fix wallclock wrapping problem


Code Diffstat:

 check         | 10 +---------
 common/config | 33 ++++++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 16 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
