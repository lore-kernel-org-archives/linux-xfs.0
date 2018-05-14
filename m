Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52320 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752112AbeENX0I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 19:26:08 -0400
Subject: Re: [PATCH V2] test online label ioctl
References: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
 <20180514231100.GE23861@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d4dea5fc-9f68-604d-92ec-c9cd2510db52@sandeen.net>
Date: Mon, 14 May 2018 18:26:07 -0500
MIME-Version: 1.0
In-Reply-To: <20180514231100.GE23861@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On 5/14/18 6:11 PM, Dave Chinner wrote:
> On Mon, May 14, 2018 at 12:09:16PM -0500, Eric Sandeen wrote:
>> This tests the online label ioctl that btrfs has, which has been
>> recently proposed for XFS.
>>
>> To run, it requires an updated xfs_io with the label command and a
>> filesystem that supports it
>>
>> A slight change here to _require_xfs_io_command as well, so that tests
>> which simply fail with "Inappropriate ioctl" can be caught in the
>> common case.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---

<snip>
 
>> +# The maximum filesystem label length, not including terminating NULL
>> +_label_get_max()
>> +{
>> +	case $FSTYP in
>> +	xfs)
>> +		MAXLEN=12
>> +		;;
>> +	btrfs)
>> +		MAXLEN=255
>> +		;;
>> +	*)
>> +		MAXLEN=0
> 
> Why not just _notrun here?

do we want to go through the other steps only to get here and notrun
halfway through?

>> +		;;
>> +	esac
>> +
>> +	echo $MAXLEN
>> +}
>> +
>> +_require_label_get_max()
>> +{
>> +	if [ $(_label_get_max) -eq 0 ]; then
>> +		_notrun "$FSTYP does not define maximum label length"
>> +	fi
> 
> And this check can go away?

We'd like to know if all the validations in this can complete before we
get started, right?  That's why I did it this way.

> Also, shouldn't it be _require_online_label_change() ? And then
> maybe you can move the xfs_io label command check inside it?

Well, we want to know a lot of things:

1) can the kernel code for this filesystem support online label
2) does xfs_io support the label command
3) does this test know the maximum label length to test for this fs

the above stuff is for 3)

>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_scratch
>> +_require_xfs_io_command "label"
>> +_require_label_get_max
>> +
>> +_scratch_mkfs > $seqres.full 2>&1
>> +_scratch_mount
>> +
>> +# Make sure we can set & clear the label
>> +$XFS_IO_PROG -c "label label.$seq" $SCRATCH_MNT
>> +$XFS_IO_PROG -c "label" $SCRATCH_MNT
>> +
>> +# And that userspace can see it now, while mounted
>> +# NB: some blkid has trailing whitespace, filter it out here
>> +blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
>> +
>> +# And that the it is still there when it's unmounted
>> +_scratch_unmount
>> +blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
> 
> Ok, so "LABEL" here is a special blkid match token....

yep

>> +# And that it persists after a remount
>> +_scratch_mount
>> +$XFS_IO_PROG -c "label" $SCRATCH_MNT
>> +
>> +# And that a too-long label is rejected, beyond the interface max:
>> +LABEL=$(perl -e "print 'l' x 257;")
> 
> And now you use it as a variable. Nasty and confusing. Using lower
> case for local variables is the norm, right? I thought we were only
> supposed to use upper case for global test harness variables...

I guess I didn't know about that convention (or forgot)

ok, yeah, that's a little confusing I guess.  *shrug*  I can change it
if you prefer.  Obviously the "blkid -s LABEL" must remain "LABEL"

> But even making it "label" is problematic:
> 
>> +$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT
> 
> because "label" is an xfs_io command. Perhaps call it "fs_label"?

ok

-Eric
