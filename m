Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 72C3C7F50
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 15:28:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8F54AC002
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 13:28:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	r4s9T1MIMWUBzEzG for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 13:28:18 -0800 (PST)
Date: Wed, 4 Dec 2013 08:28:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: fix calculation of freed inode cluster blocks
Message-ID: <20131203212814.GW10988@dastard>
References: <20131203210054.GN1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203210054.GN1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 03, 2013 at 03:00:54PM -0600, Ben Myers wrote:
> rec.ir_startino is an agino rather than an ino.  Use the correct macro
> when dealing with it in xfs_difree.
> 
> ---
> 
> This is very lightly tested so it's RFC.  Looks like using "ino to
> agbno" is actually harmless when you pass in an agino, so there
> shouldn't have been any trouble caused by this one.

Right, the XFS_INO_TO_AGBNO() macro will behave correctly when
passed an agino - it's the same as an inode from AG 0. Changing the
macro to the correct one is effectively a no-op, so just send a
patch and get it reviewed and integrated...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
