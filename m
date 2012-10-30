Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UI19nN062503 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 13:01:09 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	IN4UqJ9kfUeGHWgS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 11:02:55 -0700 (PDT)
Date: Tue, 30 Oct 2012 08:23:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/25] xfs: add write verifiers to log recovery
Message-ID: <20121030122331.GB30039@infradead.org>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-26-git-send-email-david@fromorbit.com>
	<20121026085448.GD3035@infradead.org>
	<20121026203107.GJ29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121026203107.GJ29378@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> Remote attr buffers aren't logged - they are written sycnhronously
> during the transaction - so won't get found by this.

Oh right.  Removing the synchronous writes for the remote attrs is
someting we should tackled on day as well.

> As for remote
> symlink buffers, yeah, that might be a problem. Ultimately, both of
> these buffer types are going to grow headers for CRCs, so this
> problem will go away. I'm not sure how to address this problem
> in the mean time short of putting the buffer content type into all
> the buf_log_format headers. Do you have any better ideas?

I can't think of a really good idea.  But introducing user exploitable
issues in log recovery is something I'd avoid.  I also hate having to
change the log format now if we're going to bump it soon again.  Let
me look a bit more at the log recovery code if there's some way to
interfer the buffer type.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
