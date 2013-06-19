Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E7F87CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 10:47:13 -0500 (CDT)
Date: Wed, 19 Jun 2013 10:47:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
Message-ID: <20130619154709.GO20932@sgi.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<20130619143537.GN20932@sgi.com>
	<20130619144441.GA14834@infradead.org>
	<51C1C622.7050704@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C1C622.7050704@redhat.com>
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
To: Ric Wheeler <rwheeler@redhat.com>
Cc: xfs@oss.sgi.com

Hey Ric,

On Wed, Jun 19, 2013 at 10:54:26AM -0400, Ric Wheeler wrote:
> On 06/19/2013 10:44 AM, Christoph Hellwig wrote:
> >On Wed, Jun 19, 2013 at 09:35:37AM -0500, Ben Myers wrote:
> >>>On Wed, Jun 19, 2013 at 02:50:08PM +1000, Dave Chinner wrote:
> >>>> >This is my patch queue for 3.11 as it stands right now.
> >>>
> >>>Getting all of this in for 3.11 does not strike me as being realistic.  You
> >>>need to think about how this can be split up.  I see that you have rebased
> >>>Jeff's log size validation patch set after your rearrangement.  I'd rather
> >>>you'd taken Jeff's series first and then made your changes.  Now we can't pull
> >>>in Jeff's work without pulling in a bunch of rearrangement that hasn't been
> >>>fully discussed.  You have also crowded out Chandra's quota work.  We had an
> >>>agreement with him to go for 3.11 with that work which you have broken.
>
> >I think 3.11 is a realistic target for all the code movearound, but
> >maybe not as part of the normal pull request for -rc1.  If we make sure
> >it's really moving code around and not changing it I think a sending a
> >second pull request to Linus saying this is just code movearounds we
> >wanted to do when the churn causes least problems with actual code work
> >he should be fine with it.
> 
> Just to chime in here, we have a lot of resources focused on testing
> these XFS updates both internally with our QA team and with a range
> of other RH partners.

This isn't about the size of your QA team or the number of other RH partners.

We had an agreement with Chandra to work toward getting his quota work in 3.11
and it appears that Dave has crowded him out with a rearrangement of code which
we had no agreement would go into 3.11.  Further, Dave has taken Jeff's log
size validation series hostage by rebasing it on top of this rearrangement of
code.

If there is a strategic reason that RH needs to have the kernel/libxfs code
rearranged and separated in 3.11 I would have liked to have heard about it
before now.  I'm all for getting this work done, but not at the expense of
crowding out other XFS contributors.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
