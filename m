Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN8rGsu049728 for <xfs@oss.sgi.com>; Fri, 23 Nov 2012 02:53:16 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XwjFUisNqJkRBIjx for <xfs@oss.sgi.com>;
	Fri, 23 Nov 2012 00:55:27 -0800 (PST)
Date: Fri, 23 Nov 2012 19:55:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix attr tree double split corruption
Message-ID: <20121123085523.GE32450@dastard>
References: <1353625175-29479-1-git-send-email-peterhuewe@gmx.de>
	<20121123004937.GC18889@devil.redhat.com>
	<201211230832.44881.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201211230832.44881.PeterHuewe@gmx.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Fri, Nov 23, 2012 at 08:32:44AM +0100, Peter H=FCwe wrote:
> Hi David,
> =

> thanks for your response!
> Am Freitag, 23. November 2012, 01:49:37 schrieb Dave Chinner:
> > [added xfs@oss.sgi.com]
> > =

> > On Thu, Nov 22, 2012 at 11:59:35PM +0100, Peter Huewe wrote:
> > =

> > Hi Peter,
> > =

> > While I appreciate what you are doing here, can you please send
> > stable backport patches to the xfs@oss.sgi.com list for review
> > before sending them to stable@vger.kernel.org? There may already be
> > someone doing this work, and we want to make sure that backports are
> > correct, tested and worth the risk of fixing before asking the
> > (already overworked) stable kernel maintainers to include it.
> =

> Yeah you're right, especially with fs changes we should be more cautious, =

> sorry about the noise then.

It's not noise, just an opportunity to sort a a good process ;)

> I'm one of the few people who offered Greg KH a hand after his 'help want=
ed' =

> message/blog post and one of the 'todos' was to look through git-commits@=
 and =

> pick those who look worth of including into stable.

That's great to hear.

> I was probably a bit too eager here, and skimming from top to bottom of g=
it-
> commits might also not have been a really good idea either ;)

Probably not. But like I said, this is an opportunity....

> > As such, how did you test that the fix works on the stable kernels
> > you are targetting? AFAIK, I'm the only person who has the
> > filesystem images that reproducably triggered this corruption
> > problem....
> =

> I was mainly looking at:
> - does it apply cleanly
> - does it still boot
> - basic functional test
> - short review of the affected code after applying the patch i.e. does it=
 still =

> look okay/as intended?

I can see that this is a good process for most changes, especially
for drivers and non-core functionality where mistakes won't cause
permanent or unrecoverable damage.

Filesystems, though, are a slightly different case - make a mistake,
you can corrupt and/or lose people's data. That's what we need to
avoid at all costs. Hence there's a higher bar for backports and
it pays to involve the guys in the trenches when deciding what to
backport.

I'll give you an idea of my normal process for doing a backport to
stable:

1. identify backport candidates based on how critical the bug is,
risk of regression, how certain I am that the problem properly
fixed, etc.
1a. let people know I'm doing this
2. do the set of backports
3. run xfstests several times, a couple of load tests (e.g. dbench,
compilebench, fsmark for a couple of hours each). Generally I get
24hrs of testing on backports before moving onwards...
4. post the backport for review. If there are multiple versions for
different stable kernels, they all get sent for review (rare). If
the code is already tested and very little change from upstream is
needed, then I'll cc stable@vger.kernel.org at this point too.
5. after review, send to stable@....

We do send some stuff to stable via CC's in commit messages - they
typically aren't the complex fixes that we are cautious about,
though.

Essentially, 1a and 3 are the main things I'm concerned about -
knowing what is going on and what testing has been done. If you are
unsure/scared by the testing requirements, I'm sure that if you ask
nicely one of us will be able to do a test cycle as part of the
review process. :)

> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> > > Signed-off-by: Ben Myers <bpm@sgi.com>
> > > =

> > > Cc: <stable@vger.kernel.org> # 3.6.x
> > > Cc: <stable@vger.kernel.org> # 3.4.x
> > > Cc: <stable@vger.kernel.org> # 3.2.x
> > =

> > If we are pushing this fix back to stable kernels, then it
> > should go back to 3.0.x as well.
> =

> 3.0.x failed my first test (does it apply cleanly?) so I left it out, as =
a =

> dedicated backport is needed.

And we can help with that. If you want learn a lot quickly, then
doing these sorts of backports is a fine way to acheive that.

I'd really, really like what you are doing to work - keeping track
of all the stable kernels and what is in them and what has/hasn't
been back ported is more that I can keep up with (and I've got
distro kernels to worry about, too). Any help we can get would be
greatly appreciated.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
