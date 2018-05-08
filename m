Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932314AbeEHXEJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 19:04:09 -0400
Date: Tue, 8 May 2018 16:04:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/21] xfsprogs: implement the upper half of parent
 pointers
Message-ID: <20180508230405.GA11261@magnolia>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-22-git-send-email-allison.henderson@oracle.com>
 <f31ce664-7173-7b99-7d65-39abd810a372@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f31ce664-7173-7b99-7d65-39abd810a372@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 03:52:37PM -0500, Eric Sandeen wrote:
> On 5/7/18 11:41 PM, Allison Henderson wrote:
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > 
> > Add ioctl definitions to libxfs, build the necessary helpers into
> > libfrog and libhandle to iterate parents (and parent paths), then wire
> > up xfs_scrub to be able to query parent pointers from userspace.  The
> > goal of this patch is to exercise userspace, and is nowhere near a
> > complete solution.  A basic xfs_io parent command implementation
> > replaces ... whatever that is that's there now.
> 
> I wonder if it'd be better to send a patch to nuke the current parent code,
> and then another to add back something that works.  Same result in the end,
> but it doesn't look like you're trying to fix old code; the patch itself is
> pretty meaningless since it diffs against nonfunctional(?) code.

Trouble is, it's exported as a shared library in the xfslibs-dev package
(should that be libxfs-dev?) so depending on how conservative you like
to be we can't just rip it out.

(Though I suppose even Linus has occasionally allowed people to rip and
replace kernel/user ABIs when they can demonstrate that it was so broken
it never worked for anybody, ever. :P)

> Not a huge deal, just a thought.

Yeah, this patch was quite quick and dirty when I wrote it, on the
assumption that tons of other stuff was going to need reorganization by
the time there was a need to land this.

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
