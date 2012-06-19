Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5J23kjx011064 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 21:03:46 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	YSrFf0bzgZ2mki1I for <xfs@oss.sgi.com>;
	Mon, 18 Jun 2012 19:03:44 -0700 (PDT)
Date: Tue, 19 Jun 2012 12:03:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] Too much time to delete file on xfs filesystem
Message-ID: <20120619020341.GK25389@dastard>
References: <CABF-5Wryz4QXMzDb12zViPytSEi67Tm0ZwPkYLJaCbDix+91fg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABF-5Wryz4QXMzDb12zViPytSEi67Tm0ZwPkYLJaCbDix+91fg@mail.gmail.com>
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
To: Ryan Lee <ryanlee.lahk@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 19, 2012 at 09:45:28AM +0900, Ryan Lee wrote:
> Hi, My name is Ryan.
> 
>  Nowadays, Our company product has a new problem which is taking too much
> time to delete file on xfs filesystem.
> 
>  When I try to delete the file (18GByte, It was just one file), it would
> take around 7 minutes 30 seconds.

It's fragmented, isn't it? Run 'xfs_bmap -vp <file>' and count the
extents. If that fails because of ENOMEM errors, run 'xfs_io -f -c
stat <file>' to see what the count of extents is. if the result is
in the thousands, then that is the reason for it being slow.

> # time rm hdd_write_test6.ts

Hmmm - a loopback filesystem image that was written to randomly?
Perhaps you should preallocate the file before running the write
test....

> kernel  2.6.37

A current kernel (e.g. 3.4) will be significantly faster at removing
fragmented files than 2.6.37. Consider upgrading.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
