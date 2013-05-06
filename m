Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60FD729DF8
	for <xfs@oss.sgi.com>; Sun,  5 May 2013 19:19:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4ED90304032
	for <xfs@oss.sgi.com>; Sun,  5 May 2013 17:19:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5XSyRdaii628dxVJ for <xfs@oss.sgi.com>;
	Sun, 05 May 2013 17:19:11 -0700 (PDT)
Date: Mon, 6 May 2013 10:19:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
Message-ID: <20130506001909.GK19978@dastard>
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
	<51840047.4020908@sgi.com>
	<20130503190514.GD12414@localhost.localdomain>
	<51840F54.9060206@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51840F54.9060206@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, May 03, 2013 at 02:26:12PM -0500, Rich Johnston wrote:
> On 05/03/2013 02:05 PM, Josef Bacik wrote:
> >On Fri, May 03, 2013 at 12:21:59PM -0600, Rich Johnston wrote:
> >>Thanks for another patch Josef, it has been committed with the change
> >>discussed.
> >>
> >
> >Err I forgot to point out I already have a "sync" variable in there so it fails
> >to compile, we'll need to change the var to do_sync or something.  Want me to
> >send a patch along?  Thanks,
> >
> >Josef
> >
> Sorry this was my fault, I have reverted
> 
> 
> commit 7f622f44b651aec13b99ef62c2942388a6fbee5d
> Author: Rich Johnston <rjohnston@sgi.com>
> Date:   Fri May 3 14:07:59 2013 -0500
> 
>     Revert "xfstests 311: test fsync with dm flakey V3"
> 
> and committed it again.
> 
> commit dd3b5268312e0518ae695e8ee2a618f13805c425
> Author: Josef Bacik <jbacik@fusionio.com>
> Date:   Fri Apr 26 19:13:59 2013 +0000
> 
>     xfstests 311: test fsync with dm flakey V4

Hi Rich - reverting the entire patch for a small change makes the
git history look very strange.  Looking at the history I now see 2
commits with the same commit message, and a revert that says "patch
will be resubmitted".  It doesnt tell me why the commit was
reverted, and the nsecond commit doesn't document the changes
between the first (reverted) commit and the second. I have to use
git diff to find out what the difference between the two commits,
and even then I don't know the reason for the change....

In future, can you just add a new commit that fixes the previous
problem with a commit message that describes the reason for needing
the fix? i.e. rather than a complete revert and a new commit,
a single commit like this is much better:

xfstests: fix shadow variable in fsync-tester

Commit 2ca254d introduced a build error where a variable named sync
was used in a function that called the sync() syscall function,
resulting in a build error. Rename the sync variable to do_sync to
fix.

SOB
---
diff --git a/src/fsync-tester.c b/src/fsync-tester.c
index 4de0d94..f0875fc 100644
--- a/src/fsync-tester.c
+++ b/src/fsync-tester.c
@@ -95,7 +95,7 @@ static void drop_all_caches()
  * the file and randomly write within it, depending on the prealloc flag
  */
 static int test_three(int *max_blocks, int prealloc, int rand_fsync,
-                     int sync, int drop_caches)
+                     int do_sync, int drop_caches)
 {
        int size = (random() % 2048) + 4;
        int blocks = size / 2;
@@ -128,8 +128,8 @@ static int test_three(int *max_blocks, int prealloc, int rand_
                }
 
                /* Force a transaction commit in between just for fun */
-               if (blocks == sync_block && (sync || drop_caches)) {
-                       if (sync)
+               if (blocks == sync_block && (do_sync || drop_caches)) {
+                       if (do_sync)
                                sync();
                        else
                                sync_file_range(test_fd, 0, 0,

----

That leaves a history that gives the reason for the change and the
exact change that was necessary to fix the problem, and is much
easier to work out what and why stuff was done a couple of years
down the track....

Cheers,

Dave.



> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
