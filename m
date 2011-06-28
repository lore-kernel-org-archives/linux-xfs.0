Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S1N4FZ167898
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 20:23:05 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2912933DA5
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 18:23:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XysxahzwpC5Ba2xz for <linux-xfs@oss.sgi.com>;
	Mon, 27 Jun 2011 18:23:01 -0700 (PDT)
Date: Tue, 28 Jun 2011 11:22:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs error creating large agcount an raid
Message-ID: <20110628012257.GH32466@dastard>
References: <4E063BC6.9000801@task.com.br> <4E0694CC.8050003@hardwarefreak.com>
	<4E06C967.2060107@task.com.br> <20110626235959.GC32466@dastard>
	<4E07FA07.4050907@hardwarefreak.com> <4E0803AA.20809@task.com.br>
	<4E08456F.1090503@hardwarefreak.com>
	<BANLkTimJm5Fe1LvD1AQYZC5QCDs0gXJpFA@mail.gmail.com>
	<4E089D4E.1060503@sandeen.net>
	<BANLkTikJe7ayzwD2Yqc7BHePfZ4x-M_SyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikJe7ayzwD2Yqc7BHePfZ4x-M_SyQ@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: linux-xfs@oss.sgi.com, Marcus Pereira <marcus@task.com.br>, Eric Sandeen <sandeen@sandeen.net>, Stan Hoeppner <stan@hardwarefreak.com>

On Mon, Jun 27, 2011 at 11:27:00AM -0400, Paul Anderson wrote:
> On Mon, Jun 27, 2011 at 11:10 AM, Eric Sandeen <sandeen@sandeen.net> wrot=
e:
> > On 6/27/11 8:04 AM, Paul Anderson wrote:
> >> One thing this thread indicates is the need for a warning in mkfs.xfs
> >> - according to several developers, there is, I think, linear increase
> >> in allocation time to number of allocation groups.
> >>
> >> It would be helpful for the end user to simply issue a warning stating
> >> this when the AG count seems high with a brief explanation as to why
> >> it seems high. =A0I would allow it, but print the warning. =A0Even a
> >> simple linear check like agroups>500 should suffice for "a while".
> >
> > I disagree.
> >
> > There are all sorts of ways a user can shoot themselves in the foot with
> > unix commands. =A0Detecting and warning about all of them is a fool's e=
rrand.
> =

> Clearly a philosophical difference.
> =

> In managing complex software, it is far better for users if the
> software itself can simply report why something is a problem, without
> resorting to expecting users to read source code or ask developers
> why.

I don't expect users to read code. We have documentation, we expect
users to read it first and have some understanding of how stuff works.
If you don't understand it, then I expect that users will ask
questions on the mailing list. That's -exactly- how the OSS world
works and one of it's great strengths - if you don't understand how
something works you can ask the developers directly!

You seem to be indicating that the XFS developers should be handing
everything to users on a silver platter so they don't have to think
about anything. i.e. that they need *no prior knowledge* to use XFS
effectively and everything should just work.

Welcome to the real world, buddy.

XFS is aimed at high-end, large-scale, high-performance,
high-reliability, 24x7 production workloads.  Any user who ticks
even one of those boxes tends to have at least some knowledge of
their storage and filesystems. If they don't have the necessary
knowledge, they generally have a process via which to evaluate new
technologies for their environment. If they have neither, then they
aren't qualified for the job they've been asked to do.....

Hence we assume that users - at minimum - have read the various man
pages and some of the user/admin documentation on xfs.org before
starting out.  Most of these people tend to heed the "use the
defaults" recommendations, and we typically never hear from them
because Stuff Just Works The Way It Should.

In this particular case, the user had obviously read some of the
documentation, but was applying scalability concepts inappropriately
for the problem he was trying to solve. That is not a bad thing - it
happens all the time - and asking questions is the quickest and
easiest way to understand why something didn't work as expected.
e.g. Just look at Stan's responses about reconfiguring the entire
storage stack to be more optimal for the specific workload the user
was running.

