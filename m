Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBSFA4Wh031314 for <xfs@oss.sgi.com>; Mon, 28 Dec 2009 09:10:04 -0600
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60B8A1C1D1EF
	for <xfs@oss.sgi.com>; Mon, 28 Dec 2009 07:10:49 -0800 (PST)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with
	ESMTP id e49rUvgUBLw53qiE for <xfs@oss.sgi.com>;
	Mon, 28 Dec 2009 07:10:49 -0800 (PST)
Date: Mon, 28 Dec 2009 16:10:48 +0100
From: DS <xfs@bob.dscon.sk>
Subject: xfs 2.6.31.9 error
Message-ID: <20091228151048.GA24031@bob.dscon.sk>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

after upgrade from Debian etch -> Debian lenny with custom kernel 2.6.31.9 (before 2.6.28.1) I see this error and server is resetting sometimes.

Filesystem was creating far far away (about 4years ago).


Dusan



XFS internal error XFS_WANT_CORRUPTED_RETURN at line 366 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff81169ae3                                                                     
Pid: 4022, comm: procmail Not tainted 2.6.31.9 #3                                                                                                                                   
Call Trace:                                                                                                                                                                         
 [<ffffffff8118edfe>] xfs_error_report+0x3e/0x40                                                                                                                                    
 [<ffffffff81169ae3>] ? xfs_alloc_ag_vextent_near+0x3f3/0x940                                                                                                                       
 [<ffffffff811680fa>] xfs_alloc_fixup_trees+0x2ba/0x340                                                                                                                             
 [<ffffffff81167de9>] ? xfs_alloc_get_rec+0x29/0x60                                                                                                                                 
 [<ffffffff81169ae3>] xfs_alloc_ag_vextent_near+0x3f3/0x940                                                                                                                         
 [<ffffffff8116a105>] xfs_alloc_ag_vextent+0xd5/0x130                                                                                                                               
 [<ffffffff8116aa68>] xfs_alloc_vextent+0x3a8/0x4f0                                                                                                                                 
 [<ffffffff81176ff7>] xfs_bmap_btalloc+0x5b7/0xa30                                                                                                                                  
 [<ffffffff81177479>] xfs_bmap_alloc+0x9/0x10                                                                                                                                       
 [<ffffffff8117976e>] xfs_bmapi+0x96e/0x10e0                                                                                                                                        
 [<ffffffff813aafcc>] ? __down_write_nested+0x1c/0xc0                                                                                                                               
 [<ffffffff8119a5df>] xfs_iomap_write_allocate+0x23f/0x3c0                                                                                                                          
 [<ffffffff8119b1ce>] xfs_iomap+0x2ce/0x300                                                                                                                                         
 [<ffffffff811b3817>] xfs_map_blocks+0x27/0x30                                                                                                                                      
 [<ffffffff811b498b>] xfs_page_state_convert+0x46b/0x720                                                                                                                            
 [<ffffffff811ef768>] ? __up_write+0xd8/0x140                                                                                                                                       
 [<ffffffff811b4f55>] xfs_vm_writepage+0x75/0x120                                                                                                                                   
 [<ffffffff8107bf52>] __writepage+0x12/0x50                                                                                                                                         
 [<ffffffff8107c877>] write_cache_pages+0x227/0x460                                                                                                                                 
 [<ffffffff8107bf40>] ? __writepage+0x0/0x50                                                                                                                                        
 [<ffffffff811b7f5d>] ? xfs_file_aio_write+0x5d/0x70                                                                                                                                
 [<ffffffff810a2861>] ? do_sync_write+0xf1/0x140                                                                                                                                    
 [<ffffffff8107cacf>] generic_writepages+0x1f/0x30                                                                                                                                  
 [<ffffffff811b4ea6>] xfs_vm_writepages+0x56/0x70                                                                                                                                   
 [<ffffffff8107cb08>] do_writepages+0x28/0x50                                                                                                                                       
 [<ffffffff81076541>] __filemap_fdatawrite_range+0x51/0x60                                                                                                                          
 [<ffffffff810775fa>] filemap_fdatawrite+0x1a/0x20                                                                                                                                  
 [<ffffffff810c58b0>] vfs_fsync+0x70/0x100                                                                                                                                          
 [<ffffffff810c5979>] do_fsync+0x39/0x60                                                                                                                                            
 [<ffffffff810c59cb>] sys_fsync+0xb/0x10                                                                                                                                            
 [<ffffffff8100bd6b>] system_call_fastpath+0x16/0x1b                                                                                                                                
~


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
