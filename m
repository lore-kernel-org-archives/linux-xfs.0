Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 19:38:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S2brKs018883
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 19:38:04 -0700
Date: Mon, 28 Apr 2008 12:37:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Message-ID: <20080428023757.GB108924158@sgi.com>
References: <200804270246.58828.vda.linux@googlemail.com> <20080427232317.GB103491721@sgi.com> <200804280148.22358.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804280148.22358.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 01:48:22AM +0200, Denys Vlasenko wrote:
> On Monday 28 April 2008 01:23, David Chinner wrote:
> > > This patch reduces xfs_page_state_convert() stack usage by 16 bytes
> > > by eliminating some local variables, and reducing the size
> > > of scope for other locals.
> > > 
> > > Compile tested only.
> > 
> > Can you start testing your patches? if you are touching the writeback
> > or allocator path, there's a pretty high barrier to having patches
> > excepted, and testing them before is one of them. Go and download the
> 
> Its you who asked for patches. It's not like I decided
> to nag you because I have nothing better to do. Actually,
> my plate is pretty full with other things already.

Yes, I asked for patches. That doesn't guarantee that we'll accept
them, though, or apply criteria other than "does it compile?" when
deciding whether to accept them.

Given that an unnoticed error in the allocation and writeback paths
could result in on-disk corruption on every single XFS filesystem
that uses it, I consider asking patch submitters to do some testing
(given that we have a test suite) not at all unreasonable.

Cleanups like removing function args are trivial and we can easily
review and test them (I'm doing that for several of your patches on
ia64, x86_64 and UML), but factoring critical code is a different
level. I note that Christoph's patch to the same code included a
comment that "it passed XFSQA" - he is a long time contributor to
XFS and knows that this is critical code and has performed the due
diligence that we expect for changes to critical code.

Basically, what I'm saying is that I'm not holding you to a standard
that is different to anyone else contributing patches to XFS - it's
the same standard patches from SGI XFS engineers are held to. Yes,
it might be a higher standard than you are used to, but people make
mistakes and the processes we use attempt to prevent mistakes that
have been made in the past.

> I was honestly trying to help you. I am still willing
> to do it, but at some point you have to carry some part
> of a burden (maybe review and run testing?).

I am grateful for the time you have spent so far writing and
sending patches, and encourage you to continue doing so.

However, part of the overall burden of code changes has to be shared
by the submitter.  We're taking on the integration, QA and long term
maintenance burden by accepting your patch. A bug in a patch could
mean weeks of engineering time a year down the track when someone
finally hits the corner case that triggers the bug. That burden is
something you will never have to wear, but it's a major, major load
on us and at some times completely absorbs all our resources.

Hence to reduce the *burden on us* we ask that non-trivial patches
or patches to critical sections of code are tested first by the
submitter to help increase the initial code coverage of the patch.
It saves us all lot of pain and expense in the long run....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
