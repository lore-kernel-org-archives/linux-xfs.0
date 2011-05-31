Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4V0BXED014838 for <xfs@oss.sgi.com>; Mon, 30 May 2011 19:11:33 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F259614E1CB4
	for <xfs@oss.sgi.com>; Mon, 30 May 2011 17:11:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	StKR6o3uCr9BEjHO for <xfs@oss.sgi.com>;
	Mon, 30 May 2011 17:11:30 -0700 (PDT)
Date: Tue, 31 May 2011 10:11:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: logbufs default value
Message-ID: <20110531001127.GF561@dastard>
References: <4DE0A80C.7060806@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DE0A80C.7060806@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Sat, May 28, 2011 at 09:45:16AM +0200, Michael Weissenbacher wrote:
> Hi List!
> From linux-2.6.39/Documentation/filesystems/xfs.txt:
>   logbufs=value
>         Set the number of in-memory log buffers.  Valid numbers range
>         from 2-8 inclusive.
>         The default value is 8 buffers for filesystems with a
>         blocksize of 64KiB, 4 buffers for filesystems with a blocksize
>         of 32KiB, 3 buffers for filesystems with a blocksize of 16KiB
>         and 2 buffers for all other configurations.  Increasing the
>         number of buffers may increase performance on some workloads
>         at the cost of the memory used for the additional log buffers
>         and their associated control structures.
> 
> Is this still valid? I thought that newer kernels would always use 8 as
> default?

No, it's not. Patches to fix the documentation are welcome.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
