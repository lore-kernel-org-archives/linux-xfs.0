Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1I86DxC036206 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 02:06:14 -0600
Received: from smtpout7.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6662C13B623A
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 00:07:29 -0800 (PST)
Received: from smtpout7.poczta.onet.pl (smtpout7.poczta.onet.pl
	[213.180.147.167]) by cuda.sgi.com with ESMTP id
	EgNpdoS0Fg3KzpDk for <xfs@oss.sgi.com>;
	Thu, 18 Feb 2010 00:07:29 -0800 (PST)
Received: from ip-83-238-22-2.netia.com.pl ([83.238.22.2]:46342 "EHLO
	[192.168.242.3]" rhost-flags-OK-FAIL-OK-FAIL) by ps3.m5r2.onet
	with ESMTPA id S134218505Ab0BRIH21tX7i (ORCPT
	<rfc822;xfs@oss.sgi.com>); Thu, 18 Feb 2010 09:07:28 +0100
Message-ID: <4B7CF542.6090501@poczta.onet.pl>
Date: Thu, 18 Feb 2010 09:07:30 +0100
From: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
MIME-Version: 1.0
Subject: Re: XFS problems with 2.6.27
References: <4B717CCD.3040008@poczta.onet.pl>
In-Reply-To: <4B717CCD.3040008@poczta.onet.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3452350151727847851=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============3452350151727847851==
Content-Type: multipart/alternative;
 boundary="------------010709070209000402040409"

This is a multi-part message in MIME format.
--------------010709070209000402040409
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Can somebody help with this problem? If you need more details, please
let me know.
> Hello!
>
> We"ve got two different systems running with XFS, one of them is
> publishing shares via NFS, the other via Samba. We've recently
> encountered filesystem issues on both servers, and received the
> following call traces. They look very much alike.
>
> Are these something you are familiar with? We'd like to at least
> establish that the problem really is with XFS... We don't really have
> the possibility to update the kernels (2.6.27.10) on those machines, but
> we can possibly apply patches etc. These systems are usually under a
> fairly high load and host a large number of files.
>
>
> Filesystem "dm-16": Disabling barriers, trial barrier write failed        
> XFS mounting filesystem dm-16                                             
> Starting XFS recovery on filesystem: dm-16 (logdev: internal)             
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1590 of file
> fs/xfs/xfs_alloc.c.  Caller 0xffffffff80398ca7
> Pid: 15745, comm: mount Not tainted 2.6.27.10
> #24                                                            
>
> Call Trace:
>  [<ffffffff80396fb8>] xfs_free_ag_extent+0x378/0x740
>  [<ffffffff80398ca7>] xfs_free_extent+0xc7/0x110   
>  [<ffffffff803d7642>] xlog_recover_process_efi+0x122/0x1a0
>  [<ffffffff803d7727>] xlog_recover_process_efis+0x67/0x90
>  [<ffffffff803d87dc>] xlog_recover_finish+0x1c/0xd0      
>  [<ffffffff803d0790>] xfs_log_mount_finish+0x20/0x30     
>  [<ffffffff803dac3d>] xfs_mountfs+0x2bd/0x640            
>  [<ffffffff803c0440>] xfs_fstrm_free_func+0x0/0x90       
>  [<ffffffff803dbaca>] xfs_mru_cache_create+0x15a/0x1c0   
>  [<ffffffff803f2c04>] xfs_fs_fill_super+0x214/0x450      
>  [<ffffffff80299100>] set_bdev_super+0x0/0x10            
>  [<ffffffff8029925f>] get_sb_bdev+0x13f/0x180            
>  [<ffffffff803f29f0>] xfs_fs_fill_super+0x0/0x450        
>  [<ffffffff802994f1>] vfs_kern_mount+0x81/0x160          
>  [<ffffffff8029961d>] do_kern_mount+0x4d/0x110           
>  [<ffffffff802b0fbb>] do_new_mount+0x9b/0xe0             
>  [<ffffffff802b1849>] do_mount+0x209/0x220               
>  [<ffffffff80274ea2>] __alloc_pages_internal+0x92/0x430  
>  [<ffffffff802752d7>] __get_free_pages+0x17/0x80         
>  [<ffffffff802cbdf4>] compat_sys_mount+0xa4/0x270        
>  [<ffffffff80228282>] ia32_sysret+0x0/0xa                
>
> Failed to recover EFIs on filesystem: dm-16
> XFS: log mount finish failed              
> NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> NFSD: starting 90-second grace period                                   
> bootsplash: status on console 0 changed to off                          
> usb 3-2: USB disconnect, address 2                                      
> 00000000: 00 00 00 00 00 28 00 e0 00 00 00 00 00 00 00 00  .....(..........
> Filesystem "dm-20": XFS internal error xfs_da_do_buf(2) at line 2112 of
> file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff803b34b4
> Pid: 23023, comm: smbd Not tainted 2.6.27.10
> #24                                                                             
>
>
> Call Trace:
>  [<ffffffff803b33b6>] xfs_da_do_buf+0x626/0x6b0
>  [<ffffffff803b34b4>] xfs_da_read_buf+0x24/0x30
>  [<ffffffff8023ee0f>] try_to_del_timer_sync+0x4f/0x60
>  [<ffffffff803b34b4>] xfs_da_read_buf+0x24/0x30     
>  [<ffffffff803b77e5>] xfs_dir2_block_lookup_int+0x45/0x1a0
>  [<ffffffff803b77e5>] xfs_dir2_block_lookup_int+0x45/0x1a0
>  [<ffffffff803b7958>] xfs_dir2_block_lookup+0x18/0xc0    
>  [<ffffffff803b624f>] xfs_dir2_isblock+0x1f/0x60         
>  [<ffffffff803b696d>] xfs_dir_lookup+0x19d/0x1c0         
>  [<ffffffff803e3267>] xfs_lookup+0x57/0xd0               
>  [<ffffffff8069dfd9>] _spin_lock_bh+0x9/0x20             
>  [<ffffffff803ee6e4>] xfs_vn_lookup+0x64/0xc0            
>  [<ffffffff802a9f95>] d_alloc+0x125/0x1b0                
>  [<ffffffff8029f155>] do_lookup+0x175/0x220              
>  [<ffffffff8029ea79>] generic_permission+0x69/0x130      
>  [<ffffffff8029fa01>] __link_path_walk+0x801/0xdb0       
>  [<ffffffff805de663>] sock_aio_read+0x163/0x170          
>  [<ffffffff802a0007>] path_walk+0x57/0xb0                
>  [<ffffffff802a0183>] do_path_lookup+0x123/0x1b0         
>  [<ffffffff802a06f4>] user_path_at+0x44/0x80             
>  [<ffffffff8024a450>] autoremove_wake_function+0x0/0x30  
>  [<ffffffff802af5c1>] mntput_no_expire+0x21/0x120        
>  [<ffffffff8029a1f3>] vfs_stat_fd+0x23/0x80              
>  [<ffffffff8022879f>] sys32_stat64+0x1f/0x70             
>  [<ffffffff80228282>] ia32_sysret+0x0/0xa                
>
> 00000000: 00 00 00 00 00 28 00 e0 00 00 00 00 00 00 00 00  .....(..........
> Filesystem "dm-20": XFS internal error xfs_da_do_buf(2) at line 2112 of
> file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff803b34b4
> Pid: 23023, comm: smbd Not tainted 2.6.27.10
> #24                                                                             
>
>
> Call Trace:
>  [<ffffffff803b33b6>] xfs_da_do_buf+0x626/0x6b0
>  [<ffffffff803b34b4>] xfs_da_read_buf+0x24/0x30
>  [<ffffffff8023ee0f>] try_to_del_timer_sync+0x4f/0x60
>  [<ffffffff803b34b4>] xfs_da_read_buf+0x24/0x30     
>  [<ffffffff803b77e5>] xfs_dir2_block_lookup_int+0x45/0x1a0
>  [<ffffffff803b77e5>] xfs_dir2_block_lookup_int+0x45/0x1a0
>  [<ffffffff803b7958>] xfs_dir2_block_lookup+0x18/0xc0    
>  [<ffffffff803b624f>] xfs_dir2_isblock+0x1f/0x60         
>  [<ffffffff803b696d>] xfs_dir_lookup+0x19d/0x1c0         
>  [<ffffffff803e3267>] xfs_lookup+0x57/0xd0               
>  [<ffffffff8069dfd9>] _spin_lock_bh+0x9/0x20             
>  [<ffffffff803ee6e4>] xfs_vn_lookup+0x64/0xc0            
>  [<ffffffff802a9f95>] d_alloc+0x125/0x1b0                
>  [<ffffffff8029f155>] do_lookup+0x175/0x220              
>  [<ffffffff8029ea79>] generic_permission+0x69/0x130      
>  [<ffffffff8029fa01>] __link_path_walk+0x801/0xdb0       
>  [<ffffffff805de663>] sock_aio_read+0x163/0x170          
>  [<ffffffff802a0007>] path_walk+0x57/0xb0                
>  [<ffffffff802a0183>] do_path_lookup+0x123/0x1b0         
>  [<ffffffff802a06f4>] user_path_at+0x44/0x80             
>  [<ffffffff8024a450>] autoremove_wake_function+0x0/0x30  
>  [<ffffffff802af5c1>] mntput_no_expire+0x21/0x120        
>  [<ffffffff8029a1f3>] vfs_stat_fd+0x23/0x80              
>  [<ffffffff8022879f>] sys32_stat64+0x1f/0x70             
>  [<ffffffff80228282>] ia32_sysret+0x0/0xa
>
>
> >From the other system we only have these logs:
>
> 2010/01/27 00:22:07|Pid: 17209, comm: nfsd Not tainted 2.6.27.10 #12
> 2010/01/27 00:22:07|
> 2010/01/27 00:22:07|Call Trace:
> 2010/01/27 00:22:07|[<ffffffff803b33b6>] xfs_da_do_buf+0x626/0x6b0
> 2010/01/27 00:22:07|[<ffffffff803b34b4>] xfs_da_read_buf+0x24/0x30
> 2010/01/27 00:22:07|[<ffffffff803ead07>] xfs_buf_read_flags+0x67/0x90
> 2010/01/27 00:22:07|[<ffffffff803df247>] xfs_trans_read_buf+0x147/0x310
> 2010/01/27 00:22:07|[<ffffffff803b34b4>] xfs_da_read_buf+0x24/0x30
> 2010/01/27 00:22:07|[<ffffffff803b3748>] xfs_da_node_lookup_int+0x88/0x2a0
> 2010/01/27 00:22:07|[<ffffffff803b3748>] xfs_da_node_lookup_int+0x88/0x2a0
> 2010/01/27 00:22:07|[<ffffffff803bd2f8>] xfs_dir2_node_lookup+0x48/0x120
> 2010/01/27 00:22:07|[<ffffffff803b697a>] xfs_dir_lookup+0x1aa/0x1c0
> 2010/01/27 00:22:07|[<ffffffff803e3267>] xfs_lookup+0x57/0xd0
> 2010/01/27 00:22:07|[<ffffffff8035279e>] nfsd_permission+0x7e/0x130
> 2010/01/27 00:22:07|[<ffffffff803ee6e4>] xfs_vn_lookup+0x64/0xc0
> 2010/01/27 00:22:07|[<ffffffff802a9f95>] d_alloc+0x125/0x1b0
> 2010/01/27 00:22:07|[<ffffffff802a048c>] __lookup_hash+0xec/0x180
> 2010/01/27 00:22:07|[<ffffffff802a0629>] lookup_one_len+0x59/0x60
> 2010/01/27 00:22:07|[<ffffffff8035023c>] nfsd_lookup_dentry+0x12c/0x4d0
> 2010/01/27 00:22:07|[<ffffffff80350610>] nfsd_lookup+0x30/0x100
> 2010/01/27 00:22:07|[<ffffffff803599a7>] nfsd3_proc_lookup+0xa7/0x100
> 2010/01/27 00:22:07|[<ffffffff8034ca6e>] nfsd_dispatch+0xae/0x260
> 2010/01/27 00:22:07|[<ffffffff80669a87>] svc_process+0x307/0x740
> 2010/01/27 00:22:07|[<ffffffff8034c892>] nfsd+0x172/0x2a0
> 2010/01/27 00:22:07|[<ffffffff8034c720>] nfsd+0x0/0x2a0
> 2010/01/27 00:22:07|[<ffffffff80249d3c>] kthread+0x6c/0xa0
> 2010/01/27 00:22:07|[<ffffffff8020d1c9>] child_rip+0xa/0x11
> 2010/01/27 00:22:07|[<ffffffff80249cd0>] kthread+0x0/0xa0
> 2010/01/27 00:22:07|[<ffffffff8020d1bf>] child_rip+0x0/0x11
> 2010/01/27 00:22:07|
> 2010/01/27 00:22:09|Pid: 17189, comm: nfsd Not tainted 2.6.27.10 #12
> 2010/01/27 00:22:09|
> 2010/01/27 00:22:09|Call Trace:
> 2010/01/27 00:22:09|[<ffffffff803b33b6>] xfs_da_do_buf+0x626/0x6b0
> 2010/01/27 00:22:09|[<ffffffff803b34b4>] xfs_da_read_buf+0x24/0x30
> 2010/01/27 00:22:09|[<ffffffff803b2bed>] xfs_da_buf_make+0x13d/0x150
> 2010/01/27 00:22:09|[<ffffffff803df247>] xfs_trans_read_buf+0x147/0x310
> 2010/01/27 00:22:09|[<ffffffff803b34b4>] xfs_da_read_buf+0x24/0x30
> 2010/01/27 00:22:09|[<ffffffff803bbd5b>] xfs_dir2_leafn_lookup_for_entry+0x16b/0x350
> 2010/01/27 00:22:09|[<ffffffff803bbd5b>] xfs_dir2_leafn_lookup_for_entry+0x16b/0x350
> 2010/01/27 00:22:09|[<ffffffff803b38f7>] xfs_da_node_lookup_int+0x237/0x2a0
> 2010/01/27 00:22:09|[<ffffffff803bd2f8>] xfs_dir2_node_lookup+0x48/0x120
> 2010/01/27 00:22:09|[<ffffffff803b697a>] xfs_dir_lookup+0x1aa/0x1c0
> 2010/01/27 00:22:09|[<ffffffff803e3267>] xfs_lookup+0x57/0xd0
> 2010/01/27 00:22:09|[<ffffffff8035279e>] nfsd_permission+0x7e/0x130
> 2010/01/27 00:22:09|[<ffffffff803ee6e4>] xfs_vn_lookup+0x64/0xc0
> 2010/01/27 00:22:09|[<ffffffff802a9f95>] d_alloc+0x125/0x1b0
> 2010/01/27 00:22:09|[<ffffffff802a048c>] __lookup_hash+0xec/0x180
> 2010/01/27 00:22:09|[<ffffffff802a0629>] lookup_one_len+0x59/0x60
> 2010/01/27 00:22:09|[<ffffffff8035023c>] nfsd_lookup_dentry+0x12c/0x4d0
> 2010/01/27 00:22:09|[<ffffffff80350610>] nfsd_lookup+0x30/0x100
> 2010/01/27 00:22:09|[<ffffffff803599a7>] nfsd3_proc_lookup+0xa7/0x100
> 2010/01/27 00:22:09|[<ffffffff8034ca6e>] nfsd_dispatch+0xae/0x260
> 2010/01/27 00:22:09|[<ffffffff80669a87>] svc_process+0x307/0x740
> 2010/01/27 00:22:09|[<ffffffff8034c892>] nfsd+0x172/0x2a0
> 2010/01/27 00:22:09|[<ffffffff8034c720>] nfsd+0x0/0x2a0
> 2010/01/27 00:22:09|[<ffffffff80249d3c>] kthread+0x6c/0xa0
> 2010/01/27 00:22:09|[<ffffffff8020d1c9>] child_rip+0xa/0x11
> 2010/01/27 00:22:09|[<ffffffff80249cd0>] kthread+0x0/0xa0
> 2010/01/27 00:22:09|[<ffffffff8020d1bf>] child_rip+0x0/0x11
>
>
>   


--------------010709070209000402040409
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
</head>
<body text="#000000" bgcolor="#ffffff">
Can somebody help with this problem? If you need more details, please
let me know. <span id="result_box" class="short_text"><span
 style="background-color: rgb(255, 255, 255);"
 title="Czy ty chcesz plik z większym debug"></span></span>
<blockquote cite="mid:4B717CCD.3040008@poczta.onet.pl" type="cite">
  <pre wrap="">Hello!

We"ve got two different systems running with XFS, one of them is
publishing shares via NFS, the other via Samba. We've recently
encountered filesystem issues on both servers, and received the
following call traces. They look very much alike.

Are these something you are familiar with? We'd like to at least
establish that the problem really is with XFS... We don't really have
the possibility to update the kernels (2.6.27.10) on those machines, but
we can possibly apply patches etc. These systems are usually under a
fairly high load and host a large number of files.


Filesystem "dm-16": Disabling barriers, trial barrier write failed        
XFS mounting filesystem dm-16                                             
Starting XFS recovery on filesystem: dm-16 (logdev: internal)             
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1590 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff80398ca7
Pid: 15745, comm: mount Not tainted 2.6.27.10
#24                                                            

Call Trace:
 [&lt;ffffffff80396fb8&gt;] xfs_free_ag_extent+0x378/0x740
 [&lt;ffffffff80398ca7&gt;] xfs_free_extent+0xc7/0x110   
 [&lt;ffffffff803d7642&gt;] xlog_recover_process_efi+0x122/0x1a0
 [&lt;ffffffff803d7727&gt;] xlog_recover_process_efis+0x67/0x90
 [&lt;ffffffff803d87dc&gt;] xlog_recover_finish+0x1c/0xd0      
 [&lt;ffffffff803d0790&gt;] xfs_log_mount_finish+0x20/0x30     
 [&lt;ffffffff803dac3d&gt;] xfs_mountfs+0x2bd/0x640            
 [&lt;ffffffff803c0440&gt;] xfs_fstrm_free_func+0x0/0x90       
 [&lt;ffffffff803dbaca&gt;] xfs_mru_cache_create+0x15a/0x1c0   
 [&lt;ffffffff803f2c04&gt;] xfs_fs_fill_super+0x214/0x450      
 [&lt;ffffffff80299100&gt;] set_bdev_super+0x0/0x10            
 [&lt;ffffffff8029925f&gt;] get_sb_bdev+0x13f/0x180            
 [&lt;ffffffff803f29f0&gt;] xfs_fs_fill_super+0x0/0x450        
 [&lt;ffffffff802994f1&gt;] vfs_kern_mount+0x81/0x160          
 [&lt;ffffffff8029961d&gt;] do_kern_mount+0x4d/0x110           
 [&lt;ffffffff802b0fbb&gt;] do_new_mount+0x9b/0xe0             
 [&lt;ffffffff802b1849&gt;] do_mount+0x209/0x220               
 [&lt;ffffffff80274ea2&gt;] __alloc_pages_internal+0x92/0x430  
 [&lt;ffffffff802752d7&gt;] __get_free_pages+0x17/0x80         
 [&lt;ffffffff802cbdf4&gt;] compat_sys_mount+0xa4/0x270        
 [&lt;ffffffff80228282&gt;] ia32_sysret+0x0/0xa                

Failed to recover EFIs on filesystem: dm-16
XFS: log mount finish failed              
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period                                   
bootsplash: status on console 0 changed to off                          
usb 3-2: USB disconnect, address 2                                      
00000000: 00 00 00 00 00 28 00 e0 00 00 00 00 00 00 00 00  .....(..........
Filesystem "dm-20": XFS internal error xfs_da_do_buf(2) at line 2112 of
file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff803b34b4
Pid: 23023, comm: smbd Not tainted 2.6.27.10
#24                                                                             


Call Trace:
 [&lt;ffffffff803b33b6&gt;] xfs_da_do_buf+0x626/0x6b0
 [&lt;ffffffff803b34b4&gt;] xfs_da_read_buf+0x24/0x30
 [&lt;ffffffff8023ee0f&gt;] try_to_del_timer_sync+0x4f/0x60
 [&lt;ffffffff803b34b4&gt;] xfs_da_read_buf+0x24/0x30     
 [&lt;ffffffff803b77e5&gt;] xfs_dir2_block_lookup_int+0x45/0x1a0
 [&lt;ffffffff803b77e5&gt;] xfs_dir2_block_lookup_int+0x45/0x1a0
 [&lt;ffffffff803b7958&gt;] xfs_dir2_block_lookup+0x18/0xc0    
 [&lt;ffffffff803b624f&gt;] xfs_dir2_isblock+0x1f/0x60         
 [&lt;ffffffff803b696d&gt;] xfs_dir_lookup+0x19d/0x1c0         
 [&lt;ffffffff803e3267&gt;] xfs_lookup+0x57/0xd0               
 [&lt;ffffffff8069dfd9&gt;] _spin_lock_bh+0x9/0x20             
 [&lt;ffffffff803ee6e4&gt;] xfs_vn_lookup+0x64/0xc0            
 [&lt;ffffffff802a9f95&gt;] d_alloc+0x125/0x1b0                
 [&lt;ffffffff8029f155&gt;] do_lookup+0x175/0x220              
 [&lt;ffffffff8029ea79&gt;] generic_permission+0x69/0x130      
 [&lt;ffffffff8029fa01&gt;] __link_path_walk+0x801/0xdb0       
 [&lt;ffffffff805de663&gt;] sock_aio_read+0x163/0x170          
 [&lt;ffffffff802a0007&gt;] path_walk+0x57/0xb0                
 [&lt;ffffffff802a0183&gt;] do_path_lookup+0x123/0x1b0         
 [&lt;ffffffff802a06f4&gt;] user_path_at+0x44/0x80             
 [&lt;ffffffff8024a450&gt;] autoremove_wake_function+0x0/0x30  
 [&lt;ffffffff802af5c1&gt;] mntput_no_expire+0x21/0x120        
 [&lt;ffffffff8029a1f3&gt;] vfs_stat_fd+0x23/0x80              
 [&lt;ffffffff8022879f&gt;] sys32_stat64+0x1f/0x70             
 [&lt;ffffffff80228282&gt;] ia32_sysret+0x0/0xa                

00000000: 00 00 00 00 00 28 00 e0 00 00 00 00 00 00 00 00  .....(..........
Filesystem "dm-20": XFS internal error xfs_da_do_buf(2) at line 2112 of
file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff803b34b4
Pid: 23023, comm: smbd Not tainted 2.6.27.10
#24                                                                             


Call Trace:
 [&lt;ffffffff803b33b6&gt;] xfs_da_do_buf+0x626/0x6b0
 [&lt;ffffffff803b34b4&gt;] xfs_da_read_buf+0x24/0x30
 [&lt;ffffffff8023ee0f&gt;] try_to_del_timer_sync+0x4f/0x60
 [&lt;ffffffff803b34b4&gt;] xfs_da_read_buf+0x24/0x30     
 [&lt;ffffffff803b77e5&gt;] xfs_dir2_block_lookup_int+0x45/0x1a0
 [&lt;ffffffff803b77e5&gt;] xfs_dir2_block_lookup_int+0x45/0x1a0
 [&lt;ffffffff803b7958&gt;] xfs_dir2_block_lookup+0x18/0xc0    
 [&lt;ffffffff803b624f&gt;] xfs_dir2_isblock+0x1f/0x60         
 [&lt;ffffffff803b696d&gt;] xfs_dir_lookup+0x19d/0x1c0         
 [&lt;ffffffff803e3267&gt;] xfs_lookup+0x57/0xd0               
 [&lt;ffffffff8069dfd9&gt;] _spin_lock_bh+0x9/0x20             
 [&lt;ffffffff803ee6e4&gt;] xfs_vn_lookup+0x64/0xc0            
 [&lt;ffffffff802a9f95&gt;] d_alloc+0x125/0x1b0                
 [&lt;ffffffff8029f155&gt;] do_lookup+0x175/0x220              
 [&lt;ffffffff8029ea79&gt;] generic_permission+0x69/0x130      
 [&lt;ffffffff8029fa01&gt;] __link_path_walk+0x801/0xdb0       
 [&lt;ffffffff805de663&gt;] sock_aio_read+0x163/0x170          
 [&lt;ffffffff802a0007&gt;] path_walk+0x57/0xb0                
 [&lt;ffffffff802a0183&gt;] do_path_lookup+0x123/0x1b0         
 [&lt;ffffffff802a06f4&gt;] user_path_at+0x44/0x80             
 [&lt;ffffffff8024a450&gt;] autoremove_wake_function+0x0/0x30  
 [&lt;ffffffff802af5c1&gt;] mntput_no_expire+0x21/0x120        
 [&lt;ffffffff8029a1f3&gt;] vfs_stat_fd+0x23/0x80              
 [&lt;ffffffff8022879f&gt;] sys32_stat64+0x1f/0x70             
 [&lt;ffffffff80228282&gt;] ia32_sysret+0x0/0xa


&gt;From the other system we only have these logs:

2010/01/27 00:22:07|Pid: 17209, comm: nfsd Not tainted 2.6.27.10 #12
2010/01/27 00:22:07|
2010/01/27 00:22:07|Call Trace:
2010/01/27 00:22:07|[&lt;ffffffff803b33b6&gt;] xfs_da_do_buf+0x626/0x6b0
2010/01/27 00:22:07|[&lt;ffffffff803b34b4&gt;] xfs_da_read_buf+0x24/0x30
2010/01/27 00:22:07|[&lt;ffffffff803ead07&gt;] xfs_buf_read_flags+0x67/0x90
2010/01/27 00:22:07|[&lt;ffffffff803df247&gt;] xfs_trans_read_buf+0x147/0x310
2010/01/27 00:22:07|[&lt;ffffffff803b34b4&gt;] xfs_da_read_buf+0x24/0x30
2010/01/27 00:22:07|[&lt;ffffffff803b3748&gt;] xfs_da_node_lookup_int+0x88/0x2a0
2010/01/27 00:22:07|[&lt;ffffffff803b3748&gt;] xfs_da_node_lookup_int+0x88/0x2a0
2010/01/27 00:22:07|[&lt;ffffffff803bd2f8&gt;] xfs_dir2_node_lookup+0x48/0x120
2010/01/27 00:22:07|[&lt;ffffffff803b697a&gt;] xfs_dir_lookup+0x1aa/0x1c0
2010/01/27 00:22:07|[&lt;ffffffff803e3267&gt;] xfs_lookup+0x57/0xd0
2010/01/27 00:22:07|[&lt;ffffffff8035279e&gt;] nfsd_permission+0x7e/0x130
2010/01/27 00:22:07|[&lt;ffffffff803ee6e4&gt;] xfs_vn_lookup+0x64/0xc0
2010/01/27 00:22:07|[&lt;ffffffff802a9f95&gt;] d_alloc+0x125/0x1b0
2010/01/27 00:22:07|[&lt;ffffffff802a048c&gt;] __lookup_hash+0xec/0x180
2010/01/27 00:22:07|[&lt;ffffffff802a0629&gt;] lookup_one_len+0x59/0x60
2010/01/27 00:22:07|[&lt;ffffffff8035023c&gt;] nfsd_lookup_dentry+0x12c/0x4d0
2010/01/27 00:22:07|[&lt;ffffffff80350610&gt;] nfsd_lookup+0x30/0x100
2010/01/27 00:22:07|[&lt;ffffffff803599a7&gt;] nfsd3_proc_lookup+0xa7/0x100
2010/01/27 00:22:07|[&lt;ffffffff8034ca6e&gt;] nfsd_dispatch+0xae/0x260
2010/01/27 00:22:07|[&lt;ffffffff80669a87&gt;] svc_process+0x307/0x740
2010/01/27 00:22:07|[&lt;ffffffff8034c892&gt;] nfsd+0x172/0x2a0
2010/01/27 00:22:07|[&lt;ffffffff8034c720&gt;] nfsd+0x0/0x2a0
2010/01/27 00:22:07|[&lt;ffffffff80249d3c&gt;] kthread+0x6c/0xa0
2010/01/27 00:22:07|[&lt;ffffffff8020d1c9&gt;] child_rip+0xa/0x11
2010/01/27 00:22:07|[&lt;ffffffff80249cd0&gt;] kthread+0x0/0xa0
2010/01/27 00:22:07|[&lt;ffffffff8020d1bf&gt;] child_rip+0x0/0x11
2010/01/27 00:22:07|
2010/01/27 00:22:09|Pid: 17189, comm: nfsd Not tainted 2.6.27.10 #12
2010/01/27 00:22:09|
2010/01/27 00:22:09|Call Trace:
2010/01/27 00:22:09|[&lt;ffffffff803b33b6&gt;] xfs_da_do_buf+0x626/0x6b0
2010/01/27 00:22:09|[&lt;ffffffff803b34b4&gt;] xfs_da_read_buf+0x24/0x30
2010/01/27 00:22:09|[&lt;ffffffff803b2bed&gt;] xfs_da_buf_make+0x13d/0x150
2010/01/27 00:22:09|[&lt;ffffffff803df247&gt;] xfs_trans_read_buf+0x147/0x310
2010/01/27 00:22:09|[&lt;ffffffff803b34b4&gt;] xfs_da_read_buf+0x24/0x30
2010/01/27 00:22:09|[&lt;ffffffff803bbd5b&gt;] xfs_dir2_leafn_lookup_for_entry+0x16b/0x350
2010/01/27 00:22:09|[&lt;ffffffff803bbd5b&gt;] xfs_dir2_leafn_lookup_for_entry+0x16b/0x350
2010/01/27 00:22:09|[&lt;ffffffff803b38f7&gt;] xfs_da_node_lookup_int+0x237/0x2a0
2010/01/27 00:22:09|[&lt;ffffffff803bd2f8&gt;] xfs_dir2_node_lookup+0x48/0x120
2010/01/27 00:22:09|[&lt;ffffffff803b697a&gt;] xfs_dir_lookup+0x1aa/0x1c0
2010/01/27 00:22:09|[&lt;ffffffff803e3267&gt;] xfs_lookup+0x57/0xd0
2010/01/27 00:22:09|[&lt;ffffffff8035279e&gt;] nfsd_permission+0x7e/0x130
2010/01/27 00:22:09|[&lt;ffffffff803ee6e4&gt;] xfs_vn_lookup+0x64/0xc0
2010/01/27 00:22:09|[&lt;ffffffff802a9f95&gt;] d_alloc+0x125/0x1b0
2010/01/27 00:22:09|[&lt;ffffffff802a048c&gt;] __lookup_hash+0xec/0x180
2010/01/27 00:22:09|[&lt;ffffffff802a0629&gt;] lookup_one_len+0x59/0x60
2010/01/27 00:22:09|[&lt;ffffffff8035023c&gt;] nfsd_lookup_dentry+0x12c/0x4d0
2010/01/27 00:22:09|[&lt;ffffffff80350610&gt;] nfsd_lookup+0x30/0x100
2010/01/27 00:22:09|[&lt;ffffffff803599a7&gt;] nfsd3_proc_lookup+0xa7/0x100
2010/01/27 00:22:09|[&lt;ffffffff8034ca6e&gt;] nfsd_dispatch+0xae/0x260
2010/01/27 00:22:09|[&lt;ffffffff80669a87&gt;] svc_process+0x307/0x740
2010/01/27 00:22:09|[&lt;ffffffff8034c892&gt;] nfsd+0x172/0x2a0
2010/01/27 00:22:09|[&lt;ffffffff8034c720&gt;] nfsd+0x0/0x2a0
2010/01/27 00:22:09|[&lt;ffffffff80249d3c&gt;] kthread+0x6c/0xa0
2010/01/27 00:22:09|[&lt;ffffffff8020d1c9&gt;] child_rip+0xa/0x11
2010/01/27 00:22:09|[&lt;ffffffff80249cd0&gt;] kthread+0x0/0xa0
2010/01/27 00:22:09|[&lt;ffffffff8020d1bf&gt;] child_rip+0x0/0x11


  </pre>
</blockquote>
<br>
</body>
</html>

--------------010709070209000402040409--


--===============3452350151727847851==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3452350151727847851==--
