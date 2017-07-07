Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:52512 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbdGGQrB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 12:47:01 -0400
Date: Fri, 7 Jul 2017 12:47:00 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Message-ID: <20170707164700.GA18740@fieldses.org>
References: <20170629172528.GA5869@birch.djwong.org>
 <20170629183053.GA4178@fieldses.org>
 <20170629185022.GB4178@fieldses.org>
 <20170704040446.GB4704@birch.djwong.org>
 <20170705011534.GC1420@fieldses.org>
 <20170705191933.GA6297@magnolia>
 <20170705202750.j5texbm2xdxnph6m@thunk.org>
 <1499424697.5826.3.camel@redhat.com>
 <20170707155117.4zp7qkpreeptwlgc@thunk.org>
 <1499444016.4967.1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499444016.4967.1.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 07, 2017 at 12:13:36PM -0400, Jeff Layton wrote:
> On Fri, 2017-07-07 at 11:51 -0400, Theodore Ts'o wrote:
> > On Fri, Jul 07, 2017 at 06:51:37AM -0400, Jeff Layton wrote:
> > > 
> > > Right. That's the case today if we don't remove support for old
> > > filehandles. If we were to remove them, the clients would get back
> > > -ESTALE there if they tried to use the old 2.2-style fh's that they saw
> > > before the upgrade.
> > > 
> > > The main takeaway here is that NFS filehandle lifetime is really only
> > > bounded by the boot time of the oldest clients.
> > 
> > Well, and how long an NFS server is still up.  So one could construct
> > a use case where a (hypothetical) system administrator had a RHEL 7.0
> > system with a 2.2.16-22 kernel, and they try to update it to a
> > (hypothetical) RHEL 10 kernel in one fell swoop with a 4.13+ kernel
> > that no longer supports the 2-2-style fh's.  A client that had the
> > server mounted when it was running the 2.2 kernel might only be up for
> > a few hours, before the upgrade to RHEL 10 happened, and then the
> > client would get ESTALE errors.
> > 
> > Of course, I've stopped carrying about enterprise kernel support a
> > long time ago, so I just think that scenario is funny.  I recognize
> > that folks who work at Red Hat have to worry about such things --- and
> > I'm sorry.  :-)
> > 
> > In reality a server installed with RHEL 7.0 has probably died of old
> > age by now --- unless someone crazy is running it in a VMware VM
> > because they had some enterprise software package or some bar-code
> > printing module for which they don't have source code[1], and so they are
> > stuck on RHEL 7.0, even in 2017.  Have I mentioned I'm so glad I don't
> > have to worry these sorts of things any more?

RHEL 7 is current, I think you mean the 17-year-old Red Hat Linux 7.
Anyone that far back is on their own as far as any enterprise distro is
concerned.

There are some exceptions to the "lifetime of a mount" rule, none real
issues, I think:

	- fscache may keep fh's around across client boots, but I
	  suspect you just lose the benefit of the cache until it
	  expires data keyed under old filehandles and repopulates the
	  cache with new ones.

	- Does the client actually depend on stable filehandles across
	  client reboots if it might cache write data under a persistent
	  delegation?  But seeing as we don't even implement persistent
	  delegations, this is a non-issue.

	- nontraditional NFS clients could do any random thing.  NFS is
	  just a protocol, we have no idea how some weird application
	  that talks NFS directly to the server might use filehandles.
	  But this is purely hypothetical, I don't know of one.

--b.
