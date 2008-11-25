Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAP06D70024124 for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 18:06:13 -0600
Received: from mail.sdinet.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BBD915E280C
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 16:06:11 -0800 (PST)
Received: from mail.sdinet.de (mail.sdinet.de [78.47.32.153]) by cuda.sgi.com
	with ESMTP id l9pKs1PF9WlHwSuu for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2008 16:06:11 -0800 (PST)
Date: Tue, 25 Nov 2008 01:09:02 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <1227569808.5039.6.camel@chevrolet>
Message-ID: <alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>
References: <1226760254.5089.11.camel@chevrolet>
	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
	<1227476908.32357.5.camel@chevrolet>
	<alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>
	<1227485956.5145.10.camel@chevrolet>
	<alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>
	<1227569808.5039.6.camel@chevrolet>
MIME-Version: 1.0
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
To: Stian Jordet <liste@jordet.net>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Stian Jordet wrote:

> ma., 24.11.2008 kl. 04.50 -0500, skrev Justin Piszcz:
> > While there still may be something else wrong, the first problem I see is 
> > your sunit and swidth are set to 0.
> > 
> > Please read, a good article on what they are and how to set them:
> > http://www.socalsysadmin.com/
> 
> Oh, this was new to me. But the setting didn't change anything. I can
> copy one large file between the xfs and ext3 disk (both ways), and I get
> speeds between 160 and 200 MB/s. But unpacking the kernel source takes
> between 5 and 10 minutes on the xfs disk, and a mere 15 seconds on the
> ext3... (and it also used to take between 5 and 10 minutes when I had
> xfs on the raid0, so it doesn't seem to be hardware related...)

I had the same problem when I tried it on my laptop (T60) - using it on 
the unencrypted root filesystem (with /usr/src) took ages, using it on 
the LUKS encrypted /home was blasing fast - on the same disk.

This test was some time ago with something like 2.6.20 or 2.6.24 - I 
gave up and reformatted / with ext3 as I needed the machine.

I think barriers were the problem, they seem to cost performance like 
hell, especially for operations with many small files. My laptop used 
barriers for xfs on the direct partition, but not on crypto drivermapper 
mounts.

So perhaps try mounting with nobarrier and see if the speed problem goes 
away - but know that you sacrifice some crash-resilience when doing so.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around
it. (John Gilmore on http://www.cygnus.com/~gnu/)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
