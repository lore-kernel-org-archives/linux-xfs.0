Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55D167F53
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 16:03:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3DDF68F8039
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 14:03:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FgbOQGnuydr51b2X for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 14:03:03 -0700 (PDT)
Date: Wed, 23 Oct 2013 08:03:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131022210300.GC2797@dastard>
References: <5265956F.4010700@sandeen.net> <20131021224459.GE16161@dastard>
	<5265B4D2.3000907@sandeen.net> <20131021231849.GL10553@sgi.com>
	<20131021235601.GG4446@dastard> <5265C03B.50701@sandeen.net>
	<20131022001732.GI4446@dastard>
	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>
	<20131022203946.GB2797@dastard> <5266E4BD.8030601@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5266E4BD.8030601@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>, open list <linux-kernel@vger.kernel.org>, XFS FILESYSTEM <xfs@oss.sgi.com>

On Tue, Oct 22, 2013 at 03:49:01PM -0500, Eric Sandeen wrote:
> On 10/22/13 3:39 PM, Dave Chinner wrote:
> > On Tue, Oct 22, 2013 at 08:12:51AM -0200, Geyslan Greg=F3rio Bem wrote:
> >> 2013/10/21 Dave Chinner <david@fromorbit.com>:
> >>> On Mon, Oct 21, 2013 at 07:00:59PM -0500, Eric Sandeen wrote:
> >>>> On 10/21/13 6:56 PM, Dave Chinner wrote:
> >>>>> On Mon, Oct 21, 2013 at 06:18:49PM -0500, Ben Myers wrote:
> >>>
> >>> Yes, but to continue the Devil's Advocate argument, the purpose of
> >>> debug code isn't to enlightent the casual reader or drive-by
> >>> patchers - it's to make life easier for people who actually spend
> >>> time debugging the code. And the people who need the debug code
> >>> are expected to understand why an ASSERT is not necessary. :)
> >>>
> >> Dave, Eric and Ben,
> >>
> >> This was catched by coverity (CID 102348).
> > =

> > You should have put that in the patch description.
> > =

> > Now I understand why there's been a sudden surge of irrelevant one
> > line changes from random people that have never touched XFS before.
> > =

> > <sigh>
> > =

> > Ok, lets churn the code just to shut the stupid checker up. This
> > doesn't fix a bug, it doesn't change behaviour, it just makes
> > coverity happy. Convert it to the for loop plus ASSERT I mentioned
> > in a previous message.
> =

> You know, I respectfully disagree, but we might just have to agree
> to disagree.  The code, as it stands, tests for a null ptr
> and then dereferences it.  That's always going to raise some
> eyebrows, coverity or not, debug code or not, drive by or not.

> So even for future developers, making the code more self-
> documenting about this behavior would be a plus, whether it's by
> comment, by explicit ASSERT(), or whatever.  (I don't think
> that xfs_emerg() has quite enough context to make it obvious.)

Sure, but if weren't for the fact that Coverity warned about it,
nobody other that us people who work on the XFS code day in, day out
would have even cared about it.

That's kind of my point - again, as the Devil's Advocate - that
coverity is encouraging drive-by "fixes" by people who don't
actually understand any of the context, history and/or culture
surrounding the code being modified.

I have no problems with real bugs being fixed, but if we are
modifying code for no gain other than closing "coverity doesn't like
it" bugs, then we *should* be questioning whether the change is
really necessary.

Asking the question may not change the outcome, but we need to ask
and answer the question regardless.

> (We don't have to change code to shut up coverity; we can flag
> it in the database and nobody else will see it.)

Only if you are the first to see it and make an executive decision
that it's not necessary to fix.... :/

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
