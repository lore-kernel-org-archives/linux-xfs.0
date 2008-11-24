Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAONqoht022860 for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 17:52:50 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA8AB15E0B14
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 15:52:49 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id cIS59KWqDJA5JECA for
	<xfs@oss.sgi.com>; Mon, 24 Nov 2008 15:52:49 -0800 (PST)
Date: Mon, 24 Nov 2008 18:52:48 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <1227569808.5039.6.camel@chevrolet>
Message-ID: <alpine.DEB.1.10.0811241851160.11882@p34.internal.lan>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Tue, 25 Nov 2008, Stian Jordet wrote:

> ma., 24.11.2008 kl. 04.50 -0500, skrev Justin Piszcz:
>> While there still may be something else wrong, the first problem I see is
>> your sunit and swidth are set to 0.
>>
>> Please read, a good article on what they are and how to set them:
>> http://www.socalsysadmin.com/
>
> Oh, this was new to me. But the setting didn't change anything. I can
> copy one large file between the xfs and ext3 disk (both ways), and I get
> speeds between 160 and 200 MB/s. But unpacking the kernel source takes
> between 5 and 10 minutes on the xfs disk, and a mere 15 seconds on the
> ext3... (and it also used to take between 5 and 10 minutes when I had
> xfs on the raid0, so it doesn't seem to be hardware related...)
>
> If anyone has anything more I can try before I do the lengthy process of
> backup 1TB, reformat and restore...
>
> Thanks :)
>
> Regards,
> Stian
>

When you 'unpack the kernel source' ext3 will cache it etc, best way to 
test:

/usr/bin/time cmd
or
time cmd

where cmd is: bash -c 'tar xvf file.tar; sync'

Make sure its a tar and not gzip/bzip2 (limited by CPU/etc)

The other option is the relatime you stated, use this instead:

defaults,noatime,logbufs=8,logbsize=262144

then tell me what you get
(instead of relatime)

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
