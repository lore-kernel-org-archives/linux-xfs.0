Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 09:08:10 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NG84fB021680
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 09:08:05 -0700
Received: from [85.211.139.192] (helo=sheep.housecafe.de)
	by mail.g-house.de with esmtpsa (TLS-1.0:RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1Hg15D-0003JF-Ji
	for xfs@oss.sgi.com; Mon, 23 Apr 2007 18:08:07 +0200
Received: from localhost ([127.0.0.1] helo=derchris.gotdns.org)
	by sheep.housecafe.de with esmtp (Exim 4.63)
	(envelope-from <lists@nerdbynature.de>)
	id 1Hg156-000417-6z
	for xfs@oss.sgi.com; Mon, 23 Apr 2007 17:08:00 +0100
Message-ID: <20603.194.246.123.250.1177344480.squirrel@derchris.gotdns.org:8080>
In-Reply-To: <Pine.LNX.4.64.0704021914060.3963@sheep.housecafe.de>
References: <Pine.LNX.4.64.0704021914060.3963@sheep.housecafe.de>
Date: Mon, 23 Apr 2007 17:08:00 +0100 (BST)
Subject: Re: possible recursive locking detected
From: "Christian Kujau" <lists@nerdbynature.de>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi there,

On Mon, April 2, 2007 19:18, Christian Kujau wrote:
> when I enabled a few more debug-options in the kernel (vanilla
> 2.6.21-rc5), I came across:
>
> [ INFO: possible recursive locking detected ]
> 2.6.21-rc5 #2

The same happened with -rc7, see below. Can anyone comment if this
is/could lead to a problem?


Thanks,
Christian.

Please see http://nerdbynature.de/bits/2.6.21-rc7/ for full details:

[37380.435689] =============================================
[37380.435703] [ INFO: possible recursive locking detected ]
[37380.435707] 2.6.21-rc7 #6
[37380.435710] ---------------------------------------------
[37380.435715] rm/14081 is trying to acquire lock:
[37380.435719]  (&(&ip->i_lock)->mr_lock){----}, at: [<c0246871>]
xfs_ilock+0x71/0xa0
[37380.435734]
[37380.435735] but task is already holding lock:
[37380.435739]  (&(&ip->i_lock)->mr_lock){----}, at: [<c0246871>]
xfs_ilock+0x71/0xa0
[37380.435749]
[37380.435750] other info that might help us debug this:
[37380.435755] 3 locks held by rm/14081:
[37380.435758]  #0:  (&inode->i_mutex/1){--..}, at: [<c0167196>]
do_unlinkat+0x96/0x160
[37380.435770]  #1:  (&inode->i_mutex){--..}, at: [<c0165475>]
vfs_unlink+0x75/0xe0
[37380.435782]  #2:  (&(&ip->i_lock)->mr_lock){----}, at: [<c0246871>]
xfs_ilock+0x71/0xa0
[37380.435792]
[37380.435792] stack backtrace:
[37380.435798]  [<c0134aa9>] __lock_acquire+0xa99/0x1010
[37380.435808]  [<c0135077>] lock_acquire+0x57/0x70
[37380.435814]  [<c0246871>] xfs_ilock+0x71/0xa0
[37380.435820]  [<c012e408>] down_write+0x38/0x50
[37380.435828]  [<c0246871>] xfs_ilock+0x71/0xa0
[37380.435833]  [<c0246871>] xfs_ilock+0x71/0xa0
[37380.435839]  [<c026bc06>] xfs_lock_dir_and_entry+0xf6/0x100
[37380.435847]  [<c026c287>] xfs_remove+0x197/0x4e0
[37380.435853]  [<c016dce9>] d_instantiate+0x19/0x40
[37380.435860]  [<c016db50>] d_rehash+0x20/0x50
[37380.435868]  [<c0165475>] vfs_unlink+0x75/0xe0
[37380.435875]  [<c0273ce3>] xfs_vn_unlink+0x23/0x60
[37380.435882]  [<c03ce55f>] __mutex_lock_slowpath+0x13f/0x280
[37380.435889]  [<c013394b>] mark_held_locks+0x6b/0x90
[37380.435894]  [<c03ce55f>] __mutex_lock_slowpath+0x13f/0x280
[37380.435900]  [<c03ce55f>] __mutex_lock_slowpath+0x13f/0x280
[37380.435906]  [<c0133ad9>] trace_hardirqs_on+0xb9/0x160
[37380.435913]  [<c0165475>] vfs_unlink+0x75/0xe0
[37380.435919]  [<c03ce552>] __mutex_lock_slowpath+0x132/0x280
[37380.435925]  [<c0165475>] vfs_unlink+0x75/0xe0
[37380.435931]  [<c0164a51>] permission+0x91/0xf0
[37380.435938]  [<c0165489>] vfs_unlink+0x89/0xe0
[37380.435945]  [<c01671d2>] do_unlinkat+0xd2/0x160
[37380.435953]  [<c0102938>] restore_nocheck+0x12/0x15
[37380.435959]  [<c0133ad9>] trace_hardirqs_on+0xb9/0x160
[37380.435967]  [<c0102864>] sysenter_past_esp+0x5d/0x99
[37380.435976]  =======================


-- 
BOFH excuse #442:

Trojan horse ran out of hay
