Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbeK1KTe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 05:19:34 -0500
Date: Tue, 27 Nov 2018 15:19:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] generic/050: fix ro blockdev mount of xfs with quota
Message-ID: <20181127231955.GA8115@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
 <154111436126.6577.15057711037961689350.stgit@magnolia>
 <20181104153236.GC12788@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181104153236.GC12788@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Nov 04, 2018 at 11:32:36PM +0800, Eryu Guan wrote:
> On Thu, Nov 01, 2018 at 04:19:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In XFS, mounting with quota always require a writable device.  If the
> > block device is read only, the mount fails, which fails this test.
> > Since this is expected, work around this.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/generic/050 |   23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/tests/generic/050 b/tests/generic/050
> > index 90e924db..33da228d 100755
> > --- a/tests/generic/050
> > +++ b/tests/generic/050
> > @@ -36,6 +36,21 @@ _require_norecovery
> >  
> >  _scratch_mkfs >/dev/null 2>&1
> >  
> > +filter_ro_mount() {
> > +	local arg=""
> > +
> > +	# Mounting with quota on XFS requires a writable fs, which means
> > +	# we fail the ro blockdev test with with EPERM.
> > +	if [ "$FSTYP" = "xfs" ] && echo "$MOUNT_OPTIONS" | grep -q quota ; then
> > +		arg="s|mount: $SCRATCH_MNT: permission denied|mount: device write-protected, mounting read-only|g"
> > +	fi
> > +	sed -e "$arg" | _filter_ro_mount
> > +}
> > +
> > +filter_umount() {
> > +	sed -e "\|umount: $SCRATCH_DEV: not mounted.|d" | _filter_scratch
> > +}
> > +
> >  #
> >  # Mark the device read-only
> >  #
> > @@ -46,7 +61,7 @@ blockdev --setro $SCRATCH_DEV
> >  # Mount it, and make sure we can't write to it, and we can unmount it again
> >  #
> >  echo "mounting read-only block device:"
> > -_try_scratch_mount 2>&1 | _filter_ro_mount
> > +_try_scratch_mount 2>&1 | filter_ro_mount
> >  
> >  echo "touching file on read-only filesystem (should fail)"
> >  touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> 
> This touch expects a failure message, but with this change applied, test
> still failed when testing with "-o usrquota,grpquota,prjquota" mount
> options as
> 
>     --- tests/generic/050.out   2018-07-01 20:36:05.796146192 +0800
>     +++ /root/workspace/xfstests/results//generic/050.out.bad   2018-11-04 23:25:34.551700377 +0800
>     @@ -3,7 +3,6 @@
>      mounting read-only block device:
>      mount: device write-protected, mounting read-only
>      touching file on read-only filesystem (should fail)
>     -touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system

Hmm, what kernel is this on?  I've never seen this problem, but maybe I
just have too many patches everywhere. :/

--D

>      unmounting read-only filesystem
>      setting device read-write
>      mounting read-write block device:
> 
> Thanks,
> Eryu
> 
> > @@ -56,7 +71,7 @@ touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> >  #	http://oss.sgi.com/bugzilla/show_bug.cgi?id=807
> >  #
> >  echo "unmounting read-only filesystem"
> > -_scratch_unmount 2>&1 | _filter_scratch
> > +_scratch_unmount 2>&1 | filter_umount
> >  
> >  echo "setting device read-write"
> >  blockdev --setrw $SCRATCH_DEV
> > @@ -92,10 +107,10 @@ _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
> >  # data recovery hack.
> >  #
> >  echo "mounting filesystem with -o norecovery on a read-only device:"
> > -_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount
> > +_try_scratch_mount -o norecovery 2>&1 | filter_ro_mount
> >  
> >  echo "unmounting read-only filesystem"
> > -_scratch_unmount 2>&1 | _filter_scratch
> > +_scratch_unmount 2>&1 | filter_umount
> >  
> >  echo "setting device read-write"
> >  blockdev --setrw $SCRATCH_DEV
> > 
