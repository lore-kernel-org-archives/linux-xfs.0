Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6DJnrVB105280 for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 14:49:53 -0500
Subject: Re: [PATCH] xfs: remove incorrect log write optimization
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100712160450.GA2666@infradead.org>
References: <20100628143434.GA5473@infradead.org>
	<1278905400.7456.14.camel@doink> <20100712160450.GA2666@infradead.org>
Date: Tue, 13 Jul 2010 14:52:45 -0500
Message-ID: <1279050765.1963.28.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Mon, 2010-07-12 at 12:04 -0400, Christoph Hellwig wrote:
> On Sun, Jul 11, 2010 at 10:30:00PM -0500, Alex Elder wrote:
> > On Mon, 2010-06-28 at 10:34 -0400, Christoph Hellwig wrote:
> > > We do need a barrier for the first buffer of a split log write.  Otherwise
> > > we might incorrectly stamp the tail LSN into transactions in the first
> > > block, or not flush data I/O before updating the inode size.
> > 
> > I'm not sure whether "first block" means the one at the beginning
> > of the log, or the one at the beginning of a split log write.
> 
> It means beginning of the split write.  I can fix up the commit message
> if you want.
> 

Don't bother, I will change it to:

We do need a barrier for the first buffer of a split log write.
Otherwise we might incorrectly stamp the tail LSN into transactions
in the first part of the split write, or not flush data I/O before
updating the inode size.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
