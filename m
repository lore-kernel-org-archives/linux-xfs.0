Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F84D7F5E
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 09:04:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D19EEAC00E
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 07:04:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1dCm12GMbNN8p6GE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 07:04:45 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id CEC5591C17
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 14:04:44 +0000 (UTC)
Date: Tue, 1 Sep 2015 10:04:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] repair: fix wrong logic when validating node magic number
Message-ID: <20150901140442.GA16640@bfoster.bfoster>
References: <1439449276-1699-1-git-send-email-eguan@redhat.com>
	<20150813071524.GI17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150813071524.GI17933@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 13, 2015 at 03:15:24PM +0800, Eryu Guan wrote:
> On Thu, Aug 13, 2015 at 03:01:16PM +0800, Eryu Guan wrote:
> > Magic number is wrong only when != XFS_DA_NODE_MAGIC and
> > != XFS_DA3_NODE_MAGIC.
> > 
> > This is triggered by shared/002 when testing 512 block size XFS.
> > 
> >   Phase 1 - find and verify superblock...
> >   Phase 2 - using internal log
> >           - scan filesystem freespace and inode maps...
> >           - found root inode chunk
> >   Phase 3 - for each AG...
> >           - scan (but don't clear) agi unlinked lists...
> >           - process known inodes and perform inode discovery...
> >           - agno = 0
> >   bad magic number febe in block 64 (108) for directory inode 35
> >   ......
> > 
> > Fix it by changing "||" to "&&".
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> 
> With this patch applied, shared/002 still fails on 512 block size XFS,
> full xfs_repair -n output is                                                                                                                  
>                                                                                                                                               
> *** xfs_repair -n output ***                                                                                                                  
> Phase 1 - find and verify superblock...                                                                                                       
> Phase 2 - using internal log                                                                                                                  
>         - scan filesystem freespace and inode maps...                                                                                         
>         - found root inode chunk                                                                                                              
> Phase 3 - for each AG...                                                                                                                      
>         - scan (but don't clear) agi unlinked lists...                                                                                        
>         - process known inodes and perform inode discovery...                                                                                 
>         - agno = 0                                                                                                                            
> problem with attribute contents in inode 35                                                                                                   
> would clear attr fork                                                                                                                         
> bad nblocks 67 for inode 35, would reset to 0                                                                                                 
> bad anextents 5 for inode 35, would reset to 0                                                                                                
>         - agno = 1                                                                                                                            
>         - agno = 2                                                                                                                            
>         - agno = 3                                                                                                                            
>         - process newly discovered inodes...                                                                                                  
> Phase 4 - check for duplicate blocks...                                                                                                       
>         - setting up duplicate extent list...                                                                                                 
>         - check for inodes claiming duplicate blocks...                                                                                       
>         - agno = 0                                                                                                                            
>         - agno = 1                                                                                                                            
>         - agno = 2                                                                                                                            
>         - agno = 3                                                                                                                            
> No modify flag set, skipping phase 5                                                                                                          
> Phase 6 - check inode connectivity...                                                                                                         
>         - traversing filesystem ...                                                                                                           
>         - traversal finished ...                                                                                                              
>         - moving disconnected inodes to lost+found ...                                                                                        
> Phase 7 - verify link counts...                                                                                                               
> No modify flag set, skipping filesystem flush and exiting.                                                                                    
> *** end xfs_repair output
> 
> And a simplified reproducer is just adding >= 577 xattrs to file foo on
> 512 block size XFS, no dmflaky is needed.
> 
> num_xattrs=577
> for ((i = 1; i <= $num_xattrs; i++)); do
>         name="user.attr_$(printf "%04d" $i)"
>         $SETFATTR_PROG -n $name -v "val_$(printf "%04d" $i)" $SCRATCH_MNT/foo
> done
> 
> And it's easily reproduced.
> 

Thanks for the reproducer. This looks like a bug in xfs_repair. Care to
test the appended hunk?

Brian

---8<---

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 83a07a8..b76618a 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -562,7 +562,7 @@ verify_da_path(xfs_mount_t	*mp,
 		}
 
 		newnode = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
-		btree = M_DIROPS(mp)->node_tree_p(node);
+		btree = M_DIROPS(mp)->node_tree_p(newnode);
 		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, newnode);
 
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
