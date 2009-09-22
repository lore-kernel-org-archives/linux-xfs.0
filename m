Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8MCEXb0189755 for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 07:14:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7139131E43C
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 05:15:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id l9ka72Q0xmYiuQvJ for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2009 05:15:51 -0700 (PDT)
Date: Tue, 22 Sep 2009 08:15:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsprogs build tweaks for Debian
Message-ID: <20090922121550.GA16920@infradead.org>
References: <777659823.265181253164106522.JavaMail.root@mail-au.aconex.com>
	<1527800797.273701253228929936.JavaMail.root@mail-au.aconex.com>
	<20090922115707.GA8143@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090922115707.GA8143@infradead.org>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 22, 2009 at 07:57:07AM -0400, Christoph Hellwig wrote:
> >  PKG_MINOR=0
> > -PKG_REVISION=3
> > +PKG_REVISION=4
> >  PKG_BUILD=1
> 
> Note that when you bump package version please always also tag the
> result in git.

Actually given that the tree has moved ahead that's not even easily
doable.  I'd suggest to commit this ontop of the few patches in already
and include them in the changelog.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
