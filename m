Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NDeUJG203201 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:40:30 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDE3D46C376
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 06:43:32 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 9wCuzq81A8WxrcjL for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 06:43:32 -0700 (PDT)
Date: Fri, 23 Jul 2010 15:38:43 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: 4k sector drives
Message-ID: <20100723133843.GA3397@citd.de>
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<201007230809.28111@zmi.at> <20100723095832.GA23174@infradead.org>
	<201007231259.11714@zmi.at> <4C4994CB.2050200@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C4994CB.2050200@hardwarefreak.com>
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
Cc: xfs@oss.sgi.com

On 23.07.2010 08:10, Stan Hoeppner wrote:
> Michael Monnerie put forth on 7/23/2010 5:59 AM:
> > On Freitag, 23. Juli 2010 Christoph Hellwig wrote:
> >> -b size=4096 is the default anyway, for 4k sector drivers you also
> >>  want -s size=4096, which you do not want for 512 byte sector disks.
> > 
> > Thanks for clarification. Should I use "-s size=4096" despite the drive 
> > saying 512b sectors? It's a "hidden" 4K sector drive, so maybe declaring 
> > it extra for XFS helps performance? Or does it not matter at all?
> >  
> >> What values do the files
> >>
> >>         /sys/block/<device>/queue/logical_block_size
> >>         /sys/block/<device>/queue/physical_block_size
> >>         /sys/block/<device>/alignment_offset
> >>
> >> say about your disk?
> > 
> > 512, 512, 0 for a Western Digital D20EARS-00MVWB0 (2TB) which has 4K 
> > sectors but obviously hides it.
> 
> The WD20EARS-00MVWB0 is definitely a 4k sector drive:
> http://products.wdc.com/Library/Flyer/ENG/2178-771123.pdf
> 
> If you're currently seeing somewhere between 60-120MB/s per drive with hdparm
> or dd then you don't need to further tweak anything.  If alignment is off,
> from all I've read, performance will be abysmal, down in the sub 30MB/s range.

Only for writes, reads are for practically unaffected.

The problem for write is the "Read Modify Write" Cycle that is needed 
when you don't change all 8 512byte "sub-"sectors contained in a 4096 
byte sector.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
