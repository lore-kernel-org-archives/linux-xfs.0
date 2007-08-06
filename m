Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Aug 2007 14:24:08 -0700 (PDT)
Received: from pat.uio.no (pat.uio.no [129.240.10.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l76LNqbm008349
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2007 14:23:54 -0700
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
From: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <E1II8Nw-0005XH-00@dorka.pomaz.szeredi.hu>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	 <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
	 <20070806141333.0f54ab17.jlayton@redhat.com>
	 <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
	 <1186427063.6616.59.camel@localhost>
	 <E1II8Nw-0005XH-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 17:23:39 -0400
Message-Id: <1186435419.6616.136.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jlayton@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org, xfs@oss.sgi.com, joel.becker@oracle.com, wli@holomorphy.com, reiserfs-devel@vger.kernel.org, dhowells@redhat.com, fuse-devel@lists.sourceforge.net, jffs-dev@axis.com, user-mode-linux-user@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu

On Mon, 2007-08-06 at 21:37 +0200, Miklos Szeredi wrote:
> > > Your patch is changing the API in a very unsafe way, since there will
> > > be no error or warning on an unconverted fs.  And that could lead to
> > > security holes.
> > > 
> > > If we would rename the setattr method to setattr_new as well as
> > > changing it's behavior, that would be fine.  But I guess we do not
> > > want to do that.
> > 
> > Which "unconverted fses"? If we're talking out of tree stuff, then too
> > bad: it is _their_ responsibility to keep up with kernel changes.
> 
> It is usually a good idea to not change the semantics of an API in a
> backward incompatible way without changing the syntax as well.

We're taking two setattr flags ATTR_KILL_SGID, and ATTR_KILL_SUID which
have existed for several years in the VFS, and making them visible to
the filesystems. Out-of-tree filesystems that care can check for them in
a completely backward compatible way: you don't even need to add a
#define.

> This is true regardless of whether we care about out-of-tree code or
> not (and we should care to some degree).  And especially true if the
> change in question is security sensitive.

It is not true "regardless": the in-tree code is being converted.
Out-of-tree code is the only "problem" here, and their only problem is
that they may have to add support for the new flags if they also support
suid/sgid mode bits.

Are you advocating reserving a new filesystem bit every time we need to
add an attribute flag?

Trond
