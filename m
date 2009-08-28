Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SMmTP1181785 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 17:48:39 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF3203040D1
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 15:49:23 -0700 (PDT)
Message-Id: <6854DCEB-F9C8-4969-8012-65B0CD671E38@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090828221304.GA17666@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfsprogs: update CHANGES
Date: Fri, 28 Aug 2009 17:49:22 -0500
References: <20090828221304.GA17666@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Aug 28, 2009, at 5:13 PM, Christoph Hellwig wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

I'll generate the 3.0.3 package later tonight.
Are we planning on update of other xfs userland pieces at this
time as well?

Felix

>
>
> Index: xfsprogs-dev/doc/CHANGES
> ===================================================================
> --- xfsprogs-dev.orig/doc/CHANGES	2009-08-28 18:55:43.439981605 -0300
> +++ xfsprogs-dev/doc/CHANGES	2009-08-28 19:11:00.795912101 -0300
> @@ -1,5 +1,11 @@
> -	- Fix xfs_io and xfs_quota when readline config enabled.
> +xfsprogs-3.0.3
> +	- Fix unaligned accesses in libxfs.
> +	- Various small fixes to xfs_db, xfs_repair and xfs_io.
> 	- Add fallocate command to xfs_io.
> +	- Enable readline support in xfs_io and xfs_quota.
> +	- Allow log sizes up to 2GiB (minus 1 byte) in xfs_mkfs.
> +	- Open the block device in xfs_repair exclusively, thanks to
> +	  Nathaniel W. Turner.
>
> xfsprogs-3.0.2 (6 May 2009)
> 	- Updates to Debian build process after recent autoconf tweaks.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
