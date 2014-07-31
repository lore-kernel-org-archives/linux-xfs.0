Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 10C347F93
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 12:13:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 928CFAC003
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 10:13:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id lpIRIcjDvpuys4oZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 10:13:03 -0700 (PDT)
Date: Thu, 31 Jul 2014 10:13:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: kill VN_DIRTY()
Message-ID: <20140731171302.GA22173@infradead.org>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406791995-14723-4-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 31, 2014 at 05:33:12PM +1000, Dave Chinner wrote:
> -			if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0) {
> +			if (mapping_tagged(VFS_I(ip)->i_mapping,
> +					   PAGECACHE_TAG_DIRTY) &&
> +			    ip->i_delayed_blks > 0) {
>  				error = filemap_flush(VFS_I(ip)->i_mapping);

I don't think there's even any point in keeping the mapping_tagged
check.  filemap_flush handles the case where nothing is to flush
internally, and no other callers others with things like this either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
