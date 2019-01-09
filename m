Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43733 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfAIVNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Jan 2019 16:13:16 -0500
Received: by mail-qt1-f195.google.com with SMTP id i7so9968277qtj.10
        for <linux-xfs@vger.kernel.org>; Wed, 09 Jan 2019 13:13:15 -0800 (PST)
Message-ID: <1547068393.6911.3.camel@lca.pw>
Subject: Re: [PATCH] xfs: silence lockdep false positives when freezing
From: Qian Cai <cai@lca.pw>
Date: Wed, 09 Jan 2019 16:13:13 -0500
In-Reply-To: <20190109210111.GZ4205@dastard>
References: <20190106225639.GU4205@dastard>
         <20190109205329.2486-1-cai@lca.pw> <20190109210111.GZ4205@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: darrick.wong@oracle.com, dchinner@redhat.com, peterz@infradead.org, bfoster@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2019-01-10 at 08:01 +1100, Dave Chinner wrote:
> On Wed, Jan 09, 2019 at 03:53:29PM -0500, Qian Cai wrote:
> > Easy to reproduce:
> > 
> > 1. run LTP oom02 workload to let kswapd acquire this locking order:
> >    fs_reclaim -> sb_internal.
> > 
> >  # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
> > [00000000826b9172] &type->s_umount_key#27
> > [000000005fa8b2ac] sb_pagefaults
> > [0000000033f1247e] sb_internal
> > [000000009e9a9664] fs_reclaim
> > 
> > 2. freeze XFS.
> >   # fsfreeze -f /home
> > 
> > Dave mentioned that this is due to a lockdep limitation - "IOWs, this is
> > a false positive, caused by the fact that xfs_trans_alloc() is called
> > from both above and below memory reclaim as well as within /every level/
> > of freeze processing. Lockdep is unable to describe the staged flush
> > logic in the freeze process that prevents deadlocks from occurring, and
> > hence we will pretty much always see false positives in the freeze
> > path....". Hence, just temporarily disable lockdep in that path.
> 
> NACK. Turning off lockdep is not a solution, it just prevents
> lockdep from finding and reporting real issues.
> 

Well, it is a trade-off. It is turned on right after that path. All those false
positives leave unfixed are also going to render lockdep less useful.
