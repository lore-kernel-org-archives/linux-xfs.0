Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o74BOAjC030570 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 06:24:10 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE8C64932EC
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 04:24:30 -0700 (PDT)
Received: from linta.de (isilmar-3.linta.de [188.40.101.200]) by cuda.sgi.com
	with ESMTP id jlJCtIzn51uxKctK for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 04:24:30 -0700 (PDT)
Date: Wed, 4 Aug 2010 13:24:28 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100804112428.GA5462@isilmar-3.linta.de>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<20100804111803.GA32643@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100804111803.GA32643@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 04, 2010 at 07:18:03AM -0400, Christoph Hellwig wrote:
> On Wed, Aug 04, 2010 at 12:25:26PM +0200, Dominik Brodowski wrote:
> > Hey,
> > 
> > many thanks for your feedback. It seems the crypto step is the culprit:
> > 
> > Reading 1.1 GB with dd, iflag=direct, bs=8k:
> > 
> > /dev/sd*                35.3 MB/s       ( 90 %)
> > /dev/md*                39.1 MB/s       (100 %)
> > /dev/mapper/md*_crypt    3.9 MB/s       ( 10 %)
> > /dev/mapper/vg1-*        3.9 MB/s       ( 10 %)
> > 
> > The "good" news: it also happens on my notebook, even though it has a
> > different setup (no raid, disk -> lv/vg -> crypt). On my notebook, I'm
> > more than happy to test out different kernel versions, patches etc.
> > 
> > /dev/sd*                17.7 MB/s       (100 %)
> > /dev/mapper/vg1-*       16.2 MB/s       ( 92 %)
> > /dev/mapper/*_crypt      3.1 MB/s       ( 18 %)
> 
> The good news is that you have it tracked down, the bad news is that
> I know very little about dm-crypt.  Maybe the issue is the single
> threaded decryption in dm-crypt?  Can you check how much CPU time
> the dm crypt kernel thread uses?

2 CPUs overall:
Cpu(s):  1.0%us,  5.7%sy,  0.0%ni, 44.8%id, 47.0%wa,  0.0%hi,  1.5%si, 0.0%st

Thanks & best,
	Dominik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
