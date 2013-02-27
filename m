Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A0CDC7F50
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 17:04:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8EFA330406B
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 15:04:48 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	x61iusf8F7PnndUc for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 15:04:46 -0800 (PST)
Date: Thu, 28 Feb 2013 10:04:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
Message-ID: <20130227230443.GB5551@dastard>
References: <512DB284.1090806@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <512DB284.1090806@gmail.com>
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
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: list.btrfs@jan-o-sch.net, linux-btrfs@vger.kernel.org, xfstests <xfs@oss.sgi.com>

On Wed, Feb 27, 2013 at 03:15:16PM +0800, Wang Sheng-Hui wrote:
> Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by
> -x option of filefrag, and will fail with
> 	'FIBMAP: Invalid argument'
> for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
>     'FIEMAP failed with unsupported flags 2'
> Remove the '-x' option.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

I can see that this changes what gets dumped into the $seq.full
file, but it seems to me that also changes the extent list returned
to the checking functions. So either the test previously worked and
now it fails with this change, or the test never worked and now it
does, or perhaps something else?

IOWs, I can't tell why you want to change this from the patch
description, hence I don't know if the original behaviour was
intentional or not.  Can you say describe what the overall effect of
the change is in the commit description?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