The result of this thread is that the user had a problem, and has
come away with a greatly improved storage configuration from top to
bottom, along with a better understanding of how XFS works and a
better idea of the process needed to evaluate the benefit of
changes.

In the end, that's a user who is much more likely to be happy with
XFS, and a user that knows he'll get good support from the community
so is more likely to report problems in future. That's a win-win
situation as far as I'm concerned, and it helps keeps a high
signal-to-noise ratio on the list.

> There is nothing in the man page I see indicating what is good or bad
> regarding allocation groups - either document it there or warn in the
> software.  If allocation algorithms are linear with respect to
> allocation groups, the something like this should be stated in the man
> pages.

It is, in this man page:

$ man 5 xfs
xfs(5)

NAME
       xfs - layout of the XFS filesystem
.....

It warns that too many AGs is bad.  So really what you are
complaining about is that it doesn't define "too many", right?

Well, IMO, changing a config value by more than an order of
magnitude should ring alarm bells, let alone a change of 3-5 orders
of magnitude.  i.e. When your default is 4 ("small"), then 400 is
large and 4000 is clearly "very high". That's common sense, yes?

However, there may very well be a use case for having 4000 AGs in a
small filesystem - just because I haven't seen one doesn't mean it
doesn't exist, and therefore the capability to do this remains.

IOWs, we cater for people that need to do crazy (good) things, but
we also rely on people having the knoweldge and common sense to
determine whether they really should be doing something crazy or
not...

> Doing neither leads to frustrated end users.  If you answer is "use
> the defaults" then explain why and which parameters is applies to
> (again in the documentation).

As a developer, I always take the time to explain why something
is bad before pointing to the "use the defaults" FAQ entry. I do
that to help the education of everyone on the list that is reading,
and also to get the "don't do this" reason into google....

We've been doing this often enough now that often it is the long
term users that are making such responses and pointing out why
something is bad, not the developers. They've learnt enough from us
through the same process, and now they are helping educate the new
users in turn.

This is also a good feedback loop, because when someone else
explains the problems in their own words, I get to see how well they
understood the previous explainations. As such I'll often let such
threads run until I see some small misunderstanding in an
explanation - at that point I'll jump in to help these expert-users
improve their knowledge further.

Users with in-depth knowledge of the systems are a very valuable
resource - I often learn from their experience solving problems just
like they learn from mine. That's another big win-win situation from
my POV. ;)

> Also, it is not hard to do, and would have in this instance saved
> developer time.  Since the issue has come up a few times the last
> month or so, it seems worthwhile to deal with.

We cannot force people to read the documentation before they twiddle
knobs.

While I fully agree that user friendly interfaces are needed to make
storage administration easy for the technologically challenged, I
think that mkfs is not the place for such refinement.  User friendly
storage tools need to sit above mkfs, fsck, growfs, lvm, md,
dm-crypt, etc and hide *all* the deep, dark, nasty corners of the
storage stack from view. This is something the Sun engineers got
right when designing the ZFS UI.

IOWs, if such a UI is well designed, then it can drive mkfs in
different directions according to the user's needs without the user
needing to know a single thing about how the filesystem actually
works. Hell, done right the user won't even know (or need to care)
what filesystem they are using....

> It's sort of like the story about giving a person a fish versus
> teaching them how to fish.

"Give a man a fish and you feed him for a day. Teach a man to fish
and you feed him for a lifetime."
	- Chinese Proverb.

If you want to use that analogy, then consider that it takes months
to teach someone how to "fish XFS" properly. So they will have
starved before they can catch enough fish to be self-sufficient.
Yes, you can learn the basics of how to "fish XFS" from the
documentation, but it's not enough by itself to be a self-sufficient
expert....

If you think about what I've written above, you'll see that we do
indeed have a (long) process for teaching people how to "fish XFS".
You'll also see that asking questions or even doing silly things
that result in discussion threads like this is a core part of that
education process...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
