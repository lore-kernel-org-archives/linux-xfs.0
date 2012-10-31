Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VAIZB8163945 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 05:18:35 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JY37W7TZBAIF2lQs (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 31 Oct 2012 03:20:25 -0700 (PDT)
Date: Wed, 31 Oct 2012 06:20:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/25] xfs: add buffer pre-write callback
Message-ID: <20121031102024.GB29769@infradead.org>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-22-git-send-email-david@fromorbit.com>
	<20121026085014.GC3035@infradead.org>
	<20121030223015.GE29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030223015.GE29378@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 31, 2012 at 09:30:15AM +1100, Dave Chinner wrote:
> Perhaps. I just wrote it in a manner consistent with the iodone
> function where errors are returned in bp->b_error. Other functions
> pass buffer errors like this, too - xfs_buf_ioapply_map(),
> xfs_buf_read_map(), and _xfs_buf_ioapply() - so it's not unusual,
> really..
> 
> I can change it, but that involves changing every callback function
> as well and I don't see that as really necessary. i.e. they call
> xfs_buf_ioerror() already, so do we really need to have them return
> bp->b_error as well?

Let's keep it as is for now to make forward progress, we can still
figure out later if doing it differently is cleaner.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
