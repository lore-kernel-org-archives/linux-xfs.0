Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750808AbdANDow (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 22:44:52 -0500
Date: Fri, 13 Jan 2017 22:44:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 4/5] xfs_db: sanitize geometry on load
Message-ID: <20170114034449.GA29191@bfoster.bfoster>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419041340.32674.2646685552269275817.stgit@birch.djwong.org>
 <20170113003201.GC14038@birch.djwong.org>
 <20170113133542.GB22013@bfoster.bfoster>
 <b071967b-e67b-2280-156c-9a5aeaa5d40c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b071967b-e67b-2280-156c-9a5aeaa5d40c@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 08:25:47PM -0600, Eric Sandeen wrote:
> On 1/13/17 7:35 AM, Brian Foster wrote:
> >> +		fprintf(stderr,
> >> +_("%s: device %s AG count is insane, but could be %u.  Limiting reads to AG 0.\n"),
> >> +			progname, fsdevice, dblocks / sbp->sb_agblocks);
> >> +	} else {
> >> +		fprintf(stderr,
> >> +_("%s: device %s AG count is insane.  Limiting reads to AG 0.\n"),
> >> +			progname, fsdevice);
> >> +	}
> > For reasons like the above, I think xfs_db shouldn't be in the business
> > of repair like validation (xfs_check notwithstanding). That said,
> > dropping into a fixed single AG mode seems less risky than trying to
> > surmise a valid geometry. I'd get rid of the "this might be your
> > agcount" messaging entirely though and just replace it with something
> > that explicitly states the filesystem is corrupted, the runtime geometry
> > is invalid and that the user should probably run xfs_repair before doing
> > anything.
> 
> So keep in mind that xfs_db is for people with super xfs powers. (*)
> 
> I wouldn't suggest repair, I'd start with 1 ag to avoid the OOM, state 
> that clearly, and punt the problem to the admin with no other specific
> suggestions.
> 
> > I still like the idea of the single AG mode thing as a command line flag
> > rather than default behavior because it requires user acknowledgement,
> > but this is a debug tool after all, so I'll defer to Eric on that. I do
> > think that if we create this kind of invalid runtime mode, this should
> > be split into two patches. First, a bugfix patch for the core OOM
> > problem (i.e., detect a wacky superblock and exit). Second, replace the
> > exit with the single AG runtime mode thing.
> 
> Well, the problem with a flag, I think, is that you might have already
> unwittingly OOMed your box to find out that you need it.
> Rebooting to try again with a flag sucks.
> 

I don't see how that is relevant. I'm not suggesting a
--please-don't-oom-in-case-of-corruption flag. :) As mentioned
previously, I think the bug fix here is a simple patch to detect the
bogus superblock and exit gracefully rather than go off the rails and
end up OOM killed.

>From there the OOM is irrelevant and we can optionally enhance xfs_db to
try and allow it to run in such situations. To be honest, I'm perfectly
happy for xfs_db to exit gracefully in this situation and to leave it at
that. I think the majority of cases where this problem occurs, the next
logical step is to run xfs_repair. I suggested the flag approach more
because I think it's more appropriate to do things like fabricate fs
geometry behind a flag rather than by default. The larger point is that
if we want this kind of enhancement, it should probably be driven more
by a use case than an unfortunate (and probably rare) bug. I don't see
why we need to complicate the bug fix with the fancy enhancement.

Brian

> (*) unless you are invoking it via xfs_admin.sh, dammit.  We sure wouldn't
> want xfs_admin to exit happily, having updated only one AG.  Dammit!
> 
> Perhaps it should set exitcode, and then xfs_admin could do something
> like:
> 
> 	xfs_db -c quit $DEV
> 
> first, and check that db is able to initialize sanely before using it again
> to perform normal admin functions.
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
