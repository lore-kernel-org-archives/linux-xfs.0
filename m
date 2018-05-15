Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50443 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750952AbeEOE3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 00:29:30 -0400
Date: Tue, 15 May 2018 14:29:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] test online label ioctl
Message-ID: <20180515042923.GD10363@dastard>
References: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
 <20180514231100.GE23861@dastard>
 <d4dea5fc-9f68-604d-92ec-c9cd2510db52@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4dea5fc-9f68-604d-92ec-c9cd2510db52@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On Mon, May 14, 2018 at 06:26:07PM -0500, Eric Sandeen wrote:
> On 5/14/18 6:11 PM, Dave Chinner wrote:
> > On Mon, May 14, 2018 at 12:09:16PM -0500, Eric Sandeen wrote:
> >> This tests the online label ioctl that btrfs has, which has been
> >> recently proposed for XFS.
> >>
> >> To run, it requires an updated xfs_io with the label command and a
> >> filesystem that supports it
> >>
> >> A slight change here to _require_xfs_io_command as well, so that tests
> >> which simply fail with "Inappropriate ioctl" can be caught in the
> >> common case.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> 
> <snip>
>  
> >> +# The maximum filesystem label length, not including terminating NULL
> >> +_label_get_max()
> >> +{
> >> +	case $FSTYP in
> >> +	xfs)
> >> +		MAXLEN=12
> >> +		;;
> >> +	btrfs)
> >> +		MAXLEN=255
> >> +		;;
> >> +	*)
> >> +		MAXLEN=0
> > 
> > Why not just _notrun here?
> 
> do we want to go through the other steps only to get here and notrun
> halfway through?
> 
> >> +		;;
> >> +	esac
> >> +
> >> +	echo $MAXLEN
> >> +}
> >> +
> >> +_require_label_get_max()
> >> +{
> >> +	if [ $(_label_get_max) -eq 0 ]; then
> >> +		_notrun "$FSTYP does not define maximum label length"
> >> +	fi
> > 
> > And this check can go away?
> 
> We'd like to know if all the validations in this can complete before we
> get started, right?  That's why I did it this way.

Sure, just trying to be a bit defensive as people often forget
_requires directives when writing new tests....

> > Also, shouldn't it be _require_online_label_change() ? And then
> > maybe you can move the xfs_io label command check inside it?
> 
> Well, we want to know a lot of things:
> 
> 1) can the kernel code for this filesystem support online label
> 2) does xfs_io support the label command
> 3) does this test know the maximum label length to test for this fs
> 
> the above stuff is for 3)

What I was suggesting was doing all of these in one function similar
to _require_xfs_sparse_inodes, _require_meta_uuid, etc:

_require_online_label_change()
{
	# need xfs_io support
	_require_xfs_io_command "label"

	# need fstests knowledge of label size
	[ $(_label_get_max) -eq 0 ] && _notrun "$FSTYP does not define maximum label length"

	# need kernel support
	$XFS_IO_PROG -c label $TEST_DIR > /dev/null 2>&1
	[ $? -ne 0 ] && _notrun "Kernel does not support FS_IOC_GETLABEL"
}

Which also means that the label_f command in xfs_io needs to set the
exitcode to non-zero when the ioctl fails so that xfs_io returns
non-zero on failure...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
