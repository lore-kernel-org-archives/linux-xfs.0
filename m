Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CBB17F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 14:20:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE929AC003
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 12:20:58 -0700 (PDT)
Received: from mail-ve0-f176.google.com (mail-ve0-f176.google.com
	[209.85.128.176]) by cuda.sgi.com with ESMTP id
	nmXSwewCkg8bIzIT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 12:20:57 -0700 (PDT)
Received: by mail-ve0-f176.google.com with SMTP id c13so7345060vea.35
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 12:20:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51EFD68A.40400@sgi.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com> <51EEF949.9020104@gmail.com>
	<51EFD68A.40400@sgi.com>
Date: Wed, 24 Jul 2013 15:20:52 -0400
Message-ID: <CAJzLF9kVPg8tRmzWx_T0X7bkHGMc4CHvMohpS2Y6T46565ad7g@mail.gmail.com>
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
From: "Michael L. Semon" <mlsemon35@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jul 24, 2013 at 9:28 AM, Mark Tinguely <tinguely@sgi.com> wrote:
> On 07/23/13 16:44, Michael L. Semon wrote:
>>
>> On 07/23/2013 05:15 PM, Mark Tinguely wrote:
>>>
>>> On 07/19/13 01:25, Dave Chinner wrote:
>>>>
>>>> From: Dave Chinner<dchinner@redhat.com>
>>>>
>>>> Now that we have the size of the object before the formatting pass
>>>> is called, we can allocation the log vector and it's buffer in a
>>>> single allocation rather than two separate allocations.
>>>>
>>>> Store the size of the allocated buffer in the log vector so that
>>>> we potentially avoid allocation for future modifications of the
>>>> object.
>>>>
>>>> While touching this code, remove the IOP_FORMAT definition.
>>
>>
>>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>>
>>>
>>> Looks good.
>>>
>>> Reviewed-by: Mark Tinguely<tinguely@sgi.com>
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>>
>> I'd like to register a gentle "test this well" protest on this patch.
>> While trying to figure out the origin of an unrelated lockdep, I
>> tried to copy 3 kernel gits from one 2k non-CRC XFS filesystem to
>> another one.  With at least this patch used, the cp operatin stops,
>> leading to not-umountable, not-syncable filesystems.  It might be
>> while copying the 2nd git, or the 3rd git, while copying header files,
>> or while copying those large *.pack files, but it will happen
>> somewhere.
>>
>> A bisect of the issue ends on this patch, but its removal means that
>> 45_49 and 46_49 cannot be applied without good knowledge of the code
>> to be patched.
>>
>> This one's on me for not being able to get good information to Dave.
>> If I can find a way to get trace-cmd to pipe over ssh or something
>> like that, then maybe there's a chance to make a file that `trace-cmd
>> report` can read.  Previous attempts to save to different filesystems
>> or save over NFS and CIFS have all failed.  Will keep trying...
>>
>> For diagnosing this patch, is there an effective trace that is rather
>> small?  And would you need more than just the XFS events?
>>
>> Thanks!
>>
>> Michael
>>
>
> Thanks for the heads up.
>
> If you could please redo the test and get the stack traces with
> /proc/sysrq-trigger and if you kernel works with crash, a core dump. For the
> stack trace, I mostly want to know if it has several "xlog_grant_head_wait"
> entries in it, because ...

There are those entries.  I have a trace from the hung-task detector, from the
previous round of testing.  So if the hard drive light goes out, wait a couple
of minutes for the hung-task detector to kick in.

[ 2640.393845] INFO: task kworker/u2:3:50 blocked for more than 120 seconds.
[ 2640.393939] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2640.394024] kworker/u2:3    D e95d7100     0    50      2 0x00000000
[ 2640.394237] Workqueue: writeback bdi_writeback_workfn (flush-8:16)
[ 2640.394411]  ee987b18 00000092 e95d712c e95d7100 00000001 ee8b5550
0c7183c1 0000021a
[ 2640.394925]  ee986000 ee8b5550 ee986000 c117c369 e9e9ec40 00000001
c11b7f8a c11a990c
[ 2640.395422]  d1693460 00000000 00000246 00000000 ee987b28 00000005
ea335800 00000001
[ 2640.395936] Call Trace:
[ 2640.396029]  [<c117c369>] ? xfs_trans_free+0x5d/0x61
[ 2640.396105]  [<c11b7f8a>] ? xlog_space_left+0x26/0x9f
[ 2640.396203]  [<c11a990c>] ? xfs_iunlock+0x6d/0xc4
[ 2640.396279]  [<c11b8ddc>] ? xlog_grant_head_wait+0x55/0x14d
[ 2640.396378]  [<c13a67b6>] schedule+0x22/0x4e
[ 2640.396451]  [<c11b8df5>] xlog_grant_head_wait+0x6e/0x14d
[ 2640.396550]  [<c11b900b>] xlog_grant_head_check+0x72/0xc1
[ 2640.396626]  [<c11bb44c>] xfs_log_reserve+0xaf/0x22d
[ 2640.396724]  [<c117c813>] ? xfs_trans_alloc+0x1f/0x35
[ 2640.396799]  [<c117cacb>] xfs_trans_reserve+0x1f2/0x1f9
[ 2640.396900]  [<c116081e>] xfs_setfilesize_trans_alloc.isra.5+0x3d/0xa1
[ 2640.396981]  [<c1161d84>] xfs_vm_writepage+0x1ef/0x575
[ 2640.397084]  [<c109efac>] __writepage+0x13/0x39
[ 2640.397159]  [<c109ef99>] ? global_dirtyable_memory+0x39/0x39
[ 2640.397260]  [<c10a086b>] write_cache_pages+0x1c4/0x3f8
[ 2640.397336]  [<c109ef99>] ? global_dirtyable_memory+0x39/0x39
[ 2640.397436]  [<c1064e3f>] ? trace_hardirqs_on_caller+0x14/0x1b1
[ 2640.397514]  [<c11609c2>] ? xfs_vm_writepages+0x22/0x42
[ 2640.397611]  [<c10a0ad6>] generic_writepages+0x37/0x51
[ 2640.397685]  [<c11609da>] xfs_vm_writepages+0x3a/0x42
[ 2640.397782]  [<c10a0b0d>] do_writepages+0x1d/0x2a
[ 2640.397854]  [<c10e7d97>] __writeback_single_inode+0x42/0x229
[ 2640.397952]  [<c10e82de>] writeback_sb_inodes+0x232/0x385
[ 2640.398027]  [<c10e84a4>] __writeback_inodes_wb+0x73/0xa2
[ 2640.398124]  [<c10e8699>] wb_writeback+0x1c6/0x27a
[ 2640.398196]  [<c10e997e>] bdi_writeback_workfn+0x217/0x36d
[ 2640.398294]  [<c104241b>] process_one_work+0x18f/0x454
[ 2640.398367]  [<c10423de>] ? process_one_work+0x152/0x454
[ 2640.398464]  [<c10427d6>] worker_thread+0xf6/0x319
[ 2640.398537]  [<c10426e0>] ? process_one_work+0x454/0x454
[ 2640.398634]  [<c1047c5b>] kthread+0x9e/0xa0
[ 2640.398708]  [<c13a91b7>] ret_from_kernel_thread+0x1b/0x28
[ 2640.398806]  [<c1047bbd>] ? __kthread_parkme+0x5b/0x5b

In previous testing, not much of the SysRq keys worked, and forced crash
didn't seem to have anything XFS in it, like it was reporting the steps needed
to crash.  I'll keep trying and alter my Alt-Shift-SysRq-e-i-e-i-s-u-s-e-i-e-i-o
termination string a bit, maybe set the "Panic on Hung Tasks" settings in
the kernel as well.

> ...I seemed to have triggered a couple log space reservation hangs with
> fsstress one XFS partition and a mega-copy on another partition, but will
> have to graft the new XFS tree onto a Linux 3.10 kernel to get crash (and
> one of my sata controllers) to work again.
>
> Thanks.
>
> --Mark.

Does this have anything to do with the XFS_RSVSP64 kind of strings output
in some test failures, or does that have more to do with speculative
preallocation?

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
