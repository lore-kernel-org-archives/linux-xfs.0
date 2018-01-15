Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbeAOGgH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jan 2018 01:36:07 -0500
Date: Mon, 15 Jan 2018 14:36:05 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: recheck reflink / dirty page status before freeing
 CoW reservations
Message-ID: <20180115063605.GC3102@eguan.usersys.redhat.com>
References: <20180110220336.GU5602@magnolia>
 <20180111075441.GH5123@eguan.usersys.redhat.com>
 <20180112033231.GM5123@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180112033231.GM5123@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Jan 12, 2018 at 11:32:31AM +0800, Eryu Guan wrote:
> On Thu, Jan 11, 2018 at 03:54:41PM +0800, Eryu Guan wrote:
> > On Wed, Jan 10, 2018 at 02:03:36PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Eryu Guan reported seeing occasional hangs when running generic/269 with
> > > a new fsstress that supports clonerange/deduperange.  The cause of this
> > > hang is an infinite loop when we convert the CoW fork extents from
> > > unwritten to real just prior to writing the pages out; the infinite
> > > loop happens because there's nothing in the CoW fork to convert, and so
> > > it spins forever.
> > > 
> > > The underlying issue here is that when we go to perform these CoW fork
> > > conversions, we're supposed to have an extent waiting for us, but the
> > > low space CoW reaper has snuck in and blown them away!  There are four
> > > conditions that can dissuade the reaper from touching our file -- no
> > > reflink iflag; dirty page cache; writeback in progress; or directio in
> > > progress.  We check the four conditions prior to taking the locks, but
> > > we neglect to recheck them once we have the locks, which is how we end
> > > up whacking the writeback that's in progress.
> > > 
> > > Therefore, refactor the four checks into a helper function and call it
> > > once again once we have the locks to make sure we really want to reap
> > > the inode.  While we're at it, add an ASSERT for this weird condition so
> > > that we'll fail noisily if we ever screw this up again.
> > > 
> > > Reported-by: Eryu Guan <eguan@redhat.com>
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > I applied this patch on top of v4.15-rc5 kernel, and ran generic/083
> > generic/269 and generic/270 (where I hit the soft lockup and hang before)
> > multiple times and tests all passed. I also ran all tests in 'enospc'
> > group on 1k/2k/4k XFS with reflink enabled, tests passed too. So
> > 
> > Tested-by: Eryu Guan <eguan@redhat.com>
> 
> Sorry, I have to withdraw this tag for now.. I'm seeing soft lockup
> again in generic/269 run with the patched kernel. I'll do more testings
> to confirm, paste the soft lockup info here for now:

I ran generic/269 for over 4000 iterations and didn't hit soft lockup, I
suspect that previously I tested on wrong/unpatched xfs module..

But occationally I saw fs inconsistency in generic/269, it's hard to
reproduce (need 100-200 iterations) but I did see it several times. But
it seems like another problem.

_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (r)                                                                                                                                                   
*** xfs_repair -n output ***                                                                                                                                                                                         
Phase 1 - find and verify superblock...                                                                                                                                                                              
Phase 2 - using internal log                                                                                                                                                                                         
        - zero log...                                                                                                                                                                                                
        - scan filesystem freespace and inode maps...                                                                                                                                                                
sb_fdblocks 8178, counted 8188                                                                                                                                                                                       
        - found root inode chunk                                                                                                                                                                                     
Phase 3 - for each AG...                                                                                                                                                                                             
        - scan (but don't clear) agi unlinked lists...                                                                                                                                                               
        - process known inodes and perform inode discovery...                                                                                                                                                        
        - agno = 0                                                                                                                                                                                                   
        - agno = 1                                                                                                                                                                                                   
        - agno = 2                                                                                                                                                                                                   
        - agno = 3                                                                                                                                                                                                   
        - process newly discovered inodes...                                                                                                                                                                         
Phase 4 - check for duplicate blocks...                                                                                                                                                                              
        - setting up duplicate extent list...                                                                                                                                                                        
        - check for inodes claiming duplicate blocks...                                                                                                                                                              
        - agno = 1                                                                                                                                                                                                   
        - agno = 3                                                                                                                                                                                                   
        - agno = 2                                                                                                                                                                                                   
        - agno = 0                                                                                                                                                                                                   
No modify flag set, skipping phase 5                                                                                                                                                                                 
Phase 6 - check inode connectivity...                                                                                                                                                                                
        - traversing filesystem ...                                                                                                                                                                                  
        - traversal finished ...                                                                                                                                                                                     
        - moving disconnected inodes to lost+found ...                                                                                                                                                               
Phase 7 - verify link counts...                                                                                                                                                                                      
No modify flag set, skipping filesystem flush and exiting.                                                                                                                                                           
*** end xfs_repair output

Thanks,
Eryu
