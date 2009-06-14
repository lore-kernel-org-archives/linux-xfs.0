Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5EGZ9sL053460 for <xfs@oss.sgi.com>; Sun, 14 Jun 2009 11:35:09 -0500
Received: from hall.aurel32.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6460120D2FC
	for <xfs@oss.sgi.com>; Sun, 14 Jun 2009 09:43:04 -0700 (PDT)
Received: from hall.aurel32.net (hall.aurel32.net [88.191.82.174]) by
	cuda.sgi.com with ESMTP id BtAFtAn9E66Uwv4d for
	<xfs@oss.sgi.com>; Sun, 14 Jun 2009 09:43:04 -0700 (PDT)
Date: Sun, 14 Jun 2009 18:35:17 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
Message-ID: <20090614163517.GA19259@volta.aurel32.net>
References: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
	<Pine.LNX.4.62.0906091328270.31325@sci.felk.cvut.cz>
	<20090609121042.GA28666@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090609121042.GA28666@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: 531950-quiet@bugs.debian.org, xfs@oss.sgi.com, Nathan Scott <nscott@aconex.com>, Petr Salinger <Petr.Salinger@seznam.cz>

On Tue, Jun 09, 2009 at 08:10:42AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 09, 2009 at 01:35:58PM +0200, Petr Salinger wrote:
> > The problem is that there is no ENODATA errno value defined
> > on GNU/kFreeBSD. The errno values are determined by kernel,
> > they are the same as on plain FreeBSD, used libc
> > implementation does not change it.
> >
> > Another possibility is to use patch bellow.
> > Does it looks acceptable for you ?
> 
> This one looks better to me, except that I would really make this
> an explicit #ifdef __linux__.  The lack of a proper ENOATTR is
> a Linux specific quirck and not related to the presence of
> non-standard ENODATA.  Maybe also add a little comment why
> we're doing this so people don't get confused by it.
> 
> Btw, how does libattr actually work for you on FreeBSD?  Last time
> I checked FreeBSD had slightly different xattr system calls that (just
> like IRIX) used an integer namespace value instead of the string prefix
> in Linux.
> 

When not on Linux, libattr uses the GNU libc functions instead of the
system calls. The GNU libc then translates that into FreeBSD syscalls
including the integer namespace value.

-- 
Aurelien Jarno	                        GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
