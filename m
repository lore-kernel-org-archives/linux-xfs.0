Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QLIOab043125 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 16:18:34 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EF6F400795
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 14:19:12 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id n83S8MQI5FsRfYyB for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 14:19:12 -0700 (PDT)
Date: Wed, 26 Aug 2009 17:19:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <20090826180234.GC14019@infradead.org>
Message-ID: <alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
References: <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan>
	<20090822142550.GA10003@infradead.org>
	<alpine.DEB.2.00.0908221044420.30321@p34.internal.lan>
	<20090822201558.GA17955@infradead.org>
	<alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
	<20090822205502.GA18904@infradead.org>
	<alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
	<20090823224504.GA19942@infradead.org>
	<alpine.DEB.2.00.0908240704130.9427@p34.internal.lan>
	<alpine.DEB.2.00.0908260949550.9396@p34.internal.lan>
	<20090826180234.GC14019@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>



On Wed, 26 Aug 2009, Christoph Hellwig wrote:

> On Wed, Aug 26, 2009 at 09:50:27AM -0400, Justin Piszcz wrote:
>> So far the uptime is 2 days, if it does not recur in the next 24-48
>> hours, do you recommend I follow up with the linux-crypto folks about
>> this?  It appears this could be the cause (no issues, as of yet).
>
> At this point it doesn't look crypto related anymore, but like some
> bad interaction between layers once we add those fsync in the loop code.
>
> What filesystem does you loop image reside on?   Anything else special?
For the root filesystem, on / type xfs (rw,noatime)
For larger partitions (per the cryptoloop doc) the partition itself is 
setup via cryptoloop and then XFS ontop of that.  Nothing special.


> Any way to trgiger it with just loop but not crypto, etc.
Unfortunately not that I am aware of..  Would trying the kernel with the 
patch removed and mounted with -o nobarrier help to show us anything, or?

>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
