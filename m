Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17868 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032055AbeBNX4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 18:56:19 -0500
Date: Thu, 15 Feb 2018 10:56:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_buf_lock vs aio
Message-ID: <20180214235616.GM7000@dastard>
References: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
 <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
 <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
 <20180213051850.GE6778@dastard>
 <f8b3b7a4-eba4-d5ab-1748-a8382a2a8fd6@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8b3b7a4-eba4-d5ab-1748-a8382a2a8fd6@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 14, 2018 at 02:07:42PM +0200, Avi Kivity wrote:
> On 02/13/2018 07:18 AM, Dave Chinner wrote:
> >On Mon, Feb 12, 2018 at 11:33:44AM +0200, Avi Kivity wrote:
> >>On 02/10/2018 01:10 AM, Dave Chinner wrote:
> >>>On Fri, Feb 09, 2018 at 02:11:58PM +0200, Avi Kivity wrote:
> >>>>i.e., no matter
> >>>>how AG and free space selection improves, you can always find a
> >>>>workload that consumes extents faster than they can be laundered?
> >>>Sure, but that doesn't mean we have to fall back to a synchronous
> >>>alogrithm to handle collisions. It's that synchronous behaviour that
> >>>is the root cause of the long lock stalls you are seeing.
> >>Well, having that algorithm be asynchronous will be wonderful. But I
> >>imagine it will be a monstrous effort.
> >It's not clear yet whether we have to do any of this stuff to solve
> >your problem.
> 
> I was going by "is the root cause" above. But if we don't have to
> touch it, great.

Remember that triage - which is all about finding the root cause of
an issue - is a separate process to finding an appropriate fix for
the issue that has been triaged.

> >>>>I'm not saying that free extent selection can't or shouldn't be
> >>>>improved, just that it can never completely fix the problem on its
> >>>>own.
> >>>Righto, if you say so.
> >>>
> >>>After all, what do I know about the subject at hand? I'm just the
> >>>poor dumb guy
> >>
> >>Just because you're an XFS expert, and even wrote the code at hand,
> >>doesn't mean I have nothing to contribute. If I'm wrong, it's enough
> >>to tell me that and why.
> >It takes time and effort to have to explain why someone's suggestion
> >for fixing a bug will not work. It's tiring, unproductive work and I
> >get no thanks for it at all.
> 
> Isn't the part of being a maintainer?

I'm not the maintainer.  That burnt me out, and this was one of the
aspects of the job that contributes significantly to burn-out.

I don't want the current maintainer to suffer from the same fate.
I can handle some stress, so I'm happy to play the bad guy because
it shares the stress around.

However, I'm not going to make the same mistake I did the first time
around - internalising these issues doesn't make them go away. Hence
I'm going to speak out about it in the hope that users realise that
their demands can have a serious impact on the people that are
supporting them. Sure, I could have put it better, but this is still
an unfamiliar, learning-as-I-go process for me and so next time I
won't make the same mistakes....

> When everything works, the
> users are off the mailing list.

That often makes things worse :/ Users are always asking questions
about configs, optimisations, etc. And then there's all the other
developers who want their projects merged and supported. The need to
say no doesn't go away just because "everything works"....

> >I'm just seen as the nasty guy who says
> >"no" to everything because I eventually run out of patience trying
> >to explain everything in simple enough terms for non-XFS people to
> >understand that they don't really understand XFS or what I'm talking
> >about.
> >
> >IOWs, sometimes the best way to contribute is to know when you're in
> >way over you head and to step back and simply help the master
> >crafters get on with weaving their magic.....
> 
> Are you suggesting that I should go away? Or something else?

Something else.

Avi, your help and insight is most definitely welcome (and needed!)
because we can't find a solution that would suit your needs without
it.  All I'm asking for is a little bit of patience as we go
through the process of gathering all the info we need to determine
the best approach to solving the problem.

Be aware that when you are asked triage questions that seem
illogical or irrelevant, then the best thing to do is to answer the
question as best you can and wait to ask questions later. Those
questions are usually asked to rule out complex, convoluted cases
that take a long, long time to explain and by responding with
questions rather than answers it derails the process of expedient
triage and analysis.

IOWs, lets talk about the merits and mechanisms of solutions when
they are proposed, not while questions are still being asked about
the application, requirements, environment, etc needed to determine
what the best potential solution may be.

> >Indeed, does your application and/or users even care about
> >[acm]times on your files being absolutely accurate and crash
> >resilient? i.e. do you use fsync() or fdatasync() to guarantee the
> >data is on stable storage?
> 
> We use fdatasync and don't care about mtime much. So lazytime would
> work for us.

OK, so let me explore that in a bit more detail and see whether it's
something we can cleanly implement....

> >>I still think reducing the amount of outstanding busy extents is
> >>important.  Modern disks write multiple GB/s, and big-data
> >>applications like to do large sequential writes and deletes,
> >Hah! "modern disks"
> >
> >You need to recalibrate what "big data" and "high performance IO"
> >means. This was what we were doing with XFS on linux back in 2006:
> >
> >https://web.archive.org/web/20171010112452/http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf
> >
> >i.e. 10 years ago we were already well into the *tens of GB/s* on
> >XFS filesystems for big-data applications with large sequential
> >reads and writes. These "modern disks" are so slow! :)
> 
> Today, that's one or a few disks, not 90, and you can such a setup
> for a few dollars an hour, doing millions of IOPS.

Sure, but that's not "big-data" anymore - it's pretty common
nowdays in enterprise server environments. Big data applications
these days are measured in TB/s and hundreds of PBs.... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
