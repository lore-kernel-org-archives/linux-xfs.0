Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3O9LWU0072289 for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 04:21:33 -0500
Received: from pond.fysh.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F4931CE46DD
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 02:21:29 -0700 (PDT)
Received: from pond.fysh.org (pond.fysh.org [166.84.7.109]) by cuda.sgi.com
	with ESMTP id S8KoZOi9oeWkxrQM for <xfs@oss.sgi.com>;
	Fri, 24 Apr 2009 02:21:29 -0700 (PDT)
Received: from mike by pond.fysh.org with local (Exim 4.69 #1 (Debian))
	id 1LxHb7-0005Sn-0i
	for xfs@oss.sgi.com; Fri, 24 Apr 2009 10:21:29 +0100
Date: Fri, 24 Apr 2009 10:21:29 +0100
From: Mike Ashton <mike@fysh.org>
Subject: Re: fsck.xfs proposed improvements
Message-ID: <20090424092128.GD16600@fysh.org>
References: <mailman.0.1240318659.128675.xfs@oss.sgi.com>
	<20090421142333.GA5197@fysh.org> <49EE441E.6040606@thebarn.com>
	<20090422094527.GA16600@fysh.org>
	<87ws9cnz14.fsf@basil.nowhere.org>
	<20090423084900.GB16600@fysh.org> <49F062E5.70800@sandeen.net>
	<20090423141432.GC16600@fysh.org>
	<20090423143515.GA5878@fysh.org> <49F09521.9000103@thebarn.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49F09521.9000103@thebarn.com>
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

On Thu, Apr 23, 2009 at 11:19:45AM -0500, Russell Cattelan wrote:

> Traditional thinking with a journaled filesystem has been that if
> there is a dirty log then you do not want to risk mounting the
> filesystem in an inconsistent state an thereby risking a system
> crash or file system shutdown due to that inconsistent state.

Although I don't think you're doing anything more dangerous than
mounting a non-fsck'd non-journaling filesystem read-only, which is
the traditional unix boot method when you're not using initrd, I do
accept that I've introduced a non-zero chance of a system crash in
situations where everything is fine.  I think I've thought of a
compromise.

I propose the addition of a new mount semantic, let's call it
"tryrecovery" for now, which will replay a log if possible or mount
the filesystem in an inconsistent state otherwise.  So you would mark
a filesystem as being a root fs, enabling this behaviour, and the
kernel's attempt to mount its root filesystem would invoke this
behaviour without the explicit knowledge of lilo, grub, kernel
parameters, etc.

I believe this would address both our concerns.  In the general case,
the behaviour will be as it is now; the journal is played, the root
filesystem will be mounted into known a good states and there's no
chance of a crash, but if everything's gone to hell, we allow
fingers-crossed access to the filesystem to be able to get access to
the xfs_repair tool.

> Also in the case of a mount -norecover with any subsequent repair
> being done, it is probably
> best to reboot at that point to ensure there is no bad FS data that
> may be in cache.

A remount to read/write ought to invalidate any cache/buffers for
exactly that reason.

Cheers,
Mike.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
