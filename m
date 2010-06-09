Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59DN5mJ015990 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 08:23:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74785158FF1C
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 06:28:39 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id 0ziie5tdtcCRRdLS for <xfs@oss.sgi.com>;
	Wed, 09 Jun 2010 06:28:39 -0700 (PDT)
Date: Wed, 9 Jun 2010 09:25:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 217: remove file in between mkfs's
Message-ID: <20100609132536.GA31729@infradead.org>
References: <4C0F0A4C.7050600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C0F0A4C.7050600@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 08, 2010 at 10:28:12PM -0500, Eric Sandeen wrote:
> 217 requires a 2G scratch:
> 
> _require_fs_space $SCRATCH_MNT 2202000
> 
> but as we mkfs different sizes, we actually are filling in the
> sparse loopback more and more, and 3.8G isn't enough to contain it.
> 
> If we remove & recreate the file between mkfs's it doesn't take
> so much space ... I don't think it adds significantly to test time.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
