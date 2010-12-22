Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMHXn64005479 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 11:33:49 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D5601476378
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 09:35:46 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id WZ6FsIedmmBrNpWG for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 09:35:46 -0800 (PST)
Date: Wed, 22 Dec 2010 12:35:46 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
In-Reply-To: <20101222173209.GA29291@puku.stupidest.org>
Message-ID: <alpine.DEB.2.00.1012221234310.5245@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222170620.GA29117@puku.stupidest.org>
	<alpine.DEB.2.00.1012221209150.5245@p34.internal.lan>
	<20101222173209.GA29291@puku.stupidest.org>
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
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com



On Wed, 22 Dec 2010, Chris Wedgwood wrote:

> On Wed, Dec 22, 2010 at 12:10:06PM -0500, Justin Piszcz wrote:
>
>> Do you have an example/of what you found?
>
> i don't have the numbers anymore, they are with a previous employer.
>
> basically using dbench (there were cifs NAS machines, so dbench seemed
> as good or bad as anything to test with) the performance was about 3x
> better between 'old' and 'new' with a small number of workers and
> about 10x better with a large number
Is this by specifying the sunit/swidth?
Can you elaborate on which paramters you modified?

>
> i don't know how much difference each of inode64 and getting the geom
> right made each, but bother were quite measurable in the graphs i made
> at the time
>
>
> from memory the machines are raid50 (4x (5+1)) with 2TB drives, so
> about 38TB usable on each one
>
> initially these machines were 3ware controllers and later on LSI (the
> two products lines have since merged so it's not clear how much
> difference that makes now)
>
> in testing 16GB for xfs_repair wasn't enough, so they were upped to
> 64GB, that's likely largely a result of the fact there were 100s of
> millions of small files (as well as some large ones)
Yikes =)  Hopefully its better now?

>
>> Is it dependent on the RAID card?
>
> perhaps, do you have a BBU and enable WC?  certainly we found the LSI
> cards to be faster in most cases than the (now old) 3ware

Yes and have it set to perform(ance).
Going to be using 19HDD x 3TB Hiatchi 7200RPMs, (18HDD RAID-6 + 1 hot spare).

>
> where i am now i use larger chassis and no hw raid cards, using sw
> raid on these works spectacularly well with the exception of burst of
> small seeky writes (which a BBU + wc soaks up quite well)
Interesting..

>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
