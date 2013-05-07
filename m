Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 666FD29DFA
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 09:11:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 587698F8037
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 07:11:00 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id 8SwSFDnKm4ptl6vB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 07:10:59 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A89289A0697
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 08:10:58 -0600 (MDT)
Date: Tue, 7 May 2013 10:10:56 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [BULK]  Re: [problem] xfstests generic/311 unreliable...
Message-ID: <20130507141056.GO12414@localhost.localdomain>
References: <20130507071102.GA24635@dastard> <20130507073717.GB24635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130507073717.GB24635@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <JBacik@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, May 07, 2013 at 01:37:17AM -0600, Dave Chinner wrote:
> Argh, add the cc to Josef...
> 
> On Tue, May 07, 2013 at 05:11:02PM +1000, Dave Chinner wrote:
> > Hi Josef,
> > 
> > I was just looking at a generic/311, and I think there's something
> > fundamentally wrong with the way it is checking the scratch device.
> > 
> > You reported it was failing for internal test 19 on XFS, but I'm
> > seeing is fail after the first test or 2, randomly. It has never
> > made it past test 3. So I had a little bit of a closer look at it's
> > structure. Essentially it is doing this (and the contents seen by
> > each step:
> > 
> > scratch dev + mkfs
> > 	+-------------------------------+
> > overlay dm-flakey
> > 	D-------------------------------D
> > mount/write/kill/unmount dm-flakey
> > 	Dx-x-x-x-x-x-x------------------D
> > 
> > All good up to here. Now, you can _check_scratch_fs which sees:
> > 
> > scratch dev + check
> > 	+-------------------------------+
> > 
> > i.e. it's not seeing all the changes written to dm-flakey and so
> > xfs-check it seeing corruption.
> > 
> > After I realised this was stacking block devices and checking the
> > underlying block device, the cause was pretty obvious: scratch-dev
> > and dm-flakey have different address spaces, so changes written
> > throughone address space will not be seen through the other address
> > space if there is stale cached data in the original address space.
> > 
> > And that's exactly what is happening. This patch:
> > 
> > --- a/tests/generic/311
> > +++ b/tests/generic/311
> > @@ -79,6 +79,7 @@ _mount_flakey()
> >  _unmount_flakey()
> >  {
> >         $UMOUNT_PROG $SCRATCH_MNT
> > +       echo 3 > /proc/sys/vm/drop_caches
> >  }
> >  
> >  _load_flakey_table()
> > 
> > Makes the problem go away for xfs_check. But really, I don't like
> > the assumption that the test is built on - that writes through one
> > block device are visible through another. It's just asking for weird
> > problems.
> > 
> > Is there some way that you can restructure this test so it doesn't
> > have this problem (e.g. do everything on dm-flakey)?
> > 

So I've made the following patch which I think will do what you want, it's kind
of ugly but we have such specific things for fsck that I don't want to have to
re-implement it all just for this test.  The thing is, I'm still seeing the
failure with test 19 for xfs.  xfs_check always passes fine for me, it's the
part where we re-mount the flakey device and then md5sum the file, it is the
md5sum of an empty file and doesn't match the md5sum we take before we unmount.
All of that is done on the flakey device so theres no stale caching going on
there.  Let me know what you think about this patch, I'm open to other less
horrible options.  Thanks,

Josef


index 2b3b569..f11119b
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -125,7 +125,10 @@ _run_test()
 
 	#Unmount and fsck to make sure we got a valid fs after replay
 	_unmount_flakey
+	tmp=$SCRATCH_DEV
+	SCRATCH_DEV=$FLAKEY_DEV
 	_check_scratch_fs
+	SCRATCH_DEV=$tmp
 	[ $? -ne 0 ] && _fatal "fsck failed"
 
 	_mount_flakey

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
