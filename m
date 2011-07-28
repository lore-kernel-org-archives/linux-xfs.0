Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6S8jBUc247456 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:45:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6702AF131FF
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 01:45:22 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WQK4tqdyEfyRDpcF for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2011 01:45:22 -0700 (PDT)
Date: Thu, 28 Jul 2011 04:45:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfstests: Add support for btrfs in 062
Message-ID: <20110728084504.GA3407@infradead.org>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
	<d42f34a30289157f262ffe31760a54cc1b5d3d4b.1311776403.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d42f34a30289157f262ffe31760a54cc1b5d3d4b.1311776403.git.sbehrens@giantdisaster.de>
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

On Thu, Jul 28, 2011 at 10:27:58AM +0200, Stefan Behrens wrote:
> Added btrfs to the list of supported filesystems for this test.
> Remove output of mkfs since this is specific to mkfs.xfs and now filtered
> out.

Why can't it be generic?  Any reason this one doesn't work on e.g. ext2
or reiserfs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
