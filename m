Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p28DQTlo235939 for <xfs@oss.sgi.com>; Tue, 8 Mar 2011 07:26:29 -0600
Subject: Re: xfstests: change directory to / before _cleanup_testdir in
	test 135
From: Boris Ranto <branto@redhat.com>
In-Reply-To: <1299528749.2578.821.camel@doink>
References: <1299511558.3183.115.camel@dhcp-31-190.brq.redhat.com>
	<1299528749.2578.821.camel@doink>
Date: Tue, 08 Mar 2011 14:29:20 +0100
Message-ID: <1299590960.12867.102.camel@dhcp-31-190.brq.redhat.com>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs <xfs@oss.sgi.com>

On Mon, 2011-03-07 at 14:12 -0600, Alex Elder wrote:
> On Mon, 2011-03-07 at 16:25 +0100, Boris Ranto wrote:
> > Nfs tries to umount $testdir in _cleanup_testdir function. The test 135 calls the function from directory $SCRATCH_MNT that is equal to $testdir (at least for nfs). The umount will therefore fail causing the test to fail due to the output mismatch.
> > 
> > This simple patch fixes the issue for me.
> > 
> > Signed-off-by: Boris Ranto <branto@redhat.com>
> 
> This looks OK to me.  Most other tests do this chdir
> in their cleanup function.
> 
> I did a quick scan and found that test 126 may suffer the
> same problem.  Can you check this?  We could include the
> fix for both tests in the same commit.
> 

Yes, the test needs cd /, too. Actually the test 126 also does double
umount thanks to the _cleanup before exit and the trap command. So the
removal of the call of the _cleanup function before exit is necessary,
too.

> 
> It also looks to me like tests 069, 089 might have a
> similar issue if they get interrupted.

Yes, that's also true, if the tests are interrupted and then immediately
run again the umount will fail due to the processes in background but
I'm not sure whether it is worth fixing (and if there is a good way to
fix it).
I've had bigger problems with double mount/umount in several tests
(namely: double umount - 124, 128, double mount - 129, 130). The double
umounts occur due to the use of trapped _cleanup and umount $SCRATCH_MNT
in the tests. The double mounts occur due to the use of _setup_testdir
and _scratch_mount (both of them mount $SCRATCH_MNT in the nfs case).
The problem is that I'm not sure how to fix these without any change in
the behaviour.

> 
> 					-Alex
> 
> > diff -urpN a/xfstests/135 b/xfstests/135
> > --- a/xfstests/135	2011-03-07 14:54:15.855172101 +0100
> > +++ b/xfstests/135	2011-03-07 14:54:29.895048375 +0100
> > @@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
> >  
> >  _cleanup()
> >  {
> > +    cd /
> >      _cleanup_testdir
> >  }
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 


I suppose that at least this patch could be committed, now:

diff -urpN a/xfstests/126 b/xfstests/126
--- a/xfstests/126	2011-03-07 14:52:09.038172203 +0100
+++ b/xfstests/126	2011-03-08 14:18:28.754172294 +0100
@@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
 
 _cleanup()
 {
+    cd /
     _cleanup_testdir
 }
 
@@ -73,5 +74,4 @@ $QA_FS_PERMS 040 99 99 99 500 r 1
 $QA_FS_PERMS 400 99 99 200 99 r 1
 
 status=0
-_cleanup
 exit
diff -urpN a/xfstests/135 b/xfstests/135
--- a/xfstests/135	2011-03-07 14:54:15.855172101 +0100
+++ b/xfstests/135	2011-03-07 14:54:29.895048375 +0100
@@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
 
 _cleanup()
 {
+    cd /
     _cleanup_testdir
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
