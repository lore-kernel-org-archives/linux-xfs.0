Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAIHdG43187567 for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 11:39:16 -0600
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28BD313D4F72
	for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 09:40:49 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id LpEWqLVBDK1YSbra for
	<xfs@oss.sgi.com>; Thu, 18 Nov 2010 09:40:49 -0800 (PST)
Date: Thu, 18 Nov 2010 12:40:36 -0500 (EST)
From: Boris Ranto <branto@redhat.com>
Message-ID: <718862571.1487061290102036972.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1979397072.1486461290101694923.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
Subject: Re: xfstests: MKFS_OPTIONS is not being reinitialized
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


----- "Dave Chinner" <david@fromorbit.com> wrote:

> On Wed, Nov 17, 2010 at 04:49:58PM +0100, Boris Ranto wrote:
> > Test case 223 constantly fails because the variable carrying mkfs
> > options is not being reinitialized.
> > 
> > Test calls function _scratch_mkfs_geom repeatedly in for loop
> without
> > cleaning the MKFS_OPTIONS variable. Since _scratch_mkfs_geom only
> > appends options to the variable, MKFS_OPTIONS looks like this in
> 5th
> > iteration:
> > MKFS_OPTIONS="-bsize=4096-b size=4096 -d su=8192,sw=4-b size=4096
> -d
> > su=16384,sw=4-b size=4096 -d su=32768,sw=4-b size=4096 -d
> > su=65536,sw=4-b size=4096 -d su=131072,sw=4"
> > 
> > It is also easy to see that _scratch_mkfs_geom does not append
> leading
> > space when it appends the variable.
> > 
> > Following patch fixes the issue for me and based on my testing does
> not
> > break any other test case:
> > 
> > diff -uprN xfstests-dev/223 xfstests-dev-new/223
> > --- xfstests-dev/223	2010-11-09 08:53:39.000000000 -0500
> > +++ xfstests-dev-new/223	2010-11-17 08:05:56.745068628 -0500
> > @@ -58,6 +58,7 @@ for SUNIT_K in 8 16 32 64 128; do
> >  	let SUNIT_BLOCKS=$SUNIT_BYTES/$BLOCKSIZE
> >  
> >  	echo "=== mkfs with su $SUNIT_BLOCKS blocks x 4 ==="
> > +	export MKFS_OPTIONS=""
> >  	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seq.full 2>&1
> >  	_scratch_mount
> 
> That'll drop any custom mkfs options on the floor for that test.
> 
> >  
> > diff -uprN xfstests-dev/common.rc xfstests-dev-new/common.rc
> > --- xfstests-dev/common.rc	2010-11-09 08:53:39.000000000 -0500
> > +++ xfstests-dev-new/common.rc	2010-11-17 08:07:06.972132647 -0500
> > @@ -349,10 +349,10 @@ _scratch_mkfs_geom()
> >  
> >      case $FSTYP in
> >      xfs)
> > -	MKFS_OPTIONS+="-b size=$blocksize, -d
> su=$sunit_bytes,sw=$swidth_mult"
> > +	MKFS_OPTIONS+=" -b size=$blocksize, -d su=$sunit_bytes,sw=
> > $swidth_mult"
> >  	;;
> >      ext4)
> > -	MKFS_OPTIONS+="-b $blocksize -E
> stride=$sunit_blocks,stripe_width=
> > $swidth_blocks"
> > +	MKFS_OPTIONS+=" -b $blocksize -E
> stride=$sunit_blocks,stripe_width=
> > $swidth_blocks"
> >  	;;
> >      *)
> >  	_notrun "can't mkfs $FSTYP with geometry"
> 
> Perhaps rather than using MKFS_OPTIONS, this should call
> scratch_mkfs directly with these as extra options, similar to the
> way _scratch_mkfs_sized() does. That would leave custom options set,
> and only pass the test specific options once to mkfs....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

If I remember it right this would not work because MKFS_OPTIONS already contained -bsize=4096 at the beginning of the test and if another -b size=$blocksize would be added to the options mkfs would fail again.

Cheers,
Boris Ranto
<branto@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
