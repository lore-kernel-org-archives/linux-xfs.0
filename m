Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55516 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfFRPKk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 11:10:40 -0400
Date: Tue, 18 Jun 2019 08:09:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
Message-ID: <20190618150915.GA5387@magnolia>
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com>
 <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
 <20190606215008.GA14308@dread.disaster.area>
 <4a03b347-1a71-857d-af9d-1d7eca00056a@sandeen.net>
 <20190606223607.GE14308@dread.disaster.area>
 <CABeZSNkGoKhfV2-=CfqSPUsf9CxLNFP5vRa161M_LowfnJ8TzA@mail.gmail.com>
 <20190617225558.GN3773859@magnolia>
 <CABeZSNkuNrLPMJ+HK8MPvBbLjHu4XszimOu+TsWnQNENbfoxNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeZSNkuNrLPMJ+HK8MPvBbLjHu4XszimOu+TsWnQNENbfoxNg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sheena Artrip <sheena.artrip@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, Sheena Artrip <sheenobu@fb.com>, linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 11:28:03PM -0700, Sheena Artrip wrote:
> On Mon, Jun 17, 2019 at 3:56 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Mon, Jun 17, 2019 at 03:09:15PM -0700, Sheena Artrip wrote:
> > > On Thu, Jun 6, 2019 at 3:37 PM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Thu, Jun 06, 2019 at 05:08:12PM -0500, Eric Sandeen wrote:
> > > > > On 6/6/19 4:50 PM, Dave Chinner wrote:
> > > > > > My take on this is that we need to decide which allocation policy to
> > > > > > use - the kernel policy or the dump file policy - in the different
> > > > > > situations. It's a simple, easy to document and understand solution.
> > > > > >
> > > > > > At minimum, if there's a mismatch between rtdev/non-rtdev between
> > > > > > dump and restore, then restore should not try to restore or clear rt
> > > > > > flags at all. i.e the rt flags in the dump image should be
> > > > > > considered invalid in this situation and masked out in the restore
> > > > > > process. This prevents errors from being reported during restore,
> > > > > > and it does "the right thing" according to how the user has
> > > > > > configured the destination directory. i.e.  if the destdir has the
> > > > > > rtinherit bit set and there's a rtdev present, the kernel policy
> > > > > > will cause all file data that is restored to be allocated on the
> > > > > > rtdev. Otherwise the kernel will place it (correctly) on the data
> > > > > > dev.
> > > > > >
> > > > > > In the case where both have rtdevs, but you want to restore to
> > > > > > ignore the dump file rtdev policy, we really only need to add a CLI
> > > > > > option to say "ignore rt flags" and that then allows the kernel
> > > > > > policy to dictate how the restored files are placed in the same way
> > > > > > that having a rtdev mismatch does.
> > > > > >
> > > > > > This is simple, consistent, fulfils the requirements and should have
> > > > > > no hidden surprises for users....
> > > > >
> > > > > Sounds reasonable.  So the CLI flag would say "ignore RT info in the
> > > > > dump, and write files according to the destination fs policy?"
> > > > > I think that makes sense.
> > >
> > > Any suggested flag name/prefix for this? Last i checked all the single
> > > letters were taken up?
> >
> > I suggest --preserve-xflags=<same letters as xfs_io lsattr command>
> 
> What's the implication? That we do not copy any xflags bits unless you
> include them in --preserve-xflags?
> The defaults of this would be all the available fields.
> 
> That still leaves the destination needing a xflag bit like realtime
> and the source not having it...Maybe
> xfsdump needs --preserve-xflags and xfsrestore needs --apply-xflags ?
> That will catch
> all the cases and the solution is just an and/xor on the
> outgoing/incoming bsp_xflags field:
> 
>  * realtime->realtime (--preserve-xflags=all --apply-xflags=none)
>  * non-realtime->realtime (--preserve-xflags=all --apply-xflags=t)
>  * non-realtime->non-realtime (--preserve-xflags=all --apply-xflags=none)
>  * realtime->non-realtime (--preserve-xflags=all-but-t)

I was clearly confusing, my apologies. :/

What I should've said more explicitly was that xfsdump continues to save
all the xflags as it does now, and that we should consider adding a new
cli option to xfsrestore to preserve certain xflags from the underlying
fs with a new --preserve-xflags= option.  Maybe it should be
--preserve-dest-xflags to make it clear that the xflags of the
destination are overriding the dump.

For your "create dump on non-rt fs and restore to rt dev on rt fs" use
case, you'd do....

# xfsdump -f /dumpfile /oldfs
# mkfs.xfs -r rtdev=/dev/sdX -d rtinherit=1 /dev/sdY
# mount /dev/sdY /newfs
# xfsrestore -f /dumpfile --preserve-dest-xflags=t /newfs

--D

> Thanks!
> 
> > --D
> >
> > > > *nod*
> > > >
> > > > > Now: do we need to do the same for all inheritable flags?  projid,
> > > > > extsize, etc?  I think we probably do.
> > > >
> > > > I disagree. These things are all supported on all destination
> > > > filesystems, unlike the rtdev. They are also things that can be
> > > > changed after the fact, unlike rtdev allocation policy. i.e. rtdev
> > > > has to be set /before/ restore, just about everything else can be
> > > > set or reset after the fact....
> > > > Cheers,
> > > >
> > > > Dave.
> > > > --
> > > > Dave Chinner
> > > > david@fromorbit.com
