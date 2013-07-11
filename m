Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 508BF7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 20:10:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BAA44AC003
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 18:10:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VEiE3YGsuVPEUH4B for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 18:10:14 -0700 (PDT)
Date: Thu, 11 Jul 2013 11:10:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] large-fs: improve space diversification for ext4
Message-ID: <20130711011011.GU3438@dastard>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
	<1373367918-7516-2-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373367918-7516-2-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On Tue, Jul 09, 2013 at 03:05:16PM +0400, Dmitry Monakhov wrote:
> Currently we allocated several giant files one by one until limit,
> so empty space is located as one chunk which limit code-path coverage.
> This patch consume all space with NUM_SPACE_FILES files (by default 1024)
> each has same size, and when truncate each one by required delta.
> As result we have $NUM_SPACE_FILES chunks of free blocks distributed
> across whole filesystem.
> This should help us to avoid regressions similar to e7c9e3e99adf6c49

Sounds like a good idea - distributing free space around the
filesystem - but why limit this to ext4?  If you turn this into a
generic "largefs fill space" function, it will work just as well
with XFS as it does for ext4, and with any other filesystem that we
want to support --largefs testing on....

I'd also add a CLI option to check to set NUM_SPACE_FILES like we
do for LARGE_SCRATCH_DEV and SCRATCH_DEV_EMPTY_SPACE. I'd probably
also call it SCRATCH_DEV_EMPTY_SPACE_FILES....

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  common/rc |   40 ++++++++++++++++------------------------
>  1 files changed, 16 insertions(+), 24 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index c44acea..902fc19 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -440,12 +440,17 @@ _setup_large_ext4_fs()
>  	fs_empty_space=$((50*1024*1024*1024))
>  
>  	[ "$LARGE_SCRATCH_DEV" != yes ] && return 0
> +	[ -z "$NUM_SPACE_FILES" ] && export NUM_SPACE_FILES=1024
>  	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0	
>  	fs_empty_space=$((fs_empty_space + $SCRATCH_DEV_EMPTY_SPACE))
>  	[ $fs_empty_space -ge $fs_size ] && return 0
>  
>  	# calculate the size of the file we need to allocate.
> +
>  	space_to_consume=$(($fs_size - $fs_empty_space))
> +	file_size_falloc=$(($fs_size/$NUM_SPACE_FILES))
> +	file_size_final=$(($space_to_consume/$NUM_SPACE_FILES))

spaces around "/"

> +
>  	# mount the filesystem and create 16TB - 4KB files until we consume
>  	# all the necessary space.
>  	_scratch_mount 2>&1 >$tmp_dir/mnt.err
> @@ -457,33 +462,20 @@ _setup_large_ext4_fs()
>  		return $status
>  	fi
>  	rm -f $tmp_dir/mnt.err
> -
> -	file_size=$((16*1024*1024*1024*1024 - 4096))
> -	nfiles=0
> -	while [ $space_to_consume -gt $file_size ]; do
> -
> +	mkdir $SCRATCH_MNT/.use_space
> +	# Consume all space on filesytem
> +	for ((nfiles = 0; nfiles < nfiles_total; nfiles++)); do 

Is that bashism supported on older versions of bash? i.e. like the
versions found on RHEL5, SLES10, etc? If not, then a simple:

	for nfiles in `seq 0 1 $nfiles_total`; do

will work just as well....

>  		xfs_io -F -f \

change that to XFS_IO_PROG and we can drop the -F there.

> -			-c "truncate $file_size" \
> -			-c "falloc -k 0 $file_size" \
> -			$SCRATCH_MNT/.use_space.$nfiles 2>&1
> -		status=$?
> -		if [ $status -ne 0 ]; then
> -			break;
> -		fi
> -
> -		space_to_consume=$(( $space_to_consume - $file_size ))
> -		nfiles=$(($nfiles + 1))
> +			-c "truncate $file_size_falloc" \
> +			-c "falloc -k 0 $file_size_falloc" \
> +			$SCRATCH_MNT/.use_space/use_space.$nfiles 2>&1

Is there any need for the truncate + falloc -k? I can't remember why
I did that in the first place. Just a "falloc 0 $file_size_falloc"
shoul dbe sufficient, right?

>  	done
> -
> -	# consume the remaining space.
> -	if [ $space_to_consume -gt 0 ]; then
> +	# Truncate files to smaller size, will free chunks of space
> +	for ((nfiles = 0; nfiles < nfiles_total; nfiles++)); do 
>  		xfs_io -F -f \

Same again for XFS_IO_PROG.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
