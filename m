Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:47434 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbfC0Uqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Mar 2019 16:46:42 -0400
Date: Thu, 28 Mar 2019 07:46:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20190327204637.GI23020@dastard>
References: <20170812001637.GW21024@dastard>
 <20170812140433.GA31523@bfoster.bfoster>
 <20170814002809.GA21024@dastard>
 <A86C45842A15447CAB819133E6AF76CF@alyakaslap>
 <20170814122216.GA39742@bfoster.bfoster>
 <0df483623d7b9464691d44de67c7264f@mail.gmail.com>
 <20190322160836.GP1183@magnolia>
 <1d13a515062de477bc6009ca6333442b@mail.gmail.com>
 <20190325181751.GU1183@magnolia>
 <CAOcd+r0yjfdWxoUoxVrRQNUuCkP-iG0KBSO8yggoh4DMeu4vKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOcd+r0yjfdWxoUoxVrRQNUuCkP-iG0KBSO8yggoh4DMeu4vKA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadara.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Shyam Kaushik <shyam@zadara.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Mar 27, 2019 at 06:03:38PM +0200, Alex Lyakas wrote:
> Hi Darrick,
> 
> I started this long email thread originally, and posted a patch with
> the proposed fix to the "Metadata corruption at
> xfs_attr3_leaf_write_verify" problem. We reported this problem
> originally. Eventually we found a stable reproducer for the issue,
> added different prints in the code, and posted our analysis to
> community in https://www.spinics.net/lists/linux-xfs/msg08752.html.
> The community (Dave) confirmed that we found a "zero day" bug, and
> gave us some hints on how to fix it. Hence this thread.
> 
> After reviewing my patch, Dave expressed the following concern:
> 
> "The problem is that the locked buffer is not joined and logged in
> the rolling transactions run in xfs_defer_ops. Hence it can pin the
> tail of the AIL, and this can prevent the transaction roll from
> regranting the log space necessary to continue rolling the
> transaction for the required number of transactions to complete the
> deferred ops. If this happens, we end up with a log space deadlock."
> 
> However, after more discussions, there was more or less a consensus
> that for kernel 3.18 this fix should be safe. We went ahead, applied
> and qualified the fix. With this fix we did not see the issue in any
> of the production systems, which were hitting the issue frequently.
> 
> We are now in the process of moving to long-term kernel 4.14.x. We
> see, however, that this problem was fixed by the community only for
> kernels 4.15 and later. Since we had several production systems
> hitting this issue frequently, we need a fix for it in kernel 4.14.
> 
> Hence our question: whether our original patch should be safe to apply
> to kernel 4.14?
> 
> Brian, Dave, can you perhaps also comment?

The right thing to do is to backport the upstream fix and all it's
dependencies to the LTS kernel. If it's 4.15 to 4.14, everything
should pretty much just drop in without too much hassle. Then test
the backport fixes the problem it was intended to fix, post the
patch series to the XFS list as [STABLE PATCH X/Y] with a cc to
stable@kernel.org, and if it passes review (shouldn't be an issue if
it's a straight backport) it will get merged into the 4.14-LTS kernel
tree and go through the stable kernel QA process.

This gets the problem fixed for all users of the LTS kernel, and you
do not have to maintain the backport yourself as you update to new
LTS kernels over the life of your product....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
