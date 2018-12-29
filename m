Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56896 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbeL2TFp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Dec 2018 14:05:45 -0500
Date: Sat, 29 Dec 2018 11:05:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
Message-ID: <20181229190532.GA20475@magnolia>
References: <20181129021800.GQ6311@dastard>
 <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard>
 <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
 <20181130064908.GX6311@dastard>
 <20181130074547.GY6311@dastard>
 <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
 <CAJouXQn2mSyyacnf_CnrhX-JQ1x2QOUoB3=bzsSfbHFfAdRc9Q@mail.gmail.com>
 <20181225234732.GH4205@dastard>
 <CAJouXQndAaybOzbSLRq+Uw7a35YLkUnL5NmRC0qLbV+8QP+vaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJouXQndAaybOzbSLRq+Uw7a35YLkUnL5NmRC0qLbV+8QP+vaA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kenton Varda <kenton@cloudflare.com>
Cc: Dave Chinner <david@fromorbit.com>, Ivan Babrou <ivan@cloudflare.com>, linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Tue, Dec 25, 2018 at 07:16:25PM -0800, Kenton Varda wrote:
> On Tue, Dec 25, 2018 at 3:47 PM Dave Chinner <david@fromorbit.com> wrote:
> > But taking out your frustrations on the people who are trying to fix
> > the problems you are seeing isn't productive. We are only a small
> > team and we can't fix every problem that everyone reports
> > immediately. Some things take time to fix.
> 
> I agree. My hope is that explaining our use case helps you make XFS
> better, but you don't owe us anything. It's our problem to solve and
> any help you give us is a favor.
> 
> > IOWs, there are relatively few applications that have such a
> > significant dependency on memory reclaim having extremely low
> > latency,
> 
> Hmm, I'm confused by this. Isn't low-latency memory allocation is a
> common requirement for any kind of interactive workload? I don't see
> what's unique about our use case in this respect. Any desktop and most
> web servers I would think have similar requirements.
> 
> I'm sure there's something about our use case that's unusual, but it
> doesn't seem to me that requiring low-latency memory allocation is
> unique.
> 
> Maybe the real thing that's odd about us is that we constantly create
> and delete files at a high rate, and that means we have an excessive
> number of dirty inodes to flush?
> 
> > IOWs, we're trying to solve *all* the blocking problems that we know
> > that can occur in inode reclaim so that it all just works for
> > everyone without tweaks being necessary. Yes, this takes longer than
> > just addressing the specific symptom that is causing you problems,
> > but the reality is while fixing things properly takes time to get
> > right, everyone will benefit from it being fixed and not just one or
> > two very specific, latency sensitive workloads.
> 
> Great, it's good to hear that this problem is expected to be fixed
> eventually. We can patch our way around it in the meantime.

FWIW I /was/ planning to patchbomb every feature that's sitting around
in my xfs development tree on NYE for everyone's enjoyment^Wreview. ;)

Concretely, those features are:

- Scrub fixes
- The eas(ier) parts of online repair
- Deferred inode inactivation (i.e. the thing you're talking about)
- The hard parts of online repair
- Hoisting inode operations to libxfs
- Metadata inode directory tree
- Reverse mapping for realtime devices

--D

> -Kenton
