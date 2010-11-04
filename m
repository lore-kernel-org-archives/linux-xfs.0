Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA4CdbOx145629 for <xfs@oss.sgi.com>; Thu, 4 Nov 2010 07:39:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 852991600736
	for <xfs@oss.sgi.com>; Thu,  4 Nov 2010 05:57:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	ksMGeApOrd2v1wFh for <xfs@oss.sgi.com>;
	Thu, 04 Nov 2010 05:57:20 -0700 (PDT)
Date: Thu, 4 Nov 2010 23:40:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS mounting fails on MIPS
Message-ID: <20101104124051.GB13830@dastard>
References: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Nov 04, 2010 at 11:27:24AM +0530, Ajeet Yadav wrote:
> Linux XFS version : 2.6.34
> Architecure: MIPS
> I am getting the following error during mount.
> 
> XFS mounting filesystem sda2
> Starting XFS recovery on filesystem: sda2 (logdev: internal)
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1518 of file
> fs/xfs/xfs_alloc.c.  Caller 0x801174a0

Corrupted freespace btree. Run xfs_repair to find out if it is
on-disk corruption (and to fix it).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
