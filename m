Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TLttac162927 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 16:55:55 -0500
Received: from mail.doofus.org (doofus.org [173.8.172.90]) by cuda.sgi.com
	with ESMTP id PsnAOl2CFzI9Nk8f for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 14:55:54 -0700 (PDT)
Message-ID: <4F9DB8E7.9010909@gmail.com>
Date: Sun, 29 Apr 2012 14:55:51 -0700
From: Aaron Williams <aaron.w2@gmail.com>
MIME-Version: 1.0
Subject: Re: Problem recovering XFS filesystem
References: <CAK6JqP3ze2pocsgoKUTZx_J6w-Zc9V=StqDnqG0Gx0v5hw=FGQ@mail.gmail.com>
	<18818650.cGNyynGa9I@saturn>
	<CAK6JqP3Da7E6dumOuvF12uLKXeTKAWdLw3gYs6ZtEhw3WEDQeg@mail.gmail.com>
	<20120429003539.GP9541@dastard>
In-Reply-To: <20120429003539.GP9541@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Hi Dave,

On 04/28/2012 05:35 PM, Dave Chinner wrote:
> On Fri, Apr 27, 2012 at 07:04:48PM -0700, Aaron Williams wrote:
>> On Fri, Apr 27, 2012 at 2:31 PM, Michael Monnerie <
>> michael.monnerie@is.it-management.at> wrote:
>>
>>> Am Donnerstag, 26. April 2012, 13:00:06 schrieb Aaron Williams:
>>>> I was able to recover the filesystem.
>>> So your RAID busted the filesystem. Maybe the devs could want an
>>> xfs_metadump of the FS before your repair, so they can inspect it and
>>> improve xfs_repair.
>>>
>>> Hi Michael,
> <snip story of woe>
>
>> Once that was done Linux refused to mount the XFS partition, I think due to
>> corruption in the log.
> The reason will be in the log. e.g dmesg |tail -100 usually tells
> you why it failed to mount.
I should have included the dmesg output earlier.  Here it is:

Apr 26 12:41:00 flash kernel: [387803.170457] XFS (sdd1): Mounting
Filesystem
Apr 26 12:41:00 flash kernel: [387803.181638] XFS (sdd1): Starting
recovery (logdev: internal)
Apr 26 12:41:00 flash kernel: [387803.453411] XFS: Internal error
XFS_WANT_CORRUPTED_GOTO at line 1530 of file
/home/abuild/rpmbuild/BUILD/kernel-default-3.1.10/linux-3.1/fs/xfs/xfs_alloc.c. 
Caller 0xffffffffa005da7c
Apr 26 12:41:00 flash kernel: [387803.453414]
Apr 26 12:41:00 flash kernel: [387803.453418] Pid: 28185, comm: mount
Tainted: P            3.1.10-22-default #1
Apr 26 12:41:00 flash kernel: [387803.453421] Call Trace:
Apr 26 12:41:00 flash kernel: [387803.453436]  [<ffffffff810042fa>]
dump_trace+0x9a/0x270
Apr 26 12:41:00 flash kernel: [387803.453443]  [<ffffffff815266c3>]
dump_stack+0x69/0x6f
Apr 26 12:41:00 flash kernel: [387803.453486]  [<ffffffffa005b304>]
xfs_free_ag_extent+0x564/0x7c0 [xfs]
Apr 26 12:41:00 flash kernel: [387803.453562]  [<ffffffffa005da7c>]
xfs_free_extent+0xec/0x130 [xfs]
Apr 26 12:41:00 flash kernel: [387803.453641]  [<ffffffffa008b900>]
xlog_recover_process_efi+0x160/0x1b0 [xfs]
Apr 26 12:41:00 flash kernel: [387803.453763]  [<ffffffffa008cbf1>]
xlog_recover_process_efis.isra.8+0x61/0xb0 [xfs]
Apr 26 12:41:00 flash kernel: [387803.453884]  [<ffffffffa00907f0>]
xlog_recover_finish+0x20/0xb0 [xfs]
Apr 26 12:41:00 flash kernel: [387803.454009]  [<ffffffffa009337e>]
xfs_mountfs+0x43e/0x6b0 [xfs]
Apr 26 12:41:00 flash kernel: [387803.454132]  [<ffffffffa00536cd>]
xfs_fs_fill_super+0x1bd/0x270 [xfs]
Apr 26 12:41:00 flash kernel: [387803.454180]  [<ffffffff8114e6a4>]
mount_bdev+0x1b4/0x1f0
Apr 26 12:41:00 flash kernel: [387803.454186]  [<ffffffff8114ef55>]
mount_fs+0x45/0x1d0
Apr 26 12:41:00 flash kernel: [387803.454192]  [<ffffffff81167656>]
vfs_kern_mount+0x66/0xd0
Apr 26 12:41:00 flash kernel: [387803.454197]  [<ffffffff81168a33>]
do_kern_mount+0x53/0x120
Apr 26 12:41:00 flash kernel: [387803.454202]  [<ffffffff8116a4e5>]
do_mount+0x1a5/0x260
Apr 26 12:41:00 flash kernel: [387803.454208]  [<ffffffff8116a98a>]
sys_mount+0x9a/0xf0
Apr 26 12:41:00 flash kernel: [387803.454214]  [<ffffffff81546712>]
system_call_fastpath+0x16/0x1b
Apr 26 12:41:00 flash kernel: [387803.454222]  [<00007f171d3bb97a>]
0x7f171d3bb979
Apr 26 12:41:00 flash kernel: [387803.454230] XFS (sdd1): Failed to
recover EFIs
Apr 26 12:41:00 flash kernel: [387803.454232] XFS (sdd1): log mount
finish failed
Apr
>
>> I have an image of my pre-repaired filesystem by using dd and can try and
>> do a meta dump. The filesystem is 1.9TB in size with about 1.2TB of data in
>> use.
> ISTR that metadump needs the log to be clean first, too.
What is ISTR?

> Cheers,
>
> Dave.
>> -Aaron
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
