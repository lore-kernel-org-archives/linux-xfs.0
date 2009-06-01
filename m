Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n51AY4sK257123 for <xfs@oss.sgi.com>; Mon, 1 Jun 2009 05:34:05 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B13E61D37E69
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2009 03:34:19 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id xqhlRAV7YDCzAKGE for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2009 03:34:19 -0700 (PDT)
From: Marvin <marvin24@gmx.de>
Subject: fsr stucks in D-state
Date: Mon, 1 Jun 2009 12:33:39 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906011233.39721.marvin24@gmx.de>
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

Hi,

I observed a hang in D-state when using xfs_fsr.

- xfsprogs is from git (3.0.2)
- kernel also (2.6.30-rc7...)

I tried 2.6.29.4 and it worked flawless. Machine is powerpc32.

Here is the sysrq-t trace:

xfs_fsr       D 480f7f3c     0  4211   4210                  
Call Trace:                                                  
[d1adfc40] [00001032] 0x1032 (unreliable)                    
[d1adfd00] [c0008dd8] __switch_to+0x4c/0x6c                  
[d1adfd20] [c02c5294] __schedule+0x230/0x360                 
[d1adfd70] [c02c53ec] schedule+0x28/0x54                     
[d1adfd80] [c02c7964] rwsem_down_failed_common+0x104/0x25c   
[d1adfdb0] [c02c7ae4] rwsem_down_write_failed+0x28/0x40      
[d1adfde0] [c02c6994] down_write+0x30/0x40                   
[d1adfdf0] [c012399c] xfs_ilock+0x9c/0xa0                    
[d1adfe00] [c014375c] xfs_inactive+0x2e8/0x48c               
[d1adfe40] [c015113c] xfs_fs_clear_inode+0x40/0x50           
[d1adfe50] [c00ab764] clear_inode+0x68/0xec                  
[d1adfe60] [c00ac02c] generic_delete_inode+0x16c/0x170       
[d1adfe80] [c00aaf20] iput+0x70/0x90                         
[d1adfe90] [c00a7424] dentry_iput+0xc8/0x154                 
[d1adfeb0] [c00a75e0] d_kill+0x50/0x8c                       
[d1adfed0] [c00a80cc] dput+0x110/0x210                       
[d1adfef0] [c0095b50] __fput+0x178/0x204                     
[d1adff10] [c0091eec] filp_close+0x6c/0xa0                   
[d1adff30] [c0091fd4] sys_close+0xb4/0x124                   
[d1adff40] [c0011fc4] ret_from_syscall+0x0/0x38              
--- Exception: c01 at 0x480f7f3c
    LR = 0x1000397c

Greetings

Marvin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
