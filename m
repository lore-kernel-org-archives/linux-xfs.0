Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o74MOT9x050339 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 17:24:29 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50308495B50
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 15:24:49 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id z2AMMmyrferUQ96P for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 15:24:49 -0700 (PDT)
Date: Thu, 5 Aug 2010 08:24:38 +1000
From: Neil Brown <neilb@suse.de>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100805082438.0b476adb@notabene>
In-Reply-To: <alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<20100804111803.GA32643@infradead.org>
	<alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
Mime-Version: 1.0
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com

On Wed, 4 Aug 2010 13:53:03 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 4 Aug 2010, Christoph Hellwig wrote:
> 
> > The good news is that you have it tracked down, the bad news is that I 
> > know very little about dm-crypt.  Maybe the issue is the single threaded 
> > decryption in dm-crypt?  Can you check how much CPU time the dm crypt 
> > kernel thread uses?
> 
> I'm not sure it's that. I have a Core i5 with AES-NI and that didn't 
> significantly increase my overall performance, as it's not there the 
> bottleneck is (at least in my system).
> 
> I earlier sent out an email wondering if someone could shed some light on 
> how scheduling, block caching and read-ahead works together when one does 
> disks->md->crypto->lvm->fs, becase that's a lot of layers and potentially 
> a lot of unneeded buffering, readahead and scheduling magic?
> 

Both page-cache and read-ahead work at the filesystem level, so only the
device in the stack that the filesystem mounts from is relevant for these.
Any read-ahead setting on other devices are ignored.
Other levels only have a cache if they explicitly need one.  e.g. raid5 has a
stripe-cache to allow parity calculations across all blocks in a stripe.

Scheduling can potentially happen at every layer, but it takes very different
forms.  Crypto, lvm, raid0 etc don't do any scheduling - it is just
first-in-first-out.
RAID5 does some scheduling for writes (but not reads) to try to gather full
stripes.  If you write 2 of 3 blocks in a stripe, then 3 of 3 in another
stripe, the 3 of 3 will be processed immediately while the 2 of 3 might be
delayed a little in the hope that the third will arrive.

The sys/block/XXX/queue/scheduler setting only applies at the bottom of the
stack (though when you have dm-multipath it is actually one step above the
bottom).

Hope that helps,
NeilBrown

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
