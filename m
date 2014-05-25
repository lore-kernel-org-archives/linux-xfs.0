Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24DE77F50
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 18:37:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0DE2AC001
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 16:37:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	16hQNcwHMrciKghu for <xfs@oss.sgi.com>;
	Sun, 25 May 2014 16:37:49 -0700 (PDT)
Date: Mon, 26 May 2014 09:37:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs fs shutdown when no more space available
Message-ID: <20140525233746.GR8554@dastard>
References: <alpine.LRH.2.03.1405252005430.25037@mail.vlasiu.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.03.1405252005430.25037@mail.vlasiu.net>
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
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

On Sun, May 25, 2014 at 08:32:04PM +0300, Gabriel VLASIU wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> Hi!
> 
> Usually, when the xfs partition has no more space nothing happend except I 
> cannot write new data. This was true for a long time. But it's seems that 
> in 3.14.4 something has changed (3.14.x?):
> 
> # dd if=/dev/urandom of=noise.dat count=4194304
> cp noise.dat 11.dat
> cp noise.dat 22.dat
> ....
> 
> At some point the partition become full and I get this in logs:
> 
> May 25 19:48:25 imhotep kernel: [26271.780894] XFS (loop0): xlog_write: reservation summary:
> May 25 19:48:25 imhotep kernel: [26271.780894]   trans type  = FSYNC_TS (36)
> May 25 19:48:25 imhotep kernel: [26271.780894]   unit res    = 9640 bytes
> May 25 19:48:25 imhotep kernel: [26271.780894]   current res = -4 bytes
> May 25 19:48:25 imhotep kernel: [26271.780894]   total reg   = 0 bytes (o/flow = 0 bytes)
> May 25 19:48:25 imhotep kernel: [26271.780894]   ophdrs      = 0 (ophdr space = 0 bytes)
> May 25 19:48:25 imhotep kernel: [26271.780894]   ophdr + reg = 0 bytes
> May 25 19:48:25 imhotep kernel: [26271.780894]   num regions = 0

fe4c224 xfs: inode log reservations are still too small

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
