Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KMUoYH088271 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 17:30:50 -0500
Date: Tue, 20 Sep 2011 18:30:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110920223047.GA13758@infradead.org>
References: <4E70571A.80108@profihost.ag> <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E78CEFD.9030603@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, aelder@sgi.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Sep 20, 2011 at 07:35:57PM +0200, Stefan Priebe - Profihost AG wrote:
> Am 20.09.2011 19:24, schrieb Christoph Hellwig:
> >On Tue, Sep 20, 2011 at 07:23:00PM +0200, Stefan Priebe - Profihost AG wrote:
> >>>  - what is the fs geometry?
> >>What do you exactly mean? I've seen this on 1TB and 160GB SSD
> >>devices with totally different disk layout.
> >
> >The output of mkfs.xfs (of xfs_info after it's been created)
> 
> ssd:~# xfs_info /dev/sda3
> meta-data=/dev/root              isize=256    agcount=4, agsize=9517888 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=38071552, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=18589, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Nothing special there.

So far I haven't been able to recreate it.  How many runs did you
normally need on 3.1-rc?  Note that so far I've run my known working
kernel, I'll test your config plus the drivers I need next.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
