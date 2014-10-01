Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 75CAE7F6F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 17:27:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62A9D304032
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 15:27:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	53VzFxl1s6uY1Fe3 for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 15:27:14 -0700 (PDT)
Date: Thu, 2 Oct 2014 08:26:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: preadv2/pwritev2 updates
Message-ID: <20141001222637.GU4758@dastard>
References: <1412197494-7655-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1412197494-7655-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Milosz Tanski <milosz@adfin.com>, xfs@oss.sgi.com

On Wed, Oct 01, 2014 at 11:04:51PM +0200, Christoph Hellwig wrote:
> Hi Miklos,
> 
> attached are the patches that go on top of your
> "[RFC v3 0/4] vfs: Non-blockling buffered fs read (page cache only)"
> series.  The first one adds RWF_NONBLOCK to XFS, the other two
> add a new RWF_DSYNC flag that adds a per-operation O_DSYNC flag.

Christoph, any plans to add these new syscalls to xfs_io and
data integrity tests for the new RWF_DSYNC flag?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
