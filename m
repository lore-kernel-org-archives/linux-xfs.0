Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D87697F3F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 04:56:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85273AC001
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 02:56:21 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id sFnnKwBGMUmUhA96 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 02:56:19 -0800 (PST)
Date: Thu, 18 Dec 2014 11:56:14 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: Disconnected inodes after test xfs/261
Message-ID: <20141218105614.GE13705@quack.suse.cz>
References: <20141217193535.GA8231@quack.suse.cz>
	<20141217210226.GY24183@dastard>
	<20141218103642.GB13705@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141218103642.GB13705@quack.suse.cz>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 18-12-14 11:36:42, Jan Kara wrote:
> On Thu 18-12-14 08:02:26, Dave Chinner wrote:
> > On Wed, Dec 17, 2014 at 08:35:35PM +0100, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   in my test KVM with today's Linus' kernel I'm getting xfs_repair
> > > complaint about disconnected inodes after the test xfs/261 finishes
> > > (with success). xfs_repair output is like:
> > > xfs_repair -n /dev/vdb2
> > > Phase 1 - find and verify superblock...
> > > Phase 2 - using internal log
> > >         - scan filesystem freespace and inode maps...
> > >         - found root inode chunk
> > > Phase 3 - for each AG...
> > >         - scan (but don't clear) agi unlinked lists...
> > >         - process known inodes and perform inode discovery...
> > >         - agno = 0
> > >         - agno = 1
> > >         - agno = 2
> > >         - agno = 3
> > >         - process newly discovered inodes...
> > > Phase 4 - check for duplicate blocks...
> > >         - setting up duplicate extent list...
> > >         - check for inodes claiming duplicate blocks...
> > >         - agno = 0
> > >         - agno = 1
> > >         - agno = 2
> > >         - agno = 3
> > > No modify flag set, skipping phase 5
> > > Phase 6 - check inode connectivity...
> > >         - traversing filesystem ...
> > >         - traversal finished ...
> > >         - moving disconnected inodes to lost+found ...
> > > disconnected inode 132, would move to lost+found
> > > disconnected inode 133, would move to lost+found
> > > Phase 7 - verify link counts...
> > > No modify flag set, skipping filesystem flush and exiting.
> > > ---
> > > Given how trivial test xfs/261 is, it seems like created private mtab files
> > > that also get unlinked don't get added to AGI unlinked list before umount.
> > > I didn't have a detailed look whether that's possible or not and probably
> > > won't get to it before Christmas. So I'm sending this just in case someone
> > > more knowledgeable has ideas earlier...
> > 
> > I don't see that here. If you mount/unmount the filesystem, does the
> > warning go away? i.e. xfs_repair -n ignores the contents of
> > the log, so if the unlinked list transactions are in the log then
> > log recovery will make everything good again.
>   No, the problem is still there after mounting and unmounting the
> filesystem.
> 
> Given what Michael wrote: I'm running xfs_repair version 3.2.1, filesystem
> is V4.
  Oh, and what might be related: Test xfs/071 passes but xfs_repair
complains like:
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
inode 131 - extent offset too large - start 14, count 1, offset 2251799813685247
correcting nextents for inode 131
bad data fork in inode 131
would have cleared inode 131
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
entry "071" in shortform directory 128 references free inode 131
would have junked entry "071" in directory inode 128
inode 131 - extent offset too large - start 14, count 1, offset 2251799813685247
correcting nextents for inode 131
bad data fork in inode 131
would have cleared inode 131
        - agno = 1
        - agno = 2
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "071" in shortform directory inode 128 points to free inode 131
would junk entry
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
