Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59CAVGM035620 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 07:10:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 438D6126A29F
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 05:17:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KZ6GMHtm0KDUKr7K for
	<xfs@oss.sgi.com>; Tue, 09 Jun 2009 05:17:57 -0700 (PDT)
Date: Tue, 9 Jun 2009 08:10:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
Message-ID: <20090609121042.GA28666@infradead.org>
References: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
	<Pine.LNX.4.62.0906091328270.31325@sci.felk.cvut.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0906091328270.31325@sci.felk.cvut.cz>
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
To: Petr Salinger <Petr.Salinger@seznam.cz>
Cc: Christoph Hellwig <hch@infradead.org>, 531950-quiet@bugs.debian.org, xfs@oss.sgi.com, Nathan Scott <nscott@aconex.com>

On Tue, Jun 09, 2009 at 01:35:58PM +0200, Petr Salinger wrote:
> The problem is that there is no ENODATA errno value defined
> on GNU/kFreeBSD. The errno values are determined by kernel,
> they are the same as on plain FreeBSD, used libc
> implementation does not change it.
>
> Another possibility is to use patch bellow.
> Does it looks acceptable for you ?

This one looks better to me, except that I would really make this
an explicit #ifdef __linux__.  The lack of a proper ENOATTR is
a Linux specific quirck and not related to the presence of
non-standard ENODATA.  Maybe also add a little comment why
we're doing this so people don't get confused by it.

Btw, how does libattr actually work for you on FreeBSD?  Last time
I checked FreeBSD had slightly different xattr system calls that (just
like IRIX) used an integer namespace value instead of the string prefix
in Linux.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
