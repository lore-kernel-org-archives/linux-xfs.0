Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5BNJT0I176456 for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 18:19:30 -0500
Date: Thu, 11 Jun 2009 19:19:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix freeing memory in xfs_getbmap()
Message-ID: <20090611231948.GA27620@infradead.org>
References: <1244758585-18141-1-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1244758585-18141-1-git-send-email-felixb@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Hedi Berriche <hedi@sgi.com>, xfs@oss.sgi.com

On Thu, Jun 11, 2009 at 05:16:25PM -0500, Felix Blyakher wrote:
> Regression from commit 28e211700a81b0a934b6c7a4b8e7dda843634d2f.
> Need to free temporary buffer allocated in xfs_getbmap().

Defintively need to free it.  Not sure where it got lost from my initial
patch to the one that got merged, sorry.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
