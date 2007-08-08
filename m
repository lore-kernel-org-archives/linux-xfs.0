Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 17:46:10 -0700 (PDT)
Received: from pat.uio.no (pat.uio.no [129.240.10.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l780k2bm000877
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 17:46:04 -0700
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into
	individual setattr functions (RESEND)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <20070807171501.e31c4a97.akpm@linux-foundation.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	 <20070807171501.e31c4a97.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 20:45:34 -0400
Message-Id: <1186533934.6625.91.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

On Tue, 2007-08-07 at 17:15 -0700, Andrew Morton wrote:

> Is there any way in which we can prevent these problems?  Say

The problem here is that we occasionally DO need to add new flags, and
yes, they MAY be security related. The whole reason why we're now having
to change the semantics of setattr is because somebody tried to hack
their way around the write+suid issue.

I suspect we will see the exact same thing will happen again in a couple
of years with Serge's ATTR_KILL_PRIV flag.

> - rename something so that unconverted filesystems will reliably fail to
>   compile?
> 
> - leave existing filesystems alone, but add a new
>   inode_operations.setattr_jeff, which the networked filesytems can
>   implement, and teach core vfs to call setattr_jeff in preference to
>   setattr?

If you really need to know that the filesystem is handling the flags,
then how about instead having ->setattr() return something which
indicates which flags it actually handled? That is likely to be a far
more intrusive change, but it is one which is future-proof.

Trond
