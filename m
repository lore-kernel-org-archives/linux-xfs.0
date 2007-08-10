Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Aug 2007 13:50:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7AKnpbm002847
	for <xfs@oss.sgi.com>; Fri, 10 Aug 2007 13:49:54 -0700
Date: Fri, 10 Aug 2007 16:47:52 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into
 individual setattr functions (RESEND)
Message-Id: <20070810164752.23117e0e.jlayton@redhat.com>
In-Reply-To: <1186533934.6625.91.camel@heimdal.trondhjem.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<1186533934.6625.91.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

On Tue, 07 Aug 2007 20:45:34 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > - rename something so that unconverted filesystems will reliably fail to
> >   compile?
> > 
> > - leave existing filesystems alone, but add a new
> >   inode_operations.setattr_jeff, which the networked filesytems can
> >   implement, and teach core vfs to call setattr_jeff in preference to
> >   setattr?
> 
> If you really need to know that the filesystem is handling the flags,
> then how about instead having ->setattr() return something which
> indicates which flags it actually handled? That is likely to be a far
> more intrusive change, but it is one which is future-proof.
> 

One thing that we could do here is have notify_change check
attr->ia_valid after the setattr operation returns. If either ATTR_KILL_*
bit is set then BUG(). The helper function already clears those bits
so anything using it should automatically be ok. We'd have to fix
up NFS and a few others that don't implement suid/sgid.

This is not as certain as changing the name of the inode operation. It
would only pop when someone is attempting to change a setuid/setgid
file on these filesystems. Still, it should conceivably catch most if
not all offenders. Would that be sufficient to take care of everyone's
concerns?

-- 
Jeff Layton <jlayton@redhat.com>
