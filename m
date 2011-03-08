Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p28KBOZt257057 for <xfs@oss.sgi.com>; Tue, 8 Mar 2011 14:11:25 -0600
Subject: Re: xfstests: change directory to / before _cleanup_testdir in
	test 135
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1299590960.12867.102.camel@dhcp-31-190.brq.redhat.com>
References: <1299511558.3183.115.camel@dhcp-31-190.brq.redhat.com>
	<1299528749.2578.821.camel@doink>
	<1299590960.12867.102.camel@dhcp-31-190.brq.redhat.com>
Date: Tue, 08 Mar 2011 14:14:13 -0600
Message-ID: <1299615253.2716.52.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs <xfs@oss.sgi.com>

On Tue, 2011-03-08 at 14:29 +0100, Boris Ranto wrote:
> On Mon, 2011-03-07 at 14:12 -0600, Alex Elder wrote:
> > On Mon, 2011-03-07 at 16:25 +0100, Boris Ranto wrote:
> > > Nfs tries to umount $testdir in _cleanup_testdir function. The test 135 calls the function from directory $SCRATCH_MNT that is equal to $testdir (at least for nfs). The umount will therefore fail causing the test to fail due to the output mismatch.
> > > 
> > > This simple patch fixes the issue for me.
> > > 
> > > Signed-off-by: Boris Ranto <branto@redhat.com>
> > 
> > This looks OK to me.  Most other tests do this chdir
> > in their cleanup function.
> > 
> > I did a quick scan and found that test 126 may suffer the
> > same problem.  Can you check this?  We could include the
> > fix for both tests in the same commit.
> > 
> 
> Yes, the test needs cd /, too. Actually the test 126 also does double
> umount thanks to the _cleanup before exit and the trap command. So the
> removal of the call of the _cleanup function before exit is necessary,
> too.

I will commit this patch, fixing the problems in 126 and 135.
I'll massage the commit message a bit to fit what it does,
and the your discussion here.

I'm not going to do anything (at the moment) about the
double mount/umount issues you mention.

Thanks for submitting the fixes.

					-Alex

> > 
> > It also looks to me like tests 069, 089 might have a
> > similar issue if they get interrupted.
> 
> Yes, that's also true, if the tests are interrupted and then immediately
> run again the umount will fail due to the processes in background but
> I'm not sure whether it is worth fixing (and if there is a good way to
> fix it).
> I've had bigger problems with double mount/umount in several tests
> (namely: double umount - 124, 128, double mount - 129, 130). The double
> umounts occur due to the use of trapped _cleanup and umount $SCRATCH_MNT
> in the tests. The double mounts occur due to the use of _setup_testdir
> and _scratch_mount (both of them mount $SCRATCH_MNT in the nfs case).
> The problem is that I'm not sure how to fix these without any change in
> the behaviour.
> 
> > 
> > 					-Alex
> > 
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
