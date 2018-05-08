Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52872 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755375AbeEHROg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 13:14:36 -0400
Date: Tue, 8 May 2018 10:14:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/21] xfs: Add attibute remove and helper functions
Message-ID: <20180508171433.GO11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-5-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxiNvdvw6Hn4bvESitVPgzYYy581KdYiqdBX0XXFpL59Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiNvdvw6Hn4bvESitVPgzYYy581KdYiqdBX0XXFpL59Xw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, May 08, 2018 at 10:33:05AM +0300, Amir Goldstein wrote:
> On Sun, May 6, 2018 at 8:24 PM, Allison Henderson
> <allison.henderson@oracle.com> wrote:
> > This patch adds xfs_attr_remove_args. These sub-routines remove
> > the attributes specified in @args. We will use this later for setting
> > parent pointers as a deferred attribute operation.
> >
> 
> But this patch also adds xfs_defer_init()+xfs_trans_ijoin()
> so maybe I am not understanding how this work, but it seems
> to be changing logic as well.

Sooooo... I went and took another look at this, having realized that
xfs_da_args.dfops is a *pointer* to a dfops, not the dfops itself.
Subsequently we have a bunch of calls to:

xfs_defer_init(args->dfops, ...);

which AFAICT is careful enough that we always pair the init with a
_finish or a _cancel... but this is really gross behavior.  The da_args
creators will declare a separate dfops on the stack and set args.dfops
to the uninitialized dfops(!) and then the attr code blindly assumes
that it owns this dfops pointer and can therefore reinitialize it at
will.

That will need fixing.

> Please say something about this in commit message.

"Mugga wugga mugga wugga mugga wugga mugga wugga mugga wugga wugggga!!!"

--D

> 
> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
