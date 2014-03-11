Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6627B7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 17:51:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55C70304059
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 15:51:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GtjsLiCfzDPnW4f2 for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2014 15:51:47 -0700 (PDT)
Date: Wed, 12 Mar 2014 09:51:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: hide debug bbmap output
Message-ID: <20140311225142.GC6851@dastard>
References: <531F33F4.40707@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531F33F4.40707@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 11, 2014 at 11:04:04AM -0500, Eric Sandeen wrote:
> Most of xfsprogs building with DEBUG enables extra
> checks, asserts, etc, but this bunch of printfs was
> extra output that's not generally helpful for most
> people's runtime experience - and it breaks xfs/290
> with all the noise.
> 
> I assume it's for actual debugging use, and not
> generally useful, so bury it a bit deeper under
> it's own #ifdef.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Just remove it, I think. It doesn't serve any real purpose anymore,
and changing it to an obscure ifdef guarantees it'll never get used
again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
