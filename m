Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40806 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388316AbeGXHot (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 03:44:49 -0400
Subject: Re: [PATCH 2/6] xfs: verify extent size hint is valid in inode
 verifier
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-3-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6196d8ce-03b9-eaae-4a07-d307e35540ca@sandeen.net>
Date: Mon, 23 Jul 2018 23:39:53 -0700
MIME-Version: 1.0
In-Reply-To: <20180605062423.4877-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 6/4/18 11:24 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are rules for vald extent size hints. We enforce them when
> applications set them, but fuzzers violate those rules and that
> screws us over.
> 
> This results in alignment assertion failures when setting up
> allocations such as this in direct IO:
> 
> XFS: Assertion failed: ap->length, file: fs/xfs/libxfs/xfs_bmap.c, line: 3432
> ....
> Call Trace:
>  xfs_bmap_btalloc+0x415/0x910
>  xfs_bmapi_write+0x71c/0x12e0
>  xfs_iomap_write_direct+0x2a9/0x420
>  xfs_file_iomap_begin+0x4dc/0xa70
>  iomap_apply+0x43/0x100
>  iomap_file_buffered_write+0x62/0x90
>  xfs_file_buffered_aio_write+0xba/0x300
>  __vfs_write+0xd5/0x150
>  vfs_write+0xb6/0x180
>  ksys_write+0x45/0xa0
>  do_syscall_64+0x5a/0x180
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> And from xfs_db:
> 
> core.extsize = 10380288
> 
> Which is not an integer multiple of the block size, and so violates
> Rule #7 for setting extent size hints. Validate extent size hint
> rules in the inode verifier to catch this.

So, I think that if I do:

# mkfs.xfs -f -m crc=0 $TEST_DEV
# ./check xfs/229
# ./check xfs/229

I trip the verifier, because I end up with freed inodes on disk with an
extent size hints but zeroed flags.  

xfs_ifree sets di_flags = 0 but doesn't clear di_extsize; xfs_inode_validate_extsize
says if extsize !=0 and the hint flag is set, it fails

Anyone else see this?

(crc=0 needed because that causes us to actually reread the inode chunks
in xfs_iread vs. /* shortcut IO on inode allocation if possible */

-Eric
