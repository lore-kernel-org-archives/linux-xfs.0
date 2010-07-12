Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6CG1uuu037184 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 11:01:56 -0500
Date: Mon, 12 Jul 2010 12:04:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove incorrect log write optimization
Message-ID: <20100712160450.GA2666@infradead.org>
References: <20100628143434.GA5473@infradead.org>
	<1278905400.7456.14.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1278905400.7456.14.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Jul 11, 2010 at 10:30:00PM -0500, Alex Elder wrote:
> On Mon, 2010-06-28 at 10:34 -0400, Christoph Hellwig wrote:
> > We do need a barrier for the first buffer of a split log write.  Otherwise
> > we might incorrectly stamp the tail LSN into transactions in the first
> > block, or not flush data I/O before updating the inode size.
> 
> I'm not sure whether "first block" means the one at the beginning
> of the log, or the one at the beginning of a split log write.

It means beginning of the split write.  I can fix up the commit message
if you want.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
