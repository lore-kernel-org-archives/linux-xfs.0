Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q69C1TYF222469 for <xfs@oss.sgi.com>; Mon, 9 Jul 2012 07:01:29 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id T92VxgLp0gHD9t0Y
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Jul 2012 05:01:28 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so23859026pbb.26
	for <xfs@oss.sgi.com>; Mon, 09 Jul 2012 05:01:28 -0700 (PDT)
Date: Mon, 9 Jul 2012 20:02:28 +0800
From: kedacomkernel <kedacomkernel@gmail.com>
Subject: Re: Re: mkfs.xfs states log stripe unit is too large
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
	<20120626023059.GC19223@dastard>
	<20120626080217.GA30767@infradead.org>
	<20120702061827.GB16671@infradead.org>
	<20120702164113.109162be@notabene.brown>,
	<20120702080802.GQ19223@dastard>
Mime-Version: 1.0
Message-ID: <201207092002243437160@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid <linux-raid@vger.kernel.org>, Ingo J?rgensmann <ij@2012.bluespice.org>, xfs <xfs@oss.sgi.com>

On 2012-07-02 16:08 Dave Chinner <david@fromorbit.com> Wrote:
>On Mon, Jul 02, 2012 at 04:41:13PM +1000, NeilBrown wrote:
>> On Mon, 2 Jul 2012 02:18:27 -0400 Christoph Hellwig <hch@infradead.org> wrote:
>> 
>> > Ping to Neil / the raid list.
>> 
>> Thanks for the reminder.
>> 
>> > 
[snip]
>
>That's true, but the characterisitics of spinning disks have not
>changed in the past 20 years, nor has the typical file size
>distributions in filesystems, nor have the RAID5/6 algorithms. So
>it's not really clear to me why you;d woul deven consider changing
>the default the downsides of large chunk sizes on RAID5/6 volumes is
>well known. This may well explain the apparent increase in "XFS has
>hung but it's really just waiting for lots of really slow IO on MD"
>cases I've seen over the past couple of years.
>
At present, cat /sys/block/sdb/queue/max_sectors_kb:
is 512k. Maybe because this.

>The only time I'd ever consider stripe -widths- of more than 512k or
>1MB with RAID5/6 is if I knew my workload is almost exclusively
>using large files and sequential access with little metadata load,
>and there's relatively few workloads where that is the case.
>Typically those workloads measure throughput in GB/s and everyone
>uses hardware RAID for them because MD simply doesn't scale to this
>sort of usage.
>
>> If 512K is always suboptimal for XFS then that is unfortunate but I don't
>
>I think 512k chunk sizes are suboptimal for most users, regardless
>of the filesystem or workload....
>
>> think it is really possible to choose a default that everyone will be happy
>> with.  Maybe we just need more documentation and warning emitted by various
>> tools.  Maybe mkfs.xfs could augment the "stripe unit too large" message with
>> some text about choosing a smaller chunk size?
>
>We work to the mantra that XFS should always choose the defaults
>that give the best overall performance and aging characteristics so
>users don't need to be a storage expert to get the best the
>filesystem can offer. The XFS warning is there to indicate that the
>user might be doing something wrong. If that's being emitted with a
>default MD configuration, then that indicates that the MD defaults
>need to be revised....
>
>If you know what a stripe unit or chunk size is, then you know how
>to deal with the problem. But for the majority of people, that's way
>more knowledge than they are prepared to learn about or should be
>forced to learn about.
>
>Cheers,
>
>Dave.
>-- 
>Dave Chinner
>david@fromorbit.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
