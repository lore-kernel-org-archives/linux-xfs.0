Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC8257F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 16:30:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBB9C304048
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 14:30:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id msfdA7ec7CJXGJ82 for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 14:30:19 -0700 (PDT)
Message-ID: <527028EA.8070506@sandeen.net>
Date: Tue, 29 Oct 2013 16:30:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: linux-3.12 userspace Take 2
References: <526A6FF9.8000506@sgi.com> <526EE7CF.7090603@sgi.com>
In-Reply-To: <526EE7CF.7090603@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On 10/28/13 5:40 PM, Rich Johnston wrote:
> Hey Folks,
> 
> Sorry for any confusion, let me try again.
> 
> In preparation for the new userspace release, are there any outstanding
> userspace patches that should be marked as critical and hold up the new
> userspace release?

Dave should definitely chime in too, but certainly at least the xfs_db
patchset - and talking w/ Dave, there's still much repair work to be done.

I'd personally like to see my xfs_fsr fix make it, but that's pretty
small potatoes.

However, I'm not sure we need to be super "release" focused quite yet;
more emphasis on reviewing & merging what's on the list will keep it
all moving along, and we can worry about releases down the road.

Once the xfs_db stuff goes in, maybe that would warrant another prerelease,
though.

> Code shared by userspace and kernelspace are committed by different
> maintainers, I propose we discuss how to make it clear which patch
> series are tied together. This would aid reviewers and testers also.
> 
>     One thought is to state in the kernel [PATCH 0/XX] email body
>     something like:
>         This kernel series shares the same headers as the
>         userspace series "NAME OF USERSPACE SERIES"
> 
>     and a similar email for the userspace series.
> 
>     The second commit should contain the first series commit id to
>     tie them together.

Having two maintainers will make it more tricky, and you guys will
have to communicate well in order for things to go smoothly.

To be orderly about it, I think we must be in a "kernel comes first"
mindset, i.e. changes are made there first, and then userspace, whether
we're talking about shared code, or new interfaces.  That'll
save us from "free()" type errors, among other things.  ;)

(There will be some independent changes on both sides, but determining
that independence should be part of review, i.e. "hey you need to change
this in kernelspace first!")

So yes, if you have a userspace patchset that has kernelspace counterparts,
wait for them to be committed by Ben.  And make sure they still match when
they go into xfsprogs; if not, that should be noted, and the patch series
reposted.

As long as kernelspace is being committed in a timely manner post-review,
then userspace shouldn't lag that by much at all.


I can see how it might be helpful if a 00/XX cover letter makes it clear
that i.e. "patches 1 through 4 are to match kernel changes which have
already been sent in series $BLAH" or "... which are already committed."

If you want to adjust commit logs to note the kernel commit, you could,
although sounds like a bit more work on the maintainer end, and maybe
of limited value.

In the long run, I think Dave was talking about not a copy, but actual
shared code for libxfs, which would simplify all this.

But we're not there yet ...

> Userspace patch series will be committed when the entire patch series
> has been reviewed. Partial series commits will happen only with the
> authors approval (confirmation posted to the list).

Yeah, I think that's the best plan.  If it seems that a large series
is accomplishing several discrete changes, that could be noted in the
cover letter as well, giving "permission" up front to do a partial merge
when independent bits get reviewed, so the whole series doesn't need
to wait if it doesn't have to.

-Eric

> Thanks
> --Rich
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
