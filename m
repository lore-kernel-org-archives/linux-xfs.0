Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o74CvfSb034042 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 07:57:41 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73DE115D0478
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 06:06:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vj3WzoTl3An5KA3U for
	<xfs@oss.sgi.com>; Wed, 04 Aug 2010 06:06:05 -0700 (PDT)
Date: Wed, 4 Aug 2010 08:56:31 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100804125631.GC17263@redhat.com>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<20100804111803.GA32643@infradead.org>
	<alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
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
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>

On Wed, Aug 04 2010 at  7:53am -0400,
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 4 Aug 2010, Christoph Hellwig wrote:
> 
> >The good news is that you have it tracked down, the bad news is
> >that I know very little about dm-crypt.  Maybe the issue is the
> >single threaded decryption in dm-crypt?  Can you check how much
> >CPU time the dm crypt kernel thread uses?
> 
> I'm not sure it's that. I have a Core i5 with AES-NI and that didn't
> significantly increase my overall performance, as it's not there the
> bottleneck is (at least in my system).

You could try applying both of these patches that are pending review for
hopeful inclussion in 2.6.36:

https://patchwork.kernel.org/patch/103404/
https://patchwork.kernel.org/patch/112657/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
