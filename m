Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.mpynet.fi ([82.197.21.85]:54093 "EHLO mx2.mpynet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755864AbdLOO02 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Dec 2017 09:26:28 -0500
Subject: Re: [PATCH] xfs_io: fix exitcode handling (was Re: generic/399 and
 xfs_io pwrite command)
From: Ari Sundholm <ari@tuxera.com>
References: <7235f31f-5427-ff12-11f9-cba98431e71c@tuxera.com>
 <20171204222842.GX4094@dastard>
 <35d2712c-b036-d017-2d42-f74bbc4444a9@tuxera.com>
 <20171205211850.GA5858@dastard> <20171206002638.GB5858@dastard>
 <27b82a44-b889-212f-af74-cad35c103c86@tuxera.com>
Message-ID: <cf9c4f45-6c8c-3bc4-91c6-0707eb64f828@tuxera.com>
Date: Fri, 15 Dec 2017 16:26:26 +0200
MIME-Version: 1.0
In-Reply-To: <27b82a44-b889-212f-af74-cad35c103c86@tuxera.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, Emil Karlson <jkarlson@tuxera.com>, linux-xfs@vger.kernel.org

On 12/14/2017 02:11 PM, Ari Sundholm wrote:
> On 12/06/2017 02:26 AM, Dave Chinner wrote:
>> On Wed, Dec 06, 2017 at 08:18:50AM +1100, Dave Chinner wrote:
>>> On Tue, Dec 05, 2017 at 04:23:43PM +0200, Ari Sundholm wrote:
>>>> On 12/05/2017 12:28 AM, Dave Chinner wrote:
>>>>> On Thu, Nov 30, 2017 at 04:21:47PM +0200, Ari Sundholm wrote:
>>>>>> Hi!
>>>>>>
>>>>>> While debugging an issue, we found out that generic/399 seems to
>>>>>> rely on a behavior that is specific to ext4 in the following section
>>>>>> of code:
>>>>>> ----------------8<--------snip--------8<------------------------------ 
>>>>>>
>>>>>> #
>>>>>> # Write files of 1 MB of all the same byte until we hit ENOSPC.
>>>>>> Note that we
>>>>>> # must not create sparse files, since the contents of sparse files 
>>>>>> are not
>>>>>> # stored on-disk.  Also, we create multiple files rather than one 
>>>>>> big file
>>>>>> # because we want to test for reuse of per-file keys.
>>>>>> #
>>>>>> total_file_size=0
>>>>>> i=1
>>>>>> while true; do
>>>>>>     file=$SCRATCH_MNT/encrypted_dir/file$i
>>>>>>     if ! $XFS_IO_PROG -f $file -c 'pwrite 0 1M' &> $tmp.out; then
>>>>>>         if ! grep -q 'No space left on device' $tmp.out; then
>>>>>>             echo "FAIL: unexpected pwrite failure"
>>>>>>             cat $tmp.out
>>>>>>         elif [ -e $file ]; then
>>>>>>             total_file_size=$((total_file_size + $(stat -c %s 
>>>>>> $file)))
>>>>>>         fi
>>>>>>         break
>>>>>>     fi
>>>>>>     total_file_size=$((total_file_size + $(stat -c %s $file)))
>>>>>>     i=$((i + 1))
>>>>>>     if [ $i -gt $fs_size_in_mb ]; then
>>>>>>         echo "FAIL: filesystem never filled up!"
>>>>>>         break
>>>>>>     fi
>>>>>> done
>>>>>> ----------------8<--------snip--------8<------------------------------ 
>>>>>>
>>>>>>
>>>>>> What happens with ext4 is that the xfs_io command gives a nonzero
>>>>>> exit value not when the pwrite command fails with ENOSPC but during
>>>>>> the *next* iteration when opening the file fails with ENOSPC. Turns
>>>>>> out the pwrite command failing does not cause xfs_io to give a
>>>>>> nonzero exit value.
>>>>>
>>>>> That implies ext4 is returning zero bytes written to the pwrite()
>>>>> call rather than ENOSPC. i.e.:
>>>>>
>>>>>                  bytes = do_pwrite(file->fd, off, cnt, buffersize,
>>>>>                                  pwritev2_flags);
>>>>>                  if (bytes == 0)
>>>>>                          break;
>>>>>                  if (bytes < 0) {
>>>>>                          perror("pwrite");
>>>>>                          return -1;
>>>>>                  }
>>>>>
>>>>> So if it's exiting with no error, then we can't have got an error
>>>> >from ext4 at ENOSPC. If that's the case, it probably should be
>>>>> considered an ext4 bug, not an issue with xfs_io...
>>>>>
>>>>
>>>> No, according to what we've observed, that is not what happens. The
>>>> pwrite() call does fail and errno is ENOSPC after the call. The
>>>> immediate problem is that xfs_io does not reflect this failure in
>>>> its exit value and thus the check in generic/399 does not work in
>>>> this case. Only when open() fails during the next iteration does
>>>> xfs_io give a nonzero exit value and cause the check in the test
>>>> case to allow the test case to end successfully.
>>>
>>> Ah, io/pwrite.c fails to set exitcode on failure iappropriately
>>> before returning. Looks like there is a bunch of xfs_io commands
>>> that fail to do this properly.
>>>
>>>> What is specific to ext4 here is, as stated in my original message,
>>>> that open() fails.
>>>
>>> Because there are no more inodes to allocate (i.e. inode table is
>>> full) and so attempts to create more fail with ENOSPC. The xfs_io
>>> open command set exitcode appropriately, and that's why it finally
>>> triggers a test abort.
>>>
>>> Looks like xfs_io does need fixing to set exitcode appropriately on
>>> all failures...
>>
>> Try the patch below.
>>
> 
> Thanks, I'll try it. Sorry for the late response (was on vacation).
> 

The patch does seem to fix the specific issue with this test case. Thank 
you.

However, it seems there is still some need for discussion and a decision 
on what kind of a change should be merged in xfsprogs, if anything, 
and/or whether the fstests test case itself could be changed (at least 
for now) to accommodate the current xfs_io behavior.

Best regards,
Ari Sundholm
ari@tuxera.com

>> Cheers,
>>
>> Dave.
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

