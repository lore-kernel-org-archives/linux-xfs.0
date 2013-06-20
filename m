Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 591C57F54
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 14:14:37 -0500 (CDT)
Date: Thu, 20 Jun 2013 14:14:33 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
Message-ID: <20130620191433.GY32736@sgi.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<20130619143537.GN20932@sgi.com>
	<20130619144441.GA14834@infradead.org>
	<51C1C622.7050704@redhat.com> <20130619154709.GO20932@sgi.com>
	<20130619233347.GK29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619233347.GK29338@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

Hey Dave,

On Thu, Jun 20, 2013 at 09:33:47AM +1000, Dave Chinner wrote:
> On Wed, Jun 19, 2013 at 10:47:09AM -0500, Ben Myers wrote:
> > On Wed, Jun 19, 2013 at 10:54:26AM -0400, Ric Wheeler wrote:
> > > On 06/19/2013 10:44 AM, Christoph Hellwig wrote:
> > > >On Wed, Jun 19, 2013 at 09:35:37AM -0500, Ben Myers wrote:
> > > >>>On Wed, Jun 19, 2013 at 02:50:08PM +1000, Dave Chinner wrote:
> > > >>>> >This is my patch queue for 3.11 as it stands right now.
> > > >>>
> > > >>>Getting all of this in for 3.11 does not strike me as being realistic.  You
> > > >>>need to think about how this can be split up.  I see that you have rebased
> > > >>>Jeff's log size validation patch set after your rearrangement.  I'd rather
> > > >>>you'd taken Jeff's series first and then made your changes.  Now we can't pull
> > > >>>in Jeff's work without pulling in a bunch of rearrangement that hasn't been
> > > >>>fully discussed.  You have also crowded out Chandra's quota work.  We had an
> > > >>>agreement with him to go for 3.11 with that work which you have broken.
> > >
> > > >I think 3.11 is a realistic target for all the code movearound, but
> > > >maybe not as part of the normal pull request for -rc1.  If we make sure
> > > >it's really moving code around and not changing it I think a sending a
> > > >second pull request to Linus saying this is just code movearounds we
> > > >wanted to do when the churn causes least problems with actual code work
> > > >he should be fine with it.
> > > 
> > > Just to chime in here, we have a lot of resources focused on testing
> > > these XFS updates both internally with our QA team and with a range
> > > of other RH partners.
> > 
> > This isn't about the size of your QA team or the number of other RH partners.
> > 
> > We had an agreement with Chandra to work toward getting his quota work in 3.11
> > and it appears that Dave has crowded him out with a rearrangement of code which
> > we had no agreement would go into 3.11.
> 
> What I posted is what I'm *proposing* for 3.11. You can't have an
> agreement with first having a proposal....
> 
> > Further, Dave has taken Jeff's log
> > size validation series hostage by rebasing it on top of this rearrangement of
> > code.
> 
> Ben, I think you're being a little melodramatic here. I asked Jeff
> if it was OK to rebase his patchset, and he said that was fine:
> 
> http://oss.sgi.com/pipermail/xfs/2013-June/027270.html
> 
> You don't have to take my rebase of Jeff's patches - you're welcome
> to take them direct from Jeff, but then I'll have to send reviews
> asking for changes to problems I found when integrating it so that's
> going to delay any integration you can do of that series. Please let
> Jeff and myself know what you want to do here...
> 
> > If there is a strategic reason that RH needs to have the kernel/libxfs code
> > rearranged and separated in 3.11 I would have liked to have heard about it
> > before now.  I'm all for getting this work done, but not at the expense of
> > crowding out other XFS contributors.
> 
> You are making a mountain out of a molehill. I had an itch, and I
> scratched it. Simple as that. It is only a couple of days work.

You jumped the queue in front of the other cars.  I'm asking you not to do
that, even if one of the drivers was kind enough to let you in.
 
> If you think it's too much for 3.11, then just say so and leave it at that.
> I'll move it to my for-3.12 queue and you won't see it again until after
> 3.11-rc1 is released...

Lets see where Chandra is at with his quota work.  If he has already rebased on
top of your series I don't see a good reason to rearrange things now.  If he
hasn't, I'd like focus on getting his code merged before pulling in your
rearrangement.  Now that you've rebased Jeff's work, I don't see much point in
redoing that, so maybe that will have to wait for the rearrangement to get
merged.

For now we'll focus on the first 13 patches.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
