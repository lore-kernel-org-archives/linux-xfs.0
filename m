Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7671E7F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 04:48:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B3808F804B
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 02:48:21 -0700 (PDT)
Received: from mail-vc0-f169.google.com (mail-vc0-f169.google.com
	[209.85.220.169]) by cuda.sgi.com with ESMTP id
	BKkaRsRaiKxV7JhS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 02:48:19 -0700 (PDT)
Received: by mail-vc0-f169.google.com with SMTP id hy4so5583865vcb.28
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 02:48:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141013013715.GD4503@dastard>
References: <20141013013715.GD4503@dastard>
Date: Mon, 13 Oct 2014 05:48:18 -0400
Message-ID: <CA+55aFwcE=OX7FvckrsZRopCAxw0QnEu5iQUEM5JBoDVzg7uEA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: updates for 3.18-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Oct 12, 2014 at 9:37 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> i.e. I have generated this pull-req from the base tree I've been working
> on (3.17-rc2) but there have already been commits merged into a more
> recent upstream tree (3.17-rc4) in this tree. When I generate the
> pull request from the underlying 3.17-rc2 branch, it includes all
> those commits, both in the summary and the diffstat. If I base the
> pull request off 3.17, the base commit is the last one that was
> merged into your tree, and the diffstat and commit list reflect
> that.

That's fine, and works for me too. This is normal and expected for
stuff that has gotten into my tree other ways (ie bugfixes that were
cherrypicked to be backported from development trees etc).  I'm used
to it, and while I hope people minimize it (not only because of
multiple commits showing up with the same patch, but because it can
easily cause stupid merge conflicts because the development tree then
made further changes on top of the same patch), it's also very much
considered "normal development".

That said, when there are actual *common* commits as in your case (as
opposed to cherrypicked commits that generate duplicate commits with
the same patch), I would generally suggest you just let "git
merge-base" figure it all out from my latest tree. That way it takes
into account the stuff that you sent earlier on its own.

But this is not a big deal.

> So my question is this: Which tree should I generate the pull
> request from? I flipped a coin an generated this one from 3.17-rc2,
> but if you'd prefer to see just the commits/diffstat that aren't in
> your tree, let me know and I'll do it differently next time....

Normally, I'd suggest the easiest way to handle things is to have a
"linus" branch that tracks my upstream, and then just generate the
pull request off that. Git will figure out the latest merge base and
just do the right thing, and you don't need to really think about
where you forked things off, and which parts you have already sent to
me.

As mentioned, even then the diffstat doesn't always end up being
exactly right, because the history with partially merged branches, and
with potential cherry-picked commits. So I am not surprised or upset
if the diffstat doesn't always match, it happens quite commonly. I go
on a rant when that i sdue to bad development practices, but I don't
see anything like that in your tree.

Some people avoid this by actually generating a test-merge (to warn me
about upcoming conflicts etc), and then generate the diffstat from
that test merge instead of just using the plain "git diff" in the
git-pull-request helper scripts. Whatever works. This is not a huge
deal, exactly because it's "normal development" (unlike the
back-merges issue).

And in this case, it looks like you don't even have cherry-picks, but
just shared common branches, some of which you sent earlier. It looks
like the diffstat if you just use my current tree as the other point
of the git merge-base is correct, although I haven't actually done the
merge itself yet (still waiting for the build for the previous merge
to finish).

                Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
