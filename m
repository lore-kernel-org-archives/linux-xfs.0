Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5EKWstQ061328 for <xfs@oss.sgi.com>; Sun, 14 Jun 2009 15:32:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB86F2F53A3
	for <xfs@oss.sgi.com>; Sun, 14 Jun 2009 13:33:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JDsdKf4dpIPqlzVu for
	<xfs@oss.sgi.com>; Sun, 14 Jun 2009 13:33:17 -0700 (PDT)
Date: Sun, 14 Jun 2009 16:33:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
Message-ID: <20090614203309.GA1929@infradead.org>
References: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
	<Pine.LNX.4.62.0906091328270.31325@sci.felk.cvut.cz>
	<20090609121042.GA28666@infradead.org>
	<20090614163517.GA19259@volta.aurel32.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090614163517.GA19259@volta.aurel32.net>
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

On Sun, Jun 14, 2009 at 06:35:17PM +0200, Aurelien Jarno wrote:
> When not on Linux, libattr uses the GNU libc functions instead of the
> system calls. The GNU libc then translates that into FreeBSD syscalls
> including the integer namespace value.

Maybe you'd be better off not doing a double translation by using
the raw syscalls from libattr..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
