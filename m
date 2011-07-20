Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KN1VtB252284 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 18:01:32 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5948518093A1
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 16:01:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	X4whAWwBd5rpJcka for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2011 16:01:29 -0700 (PDT)
Date: Thu, 21 Jul 2011 09:01:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Message-ID: <20110720230126.GH9359@dastard>
References: <4E24907F.6020903@johnbokma.com> <20110720064419.GG9359@dastard>
	<4E26C5C5.1090802@hardwarefreak.com> <201107201604.33419@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107201604.33419@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: John Bokma <contact@johnbokma.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Wed, Jul 20, 2011 at 04:04:31PM +0200, Michael Monnerie wrote:
> On Mittwoch, 20. Juli 2011 Stan Hoeppner wrote:
> > I thought this was packing multiple small files into
> > a single stripe write, which you just explained XFS does not do.
> 
> This is interesting, I jump in here. Does that mean that if I have a XFS 
> volume with sw=14,su=64k (14*64=896KiB) that when I write 10 small files 
> in the same dir with 2KB each, each file would be placed at a 896KiB 
> boundary?

No, they'll get sunit aligned but default, which would be on 64k
boundaries.

> That way, all stripes of a 1GB partition would be full when 
> there are roughly 1170 files (1170*896KiB ~ 1GB). What would happen when 
> I create other files - is XFS "full" then, or would it start using sub-
> stripes? If sub-stripes, would they start at su (=64KiB) distances, or 
> at single block (e.g. 4KiB) distances?

It starts packing files tightly into remaining free space when no
free aligned extents are availble for allocation in the AG.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
