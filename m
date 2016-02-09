Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A22887CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 01:51:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74C49304048
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 23:51:30 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7KBgWhhGIiEjuwtx for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 23:51:28 -0800 (PST)
Date: Tue, 9 Feb 2016 18:37:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/23] dio unwritten conversion bug tests
Message-ID: <20160209073732.GJ19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011223.23099.3987.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209011223.23099.3987.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 05:12:23PM -0800, Darrick J. Wong wrote:
> Check that we don't expose old disk contents when a directio write to
> an unwritten extent fails due to IO errors.  This primarily affects
> XFS and ext4.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -252,7 +252,9 @@
>  247 auto quick rw
>  248 auto quick rw
>  249 auto quick rw
> +250 auto quick
>  251 ioctl trim
> +252 auto quick

Also should be in the prealloc group if we are testing unwritten
extent behaviour and the rw group because it's testing IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
