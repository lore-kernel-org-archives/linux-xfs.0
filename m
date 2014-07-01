Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA73C7F95
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 17:27:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE3EA8F8035
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 15:27:32 -0700 (PDT)
Received: from mail-qg0-f49.google.com (mail-qg0-f49.google.com
	[209.85.192.49]) by cuda.sgi.com with ESMTP id VwJ7QuNDvDVbZNiB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Jul 2014 15:27:31 -0700 (PDT)
Received: by mail-qg0-f49.google.com with SMTP id f51so3927729qge.36
	for <xfs@oss.sgi.com>; Tue, 01 Jul 2014 15:27:30 -0700 (PDT)
Message-ID: <53B335D1.2010709@gmail.com>
Date: Tue, 01 Jul 2014 18:27:29 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Null pointer dereference while at ACL limit on v5 XFS
References: <53A8A0AF.9070009@gmail.com> <53A8A578.4070005@sgi.com>
	<53A8A676.80305@sgi.com> <53A8F1AC.90109@gmail.com>
	<20140624040434.GC9508@dastard>
In-Reply-To: <20140624040434.GC9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 06/24/2014 12:04 AM, Dave Chinner wrote:
> On Mon, Jun 23, 2014 at 11:34:04PM -0400, Michael L. Semon wrote:
>> [ 1068.431391] ------------[ cut here ]------------
>> [ 1068.431566] WARNING: CPU: 0 PID: 41 at lib/list_debug.c:59 __list_del_entry+0xce/0x110()
>> [ 1068.431596] list_del corruption. prev->next should be db5bf580, but was   (null)
> 
> Ok, so the current log item points to a log item that has
> null pointers (i.e. not on the list).
> 
>> [ 1068.431629] CPU: 0 PID: 41 Comm: kworker/0:1H Not tainted 3.16.0-rc1+ #3
>> [ 1068.431656] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
>> [ 1068.431697] Workqueue: xfslogd xfs_buf_iodone_work
>> [ 1068.431738]  00000000 00000000 de92fc24 c15d4e76 de92fc68 de92fc58 c103ca33 c1737648
>> [ 1068.431891]  de92fc84 00000029 c173705a 0000003b c13c3e9e 0000003b c13c3e9e 0000003b
>> [ 1068.432115]  db5bf580 00000001 de92fc70 c103cab3 00000009 de92fc68 c1737648 de92fc84
>> [ 1068.432267] Call Trace:
>> [ 1068.432329]  [<c15d4e76>] dump_stack+0x48/0x60
>> [ 1068.432386]  [<c103ca33>] warn_slowpath_common+0x83/0xa0
>> [ 1068.432433]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
>> [ 1068.432478]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
>> [ 1068.432524]  [<c103cab3>] warn_slowpath_fmt+0x33/0x40
>> [ 1068.432569]  [<c13c3e9e>] __list_del_entry+0xce/0x110
>> [ 1068.432615]  [<c13c3eeb>] list_del+0xb/0x20
>> [ 1068.432674]  [<c126eb4d>] xfs_ail_delete+0x1d/0x60
> ....
>> [ 1068.433567] ---[ end trace 60289514948e4bd7 ]---
>> [ 1068.433603] BUG: unable to handle kernel NULL pointer dereference at 0000000c
>> [ 1068.433795] IP: [<c126eac8>] xfs_ail_check+0x58/0xc0
> 
> And that's trying to dereference a pointer from an item that is not
> on the list....
> 
> So there's linked list corruption occurring here.
> 
>> I can reproduce the oops in kernel 3.15.0, perhaps with xfs-oss/for-next 
>> merged, but there's no vmlinux to go with the kernel.  Therefore, I'll have 
>> to resort to other means (rebuilt kernel with netconsole, re-attaching the 
>> serial cable, etc.) to get the full crash log.
> 
> How far back can you reproduce it? If it's a recent occurrence, can
> you bisect it?
> 
> Cheers,
> 
> Dave.

I've had terrible luck with bisects this week due to PEBKAC errors.  With 3 
commits left to try--one slow, full build (thanks, ARM!) and hopefully 2 
minor builds--this commit is staring me in the face:

commit bba719b5004234e55737e7074b81b337210c511d
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Wed Jan 1 19:28:03 2014 +0800

    xfs: fix off-by-one error in xfs_attr3_rmt_verify

In particular, one kernel had this as the most recent commit and showed 
the current problem behavior.

That is about as far back as I can go before attr3_rmt issues corrupt 
filesystems and cause a "Structure needs cleaning" message during the setfacl 
part of the test.  Certianly, Jeff has improved matters with this patch.

