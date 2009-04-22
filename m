Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3M9jXFc192114 for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 04:45:33 -0500
Received: from pond.fysh.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 020F722F99C
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 02:45:28 -0700 (PDT)
Received: from pond.fysh.org (pond.fysh.org [166.84.7.109]) by cuda.sgi.com
	with ESMTP id svqsscZZQFo0GtqR for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2009 02:45:28 -0700 (PDT)
Received: from mike by pond.fysh.org with local (Exim 4.69 #1 (Debian))
	id 1LwZ1D-0006gN-Um
	for xfs@oss.sgi.com; Wed, 22 Apr 2009 10:45:28 +0100
Date: Wed, 22 Apr 2009 10:45:27 +0100
From: Mike Ashton <mike@fysh.org>
Subject: Re: fsck.xfs proposed improvements
Message-ID: <20090422094527.GA16600@fysh.org>
References: <mailman.0.1240318659.128675.xfs@oss.sgi.com>
	<20090421142333.GA5197@fysh.org> <49EE441E.6040606@thebarn.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EE441E.6040606@thebarn.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Tue, Apr 21, 2009 at 05:09:34PM -0500, Russell Cattelan wrote:

Hi Russell (and others reading), and thanks for your reply.

> Well step back a bit, fsck.xfs exists simply to satisfy the initial
> boot scripts that invokes fsck -t $fs_type.  The reason fsck.xfs
> does nothing and should continue to do nothing is that by the time
> you have access to the boot scripts and the fsck.xfs program the
> root filesystem has already been mounted. Which means the root file
> system has successfully made it through either a clean mount or a
> log replay mount, neither of which needs additional verification.

Now that's an interesting point; I hadn't seen it quite like that
before.  It's now very clear to me that there's a semantic
inconsistency between xfs and, say, ext2 in that the initial read only
mount of ext2 is more directly analogous to a read-only _norecovery_
mount of xfs.  The filesystem at that stage might be in an
inconsistent state, but there's an expectation that you'll be able to
read fsck (/xfs_repair) from it.  By handling the "fsck stage" at the
time of the initial read only mount, some fragility has been
introduced into the process.  The filesystem now only mounts if it's
in a consistent state (bad!), even though we've redefined what
"consistent" means to refer to journal integrity rather than the
underlying filesystem integrity (good).  With badly behaved hardware,
which seem prevalent, or any bugs which do get into xfs we could
actually end up with xfs being less fault tolerant and less reliable
in general use than other filesystems, which would be a bit of a
shame.

> It would not be unreasonable to do what you are suggesting in an
> initrd startup script, provided xfs_repair was included in the
> initrd (which has size and library requirements).

I think we can do it on direct mounts, but only if we can get to the
bottom of readonly/norecovery semantics.  Obviously we don't
necessarily want readonly mounts to be non recovered by default
(although there is an argument for that).  

Would it be crazy to propose a filesystem flag to control which
default recovery behaviour a filesystem has?  A root filesystem isn't
mounted read-only except a) on boot and b) when being tinkered with by
someone competent, so I think it would be useful to be able to tell
such a filesystem that it shouldn't attempt journal recovery on
readonly mount, which would enable a meaningful use of a meaningful
fsck.  What do you think about that?

> This would probably be a matter of first implementing it and then
> convincing the mkinitrd maintainers to add the support.

I'm a bit out of my depth with the politics of that.  This would be a
different person for each distribution?

Mike.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
