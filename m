Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q835bMLI148284 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 00:37:22 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EQzhZMZIZUmcArSD for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 22:38:18 -0700 (PDT)
Date: Mon, 3 Sep 2012 15:38:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] dmapi: Use installed libraries only
Message-ID: <20120903053812.GX15292@dastard>
References: <20120828172605.607853317@sgi.com>
	<20120828172929.413312035@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120828172929.413312035@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 28, 2012 at 12:26:09PM -0500, Rich Johnston wrote:
> If a local library was found and not installed, libtool will create a wrapper
> script to call the binary from the .libs directory.  This patch will remove
> searching for local libraies so that the installed libraries are always used.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
