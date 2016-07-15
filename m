Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 25D217CA3
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 23:06:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC277304039
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 21:06:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JzRXv9YteGg7lHSQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2016 21:06:52 -0700 (PDT)
Date: Fri, 15 Jul 2016 12:06:50 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] common/rc: avoid mkfs option conflicts in
	_scratch_mkfs_xfs_supported
Message-ID: <20160715040650.GI2432@eguan.usersys.redhat.com>
References: <1467697153-23189-1-git-send-email-eguan@redhat.com>
	<20160715000129.GT12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160715000129.GT12670@dastard>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 15, 2016 at 10:01:29AM +1000, Dave Chinner wrote:
> On Tue, Jul 05, 2016 at 01:39:13PM +0800, Eryu Guan wrote:
> > In recent mkfs.xfs updates in xfsprogs, commit 9090e187bc3e ("mkfs:
> > add respecification detection to generic parsing") added
> > re-specification detection to "-m" option, it causes several tests
> > _notrun if MKFS_OPTIONS has the same options as those being tested
> > in _scratch_mkfs_xfs_supported(), because they're specified multiple
> > times.
> > 
> > 	MKFS_OPTIONS="-m crc=0" ./check xfs/001
> > 	xfs/001 3s ... [not run] mkfs.xfs doesn't have crc feature
> > 
> > Fix it by creating XFS again without MKFS_OPTIONS in
> > _scratch_mkfs_xfs_supported(), in case there's conflict between
> > MKFS_OPTIONS and mkfs_opts, like what we do in _scratch_mkfs_xfs().
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  common/rc | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index 883bd7b..ad81461 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -473,11 +473,20 @@ _scratch_mkfs_xfs_opts()
> >  
> >  _scratch_mkfs_xfs_supported()
> >  {
> > -	mkfs_opts=$*
> > +	local mkfs_opts=$*
> >  
> >  	_scratch_options mkfs
> >  
> >  	$MKFS_XFS_PROG -N $MKFS_OPTIONS $SCRATCH_OPTIONS $mkfs_opts $SCRATCH_DEV
> > +	local mkfs_status=$?
> > +
> > +	# if $mkfs_opts conflits with $MKFS_OPTIONS,
> > +	# try again without $MKFS_OPTIONS
> > +	if [ $mkfs_status -ne 0 -a -n "$MKFS_OPTIONS" ]; then
> > +		$MKFS_XFS_PROG -N $SCRATCH_OPTIONS $mkfs_opts $SCRATCH_DEV
> > +		mkfs_status=$?
> > +	fi
> > +	return $mkfs_status
> >  }
> 
> 
> This should match what _scratch_mkfs_xfs does. i.e:
> 
>         # a mkfs failure may be caused by conflicts between
>         # $MKFS_OPTIONS and $extra_mkfs_options
>         if [ $mkfs_status -ne 0 -a ! -z "$extra_mkfs_options" ]; then
>                 (
>                 echo -n "** mkfs failed with extra mkfs options "
>                 echo "added to \"$MKFS_OPTIONS\" by test $seq **"
>                 echo -n "** attempting to mkfs using only test $seq "
>                 echo "options: $extra_mkfs_options **"
>                 ) >> $seqres.full
> 
>                 # running mkfs again. overwrite previous mkfs output files
>                 _scratch_mkfs_xfs_opts $extra_mkfs_options \
>                         2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
>                 local mkfs_status=$?
>         fi
> 
> i.e. it checks if $extra_mkfs_options is not empty, rather than
> $MKFS_OPTIONS

Thanks for the review!

I thought about it too, but I realized that _scratch_mkfs_supported() is
supposed to have "$extra_mkfs_options" (always non-empty), because what
it tests is to check whether mkfs.xfs works well with these
"$extra_mkfs_options".

But making sure $mkfs_opts is not empty before using it makes more
sense, and it matches _scratch_mkfs_xfs(). I'll send v2 patch.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
