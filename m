Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C51AF7CA4
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 16:56:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3590CAC003
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:56:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Dl2V0mt6gAGZEahV for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2016 14:55:57 -0700 (PDT)
Date: Thu, 14 Apr 2016 07:55:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RFC: use iomap infrastructure for all our zeroing needs
Message-ID: <20160413215556.GT567@dastard>
References: <1460500013-28334-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460500013-28334-1-git-send-email-hch@lst.de>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 03:26:47PM -0700, Christoph Hellwig wrote:
> This series uses the new iomap infrastructure to simplify all kinds
> of zeroing operations.  The RFC tag is mostly because the DAX path
> modified in this series hasn't been tested yet, the normal buffered
> path has been tested and works fine.

Yep, passes all my testing for normal FS paths, though I haven't run
DAX on it yet, either. I'll look to include this at teh same time as
the map iomap write/fiemap series.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
