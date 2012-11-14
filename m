Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAEKWUG4173672 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 14:32:30 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rEhQsLL1Er5R1Ksj for <xfs@oss.sgi.com>;
	Wed, 14 Nov 2012 12:34:33 -0800 (PST)
Date: Thu, 15 Nov 2012 07:34:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 2/2 V3] xfstests: xfs_tosspages() test addition
Message-ID: <20121114203430.GI1710@dastard>
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com> <20121108232726.GV6434@dastard>
	<50A19EC0.4040405@sgi.com> <50A3DC58.4080704@sgi.com>
	<50A3E46E.9040508@sgi.com> <50A3E99F.8070303@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A3E99F.8070303@sgi.com>
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
To: Andrew Dahl <adahl@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Nov 14, 2012 at 12:57:35PM -0600, Andrew Dahl wrote:
> 
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
> 

> Tests the XFS_IOC_ZERO_RANGE ioctl by way of the "xfs_io zero" utility
> to ensure it is tossing the expected ranges.
> 
> The ranges tested are [0,1] [0,4095] [0,4096] [0,4097] [4095,8191]
>   [4095,8192] [4095,8193] [4096,8192] [1024,4096]
> 
> Signed-off-by: Andrew Dahl <adahl@sgi.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
