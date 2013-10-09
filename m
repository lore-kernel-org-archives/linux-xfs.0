Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 213D67F7C
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 16:42:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF3A2304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 14:42:44 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3kUiE7Tms7Hc84fD for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 14:42:43 -0700 (PDT)
Date: Thu, 10 Oct 2013 08:42:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add filter to 200 accommodate changed mount
	output
Message-ID: <20131009214241.GM4446@dastard>
References: <5251D5E1.3020202@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5251D5E1.3020202@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Oct 06, 2013 at 04:28:01PM -0500, Eric Sandeen wrote:
> The mount binary changed its output w.r.t. red-only devices, and
> stopped referring to a "block device."
> 
> This broke at least test xfs/200; add a common filter to remove
> the "block device" from older mount binary output, and change
> the 200.out file to match.

Looks good. xfs/200 is the only test I can see that dumps this
output to it's golden image.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
