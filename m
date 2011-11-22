Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM0NAVg028367 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 18:23:11 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C12601278EBC
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:23:09 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JZl3dYSPS5rpXvQa for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 16:23:09 -0800 (PST)
Date: Tue, 22 Nov 2011 11:23:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair is recommended over xfs_check.
Message-ID: <20111122002306.GI2386@dastard>
References: <4ECAC84C.1070000@sauce.co.nz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ECAC84C.1070000@sauce.co.nz>
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
To: Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 10:53:16AM +1300, Richard Scobie wrote:
> Is there currently now any situation where xfs_check would be used
> in preference to xfs_repair?
> 
> If not, perhaps xfs_check could be deprecated.

xfs_check is one of the ways we test that xfs_repair is doing the
right thing. Having two implementation that you can use to compare
results is a good thing.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
