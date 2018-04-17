Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbeDQAwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Apr 2018 20:52:23 -0400
Date: Mon, 16 Apr 2018 17:52:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: prevent creating negative-sized file via
 INSERT_RANGE
Message-ID: <20180417005218.GC5203@magnolia>
References: <20180416204630.177682-1-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180416204630.177682-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

On Mon, Apr 16, 2018 at 01:46:30PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> During the "insert range" fallocate operation, i_size grows by the
> specified 'len' bytes.  XFS verifies that i_size + len < s_maxbytes, as
> it should.  But this comparison is done using the signed 'loff_t', and
> 'i_size + len' can wrap around to a negative value, causing the check to

Hmm.  Looking at that closer, i_size_read returns loff_t, which means
that when your generic/484 test runs, it ends up doing:

if ((loff_t)9223372036854771712 + (loff_t)8192 < (loff_t)9223372036854775807)

This is a signed addition that overflows the long long int, I think.

Yes, it does; the UBSAN checker complains:

================================================================================
UBSAN: Undefined behaviour in fs/xfs/xfs_file.c:783:12
signed integer overflow:
9223372036854771712 + 8192 cannot be represented in type 'long long int'
CPU: 1 PID: 11277 Comm: xfs_io Not tainted 4.17.0-rc1-xfsx #4
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
Call Trace:
 dump_stack+0x7c/0xbb
 ubsan_epilogue+0x9/0x40
 handle_overflow+0xc7/0xf0
 ? xfs_ilock+0x2ae/0x450 [xfs]
 xfs_file_fallocate+0x41d/0x4e0 [xfs]
 vfs_fallocate+0x132/0x250
 ksys_fallocate+0x3c/0x70
 __x64_sys_fallocate+0x1a/0x20
 do_syscall_64+0x56/0x180
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f38f4a4d2cf
RSP: 002b:00007ffe289615c0 EFLAGS: 00000293 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f38f4a4d2cf
RDX: 0000000000000000 RSI: 0000000000000020 RDI: 0000000000000003
RBP: 0000000000000020 R08: 0000000000000000 R09: 1999999999999999
R10: 0000000000002000 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000002000 R14: 00000000012bcbd0 R15: 00000000012bc3e0
================================================================================

So I think we can't rely on the addition working properly and this code
has to be rearranged to use subtraction:

loff_t		isize;

isize = i_size_read(inode);

/*
 * New inode size must not exceed ->s_maxbytes, accounting for
 * possible signed overflow.
 */
if (inode->i_sb->s_maxbytes - isize < len) {
	error = -EFBIG;
	goto out_unlock;
}

if (offset & blksize_mask || len & blksize_mask) {
	error = -EINVAL;
	goto out_unlock;
}

new_size = isize + len;

I think?  Integer wrap always ties my brain in knots.

--D

> incorrectly pass, resulting in an inode with "negative" i_size.  This is
> possible on 64-bit platforms, where XFS sets s_maxbytes = LLONG_MAX.
> ext4 and f2fs don't run into this because they set a smaller s_maxbytes.
> 
> Fix it by doing an unsigned comparison instead.
> 
> Reproducer:
>     xfs_io -f file -c "truncate $(((1<<63)-1))" -c "finsert 0 4096"
> 
> Fixes: a904b1ca5751 ("xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate")
> Cc: <stable@vger.kernel.org> # v4.1+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/xfs/xfs_file.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 299aee4b7b0b..56a820efeb2a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -786,8 +786,11 @@ xfs_file_fallocate(
>  			goto out_unlock;
>  		}
>  
> -		/* check the new inode size does not wrap through zero */
> -		if (new_size > inode->i_sb->s_maxbytes) {
> +		/*
> +		 * New inode size must not exceed ->s_maxbytes, accounting for
> +		 * possible signed overflow.
> +		 */
> +		if ((u64)new_size > inode->i_sb->s_maxbytes) {
>  			error = -EFBIG;
>  			goto out_unlock;
>  		}
> -- 
> 2.17.0.484.g0c8726318c-goog
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
