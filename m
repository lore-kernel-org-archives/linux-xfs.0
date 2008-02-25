Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 12:58:31 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PKwOZA026313
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 12:58:27 -0800
Received: from itchy.spiney.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADA17EBB9AF
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 12:58:50 -0800 (PST)
Received: from itchy.spiney.org (itchy.spiney.org [78.47.118.116]) by cuda.sgi.com with ESMTP id 1AYGi7juNyHpVAMf for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 12:58:50 -0800 (PST)
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9C16261A-AFD8-45A1-AAD5-BFEACB50EE09@spiney.org>
Content-Transfer-Encoding: 7bit
From: Wolfgang Karall <spiney@spiney.org>
Subject: XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c
Date: Mon, 25 Feb 2008 21:58:42 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

today I ran across above error, resulting in an unaccessible FS,  
after remounting once xfs_repair didn't show any signs of errors. At  
the time of the error the machine and also the concerned FS was under  
rather high I/O load (doing test restores of some SVN repositories).

The FS is now working again without a hitch (and did before for close  
to a year), latest operation on the filesystem was an xfs_growfs a  
couple of days ago. I read a couple of reports about similiar errors  
(with differing line numbers), but didn't find conclusive  
information, so I'm asking here what the problem might be.

For details see below, if anything is amiss, please let me know. And  
please CC me on the replies, since I'm not subscribed to the list.

Kind regards
Wolfgang Karall


Full dmesg output of the problem:

---------
Filesystem "dm-13": XFS internal error xfs_trans_cancel at line 1138  
of file fs/xfs/xfs_trans.c. Caller 0xffffffff88158042
Call Trace:
[<ffffffff8814fd54>] :xfs:xfs_trans_cancel+0x5b/0xfe
[<ffffffff88158042>] :xfs:xfs_create+0x58b/0x5dd
[<ffffffff8816053e>] :xfs:xfs_vn_mknod+0x1bd/0x3c8
[<ffffffff8815c793>] :xfs:xfs_buf_rele+0x32/0xa1
[<ffffffff8812bd3d>] :xfs:xfs_da_brelse+0x70/0x9d
[<ffffffff80207138>] kmem_cache_free+0x77/0xca
[<ffffffff8813379b>] :xfs:xfs_dir2_node_lookup+0xa9/0xb8
[<ffffffff8812e887>] :xfs:xfs_dir2_isleaf+0x19/0x4a
[<ffffffff8812f0c4>] :xfs:xfs_dir_lookup+0x100/0x122
[<ffffffff8020f89e>] link_path_walk+0xd3/0xe5
[<ffffffff8023b184>] vfs_create+0xe7/0x12c
[<ffffffff8021adfc>] open_namei+0x18c/0x6a0
[<ffffffff8023beda>] chown_common+0xa5/0xb0
[<ffffffff80227624>] do_filp_open+0x1c/0x3d
[<ffffffff80219a7f>] do_sys_open+0x44/0xc5
[<ffffffff8025be0e>] system_call+0x86/0x8b
[<ffffffff8025bd88>] system_call+0x0/0x8b
Filesystem "dm-13": Corruption of in-memory data detected. Shutting  
down filesystem: dm-13
Please umount the filesystem, and rectify the problem(s)
---------

More information about the used software versions, mount options, etc.:

---------
test:~# uname -a
Linux test 2.6.18-6-xen-amd64 #1 SMP Sun Feb 10 18:02:52 UTC 2008  
x86_64 GNU/Linux
test:~# dpkg -l xfsprogs
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Installed/Config-files/Unpacked/Failed-config/Half- 
installed
|/ Err?=(none)/Hold/Reinst-required/X=both-problems (Status,Err:  
uppercase=bad)
||/ Name                          Version                        
Description
+++-=============================-=============================- 
======================================================================== 
==
ii  xfsprogs                      2.8.11-1                       
Utilities for managing the XFS filesystem
test:~# mount | grep /srv
/dev/mapper/test-srv on /srv type xfs (rw)
test:~# grep /srv /etc/fstab
/dev/test/srv /srv xfs rw 0 2
test:~# xfs_info /srv
meta-data=/dev/test/srv          isize=256    agcount=56,  
agsize=65536 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=3670016, imaxpct=25
          =                       sunit=0      swidth=0 blks,  
unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=2560, version=1
          =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
---------
