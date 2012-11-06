Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6MTUDq095015 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 16:29:30 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JWTP06vmOgeoGx1q for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 14:31:26 -0800 (PST)
Date: Wed, 7 Nov 2012 09:30:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 10/10] xfs: add background scanning to clear eofblocks
	inodes
Message-ID: <20121106223024.GK24575@dastard>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-11-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352213447-59791-11-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 06, 2012 at 09:50:47AM -0500, Brian Foster wrote:
> Create a new mount workqueue and delayed_work to enable background
> scanning and freeing of eofblocks inodes. The scanner kicks in once
> speculative preallocation occurs and stops requeueing itself when
> no eofblocks inodes exist.
> 
> The scan interval is based on the new
> 'speculative_prealloc_lifetime' tunable (default to 5m). The
> background scanner performs unfiltered, best effort scans (which
> skips inodes under lock contention or with a dirty cache mapping).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
