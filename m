Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J0UqRR141895 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 19:30:53 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B4E1F7C931
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 17:38:48 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vJh9N4FOlL2cqOTt for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 17:38:48 -0700 (PDT)
Date: Wed, 19 Oct 2011 11:30:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: make i_flags and unsigned long
Message-ID: <20111019003047.GA21338@dastard>
References: <20111018201304.279051318@bombadil.infradead.org>
	<20111018201405.168458311@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111018201405.168458311@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Oct 18, 2011 at 04:13:05PM -0400, Christoph Hellwig wrote:
> To be used for bit wakeup i_flags needs to be an unsigned long or we'll
> run into trouble on big endian systems.  Beause of the 1-byte i_update
> field right after it this actually causes a fairly large size increase
> on it's own (4 or 7 bytes), but that increase will be more than offset
> by the next two patches.

You could always make the i_update_core boolean a flag bit, and that
growth will also go away. Regardless:

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
