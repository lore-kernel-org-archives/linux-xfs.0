Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6nn28036746 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:49:49 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E0FF1388855
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:52:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	A8R1m6S9f87TT8zl for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:52:21 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:49:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: reject emptry suboption arguments
Message-ID: <20110822064945.GR3162@dastard>
References: <20110815182415.GA30466@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110815182415.GA30466@infradead.org>
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
Cc: Chris Pearson <kermit4@gmail.com>, xfs@oss.sgi.com

On Mon, Aug 15, 2011 at 02:24:15PM -0400, Christoph Hellwig wrote:
> We require the argument to suboptions to not only exist, but also contain
> a non-empty string, as cvtnum can't handle empty strings properly.  Also add
> the missing argument check to the -l agnum suboption which was lacking it.
> 
> Reported-by: Chris Pearson <kermit4@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
