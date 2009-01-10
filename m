Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0ANAfx9012572 for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 17:10:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5493517CBD58
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 12:34:18 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nNrFCT8Q9EhI1pJD for
	<xfs@oss.sgi.com>; Sat, 10 Jan 2009 12:34:18 -0800 (PST)
Date: Sat, 10 Jan 2009 15:33:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add test 199, bad_features2 correction
Message-ID: <20090110203347.GA7733@infradead.org>
References: <20090103205309.GB20346@infradead.org>
	<4969053E.2060903@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4969053E.2060903@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Jan 10, 2009 at 02:29:50PM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > Index: xfstests-dev/199
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ xfstests-dev/199	2009-01-03 20:36:06.000000000 +0000
> > @@ -0,0 +1,65 @@
> > +#! /bin/sh
> > +# FS QA Test No. 199
> > +#
> > +# Check that a filesystem first mounted read-only and then remounted
> > +# performs the features2 fixup properly.
> 
> Seems fine.  Would it be worth adding a few more lines to also test that
> a simple rw mount (w/o going through ro first) also properly fixes it?

I was under the impression that we already tested that somewhere else,
but it seems like we don't.  Yes, I'll add it, that's a good one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
