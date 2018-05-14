Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:46399 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752078AbeENXMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 19:12:02 -0400
Date: Tue, 15 May 2018 09:11:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] test online label ioctl
Message-ID: <20180514231100.GE23861@dastard>
References: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On Mon, May 14, 2018 at 12:09:16PM -0500, Eric Sandeen wrote:
> This tests the online label ioctl that btrfs has, which has been
> recently proposed for XFS.
> 
> To run, it requires an updated xfs_io with the label command and a
> filesystem that supports it
> 
> A slight change here to _require_xfs_io_command as well, so that tests
> which simply fail with "Inappropriate ioctl" can be caught in the
> common case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (urgh send as proper new thread, sorry)
> 
> This passes on btrfs, _notruns on xfs/ext4 of yore, and passes
> on xfs w/ my online label patchset (as long as xfs_io has the new
> capability)
> 
> V2: Add a max label length helper
>     Set the proper btrfs max label length o_O oops
>     Filter trailing whitespace from blkid output
> 
> 
> diff --git a/common/rc b/common/rc
> index 9ffab7fd..88a99cff 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2158,6 +2158,9 @@ _require_xfs_io_command()
>  		echo $testio | grep -q "Inappropriate ioctl" && \
>  			_notrun "xfs_io $command support is missing"
>  		;;
> +	"label")
> +		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
> +		;;
>  	"open")
>  		# -c "open $f" is broken in xfs_io <= 4.8. Along with the fix,
>  		# a new -C flag was introduced to execute one shot commands.
> @@ -2196,7 +2199,7 @@ _require_xfs_io_command()
>  	rm -f $testfile 2>&1 > /dev/null
>  	echo $testio | grep -q "not found" && \
>  		_notrun "xfs_io $command support is missing"
> -	echo $testio | grep -q "Operation not supported" && \
> +	echo $testio | grep -q "Operation not supported\|Inappropriate ioctl" && \
>  		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
>  	echo $testio | grep -q "Invalid" && \
>  		_notrun "xfs_io $command failed (old kernel/wrong fs/bad args?)"
> @@ -3802,6 +3805,31 @@ _require_scratch_feature()
>  	esac
>  }
>  
> +# The maximum filesystem label length, not including terminating NULL
> +_label_get_max()
> +{
> +	case $FSTYP in
> +	xfs)
> +		MAXLEN=12
> +		;;
> +	btrfs)
> +		MAXLEN=255
> +		;;
> +	*)
> +		MAXLEN=0

Why not just _notrun here?

> +		;;
> +	esac
> +
> +	echo $MAXLEN
> +}
> +
> +_require_label_get_max()
> +{
> +	if [ $(_label_get_max) -eq 0 ]; then
> +		_notrun "$FSTYP does not define maximum label length"
> +	fi

And this check can go away?

Also, shouldn't it be _require_online_label_change() ? And then
maybe you can move the xfs_io label command check inside it?

> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_io_command "label"
> +_require_label_get_max
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount
> +
> +# Make sure we can set & clear the label
> +$XFS_IO_PROG -c "label label.$seq" $SCRATCH_MNT
> +$XFS_IO_PROG -c "label" $SCRATCH_MNT
> +
> +# And that userspace can see it now, while mounted
> +# NB: some blkid has trailing whitespace, filter it out here
> +blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
> +
> +# And that the it is still there when it's unmounted
> +_scratch_unmount
> +blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"

Ok, so "LABEL" here is a special blkid match token....

> +# And that it persists after a remount
> +_scratch_mount
> +$XFS_IO_PROG -c "label" $SCRATCH_MNT
> +
> +# And that a too-long label is rejected, beyond the interface max:
> +LABEL=$(perl -e "print 'l' x 257;")

And now you use it as a variable. Nasty and confusing. Using lower
case for local variables is the norm, right? I thought we were only
supposed to use upper case for global test harness variables...

But even making it "label" is problematic:

> +$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT

because "label" is an xfs_io command. Perhaps call it "fs_label"?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
