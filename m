Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 May 2007 09:52:30 -0700 (PDT)
Received: from gab.dneg.com (mail.dneg.com [193.203.82.196])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4BGqNfB019117
	for <xfs@oss.sgi.com>; Fri, 11 May 2007 09:52:25 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gab.dneg.com (Postfix) with ESMTP id DF7594D5F86
	for <xfs@oss.sgi.com>; Fri, 11 May 2007 17:34:53 +0100 (BST)
Received: from gab.dneg.com ([127.0.0.1])
	by localhost (gab.dneg.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TpQDzJTEYiUv for <xfs@oss.sgi.com>;
	Fri, 11 May 2007 17:34:52 +0100 (BST)
Received: from [172.16.10.24] (spinach.dneg.com [172.16.10.24])
	by gab.dneg.com (Postfix) with ESMTP id E13BE4D5EFD
	for <xfs@oss.sgi.com>; Fri, 11 May 2007 17:34:52 +0100 (BST)
Message-ID: <46449B2C.30208@dneg.com>
Date: Fri, 11 May 2007 17:34:52 +0100
From: Evan Fraser <evan@dneg.com>
MIME-Version: 1.0
Subject: updatedb triggers XFS internal error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,
I'm having a problem with one of my linux servers. whenever updatedb is 
run, the following errors occur in the system log.

0x0: c9 00 5a f1 3a 7f 66 be a3 c1 d4 7f e8 1d 6b c9
Filesystem "md0": XFS internal error xfs_da_do_buf(2) at line 2271 of 
file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8817957f

Call Trace:<ffffffff881793ef>{:xfs:xfs_da_do_buf+1513} 
<ffffffff8817957f>{:xfs:xfs_da_read_buf+36}
       <ffffffff8018bfca>{do_lookup+83} 
<ffffffff8817d46f>{:xfs:xfs_dir2_put_dirent64_direct+0}
       <ffffffff8817957f>{:xfs:xfs_da_read_buf+36} 
<ffffffff8817e64d>{:xfs:xfs_dir2_block_getdents+183}
       <ffffffff8817e64d>{:xfs:xfs_dir2_block_getdents+183}
       <ffffffff8817d46f>{:xfs:xfs_dir2_put_dirent64_direct+0}
       <ffffffff8018d173>{link_path_walk+196} 
<ffffffff8816c8db>{:xfs:xfs_bmap_last_offset+226}
       <ffffffff8817d46f>{:xfs:xfs_dir2_put_dirent64_direct+0}
       <ffffffff8817d0a7>{:xfs:xfs_dir2_getdents+222} 
<ffffffff881a740b>{:xfs:xfs_readdir+84}
       <ffffffff881b104d>{:xfs:linvfs_readdir+213} 
<ffffffff80190c9a>{filldir64+0}
       <ffffffff80190c9a>{filldir64+0} <ffffffff80190b4e>{vfs_readdir+154}
       <ffffffff80190dc8>{sys_getdents64+116} 
<ffffffff8010e89e>{tracesys+209}

0x0: 28 ab a5 ec 3e 42 55 1f 76 9e 01 72 72 ee bd f1
Filesystem "md0": XFS internal error xfs_da_do_buf(2) at line 2271 of 
file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8817957f

Call Trace:<ffffffff881793ef>{:xfs:xfs_da_do_buf+1513} 
<ffffffff8817957f>{:xfs:xfs_da_read_buf+36}
       <ffffffff8015dbae>{find_or_create_page+30} 
<ffffffff8817957f>{:xfs:xfs_da_read_buf+36}
       <ffffffff88181686>{:xfs:xfs_dir2_leaf_getdents+1107}
       <ffffffff88181686>{:xfs:xfs_dir2_leaf_getdents+1107}
       <ffffffff8817d46f>{:xfs:xfs_dir2_put_dirent64_direct+0}
       <ffffffff8816c8db>{:xfs:xfs_bmap_last_offset+226} 
<ffffffff8817d46f>{:xfs:xfs_dir2_put_dirent64_direct+0}
       <ffffffff8817d0c3>{:xfs:xfs_dir2_getdents+250} 
<ffffffff881a740b>{:xfs:xfs_readdir+84}
       <ffffffff881b104d>{:xfs:linvfs_readdir+213} 
<ffffffff80190c9a>{filldir64+0}
       <ffffffff80190c9a>{filldir64+0} <ffffffff80190b4e>{vfs_readdir+154}
       <ffffffff80190dc8>{sys_getdents64+116} 
<ffffffff8010e89e>{tracesys+209}

Its a dual opteron system running Fedora Core 4 and running the fedora 
packaged 2.6.12-1.1456_FC4smp kernel.  The filesystem in question is on 
a md stripe raid running across an  Infortrend 1.4TB hardware SCSI raid.

The output from xfs_info is:

meta-data=/user_data             isize=256    agcount=32, 
agsize=11180624 blks
         =                       sectsz=512
data     =                       bsize=4096   blocks=357779520, imaxpct=25
         =                       sunit=16     swidth=32 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=131072 blocks=0, rtextents=0


Any help will be gratefully received!

Cheers, Evan.

-- 
evan@dneg.com
Linux Systems Administrator
Double Negative
tel: +44 (0)20 7534 4400 fax: +44 (0)20 7534 4452
77 shaftesbury avenue, w1d 5du, London
