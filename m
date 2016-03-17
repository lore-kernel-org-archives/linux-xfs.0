Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6E6157CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 16:56:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5BA9AC004
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 14:56:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uT3ryTHHmzXFSpXJ for <xfs@oss.sgi.com>;
	Thu, 17 Mar 2016 14:56:11 -0700 (PDT)
Date: Fri, 18 Mar 2016 08:56:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: new fs, xfs_admin new label, metadata corruption detected
Message-ID: <20160317215604.GM30721@dastard>
References: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
	<56E8AA22.7080301@sandeen.net>
	<CAJCQCtQYMitUvPN1ORyEHvDhddJ09Hp_xK_CBc0e1Cu972S3_w@mail.gmail.com>
	<CAJCQCtQJ_1ARXYuN3j2VyVN8FBtG0myqmPnOgco1v-tQxqmyBg@mail.gmail.com>
	<20160317205729.GL30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160317205729.GL30721@dastard>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Mar 18, 2016 at 07:57:29AM +1100, Dave Chinner wrote:
> On Wed, Mar 16, 2016 at 08:39:21PM -0600, Chris Murphy wrote:
> > OK I can consistently reproduce this on the CLI. I end up with totally different
> > 
> > # lvcreate -L 40g VG -n testxfs
> >   Logical volume "testxfs" created.
> ....
> [grow]
> ....
> > # xfs_repair -n /dev/VG/testxfs
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> > Metadata corruption detected at xfs_agf block 0x8c00008/0x1000
> > fllast 1014 in agf 7 too large (max = 1014)
> > Metadata corruption detected at xfs_agf block 0x6400008/0x1000
> > fllast 1014 in agf 5 too large (max = 1014)
> > Metadata corruption detected at xfs_agf block 0x5000008/0x1000
> > fllast 1014 in agf 4 too large (max = 1014)
> > Metadata corruption detected at xfs_agf block 0x7800008/0x1000
> > fllast 1014 in agf 6 too large (max = 1014)
> >         - found root inode chunk
> 
> That's caused by commit 96f859d ("libxfs: pack the agfl header
> structure so XFS_AGFL_SIZE is correct") and growfs setting the
> last free list entry to something that a userspace without the
> commit  9fccb9f ("libxfs: pack the agfl header structure so
> XFS_AGFL_SIZE is correct") fails to validate correctly.
> 
> i.e. update userspace to 4.5.0, and the repair noise will go away.
> 
> I think we probably need to fix the growfs code to set it's initial
> flfirst/fllast values to be 1/0, not 0/EOFL, and the problem will
> then go away....

Patch to do this below if you want to test it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Don't wrap growfs AGFL indexes

From: Dave Chinner <dchinner@redhat.com>

Commit 96f859d ("libxfs: pack the agfl header structure so
XFS_AGFL_SIZE is correct") allowed the freelist to use the empty
slot at the end of the freelist on 64 bit systems that was not
being used due to sizeof() rounding up the structure size.

This has caused versions of xfs_repair prior to 4.5.0 (which also
has the fix) to report this as a corruption once the filesystem has
been grown. Older kernels can also have problems (seen from a whacky
container/vm management environment) mounting filesystems grown on a
system with a newer kernel than the vm/container it is deployed on.

To avoid this problem, change the initial free list indexes not to
wrap across the end of the AGFL, hence avoiding the initialisation
of agf_fllast to the last index in the AGFL.

cc: <stable@vger.kernel.org> # 4.4-4.5
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ee3aaa0a..ca0d3eb 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -243,8 +243,8 @@ xfs_growfs_data_private(
 		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
 		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
 		agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
-		agf->agf_flfirst = 0;
-		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
+		agf->agf_flfirst = cpu_to_be32(1);
+		agf->agf_fllast = 0;
 		agf->agf_flcount = 0;
 		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
 		agf->agf_freeblks = cpu_to_be32(tmpsize);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
