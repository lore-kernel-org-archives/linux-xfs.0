Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 204A47CA1
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 15:20:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E57FD8F8035
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 13:20:32 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	J7o6W0MSTTtJTRY3 for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 13:20:26 -0700 (PDT)
Date: Thu, 7 Apr 2016 06:20:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: use named array initializers for log item dumping
Message-ID: <20160406202023.GA13574@dastard>
References: <20160406105657.GA30644@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160406105657.GA30644@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: xfs@oss.sgi.com, darrick.wong@oracle.com

On Wed, Apr 06, 2016 at 01:56:57PM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch 5110cd82ca90: "xfs: use named array initializers for log
> item dumping" from Mar 7, 2016, leads to the following static checker
> warning:
> 
> 	fs/xfs/xfs_log.c:2085 xlog_print_tic_res()
> 	error: buffer overflow 'trans_type_str' 43 <= 43
> 
> fs/xfs/xfs_log.c
>   2080  
>   2081          xfs_warn(mp, "xlog_write: reservation summary:");
>   2082          xfs_warn(mp, "  trans type  = %s (%u)",
>   2083                   ((ticket->t_trans_type <= 0 ||
>   2084                     ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
>                                                 ^
> Should be >=.  Why is zero invalid?
> 
>   2085                    "bad-trans-type" : trans_type_str[ticket->t_trans_type]),
>   2086                   ticket->t_trans_type);
>   2087          xfs_warn(mp, "  unit res    = %d bytes",

I just pushed patches to the for-next branch (i.e. linux-next) that
remove this code.

https://git.kernel.org/cgit/linux/kernel/git/dgc/linux-xfs.git/commit/?h=for-next&id=710b1e2c2948c1e5d0499def5273ecbc6472342d

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
