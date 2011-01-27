Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RLrxfi033571 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 15:53:59 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D444F1A38A38
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 13:56:23 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.183]) by cuda.sgi.com with ESMTP id
	t6C63vj03oIFpNgG for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 13:56:23 -0800 (PST)
Message-ID: <4D41EA04.7010506@teksavvy.com>
Date: Thu, 27 Jan 2011 16:56:20 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com>
	<20110127033011.GH21311@dastard>	<4D40EB2F.2050809@teksavvy.com>
	<4D418B57.1000501@teksavvy.com>	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
In-Reply-To: <4D41CA16.8070001@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>

On 11-01-27 02:40 PM, Stan Hoeppner wrote:
..
> You need to use the mkfs.xfs defaults for any single drive filesystem, and trust
> the allocator to do the right thing.

But it did not do the right thing when I used the defaults.
Big files ended up with tons of (exactly) 64MB extents, ISTR.

With the increased number of ags, I saw much less fragmentation,
and the drive was still very light on I/O despite multiple simultaneous
recordings, commflaggers, and playback at once.

The only, ONLY, glitch, was this recent "first write takes 45 seconds" glitch.
After that initial write after boot, throughput was normal (great).

Thus the attempts to tweak.

> Trust the defaults.

I imagine the defaults are designed to handle a typical Linux install,
with 100,000 to 1,000,000 files varying from a few bytes to a few megabytes.

That's not what this filesystem will have. It will have only a few thousand
(max) inodes at any given time, but each file will be HUGE.

XFS is fantastic at adapting to the workload, but I'd like to try and have
it tuned more closely for the known workload this system is throwing at it.

I'm now trying again, but with 8 ags instead of 8000+.

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
