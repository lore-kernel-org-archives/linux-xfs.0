Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0769LEg247586 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 00:09:21 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78DA71D00837
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 22:11:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	foiVeSpIOdTZLKos for <xfs@oss.sgi.com>;
	Thu, 06 Jan 2011 22:11:28 -0800 (PST)
Date: Fri, 7 Jan 2011 17:11:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: errors on sync superblock writes leave it locked
Message-ID: <20110107061125.GI8322@dastard>
References: <1294116609-15138-1-git-send-email-david@fromorbit.com>
	<20110104094336.GA19193@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110104094336.GA19193@infradead.org>
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

On Tue, Jan 04, 2011 at 04:43:36AM -0500, Christoph Hellwig wrote:
> I don't think the patch is quite correct.  In the old code xfs_buf_rele
> incremented the buffer reference count before calling ->b_relse,
> expecting it do decrement it again.
> 
> I think the best fix is to kill ->b_relse entirely.  We can simply
> do the buffer callback processing and b_flags updates in
> xfs_buf_iodone_callbacks.  The important thing is to not clear the
> buffer error there, so that it actually get propagated to the caller.
> As the buffer remains locked until xfs_bwrite calls xfs_buf_relse it
> can get the error reliably that way.
> 
> Patch below, but it's still running xfqa so far:

Looks sane. can i get a signed-off-by for it from you and I'll
include it in my remaining -for-2.6.38 series?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
