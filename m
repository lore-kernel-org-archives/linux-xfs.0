Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 13:17:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39KHkX8021415
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 13:17:48 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C46C576E7B7
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 13:18:22 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id lssgL0jXPfGt3HiV for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 13:18:22 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m39KIGF3002009
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 22:18:17 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m39KIGl2002007
	for xfs@oss.sgi.com; Wed, 9 Apr 2008 22:18:16 +0200
Date: Wed, 9 Apr 2008 22:18:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: test 001 oopses starting from today
Message-ID: <20080409201816.GB1866@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

now that the big commit storm from last night hit cvs the tree seems
rathe broken, already in xfsqa 001:

001 15s ...[   79.522114] Assertion failed: ip->i_transp == tp, file:
fs/xfs/xfs_trans_inode.c, line: 258
[   79.525823] ------------[ cut here ]------------
[   79.525900] kernel BUG at fs/xfs/support/debug.c:81!
[   79.525900] invalid opcode: 0000 [#1] SMP 
[   79.525900] Modules linked in: xfs binfmt_misc nfsd auth_rpcgss
exportfs af_packet nfs lockd nfs_acl sunrpc loop psmouse pcspkr
serio_raw evdev
[   79.525900] 
[   79.525900] Pid: 2634, comm: fill Not tainted (2.6.25-rc3 #38)
[   79.525900] EIP: 0060:[<f0a0066e>] EFLAGS: 00010286 CPU: 0
[   79.525900] EIP is at assfail+0x1e/0x30 [xfs]
[   79.525900] EAX: 00000062 EBX: ef713c90 ECX: c011b450 EDX: ec8e7540
[   79.525900] ESI: ef713c90 EDI: ec8ef2d8 EBP: eeba1d98 ESP: eeba1d88
[   79.525900]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   79.525900] Process fill (pid: 2634, ti=eeba0000 task=ec8e7540 task.ti=eeba0000)
[   79.525900] Stack: f0a1366c f0a06195 f0a0617c 00000102 eeba1db0 f09e7d6f 00000001 ef713c90 
[   79.525900]        eeba1dfc ec8ef2d8 eeba1e24 f09cd20a 0000000a 00000000 00000002 00000001 
[   79.525900]        00000040 00000002 eeba1e08 eeba1dfc 00000000 eeba1e14 ef713c90 eeba1e94 
[   79.525900] Call Trace:
[   79.525900]  [<f09e7d6f>] ? xfs_trans_log_inode+0x2f/0xb0 [xfs]
[   79.525900]  [<f09cd20a>] ? xfs_itruncate_finish+0x56a/0x720 [xfs]
[   79.525900]  [<f09ecd63>] ? xfs_free_eofblocks+0x2b3/0x2f0 [xfs]
[   79.525900]  [<f09ef546>] ? xfs_release+0x156/0x1b0 [xfs]
[   79.525900]  [<f09f8fae>] ? xfs_file_release+0xe/0x20 [xfs]
[   79.525900]  [<c017dd16>] ? __fput+0xb6/0x190
[   79.525900]  [<c017dfe9>] ? fput+0x19/0x20
[   79.525900]  [<c017b107>] ? filp_close+0x47/0x70
[   79.525900]  [<c0123c7b>] ? put_files_struct+0x9b/0xb0
[   79.525900]  [<c0123cd2>] ? __exit_files+0x42/0x60
[   79.525900]  [<c0124e82>] ? do_exit+0x172/0x730
[   79.525900]  [<c0138c26>] ? up_read+0x16/0x30
[   79.525900]  [<c0328bc6>] ? do_page_fault+0x186/0x650
[   79.525900]  [<c017d2b8>] ? vfs_write+0xf8/0x130
[   79.525900]  [<c017c960>] ? do_sync_write+0x0/0x110
[   79.525900]  [<c0125469>] ? do_group_exit+0x29/0x80
[   79.525900]  [<c01254cf>] ? sys_exit_group+0xf/0x20
[   79.525900]  [<c0103dd2>] ? sysenter_past_esp+0x5f/0xa5
[   79.525900]  =======================
[   79.525900] Code: 00 e8 27 fc 80 cf c9 c3 90 8d 74 26 00 55 89 e5 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24 04 c7 04 24 6c 36 a1 f0 e8 a2 1f 72 cf <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 83 e0 
[   79.525900] EIP: [<f0a0066e>] assfail+0x1e/0x30 [xfs] SS:ESP 0068:eeba1d88
[   79.525906] ---[ end trace 9d447135ab7111e4 ]---
[   79.526511] Fixing recursive fault but reboot is needed!
