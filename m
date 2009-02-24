Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OIidNi159478 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 12:44:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7851814C118
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 10:44:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LYDXsaD2kxzdujNZ for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 10:44:09 -0800 (PST)
Date: Tue, 24 Feb 2009 13:44:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs/xfsdump release process
Message-ID: <20090224184405.GB28007@infradead.org>
References: <200902221348.51905.vapier@gentoo.org>
	<200902221539.26143.vapier@gentoo.org>
	<200902241005.49414.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902241005.49414.vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 24, 2009 at 10:05:48AM -0500, Mike Frysinger wrote:
> On Sunday 22 February 2009 15:39:25 Mike Frysinger wrote:
> > On Sunday 22 February 2009 13:48:49 Mike Frysinger wrote:
> > > how are release tarballs created ?  seems like there's an error in the
> > > process as the dmapi-2.2.9 contains files it shouldnt.  for example,
> > > autom4te.cache/, include/builddefs, etc...
> >
> > in a similar vain, every xfsdump/xfsprogs release has made people run
> > `autoconf` first as the configure script is considered part of the
> > distclean target in general.  i dont think that makes any sense as the
> > configure script should be included with every release tarball.
> 
> so how are release tarballs made ?  i dont see a "dist" target or anything ...

The current ones were made using a hacked up release script form me.
There's a Makepkgs script in the tarballs that generates better
tarballs, but knowledge about it was lost in various transitions and
it started to bitrot.  I'm fixing it up so we can use it for the next
release right now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
