Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75GZ6eK094317 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 11:35:06 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F7C449931F
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 09:35:26 -0700 (PDT)
Received: from linta.de (isilmar-3.linta.de [188.40.101.200]) by cuda.sgi.com
	with ESMTP id QHcP1AArGuD5SODv for <xfs@oss.sgi.com>;
	Thu, 05 Aug 2010 09:35:26 -0700 (PDT)
Date: Thu, 5 Aug 2010 18:35:19 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: direct-io regression [Was: How to track down abysmal
	performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805163519.GA6604@comet.dominikbrodowski.net>
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
To: Chris Mason <chris.mason@oracle.com>, josef@redhat.com, Valdis.Kletnieks@vt.edu, Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com

Small correction:

On Thu, Aug 05, 2010 at 05:35:19PM +0200, Dominik Brodowski wrote:
> With this fix, I get proper speeds when doing dio reads from
> /dev/mapper/vg0-*_crypt; see the 17.3 MB/s above. Most strangely,
> also accesing /dev/mapper/vg0-* (un-encrypted) and the raw
> device at /dev/sda* speeds up (to up to 28 MB/s). Was only seeing around
> 16 to 18 MB/s without this patch for unencrypted access.

The speed-up of the unencrypted access (18 -> 28 MB/s) is caused by using a
different configuration for kernel 2.6.35; and seems to be unrelated to your
patch. Will try to track down which config option is the culprit.


kernel, dmcrypt?	| good config | bad config
-------------------------------------------------
patched 2.6.35, dmcrypt	  ~ 18 MB/s	~ 13 MB/s
patched 2.6.35		  ~ 28 MB/s	~ 18 MB/s
-------------------------------------------------
plain 2.6.35, dmcrypt	  ~  3 MB/s	~  3 MB/s
plain 2.6.35		  <not tested>	~ 16 MB/s	


Best,
	Dominik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
