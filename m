Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 971BF7F53
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 18:12:25 -0600 (CST)
Date: Wed, 4 Dec 2013 18:12:22 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: reinstate the iolock in xfs_readdir
Message-ID: <20131205001222.GE1935@sgi.com>
References: <20131203212951.GP1935@sgi.com> <20131203225520.GZ10988@dastard>
	<20131203231415.GS1935@sgi.com> <20131204001030.GD10988@dastard>
	<20131204130848.GA22926@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131204130848.GA22926@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Fellas,

On Wed, Dec 04, 2013 at 05:08:48AM -0800, Christoph Hellwig wrote:
> On Wed, Dec 04, 2013 at 11:10:30AM +1100, Dave Chinner wrote:
> > The simple fact is that if we ever want to do concurrent directory
> > read operations, we have to take the ilock in readdir() to ensure we
> > can serialise correctly against modifications because the i_mutex
> > can't be used to do that. So, really, I'm not against the fix you
> > proposed - I'm just trying to understand why it is necessary right
> > now....

I understand.  ;)

Dave, you are correct in guessing that this bug was found with CXFS.  No DMF on
this one though.  Unfortunately it is not reproduceable at will.

> Some comments from the person who authered that old comment that removed
> the ilock:
> 
>  - as far as I can tell that was not intentional.  I'm usually pretty
>    good at recording such things in the changelog if I do it
>    intentionally.

That was my impression too.

>  - relying on the open function to read in the extent list seems
>    potentially dangerous.

...because open doesn't take i_mutex, I think.  So today even though
xfs_dir_open does take the ilock to read in the extent list (D'oh, I'd missed
that it reads it in), there is no exclusion with readdir.

>    We generally try to make sure all the
>    functions using it read it in if needed including the proper
>    locking.  If we want to avoid that for some reason like in the
>    writeback path we at least comment it and put asserts in.

>  - like Dave pointed out I think things should just work for mainline
>    modulo maybe the attr by handle ioctl, but it seems by accident.
>    Figuring out what issues Ben sees would be useful.

- Logs indicating 'Access to block zero' on directories.
- Forced shutdowns:
	In xfs_free_ag_extent, XFS_WANT_CORRUPTED_GOTO when freeing an extent
	we find a section of it already in the freespace trees
- Log replay failures
	xlog_recover_finish
	  xlog_recover_process_efis
	    xlog_recover_process_efi
	      xfs_free_extent
	        xfs_free_ag_extent	that's the same thing
- A report that removal of files triggers the forced shutdown.

There was a similar bug related to reading in the extent list for regular files
which is not necessary mainline.  That had XFS_WANT_CORRUPTED_GOTO in
xfs_bmap_add_extent_delay_real, having found an extent in the bmbt that was
overlapping the one it was trying to convert.  Maybe that is not related to
this readdir business.

We found that files with the corruption generally had very large extent lists
with small extents, and that xfs_repair wasn't cleaning up this type of
corruption.

>  - instead of putting the ilock back at the highest level we might want
>    to push it down to the dir2 data code and only cover the actual
>    critical region where we need it.

I agree it's worth considering but I'm not sure that it can be pushed much
further down.  

>  - xfs_iread_extents really needs an assert to make sure the ilock
>    is held.
>  - xfs_bmapi_read probably should have an assert as well to make
>    sure the ilock is held in some way

I agree with adding the asserts, and I think the ilock should be reinstated
mainline in readdir.  We do seem to have some reports on the list of freespace
btree corruption and XFS_WANT_CORRUPTED_GOTO that are not resolved.

Anyway, the open and 'attr by handle' paths do seem suspect.  Looks like we're
ok in fallocate because xfs doesn't allow that on directories.  I'll keep
poking around for extent list readers that don't take the i_mutex...

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
