Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5F9xkXA098319 for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 04:59:47 -0500
Received: from relay.felk.cvut.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44CB42F6EF0
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 03:00:08 -0700 (PDT)
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [147.32.80.7]) by
	cuda.sgi.com with ESMTP id bnqIEZ6SBCBHe99i for
	<xfs@oss.sgi.com>; Mon, 15 Jun 2009 03:00:08 -0700 (PDT)
Date: Mon, 15 Jun 2009 12:26:12 +0200 (CEST)
From: Petr Salinger <Petr.Salinger@seznam.cz>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
In-Reply-To: <20090615094244.GA4793@infradead.org>
Message-ID: <Pine.LNX.4.62.0906151211550.15794@sci.felk.cvut.cz>
References: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
	<Pine.LNX.4.62.0906091328270.31325@sci.felk.cvut.cz>
	<20090609121042.GA28666@infradead.org>
	<20090614163517.GA19259@volta.aurel32.net>
	<20090614203309.GA1929@infradead.org>
	<20090614205628.GB25535@hall.aurel32.net>
	<20090615094244.GA4793@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: 531950-quiet@bugs.debian.org, Nathan Scott <nscott@aconex.com>, Aurelien Jarno <aurelien@aurel32.net>, xfs@oss.sgi.com

> On Sun, Jun 14, 2009 at 10:56:28PM +0200, Aurelien Jarno wrote:
>> Would such a patch be accepted more easily than the ENODATA patch?
>
> I don't think it's an except but in addition.  Wherever we do a strerror
> in the attr code we will have to special case ENODATA on Linux and only
> there.  Independent of that I think we would better of using the raw
> syscalls in platforms already using binary namespaces rather than double
> translation.  Note that this is only applicable for the IRIX-heritage
> attr_* routines exports by libattr, not the *xattr routines it also
> exports.

We would really appreciate to have either "#ifdef ENODATA" or
"#ifdef __linux__" applied to current debian version of package.
The debian maintainer does not want to diverge from (future) upstream,
which is quite understandable.

Would be possible to special case ENODATA as 1st step and postpone
adding of syscall support later ?

The current situation (unbuildable attr under Bebian) prevents
building of many other packages, namely kdelibs (and whole KDE 3.x),
kde4libs (and whole KDE 4.x) and gnome-vfs (almost whole GNOME) and even
vim editor under Debian GNU/kFreeBSD.

http://bugs.debian.org//cgi-bin/bugreport.cgi?bug=531950

Thanks

 		Petr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
