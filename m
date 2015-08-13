Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF7097F50
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 02:15:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C08AF304032
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 00:15:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NOPvj95OKuIyzCgA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 00:15:29 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id EE137A101A
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 07:15:28 +0000 (UTC)
Received: from localhost (dhcp-12-142.nay.redhat.com [10.66.12.142])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7D7FPJK031956
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 03:15:26 -0400
Date: Thu, 13 Aug 2015 15:15:24 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] repair: fix wrong logic when validating node magic number
Message-ID: <20150813071524.GI17933@dhcp-13-216.nay.redhat.com>
References: <1439449276-1699-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439449276-1699-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, Aug 13, 2015 at 03:01:16PM +0800, Eryu Guan wrote:
> Magic number is wrong only when != XFS_DA_NODE_MAGIC and
> != XFS_DA3_NODE_MAGIC.
> 
> This is triggered by shared/002 when testing 512 block size XFS.
> 
>   Phase 1 - find and verify superblock...
>   Phase 2 - using internal log
>           - scan filesystem freespace and inode maps...
>           - found root inode chunk
>   Phase 3 - for each AG...
>           - scan (but don't clear) agi unlinked lists...
>           - process known inodes and perform inode discovery...
>           - agno = 0
>   bad magic number febe in block 64 (108) for directory inode 35
>   ......
> 
> Fix it by changing "||" to "&&".
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

With this patch applied, shared/002 still fails on 512 block size XFS,
full xfs_repair -n output is                                                                                                                  
                                                                                                                                              
*** xfs_repair -n output ***                                                                                                                  
Phase 1 - find and verify superblock...                                                                                                       
Phase 2 - using internal log                                                                                                                  
        - scan filesystem freespace and inode maps...                                                                                         
        - found root inode chunk                                                                                                              
Phase 3 - for each AG...                                                                                                                      
        - scan (but don't clear) agi unlinked lists...                                                                                        
        - process known inodes and perform inode discovery...                                                                                 
        - agno = 0                                                                                                                            
problem with attribute contents in inode 35                                                                                                   
would clear attr fork                                                                                                                         
bad nblocks 67 for inode 35, would reset to 0                                                                                                 
bad anextents 5 for inode 35, would reset to 0                                                                                                
        - agno = 1                                                                                                                            
        - agno = 2                                                                                                                            
        - agno = 3                                                                                                                            
        - process newly discovered inodes...                                                                                                  
Phase 4 - check for duplicate blocks...                                                                                                       
        - setting up duplicate extent list...                                                                                                 
        - check for inodes claiming duplicate blocks...                                                                                       
        - agno = 0                                                                                                                            
        - agno = 1                                                                                                                            
        - agno = 2                                                                                                                            
        - agno = 3                                                                                                                            
No modify flag set, skipping phase 5                                                                                                          
Phase 6 - check inode connectivity...                                                                                                         
        - traversing filesystem ...                                                                                                           
        - traversal finished ...                                                                                                              
        - moving disconnected inodes to lost+found ...                                                                                        
Phase 7 - verify link counts...                                                                                                               
No modify flag set, skipping filesystem flush and exiting.                                                                                    
*** end xfs_repair output

And a simplified reproducer is just adding >= 577 xattrs to file foo on
512 block size XFS, no dmflaky is needed.

num_xattrs=577
for ((i = 1; i <= $num_xattrs; i++)); do
        name="user.attr_$(printf "%04d" $i)"
        $SETFATTR_PROG -n $name -v "val_$(printf "%04d" $i)" $SCRATCH_MNT/foo
done

And it's easily reproduced.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
