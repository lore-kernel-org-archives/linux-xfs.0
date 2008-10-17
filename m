Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 19:03:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H23IDo029830
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 19:03:19 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8FAC14205B4
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 19:05:00 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id cEs1gQB5Qr0CKLkG for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 19:05:00 -0700 (PDT)
Date: Fri, 17 Oct 2008 13:04:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Re: another problem with latest code drops
Message-ID: <20081017020434.GD31761@disturbed>
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com> <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com> <20081017012141.GJ25906@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017012141.GJ25906@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 17, 2008 at 12:21:41PM +1100, Dave Chinner wrote:
> On Fri, Oct 17, 2008 at 11:17:46AM +1000, Lachlan McIlroy wrote:
> > Dave Chinner wrote:
> >>> I am seeing a lot of memory used here though:
> >>>
> >>> 116605669 116605669  26%    0.23K 6859157       17  27436628K selinux_inode_security
> >>
> >> Ah - I don't run selinux. Sounds like a bug that needs reporting
> >> to lkml...
> >
> > I'm sure this is caused by your changes that introduced inode_init_always().
> > It re-initialises an existing inode without destroying it first so it calls
> > security_inode_alloc() without calling security_inode_free().
> 
> I can't think of how. The layers above XFS are symmetric:
.....
> And we should have this symmetry everywhere.
> 
> <thinks for a bit>
> 
> Hmmmm - maybe the xfs_iget_cache_miss failure paths where we call
> xfs_idestroy() could leak contexts. We should really call xfs_iput()
> because we have an initialised linux inode at this point and so
> we need to go through destroy_inode(). I'll have a bit more of
> a look, but this doesn't seem to account for the huge number of
> leaked contexts you reported....

Patch below that replaces xfs_idestroy() with IRELE() to destroy
the inode via the normal iput() path. It also fixes a second issue
that I found by inspection related to security contexts as a result
of hooking up ->destroy_inode.

It's running QA now.

FWIW, I'm not sure if this patch will apply cleanly - I'm still
running of my stack of patches and not what has been checked into
ptools. Any idea of when all the patches in ptools will be pushed
out to the git tree?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
