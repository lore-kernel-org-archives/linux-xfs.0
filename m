Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2PBS96T077734 for <xfs@oss.sgi.com>; Sun, 25 Mar 2012 06:28:11 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VYuv7yO15ESVjbOl (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 Mar 2012 04:28:04 -0700 (PDT)
Date: Sun, 25 Mar 2012 07:28:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: avoid shutdown hang in xlog_wait()
Message-ID: <20120325112801.GA7157@infradead.org>
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
	<1332467263-12985-3-git-send-email-david@fromorbit.com>
	<20120324170302.GB21708@infradead.org>
	<20120324224648.GF5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120324224648.GF5091@dastard>
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

On Sun, Mar 25, 2012 at 09:46:49AM +1100, Dave Chinner wrote:
> > Looks good.  I wonder if it might be simple to simply pass a flags
> > argument to xfs_ail_delete(_bulk) which tells which kind of shutdown
> > to do.
> 
> I thought about doing that, but it seems strange and unusual to tell
> code how to handle errors internally instead of returning the error
> and letting the caller handle it...
> 
> I don't mind either way, though. If you prefer I pass in the
> shutdown flag, I can change it all to do that....

I don't have a strong opinion.  Moving the shutdown to the caller is
cleaner for sure, but it's a lot of churn when the other version would

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
