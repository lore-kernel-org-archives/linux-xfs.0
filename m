Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Aug 2007 20:29:09 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7B3Swbm005468
	for <xfs@oss.sgi.com>; Fri, 10 Aug 2007 20:29:00 -0700
Date: Sat, 11 Aug 2007 03:57:39 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into individual setattr functions (RESEND)
Message-ID: <20070811025739.GA21244@infradead.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com> <20070807171501.e31c4a97.akpm@linux-foundation.org> <1186533934.6625.91.camel@heimdal.trondhjem.org> <20070810164752.23117e0e.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810164752.23117e0e.jlayton@redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

On Fri, Aug 10, 2007 at 04:47:52PM -0400, Jeff Layton wrote:
> attr->ia_valid after the setattr operation returns. If either ATTR_KILL_*
> bit is set then BUG(). The helper function already clears those bits
> so anything using it should automatically be ok. We'd have to fix
> up NFS and a few others that don't implement suid/sgid.
> 
> This is not as certain as changing the name of the inode operation. It
> would only pop when someone is attempting to change a setuid/setgid
> file on these filesystems. Still, it should conceivably catch most if
> not all offenders. Would that be sufficient to take care of everyone's
> concerns?

I like the idea of checking ia_valid after return a lot.  But instead of
going BUG() it should just do the default action, that we can avoid
touching all the filesystem and only need to change those that need
special care.  I also have plans to add some new AT_ flags for implementing
some filesystem ioctl in generic code that would benefit greatly from
the ia_valid checkin after return to return ENOTTY fr filesystems not
implementing those ioctls.
