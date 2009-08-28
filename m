Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SGviAh166050 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 11:57:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40A981579760
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 09:58:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xpAiBGyMBvySr7be for
	<xfs@oss.sgi.com>; Fri, 28 Aug 2009 09:58:38 -0700 (PDT)
Date: Fri, 28 Aug 2009 12:55:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
Message-ID: <20090828165526.GA6133@infradead.org>
References: <20090822205502.GA18904@infradead.org>
	<alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
	<20090823224504.GA19942@infradead.org>
	<alpine.DEB.2.00.0908240704130.9427@p34.internal.lan>
	<alpine.DEB.2.00.0908260949550.9396@p34.internal.lan>
	<20090826180234.GC14019@infradead.org>
	<alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
	<20090826212732.GA18124@infradead.org>
	<alpine.DEB.2.00.0908261728580.1594@p34.internal.lan>
	<alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
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
Cc: Christoph Hellwig <hch@infradead.org>, Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 28, 2009 at 07:23:11AM -0400, Justin Piszcz wrote:
> If both '-o nobarrier' and the patch solves the issue, what is the next  
> action that should be taken?  Update the documentation to always use
> -o nobarrier for cryptoloop? Or get the patch reverted in mainline?

We'll have to figure out why it causes those problems and how fix them.
-o nobarrier on a loop device is extremly unsafe as you will possible
lose large amounts of log updates in case of a crash.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
