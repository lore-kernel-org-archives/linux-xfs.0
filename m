Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7NMiHLC084364 for <xfs@oss.sgi.com>; Sun, 23 Aug 2009 17:44:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 319573F0229
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2009 15:45:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dFfpxgcgJXqORF9l for
	<xfs@oss.sgi.com>; Sun, 23 Aug 2009 15:45:08 -0700 (PDT)
Date: Sun, 23 Aug 2009 18:45:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
Message-ID: <20090823224504.GA19942@infradead.org>
References: <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
	<20090816022331.GA2309@infradead.org>
	<alpine.DEB.2.00.0908171024380.12533@p34.internal.lan>
	<alpine.DEB.2.00.0908220624440.30321@p34.internal.lan>
	<20090822142550.GA10003@infradead.org>
	<alpine.DEB.2.00.0908221044420.30321@p34.internal.lan>
	<20090822201558.GA17955@infradead.org>
	<alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
	<20090822205502.GA18904@infradead.org>
	<alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Ok, let's see where errors could happen then.

There are four theoretical possibilities:

 (a) XFS
 (b) loop driver
 (c) crypto loop code
 (d) block layer

Or combinations thereof.

I would take (a) and (d) as more unlikely as they tend to get used much
more and I would have heard more bug reports already.

The cryptoloop code hasn't changed at all since 2.6.29.

The loop code howver has a very interesting commit just after 2.6.39:

commit 68db1961bbf4e16c220ccec4a780e966bc1fece3
Author: Nikanth Karthikesan <knikanth@suse.de>
Date:   Tue Mar 24 12:29:54 2009 +0100

    loop: support barrier writes

Can you try reverting this one (it cleanly reverse-applies against
2.6.30 and current mainline) and see if that makes a difference?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
