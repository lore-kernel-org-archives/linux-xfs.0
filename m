Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6eXSj036282 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:40:33 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6526413887F3
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:43:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	afxCQPL3yuYJcgs2 for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:43:05 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:40:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: defer AIO/DIO completions
Message-ID: <20110822064028.GL3162@dastard>
References: <20110814222412.359079843@bombadil.infradead.org>
	<20110814222517.807217901@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814222517.807217901@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Sun, Aug 14, 2011 at 06:24:14PM -0400, Christoph Hellwig wrote:
> We really shouldn't complete AIO or DIO requests until we have finished
> the unwritten extent conversion and size update.  This means fsync never
> has to pick up any ioends as all work has been completed when signalling
> I/O completion.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I don't really like the field abuse. pahole tells me:

struct xfs_ioend {
        struct xfs_ioend *         io_list;              /*     0     8 */
        unsigned int               io_type;              /*     8     4 */
        int                        io_error;             /*    12     4 */
        atomic_t                   io_remaining;         /*    16     4 */

        /* XXX 4 bytes hole, try to pack */

        struct inode *             io_inode;             /*    24     8 */
        struct buffer_head *       io_buffer_head;       /*    32     8 */
        struct buffer_head *       io_buffer_tail;       /*    40     8 */
        size_t                     io_size;              /*    48     8 */
        xfs_off_t                  io_offset;            /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct work_struct         io_work;              /*    64    32 */
        struct kiocb *             io_iocb;              /*    96     8 */
        int                        io_result;            /*   104     4 */

There's a 4 byte hole in the xfs_ioend structure where you could put
a flags field to communicate this and not grow the structure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
