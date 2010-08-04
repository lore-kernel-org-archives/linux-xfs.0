Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o74Bqj5f032262 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 06:52:45 -0500
Received: from uplift.swm.pp.se (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 614431E3D32E
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 04:53:04 -0700 (PDT)
Received: from uplift.swm.pp.se (swm.pp.se [212.247.200.143]) by cuda.sgi.com
	with ESMTP id rKoxrBR5RM9rFA4a for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 04:53:04 -0700 (PDT)
Date: Wed, 4 Aug 2010 13:53:03 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
In-Reply-To: <20100804111803.GA32643@infradead.org>
Message-ID: <alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<20100804111803.GA32643@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-kernel@vger.kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>, xfs@oss.sgi.com, linux-raid@vger.kernel.org, dm-devel@redhat.com

On Wed, 4 Aug 2010, Christoph Hellwig wrote:

> The good news is that you have it tracked down, the bad news is that I 
> know very little about dm-crypt.  Maybe the issue is the single threaded 
> decryption in dm-crypt?  Can you check how much CPU time the dm crypt 
> kernel thread uses?

I'm not sure it's that. I have a Core i5 with AES-NI and that didn't 
significantly increase my overall performance, as it's not there the 
bottleneck is (at least in my system).

I earlier sent out an email wondering if someone could shed some light on 
how scheduling, block caching and read-ahead works together when one does 
disks->md->crypto->lvm->fs, becase that's a lot of layers and potentially 
a lot of unneeded buffering, readahead and scheduling magic?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
