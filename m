Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D0827F57
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 17:11:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 096048F8033
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 15:10:59 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bWBV7kJ8AWXPyOg5 for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 15:10:51 -0800 (PST)
Date: Wed, 4 Dec 2013 10:08:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: fix process_bmbt_reclist_int
Message-ID: <20131203230804.GA10988@dastard>
References: <20131203215735.GQ1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203215735.GQ1935@sgi.com>
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

On Tue, Dec 03, 2013 at 03:57:35PM -0600, Ben Myers wrote:
> There is a set checks for corruption in block map btrees in
> process_bmbt_reclist_int that we identify but currently do not fix.  It
> appears that the author's intent in this function was to set error = 1,
> and then only clear it when all of the checks were completed
> successfully.  Unfortunately error can be cleared when it is used for
> the return value of blkmap_set_ext.  Some kinds of corruption are not
> being fixed, including duplicate extents, claiming free blocks, claiming
> metadata blocks, and multiply used blocks.
> 
> Fix this by shadowing error for blkmap_set_ext.

Shadowing variables is not a very nice way of solving the problem.
Someone will come along in a couple of years anf go "huh?" and
remove the shadowed declaration because it makes no sense and has
no comments explaining it.

Better is to use a different variable name for this scope - say
"error2" - or to reset error to a value of 1 after the call with a
comment explaining it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
