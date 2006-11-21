Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 00:40:40 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAL8eSaG024965
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 00:40:30 -0800
Date: Tue, 21 Nov 2006 19:41:48 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: XFS Update for 2.6.19
Message-ID: <72BEC048EB6E8F7B2893FAAF@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org
Cc: akpm@osdl.org, xfs@oss.sgi.com

Hi Linus,

A couple of small XFS fixes for some apparent bugs.
Thanks.

Please pull from:
	git://oss.sgi.com:8090/xfs/xfs-2.6

This will update the following files:

 fs/xfs/xfs_bmap.c  |    2 ++
 fs/xfs/xfs_inode.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

through these commits:

commit d2133717d5f994cca970b5aeb9d4664feeb92ff4
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Tue Nov 21 18:55:16 2006 +1100

    [XFS] Fix uninitialized br_state and br_startoff in
    xfs_bmap_add_extent_delay_real()

    SGI-PV: 957008
    SGI-Modid: xfs-linux-melb:xfs-kern:27457a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Shailendra Tripathi <stripathi@agami.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>


commit e5ffd2bb62c3f2c0d9f34e0d16fab6e2c8b056fb
Author: David Chinner <dgc@sgi.com>
Date:   Tue Nov 21 18:55:33 2006 +1100

    [XFS] Stale the correct inode when freeing clusters.

    SGI-PV: 958376
    SGI-Modid: xfs-linux-melb:xfs-kern:27503a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

--Tim
