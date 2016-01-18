Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 526D17F37
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 12:16:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42A3B8F8035
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 10:16:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id vSpDaNmIqft5p16Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jan 2016 10:15:59 -0800 (PST)
Date: Mon, 18 Jan 2016 10:15:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/35 v3] eparate operations from flags in the
	bio/request structs
Message-ID: <20160118181547.GA30789@infradead.org>
References: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
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
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

The whole sries looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

There are a few pieces of future work on top of this I'd rather see
sooner than later though:

 - use REQ_OP_FLUSH for all empty flushes, including those at the bio
   level.
 - merge the req->cmd_type values into req->op.  Right now that's
   basically only a new REQ_OP_BLOCK_PC (or better REQ_OP_SCSI while
   we're at it) and a REQ_OP_DRV_PRIV as the last value.
 - drop as many of the crazy defines based on REQ_* in fs.h (e.g.
   (READ_SYNC, WRITE_SYNC, WRITE_ODIRECT, WRITE_FLUSH, WRITE_FUA,
   WRITE_FLUSH_FUA, RW_MASK, RWA_MASK)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
