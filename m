Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o749D0qt026487 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 04:13:01 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4F7014C6187
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 02:21:21 -0700 (PDT)
Received: from linta.de (isilmar-3.linta.de [188.40.101.200]) by cuda.sgi.com
	with ESMTP id kGNZMSDxT4qAKsGr for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 02:21:21 -0700 (PDT)
Date: Wed, 4 Aug 2010 11:13:17 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100804091317.GA27779@isilmar-3.linta.de>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100804085039.GA11671@infradead.org>
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
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Christoph,

On Wed, Aug 04, 2010 at 04:50:39AM -0400, Christoph Hellwig wrote:
> On Wed, Aug 04, 2010 at 09:35:46AM +0200, Dominik Brodowski wrote:
> > How can I best track down the cause of the performance problem, 
> > a) without rebooting too often, and
> > b) without breaking up the setup specified above (production system)?
> 
> So did you just upgrade the system from an earlier kernel that did not
> show these problems?

No, 2.6.31 to 2.6.34 show similar behaviour.

>  Or did no one notice them before?

Well, there are some reports relating to XFS on MD or RAID, though I couldn't
find a resolution to the issues reported, e.g.

- http://kerneltrap.org/mailarchive/linux-raid/2009/10/12/6490333
- http://lkml.indiana.edu/hypermail/linux/kernel/1006.1/00099.html

However, I think we can rule out barriers, as XFS is mounted "nobarrier"
here.

Best,
	Dominik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
