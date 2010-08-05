Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75Fe5er092604 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 10:40:05 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E7C8498CF5
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 08:40:25 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id LwWAFLOtOipQZQyx for
	<xfs@oss.sgi.com>; Thu, 05 Aug 2010 08:40:25 -0700 (PDT)
Date: Thu, 5 Aug 2010 11:39:43 -0400
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: direct-io regression [Was: How to track down abysmal
	performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805153943.GO29846@think>
References: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
	<20100805113240.GA29846@think>
	<20100805153519.GA7242@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100805153519.GA7242@comet.dominikbrodowski.net>
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
To: Dominik Brodowski <linux@dominikbrodowski.net>, josef@redhat.com, Valdis.Kletnieks@vt.edu, Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com

On Thu, Aug 05, 2010 at 05:35:19PM +0200, Dominik Brodowski wrote:
> Hey,
> 
> On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> > But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> > seems a little high.  
> 
> Well, that's what it does:
> 
> # $ dd if=/dev/mapper/vg0-home_crypt of=/dev/zero iflag=direct bs=8k count=131072 seek=131072
> # 131072+0 records in
> # 131072+0 records out
> # 1073741824 bytes (1.1 GB) copied, 62.0177 s, 17.3 MB/s

Can I ask you to do the test directly to the real honest to goodness
drive?   If it were an SSD I'd be less surprised, but then the extra
submits shouldn't hurt the ssd that much either.

Thanks for testing the patch, I'll send it in.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
