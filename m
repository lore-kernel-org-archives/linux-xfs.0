Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNLAwLA250142 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 15:10:58 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 453381CF5AA7
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:12:56 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id 2rMHkOA0kQuli0WE for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:12:56 -0800 (PST)
Message-ID: <4D13BB57.80309@sandeen.net>
Date: Thu, 23 Dec 2010 15:12:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
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

On 12/23/10 12:06 PM, Justin Piszcz wrote:
> 
> On Thu, 23 Dec 2010, Justin Piszcz wrote:
> 
> 
> Hi,
> 
> How come parted using (optimal at 1mb alignment is slower than no
> partition?  

because parted got it wrong, sounds like.

> In addition, sunit and swidth set properly as mentioned
> earlier appears to be _slower_ than defaults with no partitions.

stripe unit over an incorrectly aligned partition won't help
and I suppose could make it worse.

align your partitions, using sector units, to a stripe width unit.
Set the stripe width properly on the fs on top of that.

-Eric
 
> 
> http://home.comcast.net/~jpiszcz/20101223/final.html
> 
> Justin.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
