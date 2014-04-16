Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D52FE7F4E
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 00:47:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B594E30406A
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 22:47:52 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id JETZwWhQ8ifOHGrj (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 22:47:51 -0700 (PDT)
Date: Wed, 16 Apr 2014 01:47:47 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Message-ID: <20140416054747.GE21807@thunk.org>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu>
	<20140413220016.GD8122@thunk.org>
	<alpine.LFD.2.00.1404151749490.2146@localhost.localdomain>
	<534D5B2D.70408@redhat.com> <20140415184442.GC4456@thunk.org>
	<534DB38B.7030805@redhat.com> <20140415233039.GR4456@thunk.org>
	<20140416000634.GT15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416000634.GT15995@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Namjae Jeon <linkinjeon@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>

On Wed, Apr 16, 2014 at 10:06:35AM +1000, Dave Chinner wrote:
> > Some of the work that I've
> > been doing with kvm-xfstests and why I created a github tytso/xfstests
> > git tree is specifically to make sure things go much more smoothly
> > this time around.
> 
> Ted, this looks and sounds like you're preparing to fork xfstests.
> Why?  What's the problem with working upstream on test development
> and refinement like everyone else does?

I'd prefer not to fork xfstests.  However, I do want to get more ext4
developers using automated xfstests testing, so I can scale better.
In order to do that, I need to be able to make it really easy for
people to who aren't hard-core xfstests people to be able to use it.

One of the nice things about kvm-xfstests is that a *lot* easier for
people to figure out how to use it.  If I can lower the activation
energy required to get people to use xfstests, it saves me time in the
end.

The reason why I created the github repository is because if I'm going
to be shipping a KVM test appliance image that people can use in a
turn-key environment, I'd prefer that all of the sources, including
any local changes that I might need to make the tests run as smoothly
as possible, are available in a public repository.  (And at one point,
I did have up to 12 local changes, which is why I wanted it tracked in
a repo.)

Every single local change I made was either a test or commit that
hadn't been accepted into the upstream xfstests repository yet, or a
fix I wrote that I sent upstream.  And as soon as the fixes made it
into the upstream xfstests repository, I rebased them away.  At the
moment, there's only once commit in my xfstests github repository
which isn't upstream and it's the:

  check: add support for an external file containing tests to exclude

commit for which I've sent the V2 version to you.

So for the most part, I want to keep the repo as close to upstream as
possible, and ideally identical to upstream, and I've been working
towards that end.

> This thread is a demonstration of how avoiding upstream interaction
> results in nasty hacks being proposed. If you asked the question on
> the xfs mailing list of how to avoid various fsstress/fsx
> operations, we woul dhave told you that using FSSTRESS_AVOID and
> adding an equivalent FSX_AVOID to xfstests is all that is needed.
> i.e. we already have partial infrastructure support for what you
> need in xfstests and it would be about 30 minutes work to add
> FSX_AVOID....
> 
> Is that fast enough for you?
> 
> Indeed, we could also use similar env vars to ensure various
> _requires_* checks fail and to populate FSSTRESS_AVOID/FSX_AVOID
> automatically and so tests that require this functionality are not
> run.

Well, it took me about 1 minute to write the dozen line kernel patch.
I really didn't want to ask you to make changes to xfstests for me,
but if you're willing to make those changes, that would be great.  I
really didn't want to presume, though.  And if the answer is that I
need to spend the time making all of these changes --- I'll try, but
if I don't have time, I may end up taking the more expedient path.

> IOWs, it's in your best interests to work with upstream to add the
> functionality you require to xfstests. History tells us that forking
> development into private repositories has never worked out well for
> anyone, so I'd really, really like you to *at least try* to work
> with upstream as your primary test development environment....

As I said, every single patch which I put in my local xfstests tree I
also sent upstream.

That being said, I wasn't sure whether you were going to accept that
last change, since there was similar, but for me, not usable
functionality in the form of the -X option.  So if you weren't going
to accept a change to allow the excluded list of tests to be kept in a
single file outside of the tests/* subdirectory, I probably would have
carried it as a separate patch --- because it's something I need, and
the current -X functionality really isn't easy to maintain (you need
to have many more files, and they have to be dropped into the xfstests
tests/* subdirectory).

I know that you and I haven't seen eye to eye in the past.  For
example, the NO_HIDE_STALE out of tree patch which is running on
thousands and thousands numbers of machines inside Google, but which
the XFS folks have considered evil incarnate.  I will freely admit
that I'm much more of a pragmatist and much less of a purist on
certain matters.

So sure, I'm certainly going to _try_ to work with upstream xfstests.
I've done that to date.  But I'm certainly not going to presume that
you're going to like or accept all of the changes I might want to
propose.

Regards,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
