Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ALfJjG166610 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 16:41:19 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 335056416B
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 14:42:04 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id 4YYFq76G7mgLQerj for
	<xfs@oss.sgi.com>; Fri, 10 Sep 2010 14:42:04 -0700 (PDT)
Message-ID: <4C8AA62A.9020704@sauce.co.nz>
Date: Sat, 11 Sep 2010 09:42:02 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: XFS over LVM over md RAID
References: <4C89668E.6010800@sauce.co.nz> <20100910013026.GA24409@dastard>
	<4C899816.6030506@sauce.co.nz> <4C8A3F8F.4000704@sandeen.net>
In-Reply-To: <4C8A3F8F.4000704@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> yup F11 doesn't have all the nice blkid topology bits; F11 still has
> libblkid in e2fsprogs, from before it was liberated to util-linux-ng.
>
> (I wonder if we shouldn't just convert xfsprogs over to use the ioctls...)

Thanks both for your help. For various reasons, I'll just rely on using 
the non-topology aware version.

In the future this lv will be grown in multiples of  256K chunk, 16 
drive RAID6 arrays, so am I correct in thinking that the sunit/swidth 
parameter can stay the same as it is expanded?

I am thinking that XFS allocates ag's across all the space and that it 
will only be writing to any one array at a time, or would there be more 
configured if mkfs.xfs were aware that it was being created on say, 2 x 
16 RAID6 arrays?

This is based on backing up the first array prior to expansion, adding 
the second and mkfs.xfs, as I imagine just expanding the fs over the 
second would result in non optimal performance.

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
