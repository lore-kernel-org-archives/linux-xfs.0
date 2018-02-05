Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25021 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750796AbeBEWfL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 17:35:11 -0500
Date: Tue, 6 Feb 2018 09:36:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS over device mapper dm-thin device
Message-ID: <20180205223604.wgacfnsrsaqrwz7n@destitution>
References: <147a1764-1988-4efd-4f02-e942a1001b4e@redhat.com>
 <20180202223541.i27bfjij7itt3q5r@destitution>
 <9c3ec8ff-3595-c889-3abe-7f069292be0d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c3ec8ff-3595-c889-3abe-7f069292be0d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Todd Gill <tgill@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Feb 02, 2018 at 05:36:40PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/2/18 4:35 PM, Dave Chinner wrote:
> > On Fri, Feb 02, 2018 at 04:45:33PM -0500, Todd Gill wrote:
> >>
> >> Hi,
> >>
> >> I'd like to be able to take a snapshot of an XFS filesystem on top of
> >> dm-thin.
> >>
> >> The goal for the snapshot is:
> >>
> >>     - fast to complete (couple seconds or better)
> >>     - independent of origin (UUID updated?)
> >>     - read/write
> >>
> >> To satisfy the independent goal, I'm updating the UUID on the snapshot.
> >> Currently "xfs_admin -U xxx" takes in the ballpark of 14 seconds on my
> >> test system.
> > 
> > There's a very good chance that this is caused by dm-thinp doing
> > COW for the storage underlying the superblocks modified by the UUID
> > change.
> 
> It's actually because we rewrite the whole log, because it has the
> user-facing superblock stamped in it.
> 
> I looked at this a bit, and didn't immediately see an easy way around
> xfs_db's need to rewrite the whole log.
> 
> uuid_f()
>                 /* clear the log (setting uuid) if it's not dirty */
>                 if (!sb_logzero(&uu))
>                         return 0;
> 
> so I think that's taking the bulk of the time.  I haven't looked closely
> enough at all the mount-time log parsing to see if we could maybe write
> less of it and still be valid.

Ah, I forgot we added that. Originally the uuid in the log was only
used to identify external log devices (or Irix based filesystems).

> >> Or can the UUID update
> >> be changed to be faster?
> > 
> > Not sure - there's a fixed amount of modification we need to make
> > to change the UUID so I'm not sure there is any optimisations we
> > can make here.
> 
> In retrospect I think we (I) should have left the "metadata" uuid as
> the one to match the log, not the user-facing one.

I suspect we can just change the log recovery code to accept either
sb_uuid or sb_metauuid if the metauuid feature bit is set and
change xfs_db to not rewrite the log when metauuid is used....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
