Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KKUgVe082027 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:30:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 003EC1783D9
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:30:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Bwo0VkkjUjA82UjR for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 13:30:41 -0700 (PDT)
Date: Tue, 20 Sep 2011 16:30:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs.xfs: don't increase agblocks past maximum
Message-ID: <20110920203040.GA17082@infradead.org>
References: <4E77B7E2.6020805@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E77B7E2.6020805@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 19, 2011 at 04:45:06PM -0500, Eric Sandeen wrote:
> RH QA discovered this bug:
> 
> Steps to Reproduce:
> 1. Create 4 TB - 1 B partition
> dd if=/dev/zero of=x.img bs=1 count=0 seek=4398046511103
> 2. Create xfs fs with 512 B block size on the partition
> mkfs.xfs -b size=512 xfs.img

Can we please get this into xfstests, just doing the mkfs on a
sparse file should be enough.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
