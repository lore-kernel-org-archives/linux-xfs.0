Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75Frott093102 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 10:53:51 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B7DDC4FA52
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 09:02:20 -0700 (PDT)
Received: from linta.de (isilmar-3.linta.de [188.40.101.200]) by cuda.sgi.com
	with ESMTP id dLDlEfx33oYkC0Ie for <xfs@oss.sgi.com>;
	Thu, 05 Aug 2010 09:02:20 -0700 (PDT)
Date: Thu, 5 Aug 2010 17:53:57 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: direct-io regression [Was: How to track down abysmal
	performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805155357.GA8245@comet.dominikbrodowski.net>
References: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
	<20100805113240.GA29846@think>
	<20100805153519.GA7242@comet.dominikbrodowski.net>
	<20100805153943.GO29846@think>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100805153943.GO29846@think>
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
To: Chris Mason <chris.mason@oracle.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, josef@redhat.com

On Thu, Aug 05, 2010 at 11:39:43AM -0400, Chris Mason wrote:
> On Thu, Aug 05, 2010 at 05:35:19PM +0200, Dominik Brodowski wrote:
> > On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> > > But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> > > seems a little high.  
> > 
> > Well, that's what it does:
> > 
> > # $ dd if=/dev/mapper/vg0-home_crypt of=/dev/zero iflag=direct bs=8k count=131072 seek=131072
> > # 131072+0 records in
> > # 131072+0 records out
> > # 1073741824 bytes (1.1 GB) copied, 62.0177 s, 17.3 MB/s
> 
> Can I ask you to do the test directly to the real honest to goodness
> drive?   If it were an SSD I'd be less surprised, but then the extra
> submits shouldn't hurt the ssd that much either.

>From lower the chain up to the device:

# LANG=EN dd if=/dev/mapper/vg0-root_crypt of=/dev/zero bs=8k count=131072 seek=393300 iflag=direct
131072+0 records in
131072+0 records out
1073741824 bytes (1.1 GB) copied, 63.1217 s, 17.0 MB/s

# LANG=EN dd if=/dev/mapper/vg0-root of=/dev/zero bs=8k count=131072 seek=393300 iflag=direct
131072+0 records in
131072+0 records out
1073741824 bytes (1.1 GB) copied, 43.2335 s, 24.8 MB/s

# LANG=EN dd if=/dev/sda5 of=/dev/zero bs=8k count=131072 seek=393300 iflag=direct
131072+0 records in
131072+0 records out
1073741824 bytes (1.1 GB) copied, 42.0868 s, 25.5 MB/s

Best,
	Dominik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
