Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B18C129DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 22:17:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41886AC004
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:17:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Bl55BNueHcgVYlUR for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 20:17:36 -0800 (PST)
Date: Thu, 27 Feb 2014 15:17:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: add helper for verifying checksums on xfs_bufs
Message-ID: <20140227041722.GG29907@dastard>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-6-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392767549-25574-6-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 18, 2014 at 05:52:25PM -0600, Eric Sandeen wrote:
> Many/most callers of xfs_verify_cksum() pass bp->b_addr and
> BBTOB(bp->b_length) as the first 2 args.  Add a helper
> which can just accept the bp and the crc offset, and work
> it out on its own, for brevity.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
