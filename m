Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NCMwf8044296 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 07:22:59 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	53rDN0ba3DVEaUOq (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Oct 2012 05:24:41 -0700 (PDT)
Date: Tue, 23 Oct 2012 08:24:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests 250 fail on newer kernels
Message-ID: <20121023122440.GC7341@infradead.org>
References: <20121019173730.GA23018@andromeda.usersys.redhat.com>
	<20121019215343.GX2739@dastard>
	<20121020112405.GA652@andromeda.usersys.redhat.com>
	<20121021223158.GA2739@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121021223158.GA2739@dastard>
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

On Mon, Oct 22, 2012 at 09:31:58AM +1100, Dave Chinner wrote:
> You can - the simplest thing to do might be just to fix the log size
> for the mkfs command to 15MB (i.e. smaller than the AG size) so that
> mkfs doesn't use all the space in the AG...

I'd love to still have another test for the mkfs issue, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
