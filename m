Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f174.google.com ([209.85.166.174]:52115 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbeLZDRC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Dec 2018 22:17:02 -0500
Received: by mail-it1-f174.google.com with SMTP id w18so19673066ite.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Dec 2018 19:17:01 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard> <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard> <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
 <20181130064908.GX6311@dastard> <20181130074547.GY6311@dastard>
 <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
 <CAJouXQn2mSyyacnf_CnrhX-JQ1x2QOUoB3=bzsSfbHFfAdRc9Q@mail.gmail.com> <20181225234732.GH4205@dastard>
In-Reply-To: <20181225234732.GH4205@dastard>
From: Kenton Varda <kenton@cloudflare.com>
Date: Tue, 25 Dec 2018 19:16:25 -0800
Message-ID: <CAJouXQndAaybOzbSLRq+Uw7a35YLkUnL5NmRC0qLbV+8QP+vaA@mail.gmail.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on xfs_reclaim_inodes_ag()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ivan Babrou <ivan@cloudflare.com>, linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Tue, Dec 25, 2018 at 3:47 PM Dave Chinner <david@fromorbit.com> wrote:
> But taking out your frustrations on the people who are trying to fix
> the problems you are seeing isn't productive. We are only a small
> team and we can't fix every problem that everyone reports
> immediately. Some things take time to fix.

I agree. My hope is that explaining our use case helps you make XFS
better, but you don't owe us anything. It's our problem to solve and
any help you give us is a favor.

> IOWs, there are relatively few applications that have such a
> significant dependency on memory reclaim having extremely low
> latency,

Hmm, I'm confused by this. Isn't low-latency memory allocation is a
common requirement for any kind of interactive workload? I don't see
what's unique about our use case in this respect. Any desktop and most
web servers I would think have similar requirements.

I'm sure there's something about our use case that's unusual, but it
doesn't seem to me that requiring low-latency memory allocation is
unique.

Maybe the real thing that's odd about us is that we constantly create
and delete files at a high rate, and that means we have an excessive
number of dirty inodes to flush?

> IOWs, we're trying to solve *all* the blocking problems that we know
> that can occur in inode reclaim so that it all just works for
> everyone without tweaks being necessary. Yes, this takes longer than
> just addressing the specific symptom that is causing you problems,
> but the reality is while fixing things properly takes time to get
> right, everyone will benefit from it being fixed and not just one or
> two very specific, latency sensitive workloads.

Great, it's good to hear that this problem is expected to be fixed
eventually. We can patch our way around it in the meantime.

-Kenton
