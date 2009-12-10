Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA0cb1c023143 for <xfs@oss.sgi.com>; Wed, 9 Dec 2009 18:38:38 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BC381947734
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2009 16:39:11 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id 4OAVg0OV5F3K7dCn for
	<xfs@oss.sgi.com>; Wed, 09 Dec 2009 16:39:11 -0800 (PST)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.4 #31773)
	id <01NH2OHS78CG90XEVL@mx.isti.cnr.it> for xfs@oss.sgi.com; Thu,
	10 Dec 2009 01:38:57 +0100
Date: Thu, 10 Dec 2009 01:39:16 +0100
From: Asdo <asdo@shiftmail.org>
Subject: Disappointing performance of copy (MD raid + XFS)
Message-id: <4B204334.1000605@shiftmail.org>
MIME-version: 1.0
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
Cc: linux-raid <linux-raid@vger.kernel.org>

Hi all,

I'm copying a bagzillion of files (14TB) from a 26disk MD-raid 6 array 
to a 16disk MD-raid 6 array.
Filesystems are XFS for both arrays.
Kernel is 2.6.31 ubuntu generic-14
Performance is very disappointing, going from 150MB/sec to 22MB/sec 
depending apparently to the size of files it encounters. 150MB/sec is 
when files are 40-80MB in size, 22MB/sec is when files are 1MB in size 
on average, and I think I have seen around 10MB/sec when they are of 
500KB (this transfer at 10MB/sec was in parallel with another faster one 
however).
Doing multiple rsync transfers simultaneously for different files of the 
filesystem does increase the speed, up to a point however, and even 
launching 5 of them I am not able to bring it above 150MB/sec (that's 
the average: it's actually very unstable).

Already tried tweaking: stripe_cache_size, readahead, elevator type and 
its parameters, increasing elevator queue length, some parameters in 
/proc/sys/fs/xfs (randomly without understanding much of the xfs params 
actually), and /proc/sys/vm/*dirty* parameters .
Mount options for destination initially were defaults, then I tried to 
change them via remount to rw,nodiratime,relatime,largeio but without 
much improvements.
The above are the best results I could obtain.

Firstly I tried copying with cp and then with rsync. Not much difference 
between the two.

Rsync is nicer to monitor because it splits in 2 processes, one reads 
only, the other one only writes.

So I have repeatedly catted /proc/pid/stack for the reader and writer 
processes: the *writer* is the bottleneck, and 90% of the times it is 
stuck in one of the following stacktraces:

    [<ffffffffa02ff41d>] xlog_state_get_iclog_space+0xed/0x2d0 
[xfs]                  
    [<ffffffffa02ff76c>] xlog_write+0x16c/0x630 
[xfs]                                 
    [<ffffffffa02ffc6a>] xfs_log_write+0x3a/0x70 
[xfs]                                
    [<ffffffffa030b6d7>] _xfs_trans_commit+0x197/0x3b0 
[xfs]                          
    [<ffffffffa030ff15>] xfs_free_eofblocks+0x265/0x270 
[xfs]                         
    [<ffffffffa031090d>] xfs_release+0x10d/0x1c0 
[xfs]                                
    [<ffffffffa0318200>] xfs_file_release+0x10/0x20 
[xfs]                             
    [<ffffffff81120700>] 
__fput+0xf0/0x210                                            
    [<ffffffff8112083d>] 
fput+0x1d/0x30                                               
    [<ffffffff8111cab8>] 
filp_close+0x58/0x90                                         
    [<ffffffff8111cba9>] 
sys_close+0xb9/0x110                                         
    [<ffffffff81012002>] 
system_call_fastpath+0x16/0x1b                               
    [<ffffffffffffffff>] 0xffffffffffffffff              

---------

    [<ffffffff8107d6cc>] 
down+0x3c/0x50                                               
    [<ffffffffa03176ee>] xfs_buf_lock+0x1e/0x60 
[xfs]                                 
    [<ffffffffa0317869>] _xfs_buf_find+0x139/0x230 
[xfs]                              
    [<ffffffffa03179bb>] xfs_buf_get_flags+0x5b/0x170 
[xfs]                           
    [<ffffffffa0317ae3>] xfs_buf_read_flags+0x13/0xa0 
[xfs]                           
    [<ffffffffa030c9d1>] xfs_trans_read_buf+0x1c1/0x300 
[xfs]                         
    [<ffffffffa02e26c9>] xfs_da_do_buf+0x279/0x6f0 
[xfs]                              
    [<ffffffffa02e2bb5>] xfs_da_read_buf+0x25/0x30 
[xfs]                              
    [<ffffffffa02e7157>] xfs_dir2_block_addname+0x47/0x970 
[xfs]                      
    [<ffffffffa02e5e9a>] xfs_dir_createname+0x13a/0x1b0 
[xfs]                         
    [<ffffffffa0309816>] xfs_rename+0x576/0x660 
[xfs]                                 
    [<ffffffffa031add1>] xfs_vn_rename+0x61/0x70 
[xfs]                                
    [<ffffffff81128766>] 
vfs_rename_other+0xc6/0x100                                  
    [<ffffffff81129b29>] 
vfs_rename+0x109/0x280                                       
    [<ffffffff8112b722>] 
sys_renameat+0x252/0x280                                     
    [<ffffffff8112b766>] 
sys_rename+0x16/0x20                                         
    [<ffffffff81012002>] 
system_call_fastpath+0x16/0x1b                               
    [<ffffffffffffffff>] 
0xffffffffffffffff                                           

----------

    [<ffffffff8107d6cc>] 
down+0x3c/0x50                                                                                 
 
    [<ffffffffa03176ee>] xfs_buf_lock+0x1e/0x60 
[xfs]                                                                    
    [<ffffffffa0317869>] _xfs_buf_find+0x139/0x230 
[xfs]                                                                 
    [<ffffffffa03179bb>] xfs_buf_get_flags+0x5b/0x170 
[xfs]                                                              
    [<ffffffffa0317ae3>] xfs_buf_read_flags+0x13/0xa0 
[xfs]                                                              
    [<ffffffffa030c9d1>] xfs_trans_read_buf+0x1c1/0x300 
[xfs]                                                            
    [<ffffffffa02e26c9>] xfs_da_do_buf+0x279/0x6f0 
[xfs]                                                                 
    [<ffffffffa02e2bb5>] xfs_da_read_buf+0x25/0x30 
[xfs]                                                                 
    [<ffffffffa02e960b>] xfs_dir2_leaf_addname+0x4b/0x8b0 
[xfs]                                                          
    [<ffffffffa02e5ee3>] xfs_dir_createname+0x183/0x1b0 
[xfs]                                                            
    [<ffffffffa030fa4b>] xfs_create+0x45b/0x5f0 
[xfs]                                                                    
    [<ffffffffa031af4b>] xfs_vn_mknod+0xab/0x1c0 
[xfs]                                                                   
    [<ffffffffa031b07b>] xfs_vn_create+0xb/0x10 
[xfs]                                                                    
    [<ffffffff8112967f>] 
vfs_create+0xaf/0xd0                                                                           
 
    [<ffffffff8112975c>] 
__open_namei_create+0xbc/0x100                                                                 
 
    [<ffffffff8112ccd6>] 
do_filp_open+0x9e6/0xac0                                                                       
 
    [<ffffffff8111cc64>] 
do_sys_open+0x64/0x160                                                                         
 
    [<ffffffff8111cd8b>] 
sys_open+0x1b/0x20                                                                             
 
    [<ffffffff81012002>] 
system_call_fastpath+0x16/0x1b                                                                 
 
    [<ffffffffffffffff>] 0xffffffffffffffff         

The xfs_buf_lock trace is more common (about 3 to 1) than the 
xlog_state_get_iclog_space trace.

I don't really understand what are these buffers mentioned in the last 
stack traces (xfs_buf_*)... anybody cares to explain? Is this 
performance bottleneck really related to the disks or the contention on 
buffers locking is e.g. entirely in memory and it's stuck for some other 
reason? Can I assign more memory to xfs so to have more buffers? I have 
32GB ram and it's all free... I also have 8 cores BTW.

The controllers I'm using are 3ware 9650SE so there is a word around 
that they are not optimal in terms of latency, but I didn't expect them 
to be SO bad. Also I'm not sure latency is the bottleneck here because 
XFS could buffer writes and flush just every lots of seconds, and I'm 
pretty sure cp and rsync never do fsync/fdatasync themselves

Thanks in advance for any insight.
Asdo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
