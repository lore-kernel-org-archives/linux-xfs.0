Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 570227F3F
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 21:02:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2668B8F8050
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 19:02:07 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ioLnwonGmUquy8Sw for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 19:02:06 -0700 (PDT)
Date: Mon, 11 Mar 2013 13:02:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: skip freelist scans of corrupt agf
Message-ID: <20130311020205.GC21651@dastard>
References: <513B5393.4000203@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513B5393.4000203@sandeen.net>
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

On Sat, Mar 09, 2013 at 09:21:55AM -0600, Eric Sandeen wrote:
> If an agf has bad values in the freelist, this can wreak
> havoc if, for example, first > last and the loop
> never exits; we index agfl->agfl_bno[i] off into the weeds.
> 
> If they're off, warn about it and skip the scan.
> 
> Thisis done both in xfs_check and xfs_db's freespace cmd.
> 
> Also fix uninit'd variable "i" from previous, similar fix
> for xfs_repair.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
