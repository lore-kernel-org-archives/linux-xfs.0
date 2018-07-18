Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729667AbeGRUrN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Jul 2018 16:47:13 -0400
Date: Wed, 18 Jul 2018 15:07:41 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180718200741.GA9891@redhat.com>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180716192655.27792-1-billodo@redhat.com>
 <20180717170654.GR32415@magnolia>
 <20180717171714.GA13114@redhat.com>
 <20180717191253.GA26736@redhat.com>
 <20180717203301.GW32415@magnolia>
 <20180717232616.GC19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717232616.GC19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 09:26:16AM +1000, Dave Chinner wrote:
> On Tue, Jul 17, 2018 at 01:33:01PM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 17, 2018 at 02:12:53PM -0500, Bill O'Donnell wrote:
> > > On Tue, Jul 17, 2018 at 12:17:14PM -0500, Bill O'Donnell wrote:
> > > > On Tue, Jul 17, 2018 at 10:06:54AM -0700, Darrick J. Wong wrote:
> > > > > On Mon, Jul 16, 2018 at 02:26:55PM -0500, Bill O'Donnell wrote:
> > > > > > Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> > > > > > Add sanity checks for these parameters.
> > > > > > 
> > > > > > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > > > > > ---
> > > > > > v2: make extra sanity checks exclusive to writes (allow read)
> > > > > > 
> > > > > >  fs/xfs/libxfs/xfs_sb.c | 22 +++++++++++++++++-----
> > > > > >  1 file changed, 17 insertions(+), 5 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > > > index 350119eeaecb..6a98ec68e8ad 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > > > @@ -104,7 +104,8 @@ xfs_mount_validate_sb(
> > > > > >  	xfs_mount_t	*mp,
> > > > > >  	xfs_sb_t	*sbp,
> > > > > >  	bool		check_inprogress,
> > > > > > -	bool		check_version)
> > > > > > +	bool		check_version,
> > > > > > +	bool		write_flag)
> > > > > 
> > > > > I notice that check_version and write_flag are always xor -- either
> > > > > we're reading the sb and set check_version, or we're writing the sb and
> > > > > set write_flag.  Perhaps we can combine these two as write_flag?
> > > > > 
> > > > > if (check_version)
> > > > > 	check version stuff...
> > > > > 
> > > > > becomes:
> > > > > 
> > > > > if (!write_flag)
> > > > > 	check version stuff...
> > > > > 
> > > > > and we only have to pass around one flag.
> > > > 
> > > > I suppose that makes sense, but my notion is that 2 unique flags
> > > > is preferable for clarity and mutual exclusiveness for anyone doing
> > > > subsequent patches.
> > > 
> > > I'm all for simplifying and saving stack space, but is it ok
> > > to turn a single purpose flag into a dual purpose one?
> > 
> > That depends on the flag involved -- if they're mutually exclusive, then
> > I think it's ok to do that, so long as there's a comment nearby to
> > document the argument semantics.
> > 
> > In the case of this particular flag (check_version) it is set by the
> > read verifier so that we reject versions that we don't recognize; it is
> > not set by the write verifier because we don't change the v5 feature
> > masks at runtime* and we never write anything if the fs won't mount.
> > 
> > For write_flag, the read verifier never sets it because we have to be
> > able to mount the fs in case the log contains an sb with an updated set
> > of summary counters or for lazysbcount filesystems we'll recalculate the
> > counter after recovery; and we set write_flag at write time, obviously.
> > 
> > So having come this far, you could meld them into a single parameter so
> > long as you note that write_flag == true means that we're writing the fs
> > and write_flag == false means we want to check the v5 feature flags at
> > mount time to reject features bits that we don't recognize.
> > 
> > * Oh, but what about that pesky asterisk?  My sense of paranoia wonders
> > why we don't check the v5 feature flags on write too, just in case
> > memory gets corrupted.  I think the reason is that we don't allow
> > feature flag changes at runtime, we'll check the changes at ioctl time
> > if we ever do support runtime feature flag updates, and we implicitly
> > trust memory not to corrupt memory on us (ha ha ha).
> > 
> > At this point my tldr opinion is "seems fine to me, let's see if any of
> > the lurking vacationers have anything to say?  We're still ~3 weeks to
> > the next merge window.
> 
> My initial reaction was "urk!". I think we should consider putting
> this check in xfs_sb_verify_write(), not xfs_mount_validate_sb().
> We've kinda taken all the mount time checks (which have to be
> liberal because we can a) be handed non-XFS filesystems, and b)
> handed filesystems that need recovery) and applied them at write
> time, too, then special cased the read side primary superblock stuff
> with a flag.

> 
> The thing is, write time checks (obviously) need to be stricter than
> the mount time checks, and we have to check different things. Hence
> I think we need to do slightly more work here to clean this up. i.e.
> stop calling xfs_sb_verify() in xfs_sb_write_verify() and open code
> it instead, then add all these write-only verifier cases into
> xfs_sb_write_verify().
> 
> Similarly, open code xfs_sb_verify() and move all the read-side
> checks into xfs_sb_read_verify().
> 
> Then rename xfs_mount_validate_sb() to xfs_sb_verify_common(), as it
> only contains the checks that both the read and write side do, and
> it doesn't need any extra parameters at all...

Ok, IIUC, you suggest a partial gutting of xfs_mount_validate_sb(),
and open coding all the write and read checks in xfs_sb_write_verify() 
and xfs_sb_read_verify(), respectively (keeping common checks in 
xfs_mount_validate_sb().

What's not intuitively obvious to me:
which sanity checks in the current xfs_mount_validate_sb() are common
to read and write (and which are exlusive). 

Thanks-
Bill

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
