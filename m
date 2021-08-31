Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75900C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 00:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E6061004
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 00:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhHaAVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 20:21:11 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:44844 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230523AbhHaAVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 20:21:11 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id F186E108D06;
        Tue, 31 Aug 2021 10:20:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mKrVa-006sjV-17; Tue, 31 Aug 2021 10:20:10 +1000
Date:   Tue, 31 Aug 2021 10:20:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 00/11] Log Attribute Replay
Message-ID: <20210831002010.GS3657114@dread.disaster.area>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8
        a=fJ24RtU005vM5TsVY0cA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 24, 2021 at 03:44:23PM -0700, Allison Henderson wrote:
> Hi all,
> 
> This set is a subset of a larger series parent pointers. Delayed attributes allow
> attribute operations (set and remove) to be logged and committed in the same
> way that other delayed operations do. This allows more complex operations (like
> parent pointers) to be broken up into multiple smaller transactions. To do
> this, the existing attr operations must be modified to operate as a delayed
> operation.  This means that they cannot roll, commit, or finish transactions.
> Instead, they return -EAGAIN to allow the calling function to handle the
> transaction.  In this series, we focus on only the delayed attribute portion.
> We will introduce parent pointers in a later set.
> 
> The set as a whole is a bit much to digest at once, so I usually send out the
> smaller sub series to reduce reviewer burn out.  But the entire extended series
> is visible through the included github links.

Ok, so like I did with Darrick's deferred inactivation series, the
first thing I'm doing here is throwing this patchset at
scalability/performance worklaods and finding out what is different.

I've merged this series with 5.14 + xfs/for-next + xfs-cil-scale and
then run some tests on it. First up is fsmark creating zero length
files w/ 64 byte xattrs. This should stress only shortform attribute
manipulations.

I have not enabled delayed attributes yet (i.e.
/sys/fs/xfs/debug/larp = 0)

First thing I notice is the transaction commit rate during create is
up around 900k/s, so we are doing 3 transactions per inode - 1 for
create, 2 for attributes. That looks like a regression - existing
shortform attribute creation only takes a single transaction commit,
so this workload prior to this patchset only ran at 600k commits/s.

Note that hte only reason I'm getting 900k transactions/s is the
CIL scalability patchset - without that the system tops out at ~800k
transactions/s and so this would be a significant performance
regression (20%) vs the current xfs/for-next code.

Essentially, this looks like we are doing an extra transaction
commit to defer the creation of the attribute, then doing another
transaction to actually modify the attribute. i.e.:

 - 11.04% xfs_attr_set
    - 8.70% xfs_trans_commit
       - 8.69% __xfs_trans_commit
	  - 5.10% xfs_defer_finish_noroll
	     - 3.74% xfs_defer_trans_roll
		- 3.57% xfs_trans_roll
		   - 3.13% __xfs_trans_commit
		      - 3.01% xlog_cil_commit
			   0.66% down_read
			   0.63% xfs_log_ticket_regrant
	     - 1.16% xfs_attr_finish_item
		- 1.06% xfs_trans_attr_finish_update
		   - 1.03% xfs_attr_set_iter
		      - 1.01% xfs_attr_sf_addname
			 - 0.99% xfs_attr_try_sf_addname
			    - 0.61% xfs_attr_shortform_addname
				 0.55% xfs_attr_shortform_add


AFAICT, for non-delayed attributes, this first transaction commit
logs the inode but does not create intent or intent done items
(returns NULL for both operations), so just rolls and runs the
->finish_item. So it would seem that the first transaction just
changes the inode timestamps and does nothing else.

Firstly, this means the inode timestamp change is not atomic w.r.t.
the attribute change the timestamp change relates to and it's
essentially new overhead for the non-delayed path.

Looking at the unlink path, I see the same thing - there's an extra
transaction for the attr remove path, the same as the attr set path.
This drives the unlink path to 1.1 million transaction commits/sec
instead of 800k/s, so it's likely that there's a substantial
performance regression here on a kernel without the CIL scalability
patchset.

