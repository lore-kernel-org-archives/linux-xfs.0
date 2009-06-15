Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5F9gTPS097533 for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 04:42:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBC061279BCF
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 02:50:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vZ2H7P2JBtVQ0yKJ for
	<xfs@oss.sgi.com>; Mon, 15 Jun 2009 02:50:29 -0700 (PDT)
Date: Mon, 15 Jun 2009 05:42:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
Message-ID: <20090615094244.GA4793@infradead.org>
References: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
	<Pine.LNX.4.62.0906091328270.31325@sci.felk.cvut.cz>
	<20090609121042.GA28666@infradead.org>
	<20090614163517.GA19259@volta.aurel32.net>
	<20090614203309.GA1929@infradead.org>
	<20090614205628.GB25535@hall.aurel32.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090614205628.GB25535@hall.aurel32.net>
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
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: Christoph Hellwig <hch@infradead.org>, 531950-quiet@bugs.debian.org, Nathan Scott <nscott@aconex.com>, Petr Salinger <Petr.Salinger@seznam.cz>, xfs@oss.sgi.com

On Sun, Jun 14, 2009 at 10:56:28PM +0200, Aurelien Jarno wrote:
> Would such a patch be accepted more easily than the ENODATA patch?

I don't think it's an except but in addition.  Wherever we do a strerror
in the attr code we will have to special case ENODATA on Linux and only
there.  Independent of that I think we would better of using the raw
syscalls in platforms already using binary namespaces rather than double
translation.  Note that this is only applicable for the IRIX-heritage
attr_* routines exports by libattr, not the *xattr routines it also
exports.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
