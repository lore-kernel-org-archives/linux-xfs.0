Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D3417FAB
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 15:24:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 128C3304032
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 13:24:18 -0800 (PST)
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com
	[209.85.213.172]) by cuda.sgi.com with ESMTP id
	DHrYgzAdMS5AoDYK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 13:24:16 -0800 (PST)
Received: by mail-ig0-f172.google.com with SMTP id l13so19388007iga.5
	for <xfs@oss.sgi.com>; Mon, 09 Feb 2015 13:24:15 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Feb 2015 13:24:15 -0800
Message-ID: <CAGdUFVbs3kTTAtXjHux5sW-e9j82ouaRN3aEm+-AdVs6NLuJ+g@mail.gmail.com>
Subject: XFS umount with IO errors seems to lead to memory corruption
From: Chris Holcombe <xfactor973@gmail.com>
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
To: xfs@oss.sgi.com

Hi Dave,

http://www.spinics.net/lists/linux-xfs/msg00061.html
Back in Dec 2013 you responded to this message saying that you would
take a look at it.  Was a fix for this ever issued?  I'm seeing very
similar stacktraces:

Feb  7 00:27:32 node008-cont001 kernel: [83405.490909] INFO: task
umount:29224 blocked for more than 120 seconds.
Feb  7 00:27:32 node008-cont001 kernel: [83405.498645]       Tainted:
G        W     3.13.0-39-generic #66-Ubuntu
Feb  7 00:27:32 node008-cont001 kernel: [83405.506273] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb  7 00:27:32 node008-cont001 kernel: [83405.515244] umount
D ffff880c4fc34480     0 29224  29221 0x00000082
Feb  7 00:27:32 node008-cont001 kernel: [83405.515253]
ffff880201211db0 0000000000000086 ffff880c39cb1800 ffff880201211fd8
Feb  7 00:27:32 node008-cont001 kernel: [83405.515260]
0000000000014480 0000000000014480 ffff880c39cb1800 ffff880c33386480
Feb  7 00:27:32 node008-cont001 kernel: [83405.515267]
ffff880c395e4bc8 ffff880c333864c0 ffff880c333864e8 ffff880c33386490
Feb  7 00:27:32 node008-cont001 kernel: [83405.515274] Call Trace:
Feb  7 00:27:32 node008-cont001 kernel: [83405.515298]
[<ffffffff81723109>] schedule+0x29/0x70
Feb  7 00:27:32 node008-cont001 kernel: [83405.515384]
[<ffffffffa023b0c9>] xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
Feb  7 00:27:32 node008-cont001 kernel: [83405.515396]
[<ffffffff810aafd0>] ? prepare_to_wait_event+0x100/0x100
Feb  7 00:27:32 node008-cont001 kernel: [83405.515438]
[<ffffffffa0236f13>] xfs_log_quiesce+0x33/0x70 [xfs]
Feb  7 00:27:32 node008-cont001 kernel: [83405.515479]
[<ffffffffa0236f62>] xfs_log_unmount+0x12/0x30 [xfs]
Feb  7 00:27:32 node008-cont001 kernel: [83405.515510]
[<ffffffffa01ed846>] xfs_unmountfs+0xc6/0x150 [xfs]
Feb  7 00:27:32 node008-cont001 kernel: [83405.515541]
[<ffffffffa01ef211>] xfs_fs_put_super+0x21/0x60 [xfs]
Feb  7 00:27:32 node008-cont001 kernel: [83405.515550]
[<ffffffff811bf452>] generic_shutdown_super+0x72/0xf0
Feb  7 00:27:32 node008-cont001 kernel: [83405.515557]
[<ffffffff811bf707>] kill_block_super+0x27/0x70
Feb  7 00:27:32 node008-cont001 kernel: [83405.515565]
[<ffffffff811bf9ed>] deactivate_locked_super+0x3d/0x60
Feb  7 00:27:32 node008-cont001 kernel: [83405.515572]
[<ffffffff811bffa6>] deactivate_super+0x46/0x60
Feb  7 00:27:32 node008-cont001 kernel: [83405.515578]
[<ffffffff811dcd96>] mntput_no_expire+0xd6/0x170
Feb  7 00:27:32 node008-cont001 kernel: [83405.515584]
[<ffffffff811de31e>] SyS_umount+0x8e/0x100
Feb  7 00:27:32 node008-cont001 kernel: [83405.515591]
[<ffffffff8172f7ed>] system_call_fastpath+0x1a/0x1f


These type of errors are showing up in the logs:

Feb  7 00:27:34 node008-cont001 kernel: [83407.466853] XFS (dm-8):
metadata I/O error: block 0x0 ("xfs_buf_iodone_callbacks") error 19
numblks 1
...
Feb  7 00:27:39 node008-cont001 kernel: [83412.510982] XFS (dm-8):
metadata I/O error: block 0x0 ("xfs_buf_iodone_callbacks") error 19
numblks 1
Feb  7 00:27:44 node008-cont001 kernel: [83417.555152] XFS (dm-8):
metadata I/O error: block 0x0 ("xfs_buf_iodone_callbacks") error 19
numblks 1
...
Feb  7 00:27:54 node008-cont001 kernel: [83427.643428] XFS (dm-8):
metadata I/O error: block 0x0 ("xfs_buf_iodone_callbacks") error 19
numblks 1
Feb  7 00:27:57 node008-cont001 kernel: [83429.879442] XFS:: 568
callbacks suppressed
Feb  7 00:27:57 node008-cont001 kernel: [83429.879450] XFS (dm-8):
Detected failing async write on buffer block 0x0. Retrying async
write.
Feb  7 00:27:57 node008-cont001 kernel: [83429.879450]
Feb  7 00:27:57 node008-cont001 kernel: [83429.931438] XFS (dm-8):
Detected failing async write on buffer block 0x0. Retrying async
write.
Feb  7 00:27:57 node008-cont001 kernel: [83429.931438]
Feb  7 00:27:57 node008-cont001 kernel: [83429.983444] XFS (dm-8):
Detected failing async write on buffer block 0x0. Retrying async
write.
Feb  7 00:27:57 node008-cont001 kernel: [83429.983444]



Thanks for the help!
Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