IOWs, there's significant behavioural changes with the non-delayed
logging version of this patchset, both in terms of performance and
the atomicity of changes that appear in the journal and hence
recovery behaviour.

At this point I have to ask: why are we trying to retain the "old"
way of doing things (even for testing) if it is substantially
changing behaviour and on-disk journal contents for attribute
modifications?

So, lets turn on delayed logging:

$ sudo sh -c 'echo 1 > /sys/fs/xfs/debug/larp'
$ ~/tests/fsmark-50-test-xfs.sh -t 16 -X 64 -d /dev/mapper/fast -- -l size=2000m -d agcount=67
QUOTA=
MKFSOPTS= -l size=2000m -d agcount=67
DEV=/dev/mapper/fast
THREADS=16
.....

Message from syslogd@test4 at Aug 31 09:12:55 ...
 kernel:[ 2342.737931] XFS: Assertion failed: !test_bit(XFS_LI_DIRTY, &lip->li_flags), file: fs/xfs/xfs_trans.c, line: 652

Instant assert fail and the machine locks up hard.

Actually, now that I reproduce it with a full console trace (which
is terribly interleaved and almost impossible to read) there's
bad stuff all over the place. Null pointer dereferences in
xlog_cil_commit, "sleeping in atomic" failures, and the assert
failure above. 

Ok, run a single thread, and...

[   84.119162] BUG: kernel NULL pointer dereference, address: 000000000000000d
[   84.123541] #PF: supervisor write access in kernel mode
[   84.126028] #PF: error_code(0x0002) - not-present page
[   84.127312] PGD 0 P4D 0 
[   84.127966] Oops: 0002 [#1] PREEMPT SMP
[   84.128960] CPU: 8 PID: 5139 Comm: fs_mark Not tainted 5.14.0-dgc+ #552
[   84.130632] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
[   84.132723] RIP: 0010:xlog_prepare_iovec+0x59/0xe0
[   84.133951] Code: 4c 89 f8 4c 29 e0 48 c1 f8 04 48 39 d0 7d 76 4d 8d 67 10 8b 43 34 8d 50 0c 83 e2 07 74 0c 83 c0 0b 83 c8 07 83 e8 0b 89 43 34 <45> 89 74 24 0c 48 63 43 34 48 03 43 28 49 89 04 24 c7 40 08 69 00
[   84.137980] RSP: 0018:ffffc900021d7838 EFLAGS: 00010202
[   84.138968] RAX: 0000000000000004 RBX: ffff888140f3e100 RCX: 0000000000000006
[   84.140321] RDX: 0000000000000004 RSI: ffffc900021d7880 RDI: ffff888140f3e100
[   84.141671] RBP: ffffc900021d7868 R08: ffffffff82a8fb88 R09: 000000000000494e
[   84.143069] R10: ffff88823ffd5000 R11: 00000000000319c8 R12: 0000000000000001
[   84.144447] R13: ffffc900021d7880 R14: 000000000000001b R15: 0000000000000000
[   84.145825] FS:  00007f51fb33c740(0000) GS:ffff88823bc00000(0000) knlGS:0000000000000000
[   84.147413] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   84.148535] CR2: 000000000000000d CR3: 00000001473b1003 CR4: 0000000000770ee0
[   84.149927] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   84.151291] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   84.152331] PKRU: 55555554
[   84.152732] Call Trace:
[   84.153106]  xfs_attri_item_format+0x87/0x230
[   84.153748]  xlog_cil_commit+0x253/0xa00
[   84.154329]  ? kvmalloc_node+0x79/0x80
[   84.154881]  __xfs_trans_commit+0xc1/0x330
[   84.155490]  xfs_trans_roll+0x53/0xe0
[   84.156027]  xfs_defer_trans_roll+0x10d/0x2b0
[   84.156659]  xfs_defer_finish_noroll+0xb1/0x650
[   84.157312]  __xfs_trans_commit+0x143/0x330
[   84.157918]  xfs_trans_commit+0x10/0x20
[   84.158498]  xfs_attr_set+0x41a/0x4e0
[   84.159030]  xfs_xattr_set+0x8d/0xe0
[   84.159554]  __vfs_setxattr+0x6b/0x90
[   84.160090]  __vfs_setxattr_noperm+0x7d/0x1f0
[   84.160718]  __vfs_setxattr_locked+0xdf/0x100
[   84.161346]  vfs_setxattr+0x9b/0x170
[   84.161862]  setxattr+0x110/0x200
[   84.162346]  ? _raw_spin_unlock+0xe/0x20
[   84.162914]  ? __handle_mm_fault+0xc1b/0x16d0
[   84.163556]  ? __might_sleep+0x49/0x80
[   84.164132]  __x64_sys_fsetxattr+0xb1/0xe0
[   84.164782]  do_syscall_64+0x35/0x80

