Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAONaxjg021847 for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 17:36:59 -0600
Received: from buick.jordet.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7592615DFDB8
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 15:36:54 -0800 (PST)
Received: from buick.jordet.net (buick.jordet.net [193.91.240.190]) by
	cuda.sgi.com with ESMTP id eAjd22mwjoKaNUGA for
	<xfs@oss.sgi.com>; Mon, 24 Nov 2008 15:36:54 -0800 (PST)
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
From: Stian Jordet <liste@jordet.net>
In-Reply-To: <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>
References: <1226760254.5089.11.camel@chevrolet>
	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
	<1227476908.32357.5.camel@chevrolet>
	<alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>
	<1227485956.5145.10.camel@chevrolet>
	<alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>
Date: Tue, 25 Nov 2008 00:36:48 +0100
Message-Id: <1227569808.5039.6.camel@chevrolet>
Mime-Version: 1.0
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

ma., 24.11.2008 kl. 04.50 -0500, skrev Justin Piszcz:
> While there still may be something else wrong, the first problem I see is 
> your sunit and swidth are set to 0.
> 
> Please read, a good article on what they are and how to set them:
> http://www.socalsysadmin.com/

Oh, this was new to me. But the setting didn't change anything. I can
copy one large file between the xfs and ext3 disk (both ways), and I get
speeds between 160 and 200 MB/s. But unpacking the kernel source takes
between 5 and 10 minutes on the xfs disk, and a mere 15 seconds on the
ext3... (and it also used to take between 5 and 10 minutes when I had
xfs on the raid0, so it doesn't seem to be hardware related...)

If anyone has anything more I can try before I do the lengthy process of
backup 1TB, reformat and restore...

Thanks :)

Regards,
Stian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
