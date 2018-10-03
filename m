Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeJCWkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 18:40:18 -0400
Date: Wed, 3 Oct 2018 08:51:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: zero posteof blocks when cloning above eof
Message-ID: <20181003155109.GJ19324@magnolia>
References: <20181003020342.GD19324@magnolia>
 <24443553-fc5e-a377-dcb4-dabc0177bf99@sandeen.net>
 <20181003151253.GF19324@magnolia>
 <e32c24ba-2f8d-78f6-fe2e-5a6ca9b56c3b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e32c24ba-2f8d-78f6-fe2e-5a6ca9b56c3b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, zlang@redhat.com

On Wed, Oct 03, 2018 at 10:35:50AM -0500, Eric Sandeen wrote:
> On 10/3/18 10:12 AM, Darrick J. Wong wrote:
> > On Wed, Oct 03, 2018 at 07:11:14AM -0500, Eric Sandeen wrote:
> >> On 10/2/18 9:03 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> When we're reflinking between two files and the destination file range
> >>> is well beyond the destination file's EOF marker, zero any posteof
> >>> speculative preallocations in the destination file so that we don't
> >>> expose stale disk contents.  The previous strategy of trying to clear
> >>> the preallocations does not work if the destination file has the
> >>> PREALLOC flag set but no delalloc blocks.
> >>>
> >>> Uncovered by shared/010.
> >>>
> >>> Reported-by: Zorro Lang <zlang@redhat.com>
> >>> Bugzilla-id: https://bugzilla.kernel.org/show_bug.cgi?id=201259
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> The action makes sense, and this does resolve my simple testcase,
> >> and makes shared/010 pass for me as well.
> >>
> >> However, this makes my correctness spidey-sense tingle; why is there a
> >> new helper unique to extending reflinks, when extending writes already
> >> must do the same thing?
> > 
> > I think you're referring to Dave's earlier question of "Why don't you
> > just use xfs_file_aio_write_checks?"
> > 
> > It's tempting to adapt xfs_file_aio_write_checks for reflink, but I
> > think I have to create a new function because (a) we don't have a kiocb
> > to pass in, and (b) we have to lock two inodes for reflink while abiding
> > the [VX]FS inode locking rules and making sure we break the destination
> > flie's layout correctly.
> > 
> >> I didn't follow all the discussion on IRC, but might be worth
> >> explaining on the list for others as well.  Are there any other
> >> extending write tests that aren't happening for extending reflink?
> > 
> > Yes, there are a number of behavioral inconsistencies between regular
> > write and clonerange that have been discovered in the past few days, and
> > it's going to take me a few days to clean all of this up:
> > 
> > - Lack of file_update_times(), though the ctime update is open-coded in
> >   the reflink routines.
> > 
> > - Lack of file_remove_privs() to drop suid and capabilities on write.
> >   Totally missing from the btrfs implementation and xfs/ocfs2 followed
> >   that behavior warts and all.
> > 
> > - Lack of RLIMIT_FSIZE checking: D'oh.  Same lame excuse as above.
> > 
> > - Lack of MAX_NON_LFS size checking: Same.
> > 
> > - Lack of s_maxbytes checking: Same.  Alarming since this means we can
> >   reflink to offsets the pagecache doesn't support.
> > 
> > - Should our clonerange return bytes reflinked to copy_file_range?
> > 
> > That last one requires more careful consideration & will take longer;
> > the first two are nearly ready.
> 
> Ok, so let's say something like "this patch looks good as far as it goes,
> but as you work out these other issues, please consider code structure
> so that requirements which are common to extending write & extending reflink
> are done in common code rather than cut & pasted?"  :)

The scattershot approach sucks, yes.  I'm concentrating for now on
fixing the glaring holes and anticipate adding a final patch to pull
everything into a common xfs_reflink_clone_file_prep function that takes
both inodes and does whatever checking and prep work are needed (like
xfs_file_aio_write_checks) so that when it returns, the two files are
ready for xfs_reflink_remap_blocks.

--D

> -Eric
