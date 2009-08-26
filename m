Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QLTuqr043866 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 16:30:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE5C83FFE03
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 14:30:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id D8CJ54bn6gHUgpAO for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 14:30:49 -0700 (PDT)
Date: Wed, 26 Aug 2009 17:27:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
Message-ID: <20090826212732.GA18124@infradead.org>
References: <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan>
	<20090822201558.GA17955@infradead.org>
	<alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
	<20090822205502.GA18904@infradead.org>
	<alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
	<20090823224504.GA19942@infradead.org>
	<alpine.DEB.2.00.0908240704130.9427@p34.internal.lan>
	<alpine.DEB.2.00.0908260949550.9396@p34.internal.lan>
	<20090826180234.GC14019@infradead.org>
	<alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
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
Cc: Christoph Hellwig <hch@infradead.org>, Nikanth Karthikesan <knikanth@suse.de>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

On Wed, Aug 26, 2009 at 05:19:11PM -0400, Justin Piszcz wrote:
> For the root filesystem, on / type xfs (rw,noatime)
> For larger partitions (per the cryptoloop doc) the partition itself is  
> setup via cryptoloop and then XFS ontop of that.  Nothing special.

Just to make sure we have all data here - you see the problem only
with loop devices backed by XFS, only with loop devices backed by
raw partitions or with both?

>> Any way to trgiger it with just loop but not crypto, etc.
> Unfortunately not that I am aware of..  Would trying the kernel with the  
> patch removed and mounted with -o nobarrier help to show us anything, or?

Actually, yes - seeing what happens if you run plain 2.6.30 or 2.6.31-rc
without the backout patch, but with -o nobarrier would be very
interesting.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
