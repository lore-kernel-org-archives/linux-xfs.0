Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07BE6802D
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 16:04:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DCDDC304062
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 14:04:03 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oYHaNyCnaAJIvfrG for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2015 14:04:01 -0800 (PST)
Date: Wed, 4 Feb 2015 08:58:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/5] xfs: use generic percpu counters for icsb
Message-ID: <20150203215850.GK4251@dastard>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<20150203215043.GA21885@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150203215043.GA21885@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Feb 03, 2015 at 01:50:43PM -0800, Christoph Hellwig wrote:
> FYI, I think we should just get rid of the horrible xfs_mod_incore_sb(_batch)
> interface as part of this.  The patch below applies on top of your
> series.

I like it - getting rid of those field bitmasks altogether is a
great result.

It probably needs to be split up into several patches, though. I can
do that over the next few days and add it to the patchset if you
want.  The icsb changes are 3.21 material, anyway, so there's no
real hurry on this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
