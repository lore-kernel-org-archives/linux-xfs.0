Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6S8lwNo247570 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:47:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B3A19E6A9
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 01:47:58 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	fBTgiOy1Klw5qqdp for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2011 01:47:58 -0700 (PDT)
Date: Thu, 28 Jul 2011 04:47:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfstests: Add support for btrfs in 015
Message-ID: <20110728084756.GC3407@infradead.org>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
	<bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 28, 2011 at 10:28:00AM +0200, Stefan Behrens wrote:
> Added btrfs to the list of supported filesystems for test 015, and
> increased free space reporting tolerance to 10% for btrfs.
> Replaced the call to _scratch_mkfs_xfs with the XFS specific size
> parameter by the generic one for sized filesystem creation which is
> _scratch_mkfs_sized.

ACK for the _scratch_mkfs_sized changed, but I'm really curious why
we would allow so much more tolerance for btrfs.

And again, why can't these be marked generic?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
