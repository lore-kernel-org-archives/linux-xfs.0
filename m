Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Apr 2007 11:35:14 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l32IXskH011758
	for <xfs@oss.sgi.com>; Mon, 2 Apr 2007 11:35:11 -0700
Received: from [77.99.119.196] (helo=77-99-119-196.cable.ubr04.linl.blueyonder.co.uk)
	by mail.g-house.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1HYR6a-0002wK-26
	for xfs@oss.sgi.com; Mon, 02 Apr 2007 20:18:12 +0200
Date: Mon, 2 Apr 2007 19:18:01 +0100 (BST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: possible recursive locking detected
Message-ID: <Pine.LNX.4.64.0704021914060.3963@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

when I enabled a few more debug-options in the kernel (vanilla 
2.6.21-rc5), I came across:

[ INFO: possible recursive locking detected ]
2.6.21-rc5 #2
---------------------------------------------
rm/32198 is trying to acquire lock:
xfs_ilock+0x71/0xa0

but task is already holding lock:
xfs_ilock+0x71/0xa0

other info that might help us debug this:
3 locks held by rm/32198:
do_unlinkat+0x96/0x160
vfs_unlink+0x75/0xe0
xfs_ilock+0x71/0xa0

stack backtrace:
__lock_acquire+0xa99/0x1010
lock_acquire+0x57/0x70
xfs_ilock+0x71/0xa0
down_write+0x38/0x50
xfs_ilock+0x71/0xa0
xfs_ilock+0x71/0xa0
xfs_lock_dir_and_entry+0xf6/0x100
xfs_remove+0x197/0x4e0
d_instantiate+0x19/0x40
d_rehash+0x20/0x50
vfs_unlink+0x75/0xe0
xfs_vn_unlink+0x23/0x60
__mutex_lock_slowpath+0x13f/0x280
mark_held_locks+0x6b/0x90
__mutex_lock_slowpath+0x13f/0x280
__mutex_lock_slowpath+0x13f/0x280
trace_hardirqs_on+0xb9/0x160
vfs_unlink+0x75/0xe0
__mutex_lock_slowpath+0x132/0x280
vfs_unlink+0x75/0xe0
permission+0x91/0xf0
vfs_unlink+0x89/0xe0
do_unlinkat+0xd2/0x160
sysenter_past_esp+0x8d/0x99
trace_hardirqs_on+0xb9/0x160
sysenter_past_esp+0x5d/0x99
  =======================


Is this something I have to worry about?
Please see http://nerdbynature.de/bits/2.6.21-rc5/ for a few more 
details.

Thanks,
Christian.
-- 
BOFH excuse #372:

Forced to support NT servers; sysadmins quit.
