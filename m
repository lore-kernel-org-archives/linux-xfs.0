Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDE1B7F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 18:52:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E221B8F8065
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 16:52:37 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nglQLs1hVqZhZ9kI for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 16:52:36 -0800 (PST)
Date: Tue, 25 Feb 2014 11:52:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] xfs: be honest about used inodes in statfs
Message-ID: <20140225005232.GV13647@dastard>
References: <53067DC0.9040800@redhat.com>
 <530BE377.3050808@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530BE377.3050808@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 24, 2014 at 06:27:35PM -0600, Eric Sandeen wrote:
> Because we have lazy counters, it's possible that we over-allocate
> inodes past the maxicount (imaxpct) limit.  
> 
> A previous commit,
> 
>  2fe3366 xfs: ensure f_ffree returned by statfs() is non-negative
> 
> stopped statfs from underflowing f_ffree in this case, but that
> only happened when we mis-reported f_files, capped at maxicount.
> 
> Change statfs to report the actual number of inodes allocated,
> even if it is greater than maxicount.  It's reality.
> Deal with it.  
> 
> Also rework code & rename vars for clarity after input from
> dchinner & bfoster.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: code cleanup thanks to Brian
> V3: more cleanup thanks to Dave
> V4: Oh for crying out loud... (add maxicount test in else)

Looks good now!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
