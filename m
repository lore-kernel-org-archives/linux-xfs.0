Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2FM75xf201430 for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 17:07:05 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ynQSyS9briLsPEUB for <xfs@oss.sgi.com>;
	Thu, 15 Mar 2012 15:07:03 -0700 (PDT)
Date: Fri, 16 Mar 2012 09:07:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Fix oops on IO error during
	xlog_recover_process_iunlinks()
Message-ID: <20120315220701.GN5091@dastard>
References: <1331801705-1145-1-git-send-email-jack@suse.cz>
	<20120315090800.GA2887@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120315090800.GA2887@infradead.org>
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
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, stable@kernel.org, xfs@oss.sgi.com

On Thu, Mar 15, 2012 at 05:08:00AM -0400, Christoph Hellwig wrote:
> > +		xfs_buf_hold(agibp);
> > +		xfs_buf_relse(agibp);
> 
> This is a very awkward way to write
> 
> 		xfs_buf_unlock(agibp);

/me slaps forehead.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
