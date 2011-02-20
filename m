Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1KLDqHY105073 for <xfs@oss.sgi.com>; Sun, 20 Feb 2011 15:13:52 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEE79156ADA7
	for <xfs@oss.sgi.com>; Sun, 20 Feb 2011 13:16:33 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SASGjgloqoFY7Qno for <xfs@oss.sgi.com>;
	Sun, 20 Feb 2011 13:16:33 -0800 (PST)
Date: Mon, 21 Feb 2011 08:16:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfs_quota: don't try to report quotas which aren't
	there.
Message-ID: <20110220211631.GB3166@dastard>
References: <4D5EB09A.3030605@redhat.com> <4D5EB27C.3070306@redhat.com>
	<4D5EB423.9040009@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D5EB423.9040009@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 18, 2011 at 12:02:11PM -0600, Eric Sandeen wrote:
> Red Hat bug #669333 - xfs_quota generates "XFS_GETQUOTA: No such process" errors
> shows that if you do this for a filesystem w/o group quota enabled:
> 
> # xfs_quota -x -c ' report -h ' /xfsquota"
> 
> You'll get this output:
> 
> User quota on /xfsquota (/dev/vdb)
>                         Blocks              
> User ID      Used   Soft   Hard Warn/Grace   
> ---------- --------------------------------- 
> root            0      0      0  00 [------]
> 
> XFS_GETQUOTA: No such process
> XFS_GETQUOTA: No such process
> ...
> 
> because we're calling XFS_GETQUOTA for types which aren't enabled.
> 
> The below patch fixes it for me, just ignoring types that aren't
> there.
> 
> V2: Thanks to Arkadiusz Miskiewicz for pointing out the simpler fix.
> V3: Thanks again to Arkadiusz for suggesting fixing dump as well
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks sane.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
