Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE7F27F5F
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 21:19:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA5AD8F8054
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 19:19:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CetCaKOM7PqF7Dsx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 19:19:23 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id C0E50A4673
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 02:19:22 +0000 (UTC)
Date: Wed, 2 Sep 2015 10:19:20 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] repair: fix wrong logic when validating node magic number
Message-ID: <20150902021920.GF538@dhcp-13-216.nay.redhat.com>
References: <1439449276-1699-1-git-send-email-eguan@redhat.com>
	<20150813071524.GI17933@dhcp-13-216.nay.redhat.com>
	<20150901140442.GA16640@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150901140442.GA16640@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 01, 2015 at 10:04:43AM -0400, Brian Foster wrote:
> On Thu, Aug 13, 2015 at 03:15:24PM +0800, Eryu Guan wrote:
> > On Thu, Aug 13, 2015 at 03:01:16PM +0800, Eryu Guan wrote:
> > > Magic number is wrong only when != XFS_DA_NODE_MAGIC and
> > > != XFS_DA3_NODE_MAGIC.
> > > 
> > > This is triggered by shared/002 when testing 512 block size XFS.
> > > 
> > >   Phase 1 - find and verify superblock...
> > >   Phase 2 - using internal log
> > >           - scan filesystem freespace and inode maps...
> > >           - found root inode chunk
> > >   Phase 3 - for each AG...
> > >           - scan (but don't clear) agi unlinked lists...
> > >           - process known inodes and perform inode discovery...
> > >           - agno = 0
> > >   bad magic number febe in block 64 (108) for directory inode 35
> > >   ......
> > > 
> > > Fix it by changing "||" to "&&".
> > > 
> > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > 
> > With this patch applied, shared/002 still fails on 512 block size XFS,
> > full xfs_repair -n output is                                                                                                                  
> >                                                                                                                                               
> > *** xfs_repair -n output ***                                                                                                                  
> > Phase 1 - find and verify superblock...                                                                                                       
> > Phase 2 - using internal log                                                                                                                  
> >         - scan filesystem freespace and inode maps...                                                                                         
> >         - found root inode chunk                                                                                                              
> > Phase 3 - for each AG...                                                                                                                      
> >         - scan (but don't clear) agi unlinked lists...                                                                                        
> >         - process known inodes and perform inode discovery...                                                                                 
> >         - agno = 0                                                                                                                            
> > problem with attribute contents in inode 35                                                                                                   
> > would clear attr fork                                                                                                                         
> > bad nblocks 67 for inode 35, would reset to 0                                                                                                 
> > bad anextents 5 for inode 35, would reset to 0                                                                                                
> >         - agno = 1                                                                                                                            
> >         - agno = 2                                                                                                                            
> >         - agno = 3                                                                                                                            
> >         - process newly discovered inodes...                                                                                                  
> > Phase 4 - check for duplicate blocks...                                                                                                       
> >         - setting up duplicate extent list...                                                                                                 
> >         - check for inodes claiming duplicate blocks...                                                                                       
> >         - agno = 0                                                                                                                            
> >         - agno = 1                                                                                                                            
> >         - agno = 2                                                                                                                            
> >         - agno = 3                                                                                                                            
> > No modify flag set, skipping phase 5                                                                                                          
> > Phase 6 - check inode connectivity...                                                                                                         
> >         - traversing filesystem ...                                                                                                           
> >         - traversal finished ...                                                                                                              
> >         - moving disconnected inodes to lost+found ...                                                                                        
> > Phase 7 - verify link counts...                                                                                                               
> > No modify flag set, skipping filesystem flush and exiting.                                                                                    
> > *** end xfs_repair output
> > 
> > And a simplified reproducer is just adding >= 577 xattrs to file foo on
> > 512 block size XFS, no dmflaky is needed.
> > 
> > num_xattrs=577
> > for ((i = 1; i <= $num_xattrs; i++)); do
> >         name="user.attr_$(printf "%04d" $i)"
> >         $SETFATTR_PROG -n $name -v "val_$(printf "%04d" $i)" $SCRATCH_MNT/foo
> > done
> > 
> > And it's easily reproduced.
> > 
> 
> Thanks for the reproducer. This looks like a bug in xfs_repair. Care to
> test the appended hunk?

Test passed after applying this patch, thanks! Tested by shared/002 and
the simplified reproducer above.

Thanks,
Eryu

> 
> Brian
> 
> ---8<---
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 83a07a8..b76618a 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -562,7 +562,7 @@ verify_da_path(xfs_mount_t	*mp,
>  		}
>  
>  		newnode = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
> -		btree = M_DIROPS(mp)->node_tree_p(node);
> +		btree = M_DIROPS(mp)->node_tree_p(newnode);
>  		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, newnode);
>  
>  		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
