Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55066 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbfBZWYu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 17:24:50 -0500
Subject: Re: [PATCH 1/2] misc: don't oom the box opening tmpfiles
References: <155114852926.9683.4048206997940455508.stgit@magnolia>
 <ae463130-7e23-9fdc-6a7e-72996492abf8@oracle.com>
 <20190226210516.GI21626@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <8c33c87b-fe79-322a-1885-79aa867ac129@oracle.com>
Date: Tue, 26 Feb 2019 15:24:46 -0700
MIME-Version: 1.0
In-Reply-To: <20190226210516.GI21626@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 2/26/19 2:05 PM, Darrick J. Wong wrote:
> On Tue, Feb 26, 2019 at 12:08:20PM -0700, Allison Henderson wrote:
>> On 2/25/19 7:35 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> For the t_open_tmpfiles tests, limit ourselves to half of file-max so
>>> that we don't OOM the test machine.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>    tests/generic/530 |    2 +-
>>>    tests/generic/531 |    2 +-
>>>    tests/xfs/501     |    2 +-
>>>    tests/xfs/502     |    2 +-
>>>    4 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>>
>>> diff --git a/tests/generic/530 b/tests/generic/530
>>> index a2968d25..2bc4a992 100755
>>> --- a/tests/generic/530
>>> +++ b/tests/generic/530
>>> @@ -42,7 +42,7 @@ _scratch_mount
>>>    # Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
>>>    # so that this test doesn't take forever or OOM the box
>>>    max_files=$((50000 * LOAD_FACTOR))
>>> -max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
>>> +max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / 2 ))
>>>    test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
>>>    	max_files=$max_allowable_files
>>>    ulimit -n $max_files
>>> diff --git a/tests/generic/531 b/tests/generic/531
>>> index f3eb5cde..5d60e4b6 100755
>>> --- a/tests/generic/531
>>> +++ b/tests/generic/531
>>> @@ -44,7 +44,7 @@ nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
>>>    # Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
>>>    # so that this test doesn't take forever or OOM the box
>>>    max_files=$((50000 * LOAD_FACTOR))
>>> -max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
>>> +max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / 2 ))
>>
>> This looks like this would certainly help, but wouldn't we want it to be
>> something more like file-max - file-nr ?  Or something similar?  I'm just
>> thinking the threshold at which we pop the file limit would probably be more
>> dependent on how many files are already allocated about the system.  The 2
>> probably solves it most of the time, but it's certainly possible that
>> file-max / 2 may still be too much in some cases.  Thoughts?
> 
> Admittedly, filemax/2 is a Weasel Number -- we want to avoid running the
> system out of memory, but we also have no idea how much memory actually
> gets consumed by an open tempfile.  On my debug system it's 1664 bytes
> for the inode, 320 bytes for the dentry, and 16 bytes for the unlinked
> backref, but that's not guaranteed.  Ideally we'd stop ourselves at
> (free memory / 2k) tempfiles, but the "2k" part is hard to figure.
> 
> So we just cap ourselves at filemax/2 and hope that filemax is set
> sanely.  I guess we I could go for (filemax-filenr)/2?  Though that
> will cause minor fluctuations in the test behavior across runs on the
> same machine.
> 
> (Though really, lots of things cause fluctuations :P)
> 
> --D

Alrighty then, that makes sense.  It occurred to me later that if the 
test takes any substantial amount of time, file-nr may change many times 
anyway, so trying to use it may get racy.  So it may be more stable as 
you have it.

Thanks for the explanation!  You can add my review:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> 
>>
>> Allison
>>
>>>    test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
>>>    	max_files=$max_allowable_files
>>>    ulimit -n $max_files
>>> diff --git a/tests/xfs/501 b/tests/xfs/501
>>> index 51cdb020..d689145f 100755
>>> --- a/tests/xfs/501
>>> +++ b/tests/xfs/501
>>> @@ -47,7 +47,7 @@ _scratch_mount
>>>    # Set ULIMIT_NOFILE to min(file-max, 30000 files per LOAD_FACTOR)
>>>    # so that this test doesn't take forever or OOM the box
>>>    max_files=$((30000 * LOAD_FACTOR))
>>> -max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
>>> +max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / 2 ))
>>>    test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
>>>    	max_files=$max_allowable_files
>>>    ulimit -n $max_files
>>> diff --git a/tests/xfs/502 b/tests/xfs/502
>>> index bfb063f4..5ad10316 100755
>>> --- a/tests/xfs/502
>>> +++ b/tests/xfs/502
>>> @@ -46,7 +46,7 @@ nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
>>>    # Set ULIMIT_NOFILE to min(file-max, 30000 files per cpu per LOAD_FACTOR)
>>>    # so that this test doesn't take forever or OOM the box
>>>    max_files=$((30000 * LOAD_FACTOR))
>>> -max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
>>> +max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / 2 ))
>>>    test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
>>>    	max_files=$max_allowable_files
>>>    ulimit -n $max_files
>>>
