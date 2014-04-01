Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8AAB37F54
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 17:04:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 316D930405F
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 15:04:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xGFikzPXs7kJPQbS for <xfs@oss.sgi.com>;
	Tue, 01 Apr 2014 15:03:57 -0700 (PDT)
Date: Wed, 2 Apr 2014 09:03:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix bad hash ordering
Message-ID: <20140401220343.GI17603@dastard>
References: <20140328173430.622616177@sgi.com> <20140331001055.GD16336@dastard>
	<53399B06.5010400@sgi.com> <20140331214016.GD17603@dastard>
	<533A22DB.2030608@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <533A22DB.2030608@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Mon, Mar 31, 2014 at 09:22:19PM -0500, Mark Tinguely wrote:
> >Well, it's been over a week now and you're asking me to trust that
> >someone I don't know and who has never submitted an xfstests before
> >to do something in a timely manner so we can test a critical bug fix
> >during a merge window. I'm willing to be pleasently surprised, but
> >history tells me that people that report bugs rarely follow up with
> >xfstest cases and it's usually the developer that fixes the bug that
> >generates the xfstests patch.
> >
> >So if the xfstests patch doesn't arrive in the next few hours, can
> >you please do that for us so I can get this sorted out for the merge
> >window?
> >
> >Cheers,
> >
> >Dave.
> 
> Dave,
> 
> I think we need to take a step back and clear a little confusion here.
> There are 2 different directory bugs.
> 
> 1) Freeing of a already free extent. It presents with the error:
> 	XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 16XX of file
> 	 fs/xfs/xfs_alloc.c.
>    Could be a right or a left edge (or both) that is free.
> 
>    Morgan Meyers <Morgan.Mears@netapp.com> sent the latest occurrence on
>    March 12, but others have been seeing it in the community code in the
>    last few mounts. SGI has been seeing it lately with big customers and
>    it has occurred off and on for 7-8  years according to our bug
>    database.

I fail to see what this has to do with someone providing an xfstests
case for the directory hash regression that was under discussion.

Regardless, I'll take issue with your sweeping generalisation: not
every XFS_WANT_CORRUPTED_GOTO error has the same cause. Indeed, most
of the ones we've seen in the past 7-8 years we've found some kind
of problem with hardware or fixed other bugs that have made it go
away.

The above issue that was reported is - so far - a one of a kind. I
haven't seen any other reports that are even vaguely similar. If SGI
has more customers hitting this problem, then it would be really
nice if SGI could provide that information to the community rather
than complain that they've been seeing it for 8 years. All that
tells us in the community is that you aren't fixing bugs your
customers are hitting and youren't passing them on to people who
might be able to help...

IOWs, if a vendor doesn't have the expertise to find the underlying
problem and they need help tracking down such problems, then they
should report the bugs to the list like end users do.

> 2) Hannes Frederic Sowa found a different directory bug on Thursday,
>    March 27. He included a replicator. I bisected the source of the this
>    bug on Thursday. Walked the bisected patch on Friday and posted the
>    patch. The idea to make a xfstest from the replicator was also made
>    on March 28.
> 
>    This bug has been only known for 3 business days. I already promised
>    that a xfstest will be made. If you need to verify the problem and
>    the patch, there already is a replicator.

The xfstest is *not for me* - it's for every distro and vendor out
there that ships XFS in their product to realise that there's a
serious bug they need fixing, and for them to be able to confirm
that they've fixed it.  I don't ask people to do stuff for my
benefit - I'm perfectly capable of doing random special stuff for
myself - but I will ask for things that are needed for the greater
community.

That's why I asked you to rewrite the commit message to explain what
the cause and impact of problem being fixed was, and why I'm asking
for the regression test to be provided quickly. Both of these things
greatly benefit downstream users of XFS and xfstests, so upstream
processes need to reflect this. Fixing the bug in the upstream tree
is only half the job we need to do...

It's a moot discussion now that the xfstest case has been posted....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
