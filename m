Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 86A407F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 20:56:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21977AC001
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 18:56:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	u5pHYRkbYiKxhl0o for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 18:56:04 -0700 (PDT)
Date: Tue, 9 Sep 2014 11:56:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/2] xfs log recovery delay instrumentation
Message-ID: <20140909015601.GV30012@dastard>
References: <1409666895-49799-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409666895-49799-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 02, 2014 at 10:08:13AM -0400, Brian Foster wrote:
> Here's v2 of the log recovery delay instrumentation set. v1 is available
> here:
> 
> http://oss.sgi.com/archives/xfs/2014-08/msg00276.html
> 
> After a brief conversation with Dave, we thought it best to tie in this
> functionality with DEBUG mode to express/ensure that these attributes
> are for debugging/hacking purposes only. Everything else should be
> equivalent to v1.
> 
> Brian
> 
> v2:
> - Enable /sys/fs/xfs/debug for DEBUG mode kernels only.
> v1: http://oss.sgi.com/archives/xfs/2014-08/msg00276.html
> 
> Brian Foster (2):
>   xfs: add debug sysfs attribute set
>   xfs: export log_recovery_delay to delay mount time log recovery

These look good. I'm sure that as we add more attributes there will
be opportunity for factoring/streamlining this code more, but right
now I don't think that is necessary.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
