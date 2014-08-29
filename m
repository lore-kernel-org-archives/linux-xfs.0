Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40C1E7F5E
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:37:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17EE9304048
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:37:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 19htLgakKYEbPmuL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:37:56 -0700 (PDT)
Date: Thu, 28 Aug 2014 17:37:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: check xfs_buf_read_uncached returns correctly
Message-ID: <20140829003756.GG17502@infradead.org>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-10-git-send-email-david@fromorbit.com>
	<20140815125608.GA27856@infradead.org>
	<20140815235843.GA26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815235843.GA26465@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Aug 16, 2014 at 09:58:43AM +1000, Dave Chinner wrote:
> > I'd rather get rid of these annoying calling conventions.  Make it
> > return and errno, and the bp in a pointer argument, with the bp
> > never non-NULL in case of error.
> 
> Ok. I considered that, then just did the simple thing.

There's only about a dozen callers of all xfs_buf_read* variants, so
I think switching them over to return an errno shouldn't be much of a
problem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