Ok, there's the first failure.

This looks like it's a problem with xfs_attri_item_{size,format} in
calculating the number of bytes to log. They use ATTR_NVEC_SIZE() to
calculate the number of bytes of copy from the attribute item which
rounds up the length to copy to 4 byte aligned values. I'm not sure
what this function is calculating:

/* iovec length must be 32-bit aligned */
static inline size_t ATTR_NVEC_SIZE(size_t size)
{
        return size == sizeof(int32_t) ? size :
	               sizeof(int32_t) + round_up(size, sizeof(int32_t));
}

It appears to be saying if the size == 4, then return 4, otherwise
return 4 + roundup(size)... which leads me to struct
xfs_attri_log_format:

struct xfs_attri_log_format {
        uint16_t        alfi_type;      /* attri log item type */
        uint16_t        alfi_size;      /* size of this item */
        uint32_t        __pad;          /* pad to 64 bit aligned */
        uint64_t        alfi_id;        /* attri identifier */
        uint64_t        alfi_ino;       /* the inode for this attr operation */
        uint32_t        alfi_op_flags;  /* marks the op as a set or remove */
        uint32_t        alfi_name_len;  /* attr name length */
        uint32_t        alfi_value_len; /* attr value length */
        uint32_t        alfi_attr_flags;/* attr flags */
};

I don't see where the extra 4 bytes for the attribute vector size
comes from. It's not needed to store the length, so this could
oversize the amount of data to be copied from the source
buffer by up to 7 bytes?

I can see that it might need rounding with the existing
log code (because the formatter is responsible for 32 bit alignment
of log vectors), but that goes away with the CIL scalability
patchset that always aligns iovecs to 4 byte alignment so the
formatters do not need to do that.

Hiding it in a "macro" is not necessary, either - look at how
xfs_inode_item_{data,attr}_fork_size handle the rounding up of the
local format fork size. They round up the fork byte count to 4
directly, and the format code copies those bytes because
xfs_idata_realloc() allocates those bytes.

However, for the attribute buffers, this isn't guaranteed. Look at
xfs_xattr_set():

        struct xfs_da_args      args = {
                .dp             = XFS_I(inode),
                .attr_filter    = handler->flags,
                .attr_flags     = flags,
                .name           = name,
                .namelen        = strlen(name),
                .value          = (void *)value,
                .valuelen       = size,
        };

There is no rounding up of the name or value lengths, and these end
up directly referenced by the deferred logging via xfs_attr_log_item()
and attrip->da_args->...

        attrip->attri_name = (void *)attr->xattri_da_args->name;
        attrip->attri_value = attr->xattri_da_args->value;
        attrip->attri_name_len = attr->xattri_da_args->namelen;
        attrip->attri_value_len = attr->xattri_da_args->valuelen;

We then pass those pointers directly to xlog_iovec_copy() but with a
rounded up length that is longer than the source buffer:

        xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
                        attrip->attri_name,
                        ATTR_NVEC_SIZE(attrip->attri_name_len));
        if (attrip->attri_value_len > 0)
                xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
                                attrip->attri_value,
                                ATTR_NVEC_SIZE(attrip->attri_value_len));

So while this might not be the source of the above crash, it's
certainly a bug that needs fixing.

At this point, I'm just going to hack on the code to make it work,
and we can go from there...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
