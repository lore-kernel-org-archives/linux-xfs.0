Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F20087F54
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 04:48:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D52EF8F8040
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 02:48:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id KLjaf88doFhbd45f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 05 Jul 2014 02:48:08 -0700 (PDT)
Date: Sat, 5 Jul 2014 02:48:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] libxfs: reused invalidated buffers leak state and data
Message-ID: <20140705094807.GB18130@infradead.org>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
	<1404453435-1915-5-git-send-email-david@fromorbit.com>
	<20140704141509.GB29520@infradead.org>
	<20140704222210.GM9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140704222210.GM9508@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Jul 05, 2014 at 08:22:10AM +1000, Dave Chinner wrote:
> I'm open to other ways of fixing this, but right now we've got to
> fix xfs_repair because it's currently breaking filesystems worse
> than before xfs_repair was run...

Ok, so clearly mark this as difference from kernel code in a long
comment explaining the situation similar to wrote you above.  It's
pretty obvious that the buffer cache in userspace will eventually need
a major overhaul sooner or later.  I wonder how feasible porting the
kernel one would be..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
