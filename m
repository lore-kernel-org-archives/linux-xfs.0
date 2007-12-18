Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 01:20:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBI9KlfB006449
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 01:20:50 -0800
Received: from smtp-tls.univ-nantes.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9F6B495C51
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 01:20:58 -0800 (PST)
Received: from smtp-tls.univ-nantes.fr (Smtp-Tls1.univ-nantes.fr [193.52.101.145]) by cuda.sgi.com with ESMTP id XBR2Qu3LBn4reKS8 for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 01:20:58 -0800 (PST)
Message-ID: <476790D5.6040205@univ-nantes.fr>
Date: Tue, 18 Dec 2007 10:20:21 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: kernel oops on debian , 2.6.18-5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Jacky Carimalo <jacky.carimalo@univ-nantes.fr>

Hello, we got a kernel oops, probably in xfs on a debian kernel.

This volume is on SAN + device mapper.
this is a 1 TB  volume. It was in service for more than 2 ou 3 years. 
There is a high humber of files on it, as this volume serves for a 
rsyncd, where 200+ servers sync their root filesystem on it every day.

here is the oops :

Dec 16 23:27:32 inchgower kernel: XFS internal error 
XFS_WANT_CORRUPTED_GOTO at line 1561 of file fs/xfs/xfs_alloc.c.  Caller 
0xffffffff881857b7
Dec 16 23:27:32 inchgower kernel:
Dec 16 23:27:32 inchgower kernel: Call Trace:
Dec 16 23:27:32 inchgower kernel:  [<ffffffff88183ec0>] 
:xfs:xfs_free_ag_extent+0x19f/0x67f
Dec 16 23:27:32 inchgower kernel:  [<ffffffff881857b7>] 
:xfs:xfs_free_extent+0xa9/0xc9
Dec 16 23:27:32 inchgower kernel:  [<ffffffff88192526>] 
:xfs:xfs_bmap_finish+0xf0/0x169
Dec 16 23:27:32 inchgower kernel:  [<ffffffff881b0185>] 
:xfs:xfs_itruncate_finish+0x172/0x2b3
Dec 16 23:27:32 inchgower kernel:  [<ffffffff881c9683>] 
:xfs:xfs_inactive+0x22e/0x823
Dec 16 23:27:32 inchgower kernel:  [<ffffffff8023e8a9>] 
pagevec_lookup+0x17/0x1e
Dec 16 23:27:32 inchgower kernel:  [<ffffffff8022a5b4>] 
truncate_inode_pages_range+0x1b1/0x277
Dec 16 23:27:32 inchgower kernel:  [<ffffffff881d3146>] 
:xfs:xfs_fs_clear_inode+0xa5/0xec
Dec 16 23:27:32 inchgower kernel:  [<ffffffff8022177b>] 
clear_inode+0xc5/0xf6
Dec 16 23:27:32 inchgower kernel:  [<ffffffff8022dfa0>] 
generic_delete_inode+0xde/0x143
Dec 16 23:27:32 inchgower kernel:  [<ffffffff8020cc6b>] dput+0x135/0x153
Dec 16 23:27:32 inchgower kernel:  [<ffffffff802355c0>] 
sys_renameat+0x19b/0x20a
Dec 16 23:27:32 inchgower kernel:  [<ffffffff8020bee8>] 
_atomic_dec_and_lock+0x39/0x57
Dec 16 23:27:32 inchgower kernel:  [<ffffffff8022ba1e>] 
mntput_no_expire+0x19/0x8b
Dec 16 23:27:32 inchgower kernel:  [<ffffffff8025d2a2>] ia32_sysret+0x0/0xa
Dec 16 23:27:32 inchgower kernel:
Dec 16 23:27:32 inchgower kernel: xfs_force_shutdown(dm-3,0x8) called 
from line 4267 of file fs/xfs/xfs_bmap.c.  Return address = 
0xffffffff88192563
Dec 16 23:27:32 inchgower kernel: Filesystem "dm-3": Corruption of 
in-memory data detected.  Shutting down filesystem: dm-3
Dec 16 23:27:32 inchgower kernel: Please umount the filesystem, and 
rectify the problem(s)

and the kernel  :

inchgower:/var/log# uname -a
Linux inchgower 2.6.18-5-vserver-amd64 #1 SMP Fri Jun 1 00:27:03 UTC 
2007 x86_64 GNU/Linux


Please note that it is not the "generic" debian kernel, but the vserver 
one - but stock etch version anyway. We had not seen any problems with 
this combination, (xfs + debian kernel-vserver) which is very largely 
deployed here. This is a first.

Do you think the problems is due to xfs or other factors ?

Sincerely,

--
Yann Dupont, Cri de l'université de Nantes
Tel: 02.51.12.53.91 - Fax: 02.51.12.58.60 - Yann.Dupont@univ-nantes.fr
