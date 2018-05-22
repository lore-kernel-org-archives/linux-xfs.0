Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59386 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbeEVBnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 21:43:04 -0400
Date: Mon, 21 May 2018 18:43:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs regression
Message-ID: <20180522014301.GC14384@magnolia>
References: <446e1035-335f-afe1-3448-8428a338a1ad@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <446e1035-335f-afe1-3448-8428a338a1ad@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 21, 2018 at 05:29:44PM -0700, Dave Jiang wrote:
> Darrick,
> I may have hit an xfs regression that shows up in 4.16 that fails
> xfstest xfs/348. I have bisected it to this commit:
> 9cfb9b47479e237d217dbcfafe034cbf98f45909 ("xfs: provide a centralized
> method for verifying inline fork data")
> 
> # ./check xfs/348
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 skx-ntbusd 4.15.0-rc7+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/pmem0p2
> /mnt/xfstests_scratch
> 
> xfs/348 29s ... - output mismatch (see
> /root/xfstests/xfstests-dev/results//xfs/348.out.bad)
>     --- tests/xfs/348.out       2017-10-19 10:57:22.561819578 -0700
>     +++ /root/xfstests/xfstests-dev/results//xfs/348.out.bad
> 2018-05-21 17:13:39.171256163 -0700
>     @@ -239,7 +239,7 @@
>      would have junked entry "DIR" in directory PARENT_INO
>      would have junked entry "EMPTY" in directory PARENT_INO
>      would have junked entry "FIFO" in directory PARENT_INO
>     -stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
>     +stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning

That was fixed in (xfstests) commit 60ba1274f5d79b.

--D

>      stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
>      stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
>     ...
>     (Run 'diff -u tests/xfs/348.out
> /root/xfstests/xfstests-dev/results//xfs/348.out.bad'  to see the entire
> diff)
> Ran: xfs/348
> Failures: xfs/348
> Failed 1 of 1 tests
> 
> -- 
> 
> Dave Jiang
> Software Engineer, SSG/OTC
> Intel Corp.
> dave.jiang@intel.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
