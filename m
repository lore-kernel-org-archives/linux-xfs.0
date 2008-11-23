Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mANMPrZM030390 for <xfs@oss.sgi.com>; Sun, 23 Nov 2008 16:25:55 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB9A815CF2F2
	for <xfs@oss.sgi.com>; Sun, 23 Nov 2008 14:25:53 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id kRJ0qscaGzziwS9V for
	<xfs@oss.sgi.com>; Sun, 23 Nov 2008 14:25:53 -0800 (PST)
Date: Sun, 23 Nov 2008 17:25:22 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <1227476908.32357.5.camel@chevrolet>
Message-ID: <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>
References: <1226760254.5089.11.camel@chevrolet>
	<430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
	<1227476908.32357.5.camel@chevrolet>
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



On Sun, 23 Nov 2008, Stian Jordet wrote:

> ti., 18.11.2008 kl. 11.51 -0200, skrev Sergio Luis:
>> please post your config and dmesg output. It might help people try to
>> identify something wrong.
>
> (see http://marc.info/?l=linux-kernel&m=122676220019858&w=2 for the
> start of this thread)
>
> Hmm. I have now converted my root and /home filesystems to ext3, and
> that actually fixed it (!). I have no idea why xfs is performing so
> extremely poorly on this machine, i'm running xfs on every filesystem on
> eight other computers (one heavy loaded server, as well).
>
> Anyway, I'm now unpacking the 2.6.27.6 kernel in 15 seconds, with xfs on
> the same array it used between five and six minutes.
>
> I still have a xfs array, and when I copy files to or from that array,
> the gnome session practically freezes, and the load average easily goes
> beyond 10.
>
> How should I debug this? I'm not very eager about reformatting my 1,5TB
> xfs array... Besides, xfs have never let me down earlier.
>
> Thanks.
>
> Please cc me on any replies.
>
> Regards,
> Stian
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

As the original posted stated:

1. please post dmesg output
2. you may want to include your kernel .config
3. xfs_info /dev/mdX or /dev/device may also be useful
4. you can also check fragmentation:
    # xfs_db -c frag -f /dev/md2
    actual 257492, ideal 242687, fragmentation factor 5.75%
5. something sounds very strange, I also run XFS on a lot of systems and
    have never heard of that before..
6. also post your /etc/fstab options
7. what distribution are you running?
8. are -only- the two fujitsu's (raid0) affected or are other arrays
    affected on this HW as well (separate disks etc)?
9. you can also compile in support for latency_top & power_top to see
    if there is any excessive polling going on by any one specific
    device/function as well

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
