Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 681B37FEF
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 14:51:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B41930405F
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 12:51:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 0oLQQczygozwJ08P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 12:51:08 -0800 (PST)
Date: Thu, 7 Nov 2013 12:51:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 19/37] libxfs: refactor libxfs_buf_read_map for xfs_db
Message-ID: <20131107205108.GB23118@infradead.org>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-20-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383700043-32305-20-git-send-email-david@fromorbit.com>
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

On Wed, Nov 06, 2013 at 12:07:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_db requires low level read/write buffer primitives that are the
> equivalent of libxfs_readbufr/writebufr. The implementation of
> libxfs_writebufr already handles discontiguous buffers, but there is
> no equivalent libxfs_readbufr_map support in the code.
> 
> Refactor libxfs_readbuf_map into two parts - one that does the
> buffer cache lookup, and the other that does the read IO. This
> provides the implementation of libxfs_readbufr_map that is required
> for xfs_db.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
