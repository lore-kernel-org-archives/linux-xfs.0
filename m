Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 533A37F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 19:48:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D2958F8054
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 17:48:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UOKBsWwy6i9hLSDm for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 17:48:36 -0700 (PDT)
Date: Mon, 28 Apr 2014 10:48:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: add heuristic to flush on rename
Message-ID: <20140428004832.GJ15995@dastard>
References: <535ABA9D.2060305@redhat.com> <20140427212026.GX18672@dastard>
	<535D7CF7.2070409@sandeen.net> <20140427231523.GZ18672@dastard>
	<535D9EB9.50902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535D9EB9.50902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Apr 27, 2014 at 07:20:09PM -0500, Eric Sandeen wrote:
> On 4/27/14, 6:15 PM, Dave Chinner wrote:
> > On Sun, Apr 27, 2014 at 04:56:07PM -0500, Eric Sandeen wrote:
> >> On 4/27/14, 4:20 PM, Dave Chinner wrote:
> >>> On Fri, Apr 25, 2014 at 02:42:21PM -0500, Eric Sandeen wrote:
> >>>> Ext4, however, added a heuristic like this for just this case;
> >>>> someone who writes file.tmp, then renames over file, but
> >>>> never issues an fsync.
> >>>
> >>> You mean like rsync does all the time for every file it copies?
> >>
> >> Yeah, I guess rsync doesn't fsync either.  ;)
> > 
> > That's because rsync doesn't need to sync until it completes all of
> > the data writes. A failed
> > rsync can simply be re-run after the system comes back up and
> > nothing is lost. That's a very different situation to a package
> > manager replacing binaries that the system may need to boot, yes?
> 
> yeah, my point is that rsync overwrites exiting files and _never_ syncs.
> Not per-file, not at the end, not with any available option, AFAICT.

But which a user can easily add.

> Different situation, yes, but arguably just as bad under the
> wrong circumstances.

Which is why rsync provides this:

$ zcat /usr/share/doc/rsync/scripts/atomic-rsync.gz
....
This script lets you update a hierarchy of files in an atomic way by first
creating a new hierarchy (using hard-links to leverage the existing files),
and then swapping the new hierarchy into place.
....

Yes, it doesn't have a sync in it but, again, that can easily be
added. The point being is that rename safety and atomic renames are
something that can be solved at the application level....

> >>>> Now, this does smack of O_PONIES, but I would hope that it's
> >>>> fairly benign.  If someone already synced the tmpfile, it's
> >>>> a no-op.
> >>>
> >>> I'd suggest it will greatly impact rsync speed and have impact on
> >>> the resultant filesystem layout as it guarantees interleaving of
> >>> metadata and data on disk....
> >>
> >> Ok, well, based on the responses thus far, sounds like a non-starter.
> >>
> >> I'm not wedded to it, just thought I'd float the idea.
> >>
> >> OTOH, it is an interesting juxtaposition to say the open O_TRUNC case
> >> is worth catching, but the tempfile overwrite case is not.
> > 
> > We went through this years ago - the O_TRUNC case is dealing with
> > direct overwrite of data which we can reliably detect, usually only
> > occurs one file at a time, has no major performance impact and data
> > loss is almost entirely mitigated by the flush-on-close behaviour.
> > It's a pretty reliable mitigation mechanism.
> 
> [citation needed] for a some of that, but *shrug*

It was internal to SGI, mainly related to Irix, unfortunately, which
is where all this "avoid NULL files" stuff came from originally...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
