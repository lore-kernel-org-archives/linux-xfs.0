Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43683 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726941AbfFFVvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 17:51:10 -0400
Date: Fri, 7 Jun 2019 07:50:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
Message-ID: <20190606215008.GA14308@dread.disaster.area>
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com>
 <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Sheena Artrip <sheenobu@fb.com>, sheena.artrip@gmail.com, linux-xfs@vger.kernel.org

On Thu, Jun 06, 2019 at 04:23:51PM -0500, Eric Sandeen wrote:
> On 6/6/19 2:57 PM, Sheena Artrip wrote:
> > When running xfs_restore with a non-rtdev dump,
> > it will ignore any rtinherit flags on the destination
> > and send I/O to the metadata region.
> > 
> > Instead, detect rtinherit on the destination XFS fileystem root inode
> > and use that to override the incoming inode flags.
> > 
> > Original version of this patch missed some branches so multiple
> > invocations of xfsrestore onto the same fs caused
> > the rtinherit bit to get re-removed. There could be some
> > additional edge cases in non-realtime to realtime workflows so
> > the outstanding question would be: is it worth supporting?
> > 
> > Changes in v2:
> > * Changed root inode bulkstat to just ioctl to the destdir inode
> 
> Thanks for that fixup (though comment still says "root" FWIW)
> 
> Thinking about this some more, I'm really kind of wondering how this
> should all be expected to work.  There are several scenarios here,
> and "is this file rt?" is prescribed in different ways - either in
> the dump itself, or on the target fs via inheritance flags...
> 
> (NB: rt is not the only inheritable flag, so would we need to handle
> the others?)
> 
> non-rt fs dump, restored onto non-rt fs
> 	- obviously this is fine
> 
> rt fs dump, restored onto rt fs
> 	- obviously this is fine as well
> 
> rt fs dump, restored onto non-rt fs
> 	- this works, with errors - all rt files become non-rt
> 	- nothing else to do here other than fail outright

This should just work, without errors or warnings.

> non-rt fs dump, restored into rt fs dir/fs with "rtinherit" set
> 	- this one is your case
> 	- today it's ignored, files stay non-rt
> 	- you're suggesting it be honored and files turned into rt

Current filesystem policy should override the policy in dump image
as the dump image may contain an invalid policy....

> the one case that's not handled here is "what if I want to have my
> realtime dump with realtime files restored onto an rt-capable fs, but
> turned into regular files?" 

Which is where having the kernel policy override the dump file is
necesary...

> So your patch gives us one mechanism (restore non-rt files as
> rt files) but not the converse (restore rt files as non-rt files) -
> I'm not sure if that matters, but the symmetry bugs me a little.
> 
> I'm trying to decide if dump/restore is truly the right way to
> migrate files from non-rt to rt or vice versa, TBH.  Maybe dchinner
> or djwong will have thoughts as well...

*nod*

My take on this is that we need to decide which allocation policy to
use - the kernel policy or the dump file policy - in the different
situations. It's a simple, easy to document and understand solution.

At minimum, if there's a mismatch between rtdev/non-rtdev between
dump and restore, then restore should not try to restore or clear rt
flags at all. i.e the rt flags in the dump image should be
considered invalid in this situation and masked out in the restore
process. This prevents errors from being reported during restore,
and it does "the right thing" according to how the user has
configured the destination directory. i.e.  if the destdir has the
rtinherit bit set and there's a rtdev present, the kernel policy
will cause all file data that is restored to be allocated on the
rtdev. Otherwise the kernel will place it (correctly) on the data
dev.

In the case where both have rtdevs, but you want to restore to
ignore the dump file rtdev policy, we really only need to add a CLI
option to say "ignore rt flags" and that then allows the kernel
policy to dictate how the restored files are placed in the same way
that having a rtdev mismatch does.

This is simple, consistent, fulfils the requirements and should have
no hidden surprises for users....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