On the normal kernel git, this may correspond to kernel v3.13.0-rc7 or -rc8, 
certainly no earlier than -rc2.  git was bouncing the version numbers around 
quite a bit.

Before Jeff worked his wonders here, efforts to getfacl a directory with max 
ACLs (on a remounted, corrupt filesystem) ended like this...

[   84.819306] XFS: Assertion failed: args->op_flags & XFS_DA_OP_OKNOENT, file: fs/xfs/xfs_da_btree.c, line: 1894
[   84.819500] ------------[ cut here ]------------
[   84.819573] kernel BUG at fs/xfs/xfs_message.c:108!
[   84.819646] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[   84.819826] CPU: 0 PID: 204 Comm: getfacl Not tainted 3.12.0+ #2
[   84.819901] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
[   84.820015] task: ddc7a960 ti: ddc52000 task.ti: ddc52000
[   84.820025] EIP: 0060:[<c125822c>] EFLAGS: 00010296 CPU: 0
[   84.820025] EIP is at assfail+0x2c/0x30
[   84.820025] EAX: 00000062 EBX: 00000000 ECX: 00000007 EDX: 00000000
[   84.820025] ESI: ddc53d4c EDI: ffffffff EBP: ddc53c88 ESP: ddc53c74
[   84.820025]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   84.820025] CR0: 8005003b CR2: b7632fd0 CR3: 1dc75000 CR4: 000007d0
[   84.820025] Stack:
[   84.820025]  00000000 c160833c c160c854 c15fa532 00000766 ddc53cd0 c1290854 00000001
[   84.820025]  00000002 00000008 275b19c4 ddc53d4c 00000000 ddc74010 00000001 0fe80018
[   84.820025]  00580000 00000f90 00000000 00000000 ddc74010 ddc74014 ddc53d4c ddc53d28
[   84.820025] Call Trace:
[   84.820025]  [<c1290854>] xfs_da3_path_shift+0x264/0x470
[   84.820025]  [<c1291109>] xfs_da3_node_lookup_int+0x259/0x420
[   84.820025]  [<c1261d56>] ? kmem_zone_alloc+0x66/0xe0
[   84.820025]  [<c1261de1>] ? kmem_zone_zalloc+0x11/0xd0
[   84.820025]  [<c126ac77>] xfs_attr_node_get+0x47/0x200
[   84.820025]  [<c126af05>] xfs_attr_get_int+0xd5/0xf0
[   84.820025]  [<c126afb1>] xfs_attr_get+0x91/0xb0
[   84.820025]  [<c12cb993>] xfs_get_acl+0x123/0x2c0
[   84.820025]  [<c12cbb4a>] xfs_xattr_acl_get+0x1a/0x70
[   84.820025]  [<c11441b9>] generic_getxattr+0x49/0x70
[   84.820025]  [<c1144170>] ? SyS_fremovexattr+0xa0/0xa0
[   84.820025]  [<c11435ca>] vfs_getxattr+0x6a/0xa0
[   84.820025]  [<c1143683>] getxattr+0x83/0x1d0
[   84.820025]  [<c1124e14>] ? complete_walk+0x94/0x260
[   84.820025]  [<c11278ac>] ? path_lookupat+0x8c/0xba0
[   84.820025]  [<c1114ddf>] ? kmem_cache_alloc+0x4f/0x280
[   84.820025]  [<c1124ffd>] ? final_putname+0x1d/0x40
[   84.820025]  [<c112890f>] ? user_path_at_empty+0x4f/0x90
[   84.820025]  [<c1120134>] ? SyS_lstat64+0x34/0x40
[   84.820025]  [<c112896d>] ? user_path_at+0x1d/0x30
[   84.820025]  [<c1143c48>] SyS_getxattr+0x58/0xa0
[   84.820025]  [<c14edbb8>] sysenter_do_call+0x12/0x36
[   84.820025] Code: 89 e5 83 ec 14 3e 8d 74 26 00 89 44 24 08 b8 3c 83 60 c1 89 4c 24 10 89 54 24 0c 89 44 24 04 c7 04 24 00 00 00 00 e8 94 fd ff ff <0f> 0b 66 90 55 89 e5 83 ec 14 3e 8d 74 26 00 b9 01 00 00 00 89
[   84.820025] EIP: [<c125822c>] assfail+0x2c/0x30 SS:ESP 0068:ddc53c74 

...and there was no real variation going back to 3.11-rc.  That was 
about as far back as this particular glibc (built against 3.10.32) would 
let Linux boot.

I'm happy to continue the bisect for your benefit, just running behind 
schedule on completing it.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
