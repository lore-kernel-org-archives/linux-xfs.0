Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45893 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752154AbcLBNrx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Dec 2016 08:47:53 -0500
Date: Fri, 2 Dec 2016 14:47:51 +0100 (CET)
From: Jiri Kosina <jikos@kernel.org>
Subject: Re: XFS blocking suspend
In-Reply-To: <20161201201249.GE11750@dastard>
Message-ID: <alpine.LNX.2.00.1612021443100.29400@cbobk.fhfr.pm>
References: <20161201084757.GE12804@quack2.suse.cz> <20161201134452.GF22890@bfoster.bfoster> <20161201140959.GA16514@quack2.suse.cz> <20161201201249.GE11750@dastard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, 2 Dec 2016, Dave Chinner wrote:

> > Ultimately, the correct solution is to use filesystem freezing during
> > suspend to quiesce the filesystem. However that requires more work on the
> > suspend side - added Jiri to CC who promised to look into it some time ago
> > ;).
> 
> I've been saying that for 10 years, too, so I'm not going to hold my
> breathe waiting for someone to fix this problem.

Thanks for bringing up just another example why kthread freezer is such a 
mess.

I already have a sort-of working implementation that gets rid of kthread 
freezer, but there is still quite some work to do before it's mainline 
ready. Namely, we first have to get rid of all of the spurious kthread 
freezer usage we have in the tree so far.

The main part of this effort are these commits

https://git.kernel.org/cgit/linux/kernel/git/jikos/jikos.git/commit/?h=might-rebase/get-rid-of-kthread-freezer&id=394aa67810abefde6d79ea96a90e5d41a7df99f4
https://git.kernel.org/cgit/linux/kernel/git/jikos/jikos.git/commit/?h=might-rebase/get-rid-of-kthread-freezer&id=3f0d7690cbf813ce497f2ca816d8086afe490271
https://git.kernel.org/cgit/linux/kernel/git/jikos/jikos.git/commit/?h=might-rebase/get-rid-of-kthread-freezer&id=a637de712f9ca60bea6e93b13d09534170ec29fa

but especially the second commit needs a lot more care, as I am pretty 
sure it'd break some obscure corner cases, and needs to be investigated 
more.
Also, NFS needs to be taught about fs freezing before we can proceed this 
way.

Thanks,

-- 
Jiri Kosina
SUSE Labs

