Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F2HWjZ066688 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 21:17:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFE883C7A22
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 19:20:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	ESQ9ye9B5L5evERr for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 19:20:07 -0700 (PDT)
Date: Tue, 15 Jun 2010 12:19:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: new truncate sequence
Message-ID: <20100615021944.GQ6590@dastard>
References: <20100614091731.GA22088@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100614091731.GA22088@infradead.org>
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
Cc: npiggin@suse.de, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Mon, Jun 14, 2010 at 05:17:31AM -0400, Christoph Hellwig wrote:
> Convert XFS to the new truncate sequence.  We still can have errors after
> updating the file size in xfs_setattr, but these are real I/O errors and lead
> to a transaction abort and filesystem shutdown, so they are not an issue.
> 
> Errors from ->write_begin and write_end can now be handled correctly because
> we can actually get rid of the delalloc extents while previous the buffer
> state was stipped in block_invalidatepage.
> 
> There is still no error handling for ->direct_IO, because doing so will need
> some major restructuring given that we only have the iolock shared and do not
> hold i_mutex at all.  Fortunately leaving the normally allocated blocks behind
> there is not a major issue and this will get cleaned up by xfs_free_eofblock
> later.
> 
> Note: the patch is against Al's vfs.git tree as that contains the nessecary
> preparations.  I'd prefer to get it applied there so that we can get some
> testing in linux-next.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It looks sane, but I haven't done any testing on it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
