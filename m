Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57700 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752268AbeFHCX5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 22:23:57 -0400
Subject: Re: [PATCH 2/6] xfs: verify extent size hint is valid in inode
 verifier
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-3-david@fromorbit.com> <20180605171015.GJ9437@magnolia>
 <20180607161631.GM25007@magnolia> <20180608011039.GZ10363@dastard>
 <20180608012303.GO25007@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <14b05b8f-74db-1e9c-cd25-81fd22a2dbab@sandeen.net>
Date: Thu, 7 Jun 2018 21:23:53 -0500
MIME-Version: 1.0
In-Reply-To: <20180608012303.GO25007@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 6/7/18 8:23 PM, Darrick J. Wong wrote:
> On Fri, Jun 08, 2018 at 11:10:39AM +1000, Dave Chinner wrote:
>> On Thu, Jun 07, 2018 at 09:16:31AM -0700, Darrick J. Wong wrote:
>>> On Tue, Jun 05, 2018 at 10:10:15AM -0700, Darrick J. Wong wrote:
>>>> On Tue, Jun 05, 2018 at 04:24:19PM +1000, Dave Chinner wrote:
>>>>> From: Dave Chinner <dchinner@redhat.com>
>>>>>
>>>>> There are rules for vald extent size hints. We enforce them when
>>>>> applications set them, but fuzzers violate those rules and that
>>>>> screws us over.
>>>>>
>>>>> This results in alignment assertion failures when setting up
>>>>> allocations such as this in direct IO:
>>>>>
>>>>> XFS: Assertion failed: ap->length, file: fs/xfs/libxfs/xfs_bmap.c, line: 3432
>>>>> ....
>>>>> Call Trace:
>>>>>  xfs_bmap_btalloc+0x415/0x910
>>>>>  xfs_bmapi_write+0x71c/0x12e0
>>>>>  xfs_iomap_write_direct+0x2a9/0x420
>>>>>  xfs_file_iomap_begin+0x4dc/0xa70
>>>>>  iomap_apply+0x43/0x100
>>>>>  iomap_file_buffered_write+0x62/0x90
>>>>>  xfs_file_buffered_aio_write+0xba/0x300
>>>>>  __vfs_write+0xd5/0x150
>>>>>  vfs_write+0xb6/0x180
>>>>>  ksys_write+0x45/0xa0
>>>>>  do_syscall_64+0x5a/0x180
>>>>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>>>
>>>>> And from xfs_db:
>>>>>
>>>>> core.extsize = 10380288
>>>>>
>>>>> Which is not an integer multiple of the block size, and so violates
>>>>> Rule #7 for setting extent size hints. Validate extent size hint
>>>>> rules in the inode verifier to catch this.
>>>>>
>>>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>>>
>>>> Looks ok modulo my comments in the next patch,
>>>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> FWIW when I applied this to xfsprogs I saw an xfs/033 regression:
>>>
>>> Phase 6 - check inode connectivity...
>>> reinitializing root directory
>>> Metadata corruption detected at 0x5555555c60e0, inode 0x80 dinode
>>>
>>> fatal error -- could not iget root inode -- error - 117
>>> [Inferior 1 (process 1178) exited with code 01]
>>> (gdb) l *(0x5555555c60e0)
>>> 0x5555555c60e0 is in libxfs_inode_validate_extsize (xfs_inode_buf.c:729).
>>>
>>> We fail the inode verifier while trying to _iget the root inode so that
>>> we can reinitialize it; I suspect phase 3 is going to need to check the
>>> extent size hints and clear them.
>>
>> I'm actually quite happy to see that the continual process of
>> hardening the kernel verifiers has got to the point where we are
>> starting to expose deficiencies in xfs_repair.
>>
>> Can I wait for the xfsprogs libxfs-4.18-sync branch to pick up these
>> verifier changes before looking at what repair needs to do to avoid
>> it? I don't want to do a forced context switch to
>> debugging/enhancing userspace code right at this moment....
> 
> That's ultimately up to Eric, but since fixing it is nontrivial surgery
> on xfs_repair (and the verifier update patch doesn't itself break the
> build) I'd be fine with fixing it after the 4.18 sync goes in.
> 
> --D

I think that getting it into the kernel and even into the xfsprogs/libxfs
tree for 4.18 is fine as long as we are sure a repair fix will be forthcoming
before 4.18 is done as long as it doesn't blow up regression testing /too/
much...  This kernel<->libxfs<->application coordination
can get a bit chicken-and-eggy sometimes.

I guess this kernel change means that only a latest xfs_repair will make
a latest kernel happy; I guess that's fairly normal.

-Eric

