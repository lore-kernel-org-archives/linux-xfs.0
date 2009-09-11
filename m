Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8B9GIbw017544 for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 04:16:19 -0500
Received: from smtp-rs1.it.helsinki.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6199314A9731
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 02:17:27 -0700 (PDT)
Received: from smtp-rs1.it.helsinki.fi (smtp-rs1.it.helsinki.fi
	[128.214.148.199]) by cuda.sgi.com with ESMTP id
	GO0rRxEAF5R8Q6KP for <xfs@oss.sgi.com>;
	Fri, 11 Sep 2009 02:17:27 -0700 (PDT)
Received: from [127.0.0.1] (mli105.lib.helsinki.fi [193.166.183.105])
	by smtp-rs1.it.helsinki.fi (8.13.1/8.13.1) with ESMTP id n8B9HQ8K017643
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 12:17:26 +0300
Message-ID: <4AAA15A6.8070700@helsinki.fi>
Date: Fri, 11 Sep 2009 12:17:26 +0300
From: Riku Paananen <riku.paananen@helsinki.fi>
MIME-Version: 1.0
Subject: xfs_repair hangs at Phase 6
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello.

I have a 39TB xfs filesystem in a SAN that got corrupted. The reasons 
for the corruption are unclear. I've been trying to fix it using 
xfs_repair but the repair operation always hangs at Phase 6 "traversing 
filesystem ...".

Here's some information about the distro, kernel and xfsprogs versions 
I'm using.

server:~# cat /etc/debian_version
5.0.2
server:~# uname -a
Linux server 2.6.16.62-c4 #7 SMP Tue Oct 14 14:45:38 EDT 2008 x86_64 
GNU/Linux
server:~# apt-cache show coraid-xfsprogs
Package: coraid-xfsprogs
Version: 2.9.4-1-2
Architecture: amd64
Essential: no
Provides: xfsprogs, fsck-backend
Conflicts: xfsprogs
Depends: libc6 (>= 2.3.5-1)
Installed-Size: 12056
Maintainer: Ed L Cashin <ecashin@coraid.com>
Priority: optional
Section: admin
Filename: pool/main/c/coraid-xfsprogs/coraid-xfsprogs_2.9.4-1-2_amd64.deb
Size: 4279420
SHA1: efd8573f4bd06c2a3ff39978042967e8bbdbdd18
MD5sum: 9e255d427272b646cb25218a36e70421
Description: Utilities and development files for XFS
 This coraid-xfsprogs package is compatible with coraid-kernel and
 contains XFS-related programs like mkfs.xfs and xfs_growfs.

server:~#

I don't have xfs_info or xfs_check on this system. It's not possible 
(not recommended by the supplier of the system) to upgrade xfsprogs.

Here's what made me find out something's wrong:

Aug 25 02:16:45 server.domain local@server kernel: 0x0: 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00
Aug 25 02:16:45 server.domain local@server kernel: Filesystem 
"etherd/e100.0": XFS internal error xfs_da_do_buf(2) at line 2221 of 
file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff880e3586
Aug 25 02:16:45 server.domain local@server kernel:
Aug 25 02:16:45 server.domain local@server kernel: Call Trace: 
<ffffffff880f27ff>{:xfs:xfs_error_report+50}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff880e3586>{:xfs:xfs_da_read_buf+26} 
<ffffffff880f2903>{:xfs:xfs_corruption_error+256}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff881148ec>{:xfs:kmem_zone_alloc+76} 
<ffffffff8810b4af>{:xfs:xfs_trans_read_buf+85}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff880e3449>{:xfs:xfs_da_do_buf+1299} 
<ffffffff880e3586>{:xfs:xfs_da_read_buf+26}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff880e3586>{:xfs:xfs_da_read_buf+26} 
<ffffffff880eab28>{:xfs:xfs_dir2_leaf_getdents+1061}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff880eab28>{:xfs:xfs_dir2_leaf_getdents+1061}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff880e6cb7>{:xfs:xfs_dir2_put_dirent64_direct+0}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff880e6cb7>{:xfs:xfs_dir2_put_dirent64_direct+0}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff880e72a4>{:xfs:xfs_dir2_getdents+246} 
<ffffffff8810f5e6>{:xfs:xfs_readdir+83}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff881185ac>{:xfs:linvfs_readdir+172} <ffffffff80178e4c>{filldir+0}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff80178e4c>{filldir+0} <ffffffff80178f76>{vfs_readdir+101}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff801791ee>{sys_getdents+122} <ffffffff8010b739>{error_exit+0}
Aug 25 02:16:45 server.domain local@server kernel: 
<ffffffff8010aaa6>{system_call+126}

The filesystem is mountable and usable. However there was one directory 
with corrupted files in it. I first ran xfs_repair with no additional 
options and  - even though it hung at Phase 6 and I eventually killed it 
- it did fix this directory. However I'd rather have the repair 
operation finish to be sure everything's ok.

I have also tried running xfs_repair with the '-P' option and it's 
currently running with the '-n' option. At the moment it's been stuck at 
Phase 6 for about 36 hours. I don't see any activity with strace.

Here's the output for the current '-n' run:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...


Please let me know if there's anything I can do and please ask for any 
additional information you may need.

Cheers,

Riku Paananen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
