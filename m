Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:49280 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751914AbdGFCjf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jul 2017 22:39:35 -0400
Date: Wed, 5 Jul 2017 22:39:34 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Message-ID: <20170706023934.GA19245@fieldses.org>
References: <20170629045940.GB5865@birch.djwong.org>
 <20170629143551.GB1651@fieldses.org>
 <20170629172528.GA5869@birch.djwong.org>
 <20170629183053.GA4178@fieldses.org>
 <20170629185022.GB4178@fieldses.org>
 <20170704040446.GB4704@birch.djwong.org>
 <20170705011534.GC1420@fieldses.org>
 <20170705191933.GA6297@magnolia>
 <20170705204928.GA8151@fieldses.org>
 <87r2xuxth0.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r2xuxth0.fsf@notabene.neil.brown.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neilb@suse.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Jul 06, 2017 at 11:08:27AM +1000, NeilBrown wrote:
> On Wed, Jul 05 2017, J. Bruce Fields wrote:
> 
> > On Wed, Jul 05, 2017 at 12:19:33PM -0700, Darrick J. Wong wrote:
> >> So, what's the probability that there are clients out there that started
> >> talking to a 2.2-based knfsd and will now want to talk to a modern 4.13
> >> kernel seventeen years later?
> >
> > I think it's unlikely enough that we could drop that code;

Wow, that was a terrible sentence.  What I meant was: I think it's
unlikely that such a client exists, therefore I'm OK with dropping that
code.

Anyway:

> cc'ing Neil
> > in case we overlooked anything.
> 
> While I remain a fan of maintaining forward/backward compatibility as
> much as possible, 15 years is probably more than I can realistically
> hope for.
> As you say, a generation number of '0' is only special when old-style
> file handles are used, with the "subtree_check" export option.  They are
> unlikely to have been used recently.
...
> But for the main point of your question: I see no problem with removing
> nfs_fhbase_old and related code, and that includes the special handling
> of generation number zero.

So, we agree, OK.

I dunno if this is actually urgent.  But it'd be nice to clean out.

--b.
