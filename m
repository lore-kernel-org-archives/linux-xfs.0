Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18822 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdHaUCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:02:55 -0400
Date: Thu, 31 Aug 2017 13:02:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20170831200244.GN3775@magnolia>
References: <20170830145400.3681-1-hch@lst.de>
 <20170831064033.GF3775@magnolia>
 <20170831124321.GA21939@bfoster.bfoster>
 <20170831133019.GA5468@lst.de>
 <20170831153148.GJ3775@magnolia>
 <4b7dda9e-f470-65b6-08d0-e862dc967cd4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b7dda9e-f470-65b6-08d0-e862dc967cd4@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Thu, Aug 31, 2017 at 10:55:31AM -0500, Eric Sandeen wrote:
> On 8/31/17 10:31 AM, Darrick J. Wong wrote:
> > On Thu, Aug 31, 2017 at 03:30:19PM +0200, Christoph Hellwig wrote:
> >> On Thu, Aug 31, 2017 at 08:43:21AM -0400, Brian Foster wrote:
> >>> FWIW, I don't really have a strong opinion. To me, removing experimental
> >>> means we feel the code has stabilized long enough in principle, there
> >>> are no significant problems (i.e., corruption/crash vectors) that we are
> >>> aware of and the feature is complete (full userspace tool support, etc).
> >>> The in-core extent list thing seems like more of a general problem to me
> >>
> >> Agreed so far.
> > 
> > <nod> Dave?  Eric?  Any perspective you'd like to offer? :)
> 
> This is a bit of a naiive question, but how many applications are out
> there that can be used with reflink right now?  This would obviously

Anything that uses cp --reflink, which could be any number of deploy
scripts to VM "snapshot" tools.  ISTR that cifs & nfs now both support
reflink too, and now that ocfs2 also supports the ficlone* ioctls (sort
of) we can expect wider use.

dupremove (offline dedupe tool for btrfs) can also talk to xfs/ocfs2.

> delay things a bit, but I had considered writing something up for
> LWN or Fedora Planet or $WHATEVER describing these new xfs features,
> how they can be used, and encourage some early-adopter testing.  Try
> to get some buzz going and some real-world use.

I know there's already some dedicated experimenters using reflink...

> It's always a catch 22; nobody uses it until it's marked stable,
> but we never know if it's really stable until people outside the
> development community use it.  ;)
> 
> As for the allocation issues w/ the in core extent list, yeah, that
> worries me.

Yeah.  On the one hand it's a pre-existing condition that's orthogonal
to reflink (and hey, we even put in cowextsize to mitigate the problems
on VMs) but OTOH it probably gets worse with cow.

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
