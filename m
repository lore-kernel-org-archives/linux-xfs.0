Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753457AbeEHBWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 21:22:20 -0400
Date: Mon, 7 May 2018 18:21:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: add -R option
Message-ID: <20180508012136.GI11261@magnolia>
References: <20180504140244.GA32161@deer-run.com>
 <20180504153255.GI26569@magnolia>
 <20180507113534.GB2486@deer-run.com>
 <20180507125621.GA2969@deer-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507125621.GA2969@deer-run.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hal@deer-run.com
Cc: linux-xfs@vger.kernel.org

On Mon, May 07, 2018 at 07:56:21AM -0500, hal@deer-run.com wrote:
> Darrick's suggested patch to sb_logcheck() is the way to accomplish
> what I want with the minimum amount of code changes.  But as I look at
> the code, I'm not sure doing it the way Darrick suggests actually
> expresses what we're trying to accomplish.
> 
> Let's state the problem as "Recognize that the log is dirty but allow
> blockget to proceed if '-r' is used". If you accept that problem
> statement, then sb_logcheck() should just tell the caller whether the
> log is dirty or not. It's up to the caller to decide what to do with
> that information-- in this case the init() function in db/check.c.
> 
> However, right now sb_logcheck() returns 0 for the case where 
> there's a fatal error (like not being able to find the log) and for
> the log being dirty. init() would need to distinguish between those
> two cases and act appropriately. That means changing the return
> semantics of sb_logcheck() to something like -1 on error, 0 on dirty,
> and 1 on clean. 
> 
> Note that sb_logcheck() is also called by sb_logzero() and
> that code would have to be tweaked to handle the new return values.

Ultimately I defer to Eric on this one, but I don't see how sb_logzero
would run to completion in readonly mode, since the only caller of it is
uuid_f, which bails out if we're in readonly mode.

(Not to mention the buffer writes should fail in ro mode).

--D

> 
> So the end result is more code changes to do it this way, but I
> feel like it's a more "correct" fix. I have patches created for
> both scenarios-- does anybody have a strong opinion about which way
> to proceed?
> 
> --Hal
> 
> 
> On Mon May 07 06:35, hal@deer-run.com wrote:
> > > Why skip the warning?  I think xfs_db should always warn on a dirty log,
> > > but perhaps we could relax the 'return 0' at the end of this hunk if the
> > > fs was opened readonly?
> > > 
> > > i.e.
> > > 
> > > dbprintf(_("ERROR: The filesystem has..."));
> > > return (x.isreadonly & LIBXFS_ISREADONLY) ? 1 : 0;
> > > 
> > > which would also make adding the -R option unnecessary.
> > 
> > I like this solution very much. I'll send in this patch in a
> > separate email.
> > 
> > Hal Pomeranz
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
