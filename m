Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NCX3ep046254 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 07:33:03 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pdLVRS6QtJC47OHJ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Oct 2012 05:34:46 -0700 (PDT)
Date: Tue, 23 Oct 2012 08:34:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_quota: XFS_XFLAG_PROJINHERIT is only for dirs
Message-ID: <20121023123444.GI7341@infradead.org>
References: <5078432B.6050501@redhat.com>
	<20121013155205.GA11037@infradead.org>
	<20121013233431.GQ2739@dastard> <507A01DF.1070105@redhat.com>
	<20121014001412.GS2739@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121014001412.GS2739@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>, nscott@redhat.com

On Sun, Oct 14, 2012 at 11:14:12AM +1100, Dave Chinner wrote:
> Sorry, I wasn't particularly clear - if your patch to quota goes in,
> the problem goes away in future and we should simply filter the
> warning in xfstests to handle the present issue....

I'd suggest to stil clear it but not warn.  It's something that is a)
harmless and b) could be set in normal operation for a long time.  Just
clear it silently and add a comment.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
