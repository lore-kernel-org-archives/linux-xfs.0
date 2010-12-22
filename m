Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMIm8UB015559 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 12:48:08 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F06414768F7
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 10:50:05 -0800 (PST)
Received: from parsec.stupidest.org (parsec.stupidest.org [71.6.196.126]) by
	cuda.sgi.com with ESMTP id OUeKKa3t9EfopYbH for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 10:50:05 -0800 (PST)
Date: Wed, 22 Dec 2010 10:50:05 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101222185005.GB30073@puku.stupidest.org>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222170620.GA29117@puku.stupidest.org>
	<alpine.DEB.2.00.1012221209150.5245@p34.internal.lan>
	<20101222173209.GA29291@puku.stupidest.org>
	<alpine.DEB.2.00.1012221234310.5245@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012221234310.5245@p34.internal.lan>
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

On Wed, Dec 22, 2010 at 12:35:46PM -0500, Justin Piszcz wrote:

> Is this by specifying the sunit/swidth?

yes

> Can you elaborate on which paramters you modified?

i set both to match what the hw raid was doing, the lru that is my
brain doesn't have the detail anymore sorry

at a guess it was probably something like 64k chunk, 20 devices wide


the metadata performance difference between wrong and right is quite
noticable


> Yes and have it set to perform(ance).

be sure you have a bbu, there is a setting for force wc --- i wouldn't
do that

i would have it wc when the battery is good automatically disable it
when it's bad

i was able to buffer ~490MB of writes in the card without trying hard,
that's a lot of pain to get corrupted

> Going to be using 19HDD x 3TB Hiatchi 7200RPMs, (18HDD RAID-6 + 1
> hot spare).

are those 4k sector drives?  i ask because it's not clear if/how the
raid fw deals with these

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
