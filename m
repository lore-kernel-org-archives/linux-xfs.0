Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBAM1UAS007486 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 16:01:30 -0600
Date: Mon, 10 Dec 2012 16:03:56 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [3.0-stable PATCH 00/36] Proposed 3.0-stable bug patches
Message-ID: <20121210220356.GY27055@sgi.com>
References: <20121203144208.143464631@sgi.com> <20121205214505.GG29399@dastard>
	<50C0D57A.9000704@sgi.com> <20121207100646.GJ27172@dastard>
	<20121207211536.GW27055@sgi.com> <20121210002443.GE15784@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121210002443.GE15784@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Mark Tinguely <tinguely@sgi.com>, stable@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,

On Mon, Dec 10, 2012 at 11:24:43AM +1100, Dave Chinner wrote:
> On Fri, Dec 07, 2012 at 03:15:36PM -0600, Ben Myers wrote:
> > > > As for adding patches to 3.0-stable. I believed then and now that
> > > > proactively suggesting bug fixes into 3.0-stable is a good thing
> > > > because it is the long term stable branch.
> > > 
> > > Which is in direct contrast to what most of us think. That is, if
> > > nobody is reporting problems, then it ain't broke and it doesn't
> > > need fixing.
> > 
> > Who are you speaking for?
> 
> The people who have had to maintain the stable trees for the past
> few years. It doesn't take a rocket scientist to work out who those
> people are...
> 
> > > /me is playing Devil's Advocate because I'm not signing up to
> > > triage a whole new set of 3.0.x stable kernel regressions when
> > > nobody is currently reporting problems.....
> > 
> > SGI XFS product is based directly upon -stable branches and I'd like to track
> > these branches as closely as possible.
> 
> I'd say that's an important piece of information - i.e. stating the
> motivation for doing this work.  Especially as you might be
> including patches that fix bugs that have never been reported
> outside of SGI customers.
> 
> FWIW, I had no idea that SGI is now basing their XFS-derived
> products off a current mainline tree.

Our XFS product is based on 3.0-stable.  This is a new development which
I've been working toward for a little while.  There are other ways we
could be doing this, but I think it's best to work directly in the
stable branches if possible.

> Can you point us to the relevant XFS source code for these product
> releases?

The sources ship with the product.

> I, for one, am interested in the updated DMAPI support infrastructure and how
> SGI has implemented all the little tweaks mentioned in SGI's XFS
> documentation (e.g. ibound and agskip)...

Sure... Take a look here for dmapi:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=shortlog;h=refs/heads/v3.0-xfs_dmapi

Rich volunteered to post ibound and agskip.  The poor guy keeps
volunteering for things.  He never learns.

> > This aligns the interests of the SGI XFS team and -stable users.
> 
> Enough with the marketing speak, already.  Be up front with you
> motivations - it helps prevent a lot of misunderstandings.

That accurately described I'm trying to do.   I don't think I'd last
very long in marketing but you never know:  maybe I've missed my
calling.  Get over it, already.  ;)

> > If there are regressions, myself, Mark, Phil, Rich, and Andrew are
> > signed up to fix them regardless of whether you wish to be
> > involved.
> 
> I'm looking forward to seeing you guys run front-line community
> bug triage, then.... :)

We'll be happy to be more involved in front-line triage.  I chatted with
management about this and we'll get the thing organised.

We don't have to do it this way, but as long as the work is being done
it might as well benefit the community.  That is basically the same
proposition you made when you posted your series for -stable.  Mark has
removed the content that seemed inappropriate and posted again.  Is
there additional content in this series that you feel is not appropriate
for stable?  I'm sure Mark will be willing to have another go at this.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
