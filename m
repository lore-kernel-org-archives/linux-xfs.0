Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALAAHYQ031557 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 04:10:18 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SJaaRT9OSyAsHG1I (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 02:12:28 -0800 (PST)
Date: Wed, 21 Nov 2012 05:12:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/32] xfs: remove xfs_flushinval_pages
Message-ID: <20121121101227.GG23339@infradead.org>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-6-git-send-email-david@fromorbit.com>
	<20121115162807.GE4019@infradead.org>
	<20121115205427.GH14281@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121115205427.GH14281@dastard>
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

On Fri, Nov 16, 2012 at 07:54:27AM +1100, Dave Chinner wrote:
> Yes, I know, but the original patch I had that changed the ranges to
> something sensible was causing fsx and other failures all over the
> place. It appears that setting the ranges appropriately here exposes
> other (worse) bugs, so I decided to leave doing that until I have
> time to go on a wild goose chase....

I'm actually very happy with doing it separately, I just really prefer
comments to be put in place on why it's done the way it is in case we
forget about it again, which history has shown to happen way too often.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
