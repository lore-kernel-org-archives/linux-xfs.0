Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o749L3Cj026721 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 04:21:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97CC514C61D7
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 02:29:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DFBoWPufgCtocjbb for
	<xfs@oss.sgi.com>; Wed, 04 Aug 2010 02:29:26 -0700 (PDT)
Date: Wed, 4 Aug 2010 05:21:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100804092122.GA2998@infradead.org>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100804091317.GA27779@isilmar-3.linta.de>
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
To: Dominik Brodowski <linux@dominikbrodowski.net>, Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 11:13:17AM +0200, Dominik Brodowski wrote:
> > show these problems?
> 
> No, 2.6.31 to 2.6.34 show similar behaviour.

Ok, so it's been around for a while.  Can you test the write speed of
each individual device layer by doing a large read from it, using:

	dd if=<device> of=/dev/null bs=8k iflag=direct

where device starts with the /dev/sda* device, and goes up to the MD
device, the dm-crypt device and the LV.  And yes, it's safe to read
from the device while it's otherwise mounted/used.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
