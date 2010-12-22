Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMHUB7H004615 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 11:30:12 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 631572184E8
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 09:32:09 -0800 (PST)
Received: from parsec.stupidest.org (parsec.stupidest.org [71.6.196.126]) by
	cuda.sgi.com with ESMTP id dTijd9R5YEx8tAPT for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 09:32:09 -0800 (PST)
Date: Wed, 22 Dec 2010 09:32:09 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101222173209.GA29291@puku.stupidest.org>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222170620.GA29117@puku.stupidest.org>
	<alpine.DEB.2.00.1012221209150.5245@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012221209150.5245@p34.internal.lan>
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

On Wed, Dec 22, 2010 at 12:10:06PM -0500, Justin Piszcz wrote:

> Do you have an example/of what you found?

i don't have the numbers anymore, they are with a previous employer.

basically using dbench (there were cifs NAS machines, so dbench seemed
as good or bad as anything to test with) the performance was about 3x
better between 'old' and 'new' with a small number of workers and
about 10x better with a large number

i don't know how much difference each of inode64 and getting the geom
right made each, but bother were quite measurable in the graphs i made
at the time


from memory the machines are raid50 (4x (5+1)) with 2TB drives, so
about 38TB usable on each one

initially these machines were 3ware controllers and later on LSI (the
two products lines have since merged so it's not clear how much
difference that makes now)

in testing 16GB for xfs_repair wasn't enough, so they were upped to
64GB, that's likely largely a result of the fact there were 100s of
millions of small files (as well as some large ones)

> Is it dependent on the RAID card?

perhaps, do you have a BBU and enable WC?  certainly we found the LSI
cards to be faster in most cases than the (now old) 3ware


where i am now i use larger chassis and no hw raid cards, using sw
raid on these works spectacularly well with the exception of burst of
small seeky writes (which a BBU + wc soaks up quite well)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
