Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3NB7s1026758 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 17:11:07 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FDD91B93428
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 15:11:05 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	wtoV6oyraK5QFnYW for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2008 15:11:05 -0800 (PST)
Date: Thu, 4 Dec 2008 09:09:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27.7 vanilla, project quota enabled and process stuck in D
	state (repeatable every time)
Message-ID: <20081203220934.GA32301@disturbed>
References: <200812021949.55463.arekm@maven.pl>
	<200812031406.41882.arekm@maven.pl>
	<20081203213028.GW18236@disturbed>
	<200812032242.29326.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200812032242.29326.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 10:42:29PM +0100, Arkadiusz Miskiewicz wrote:
> On Wednesday 03 of December 2008, Dave Chinner wrote:
> 
> > > D-state lock is also happening if I drop usrquota,prjquota, reboot and
> > > retry the test. I assume something was written on disk that triggers the
> > > problem.
> >
> > Unlikely - locking doesn't generally get stuck due to on disk
> > corruption. Are there any other blocked processes in the machine?
> > i.e. what is the entire output of 'echo w > /proc/sysrq-trigger'?
> 
> Only this one program trace visible in sysrq-w output. No other traces - so no 
> other blocked programs.
> 
> > Are there any other signs of general unwellness (e.g. a CPU running
> > at 100% when it shouldn't be)?
> 
> Nothing wrong.
> 
> > FWIW, if you are seeing this on two hosts, can you try to build
> > a reproducable test case using a minimal data set and a simple
> > set of commands? If you can do this and supply us with a
> > xfs_metadump image of the filesystem plus the commands to reproduce
> > the problem we'll be able to find the problem pretty quickly....
> 
> I was able to reproduce it with:
> 
> - mount fs with usrquota,prjquota
> - setup /home/users/arekm/rpm as project quota id = 10
> - run program below twice
> 
> [arekm@farm rpm]$ more a.c
> #include <stdio.h>
>  
> int main() {
>         int i;
>  
>         i = 
> rename("/home/users/arekm/tmp/aa", "/home/users/arekm/rpm/testing");
>         printf("ret=%d %m\n", i);
>         return 0;
> }
> [arekm@farm rpm]$ touch /home/users/arekm/tmp/aa
> [arekm@farm rpm]$ ./a.out
> ret=-1 Invalid cross-device link

Well, that's what we needed to know. The bug:

199         /*
200          * Lock all the participating inodes. Depending upon whether
201          * the target_name exists in the target directory, and
202          * whether the target directory is the same as the source
203          * directory, we can lock from 2 to 4 inodes.
204          */
205  >>>>>  xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
206
207         /*
208          * If we are using project inheritance, we only allow renames
209          * into our tree when the project IDs are the same; else the
210          * tree quota mechanism would be circumvented.
211          */
212         if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
213                      (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
214                 error = XFS_ERROR(EXDEV);
215  >>>>>>>        xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
216                 xfs_trans_cancel(tp, cancel_flags);
217                 goto std_return;
218         }

Is that the unlock of the inodes is using the incorrect lock
type for the unlock, (inodes lock XFS_ILOCK_EXCL, unlocked XFS_ILOCK_SHARED)
which means they don't get unlocked and the next attempt to do anything
with those inodes will hang.

Compile-tested-only patch below that should fix the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: Fix hang after disallowed rename across directory quota domains

When project quota is active and is being used for directory tree
quota control, we disallow rename outside the current directory
tree. This requires a check to be made after all the inodes
involved in the rename are locked. We fail to unlock the inodes
correctly if we disallow the rename when the target is outside the
current directory tree. This results in a hang on the next access
to the inodes involved in failed rename.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_rename.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index d700dac..c903130 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -212,7 +212,7 @@ xfs_rename(
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 		     (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
 		error = XFS_ERROR(EXDEV);
-		xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
+		xfs_rename_unlock4(inodes, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(tp, cancel_flags);
 		goto std_return;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
