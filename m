Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAHGSYQY047830 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 10:28:34 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 581C81C4F0CC
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 08:30:06 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id GBIaW6vnHw0rOQSa for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 08:30:06 -0800 (PST)
Message-ID: <4CE4030D.9040007@sandeen.net>
Date: Wed, 17 Nov 2010 10:30:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: MKFS_OPTIONS is not being reinitialized
References: <1290008998.18362.101.camel@dhcp-31-190.brq.redhat.com>
In-Reply-To: <1290008998.18362.101.camel@dhcp-31-190.brq.redhat.com>
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
Cc: xfs@oss.sgi.com

On 11/17/10 9:49 AM, Boris Ranto wrote:
> Test case 223 constantly fails because the variable carrying mkfs
> options is not being reinitialized.
> 
> Test calls function _scratch_mkfs_geom repeatedly in for loop without
> cleaning the MKFS_OPTIONS variable. Since _scratch_mkfs_geom only
> appends options to the variable, MKFS_OPTIONS looks like this in 5th
> iteration:
> MKFS_OPTIONS="-bsize=4096-b size=4096 -d su=8192,sw=4-b size=4096 -d
> su=16384,sw=4-b size=4096 -d su=32768,sw=4-b size=4096 -d
> su=65536,sw=4-b size=4096 -d su=131072,sw=4"
> 
> It is also easy to see that _scratch_mkfs_geom does not append leading
> space when it appends the variable.
> 
> Following patch fixes the issue for me and based on my testing does not
> break any other test case:
> 
> diff -uprN xfstests-dev/223 xfstests-dev-new/223
> --- xfstests-dev/223	2010-11-09 08:53:39.000000000 -0500
> +++ xfstests-dev-new/223	2010-11-17 08:05:56.745068628 -0500
> @@ -58,6 +58,7 @@ for SUNIT_K in 8 16 32 64 128; do
>  	let SUNIT_BLOCKS=$SUNIT_BYTES/$BLOCKSIZE
>  
>  	echo "=== mkfs with su $SUNIT_BLOCKS blocks x 4 ==="
> +	export MKFS_OPTIONS=""
>  	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seq.full 2>&1
>  	_scratch_mount
>  
> diff -uprN xfstests-dev/common.rc xfstests-dev-new/common.rc
> --- xfstests-dev/common.rc	2010-11-09 08:53:39.000000000 -0500
> +++ xfstests-dev-new/common.rc	2010-11-17 08:07:06.972132647 -0500
> @@ -349,10 +349,10 @@ _scratch_mkfs_geom()
>  
>      case $FSTYP in
>      xfs)
> -	MKFS_OPTIONS+="-b size=$blocksize, -d su=$sunit_bytes,sw=$swidth_mult"
> +	MKFS_OPTIONS+=" -b size=$blocksize, -d su=$sunit_bytes,sw=
> $swidth_mult"
>  	;;
>      ext4)
> -	MKFS_OPTIONS+="-b $blocksize -E stride=$sunit_blocks,stripe_width=
> $swidth_blocks"
> +	MKFS_OPTIONS+=" -b $blocksize -E stride=$sunit_blocks,stripe_width=
> $swidth_blocks"
>  	;;
>      *)
>  	_notrun "can't mkfs $FSTYP with geometry"
> 
> 
> Signed-off-by: Boris Ranto <branto@redhat.com>


Thanks!

I wonder though ... should we just invoke _scratch_mkfs with the geom options,
and leave MKFS_OPTIONS intact?  That way we could still specify custom options
in the environment.

OTOH they might clash; as long as resetting MKFS_OPTIONS here only affects
this test, it's probably ok.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
