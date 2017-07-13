Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48627 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdGMRKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 13:10:33 -0400
Date: Thu, 13 Jul 2017 10:10:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: in iomap seek_{hole,data}, return -ENXIO for
 negative offsets
Message-ID: <20170713171026.GB4151@magnolia>
References: <20170712173650.GC4212@magnolia>
 <566E0688-E3D4-416A-B496-6B2F0FA3C85C@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566E0688-E3D4-416A-B496-6B2F0FA3C85C@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Wed, Jul 12, 2017 at 11:08:51PM -0700, Andreas Dilger wrote:
> On Jul 12, 2017, at 10:36 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > In the iomap implementations of SEEK_HOLE and SEEK_DATA, make sure we
> > return -ENXIO for negative offsets instead of badgering the iomap
> > provider with garbage requests.
> 
> Hmm, wouldn't it be useful to be able to seek N bytes before the hole
> or data?

Yes, but you can do that with a first lseek SEEK_DATA call to position
us at the start of data followed by a second lseek SEEK_CUR to position
us at the desired before-data offset.  The offset argument to SEEK DATA
tells us where to start looking for the next hole/not-hole.

> It would make more sense to verify the result after finding the hole
> or data and adding the relative offset. It should only be an error if
> the resulting offset is before the start or after the actual file end.

In any case, the manpage says:

"SEEK_DATA
Adjust the file offset to the next location in the file greater than or
equal to offset containing data.  If offset points to data, then the
file offset is set to offset.

"SEEK_HOLE
Adjust the file offset to the next hole in the file greater than or
equal to offset.  If offset points into the middle of a hole, then the
file offset is set to offset.  If there is no hole past offset, then the
file offset is adjusted to the end of the file (i.e., there is an
implicit hole at the end of any file)."

...which to my mind means that offset has to be an absolute file offset.
Therefore, negative offsets aren't allowed, and we're stuck with that.

Regrettably the ERRORS section doesn't specify the behavior when offset
is negative, so this patch merely fixes XFS to behave the same way it
did up to 4.12 (which fwiw matches btrfs behavior).

--D

> Of course, if the passed offset > size from the start then
> there is no way it can get better and that would be grounds for
> returning early.
> 
> Cheers, Andreas
> 
> > Inspired-by: Mateusz S <muttdini@gmail.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > fs/iomap.c |    8 ++++----
> > 1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index 432eed8..16f5c074 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -610,8 +610,8 @@ iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
> > 	loff_t length = size - offset;
> > 	loff_t ret;
> > 
> > -	/* Nothing to be found beyond the end of the file. */
> > -	if (offset >= size)
> > +	/* Nothing to be found before or beyond the end of the file. */
> > +	if (offset < 0 || offset >= size)
> > 		return -ENXIO;
> > 
> > 	while (length > 0) {
> > @@ -656,8 +656,8 @@ iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
> > 	loff_t length = size - offset;
> > 	loff_t ret;
> > 
> > -	/* Nothing to be found beyond the end of the file. */
> > -	if (offset >= size)
> > +	/* Nothing to be found before or beyond the end of the file. */
> > +	if (offset < 0 || offset >= size)
> > 		return -ENXIO;
> > 
> > 	while (length > 0) {
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


