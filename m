Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32KdmHd006292 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 15:39:48 -0500
Message-ID: <4F7A0E91.8070103@sgi.com>
Date: Mon, 02 Apr 2012 15:39:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs: push the ilock into xfs_zero_eof
References: <20120327143445.196524266@bombadil.infradead.org>
	<20120327143826.792184421@bombadil.infradead.org>
In-Reply-To: <20120327143826.792184421@bombadil.infradead.org>
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

On 03/27/12 09:34, Christoph Hellwig wrote:
> Instead of calling xfs_zero_eof with the ilock held only take it internally
> for the minimall required critical section around xfs_bmapi_read.  This
> also requires changing the calling convention for xfs_zero_last_block
> slightly.  The actual zeroing operation is still serialized by the iolock,
> which must be taken exclusively over the call to xfs_zero_eof.
>
> We could in fact use a shared lock for the xfs_bmapi_read calls as long as
> the extent list has been read in, but given that we already hold the iolock
> exclusively there is little reason to micro optimize this further.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
