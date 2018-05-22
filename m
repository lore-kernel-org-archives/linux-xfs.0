Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26250 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbeEVPlx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 11:41:53 -0400
Subject: Re: xfs regression
References: <446e1035-335f-afe1-3448-8428a338a1ad@intel.com>
 <20180522014301.GC14384@magnolia>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <62c622e2-6afb-1df1-b83b-8c2918b66191@intel.com>
Date: Tue, 22 May 2018 08:41:51 -0700
MIME-Version: 1.0
In-Reply-To: <20180522014301.GC14384@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 05/21/2018 06:43 PM, Darrick J. Wong wrote:
> On Mon, May 21, 2018 at 05:29:44PM -0700, Dave Jiang wrote:
>> Darrick,
>> I may have hit an xfs regression that shows up in 4.16 that fails
>> xfstest xfs/348. I have bisected it to this commit:
>> 9cfb9b47479e237d217dbcfafe034cbf98f45909 ("xfs: provide a centralized
>> method for verifying inline fork data")
>>
>> # ./check xfs/348
>> FSTYP         -- xfs (non-debug)
>> PLATFORM      -- Linux/x86_64 skx-ntbusd 4.15.0-rc7+
>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
>> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/pmem0p2
>> /mnt/xfstests_scratch
>>
>> xfs/348 29s ... - output mismatch (see
>> /root/xfstests/xfstests-dev/results//xfs/348.out.bad)
>>     --- tests/xfs/348.out       2017-10-19 10:57:22.561819578 -0700
>>     +++ /root/xfstests/xfstests-dev/results//xfs/348.out.bad
>> 2018-05-21 17:13:39.171256163 -0700
>>     @@ -239,7 +239,7 @@
>>      would have junked entry "DIR" in directory PARENT_INO
>>      would have junked entry "EMPTY" in directory PARENT_INO
>>      would have junked entry "FIFO" in directory PARENT_INO
>>     -stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
>>     +stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
> 
> That was fixed in (xfstests) commit 60ba1274f5d79b.
> 
> --D

Ah sorry my bad. Forgot to update my xfstests to the latest.

> 
>>      stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
>>      stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
>>     ...
>>     (Run 'diff -u tests/xfs/348.out
>> /root/xfstests/xfstests-dev/results//xfs/348.out.bad'  to see the entire
>> diff)
>> Ran: xfs/348
>> Failures: xfs/348
>> Failed 1 of 1 tests
>>
>> -- 
>>
>> Dave Jiang
>> Software Engineer, SSG/OTC
>> Intel Corp.
>> dave.jiang@intel.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
