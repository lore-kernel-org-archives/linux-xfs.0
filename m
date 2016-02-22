Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 804C37CB2
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 07:39:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 402F3304089
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 05:39:51 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id xgf0zuq8EDD59u60 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 05:39:45 -0800 (PST)
Date: Mon, 22 Feb 2016 14:39:43 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: better xfs_trans_alloc interface
Message-ID: <20160222133943.GA26966@lst.de>
References: <1455699159-20906-1-git-send-email-hch@lst.de>
	<1455699159-20906-2-git-send-email-hch@lst.de>
	<20160217134006.GA4065@bfoster.bfoster>
	<20160217220436.GI19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217220436.GI19486@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Feb 18, 2016 at 09:04:36AM +1100, Dave Chinner wrote:
> I've considered doing this removal myself in the past - doing
> somethign like embedding the return address of the
> xfs-trans_reserve() call in the ticket that is allocated tells us
> exactly where the call was made. This can be printed with %pS, and
> that gives us the function (and location in the function) the
> reservation was made. Hence we solve the problem of not
> knowing which call path triggered the problem.
> 
> Hence I don't think we actually need to the type in every function
> call.

This brings up a question:  do we care about the type of the transaction,
or the caller?  The existing types were rather confused about that.
If it's the transaction type we could simply add a name field to
struct xfs_trans_res, if we care about caller the trick from Dave
should do the job.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
