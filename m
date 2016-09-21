Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:24576 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753799AbcIUVsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2016 17:48:19 -0400
Date: Thu, 22 Sep 2016 07:48:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/4] ovl: use vfs_clone_file_range() for copy up if
 possible
Message-ID: <20160921214814.GC10454@dastard>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-3-git-send-email-amir73il@gmail.com>
 <CAJfpegvtCf7mPanvmhU8vmoyQTUsVo-O0bpNxwnt4abkJ5ZD6Q@mail.gmail.com>
 <CAOQ4uxjEUghU=-RDBOn5zg6hrM1pn1FseEspO8hCLcSnH4WNGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjEUghU=-RDBOn5zg6hrM1pn1FseEspO8hCLcSnH4WNGA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Sep 21, 2016 at 08:01:22PM +0300, Amir Goldstein wrote:
> On Wed, Sep 21, 2016 at 6:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Wed, Sep 14, 2016 at 2:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >> When copying up within the same fs, try to use vfs_clone_file_range().
> >> This is very efficient when lower and upper are on the same fs
> >> with file reflink support. If vfs_clone_file_range() fails because
> >> lower and upper are not on the same fs or if fs has no reflink support,
> >> copy up falls back to the regular data copy code.
> >>
> >> Tested correct behavior when lower and upper are on:
> >> 1. same ext4 (copy)
> >> 2. same xfs + reflink patches + mkfs.xfs (copy)
> >> 3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (reflink)
> >> 4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)
> >>
> >> For comparison, on my laptop, xfstest overlay/001 (copy up of large
> >> sparse files) takes less than 1 second in the xfs reflink setup vs.
> >> 25 seconds on the rest of the setups.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>  fs/overlayfs/copy_up.c | 12 +++++++++++-
> >>  1 file changed, 11 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> >> index 43fdc27..ba039f8 100644
> >> --- a/fs/overlayfs/copy_up.c
> >> +++ b/fs/overlayfs/copy_up.c
> >> @@ -136,6 +136,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
> >>                 goto out_fput;
> >>         }
> >>
> >> +       /* Try to use clone_file_range to clone up within the same fs */
> >> +       error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
> >> +       if (!error)
> >> +               goto out;
> >> +       /* If we can clone but clone failed - abort */
> >> +       if (error != -EXDEV && error != -EOPNOTSUPP)
> >> +               goto out;
> >
> > Would be safer to fall back on any error.
> >
> 
> Agreed. Dave, since you suggested the 'softer' fall back, do you have
> any objections?

If you get any error other than -EXDEV or -EOPNOTSUPP from a clone
operation, there's somethign seriously wrong with the metadata of
the inode or th eunderlying storage. You're not going to be able to
copy the data if a clone fails for exactly the same reasons.

What's worse is that you might get a partial copy before failure, or
there might not be a failure during copy at all because the fs uses
delayed allocation and the corruption problem during allocation that
prevented clone from working is not triggered until writeback time.
i.e. you may not have anyone to report the fact that the copyup
failed by the time the failure is known.

Your choice, really - I'd much prefer that known hard errors are
propagated immediately than leave them to chance and have a user
then wonder where the $ANTI-DEITY their data has gone later on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
