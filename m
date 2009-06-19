Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5JFcP7o070536 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 10:38:26 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 943829502D1
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 08:46:49 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id To25vBTFjnGLRrxk for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2009 08:46:49 -0700 (PDT)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
Date: Fri, 19 Jun 2009 17:37:57 +0200
References: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
	<20090615094244.GA4793@infradead.org>
	<Pine.LNX.4.62.0906151211550.15794@sci.felk.cvut.cz>
In-Reply-To: <Pine.LNX.4.62.0906151211550.15794@sci.felk.cvut.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906191737.58393.agruen@suse.de>
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
To: Petr Salinger <Petr.Salinger@seznam.cz>, acl-devel@nongnu.org
Cc: Christoph Hellwig <hch@infradead.org>, 531950-quiet@bugs.debian.org, Nathan Scott <nscott@aconex.com>, Aurelien Jarno <aurelien@aurel32.net>, xfs@oss.sgi.com

On Monday 15 June 2009 12:26:12 Petr Salinger wrote:
> We would really appreciate to have either "#ifdef ENODATA" or
> "#ifdef __linux__" applied to current debian version of package.
> The debian maintainer does not want to diverge from (future) upstream,
> which is quite understandable.
>
> Would be possible to special case ENODATA as 1st step and postpone
> adding of syscall support later ?

Yes, done.

> The current situation (unbuildable attr under Bebian) prevents
> building of many other packages, namely kdelibs (and whole KDE 3.x),
> kde4libs (and whole KDE 4.x) and gnome-vfs (almost whole GNOME) and even
> vim editor under Debian GNU/kFreeBSD.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
