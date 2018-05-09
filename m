Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965232AbeEIQSH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 May 2018 12:18:07 -0400
Subject: Re: [PATCH] test online label ioctl
References: <fd1e2651-099f-8acd-da4d-a67c1e45cd07@redhat.com>
 <20180509154931.GJ8373@desktop>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <96efb2d0-3cb0-ba1b-35c4-8e6e3df388ac@redhat.com>
Date: Wed, 9 May 2018 11:18:06 -0500
MIME-Version: 1.0
In-Reply-To: <20180509154931.GJ8373@desktop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/9/18 10:49 AM, Eryu Guan wrote:
> On Mon, Apr 30, 2018 at 04:43:18PM -0500, Eric Sandeen wrote:
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
>>

...

>> +# And that it succeeds right at the filesystem max:
>> +case $FSTYP in
>> +xfs)
>> +	MAXLEN=12;
>> +	;;
>> +btrfs)
>> +	MAXLEN=256
> 
> Seems this should be 255, otherwise I got failure like:
> 
> -label = "MAXLABEL"
> +label: Invalid argument
> 
> and MAXLEN=255 makes the test pass with btrfs.

You are correct, I missed that they exclude the trailing
null from the length.  (Sorry, thought I tested this :( )

>> +	;;
>> +*)
>> +	MAXLEN=256
>> +	echo "Your filesystem supports online label, please add max length"
> 
> Perhaps we can introduce a new helper similar to _require_acl_get_max()
> and _notrun the test if current $FSTYP doesn't define a maxlen on
> filesystem label?

Ok, sure.

>> +	;;
>> +esac
>> +LABEL=$(perl -e "print 'o' x $MAXLEN;")
>> +$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT | sed -e 's/o\+/MAXLABEL/'
>> +
>> +# And that it fails just past the filesystem max:
>> +let TOOLONG=MAXLEN+1
>> +LABEL=$(perl -e "print 'o' x $TOOLONG;")
>> +$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/generic/485.out b/tests/generic/485.out
>> new file mode 100644
>> index 0000000..bc54684
>> --- /dev/null
>> +++ b/tests/generic/485.out
>> @@ -0,0 +1,9 @@
>> +QA output created by 485
>> +label = "label.485"
>> +label = "label.485"
>> +SCRATCH_DEV: LABEL="label.485" 
>> +SCRATCH_DEV: LABEL="label.485" 
> 
> There're trailing whitespaces in above two lines, I thought they're the
> output from xfs_io label command at first, but actually I have to remove
> the spaces to make test pass.

It might need a filter, this is output from blkid; it might have changed.
I noticed the whitespace as well but IIRC it works here.

Will look into these and fix stuff up.

Thanks!
-Eric

> Thanks,
> Eryu
> 

