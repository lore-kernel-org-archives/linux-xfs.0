Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VAHnSw163849 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 05:17:49 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qf9O9Iex15bTQJm7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 31 Oct 2012 03:19:38 -0700 (PDT)
Date: Wed, 31 Oct 2012 06:19:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/25] xfs: add write verifiers to log recovery
Message-ID: <20121031101937.GA29769@infradead.org>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-26-git-send-email-david@fromorbit.com>
	<20121026085448.GD3035@infradead.org>
	<20121026203107.GJ29378@dastard>
	<20121030122331.GB30039@infradead.org>
	<20121030220855.GA29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030220855.GA29378@dastard>
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

On Wed, Oct 31, 2012 at 09:08:55AM +1100, Dave Chinner wrote:
> I couldn't find any short of magic number matches. The ones that can
> be inferred (inode and dquot buffers) are done that way, but for
> everything else they are anonymous buffers being recovered. I might
> just drop this patch for now, and only re-introduce it for CRC
> enabled filesystems when that is added.

I fear that's the only reasonable way to go.  Otoh we were planning
to bump the log version at some point anyway, at which point we could
enable the new log formats even without CRCs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
