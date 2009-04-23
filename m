Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NEZJ3K010798 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 09:35:19 -0500
Received: from pond.fysh.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 990D9235608
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 07:35:16 -0700 (PDT)
Received: from pond.fysh.org (pond.fysh.org [166.84.7.109]) by cuda.sgi.com
	with ESMTP id HXj1TKscnpyzpJcs for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2009 07:35:16 -0700 (PDT)
Received: from mike by pond.fysh.org with local (Exim 4.69 #1 (Debian))
	id 1Lx01D-0001aI-IH
	for xfs@oss.sgi.com; Thu, 23 Apr 2009 15:35:15 +0100
Date: Thu, 23 Apr 2009 15:35:15 +0100
From: Mike Ashton <mike@fysh.org>
Subject: Re: fsck.xfs proposed improvements
Message-ID: <20090423143515.GA5878@fysh.org>
References: <mailman.0.1240318659.128675.xfs@oss.sgi.com>
	<20090421142333.GA5197@fysh.org> <49EE441E.6040606@thebarn.com>
	<20090422094527.GA16600@fysh.org>
	<87ws9cnz14.fsf@basil.nowhere.org>
	<20090423084900.GB16600@fysh.org> <49F062E5.70800@sandeen.net>
	<20090423141432.GC16600@fysh.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090423141432.GC16600@fysh.org>
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

On Thu, Apr 23, 2009 at 07:45:25AM -0500, Eric Sandeen wrote:

> It certainly does sound like an interesting idea, but others' concerns
> are relevant too.  The issues around how the root filesystem gets
> mounted would need to be pretty clearly addressed.  Maybe you can spell
> out your original proposal again, with updates to handle that issue?
>
> (as an aside, there have been arguments in the past that readonly mounts
> should not do recovery at all - i.e. "mount -o ro" doesn't just mean
> that you can only read the filesystem, but that the mount will only ever
> read the block device...)

I propose firstly that that behaviour should be configurable by per
filesystem tuning, making it possible to set a root filesystem to
default to norecovery on a read-only mount.  Then non-initrd mounting
of / should always succeed, getting us access to fsck.xfs.

I secondly, and I'm going to broke here, propose that
xfs_check/xfs_repair (as invocations, not the code!) should be
deprecated and both programs should be called fsck.xfs. When called
with that name, they would have the following (familiar) semantics:

fsck.xfs: verify journal integrity.  
	If it's good, return "filesystem is clean" and exit.
        If it's bad, invoke xfs_clean behaviour

fsck.xfs -f:   invoke xfs_clean behaviour even with a good journal

fsck.xfs -a: verify journal integrity
	If it's good, return "filesystem is clean" and exit.
        If it's bad, invoke xfs_repair -L behaviour

(and so on)

This makes fsck.xfs behave analogously to fsck.ext2 and friends, with
it's clean and dirty flag.  The improvement xfs offers over ext2 in
this area is that a filesystem is not only clean if shut down cleanly,
but is also clean if shutdown unclearly but with a usable journal, but
without behaving worse than ext2 by fsck.xfs thinking (incorrectly)
that a filesystem repair will never be needed and giving a filesystem
that won't mount a clean bill of health.

With both these proposals implemented, both initrd and non-initrd boot
processes would correctly handle xfs filesystem checking, using the
xfs journal to give the current excellent general case performance but
provide a safe approach to corrupted journals, without the need for
specific xfs-related care from distribution maintainers.

Thanks,
Mike.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
