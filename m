Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F1Io8O064779 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 20:18:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3C77AE0442
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 18:24:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	x81nzgWzDalodI3a for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 18:24:55 -0700 (PDT)
Date: Tue, 15 Jun 2010 11:21:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: fix corruption case for block size < page size
Message-ID: <20100615012114.GM6590@dastard>
References: <20100611161312.446670249@bombadil.infradead.org>
	<20100611161510.303551652@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100611161510.303551652@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Jun 11, 2010 at 12:13:13PM -0400, Christoph Hellwig wrote:
> From: Eric Sandeen <sandeen@sandeen.net>                                        
> 
> xfstests 194 first truncats a file back and then extends it again by
> truncating it to a larger size.  This causes discard_buffer to drop
> the mapped, but not the uptodate bit and thus creates something that
> xfs_page_state_convert takes for unmapped space created by mmap because
> it doesn't check for the dirty bit, which also gets cleared by
> discard_buffer and checked by other ->writepage implementations like
> block_write_full_page.  Handle this kind of buffers early, and unlike
> Eric's first version of the patch simply ASSERT that the buffers is
> dirty, given that the mmap write case can't happen anymore since the
> introduction of ->page_mkwrite.  The now dead code dealing with that
> will be deleted in a follow on patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
