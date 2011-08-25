Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P5IEft163594 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:18:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A1481C02C72
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 22:18:13 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Z6su2eGD8UUOvlTH for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 22:18:13 -0700 (PDT)
Date: Thu, 25 Aug 2011 01:18:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 3.0.1: xfs hang
Message-ID: <20110825051812.GC1869@infradead.org>
References: <alpine.DEB.2.02.1108201536510.14176@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1108201536510.14176@p34.internal.lan>
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
Cc: xfs@oss.sgi.com

On Sat, Aug 20, 2011 at 03:38:21PM -0400, Justin Piszcz wrote:
> Hi,
> 
> Forgot to remove 'delaylog' from my fstab on one of my machines,
> while rm -rf a large directory with many files:

Does it actually hand the machine, or do you get the warning and then
work continues?

Unfortunately your backtrace doesn't seem overly reliable, so it's kinda
hard to figure out what is going on.  There is nothing delaylog related
in the provided one though.  If it halfway matches what is going on it
seems to be block I/O related.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
