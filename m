Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KNQO1r072737 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 18:26:25 -0500
Received: from mail2.shareable.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F21CC148D786
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 16:28:23 -0700 (PDT)
Received: from mail2.shareable.org (mail2.shareable.org [80.68.89.115]) by
	cuda.sgi.com with ESMTP id fMjehY4HKCXM1Yk8 for
	<xfs@oss.sgi.com>; Tue, 20 Apr 2010 16:28:23 -0700 (PDT)
Date: Wed, 21 Apr 2010 00:28:19 +0100
From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 5/4] writeback: limit write_cache_pages integrity scanning
	to current EOF
Message-ID: <20100420232819.GR11723@shareable.org>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<20100420034005.GA15130@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100420034005.GA15130@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner wrote:
> sync can currently take a really long time if a concurrent writer is
> extending a file. The problem is that the dirty pages on the address
> space grow in the same direction as write_cache_pages scans, so if
> the writer keeps ahead of writeback, the writeback will not
> terminate until the writer stops adding dirty pages.
> 
> For a data integrity sync, we only need to write the pages dirty at
> the time we start the writeback, so we can stop scanning once we get
> to the page that was at the end of the file at the time the scan
> started.
> 
> This will prevent operations like copying a large file preventing
> sync from completing as it will not write back pages that were
> dirtied after the sync was started. This does not impact the
> existing integrity guarantees, as any dirty page (old or new)
> within the EOF range at the start of the scan will still be
> captured.

I guess it can still get stuck if someone does ftruncate() first, then
writes to the hole?

-- Jamie

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
