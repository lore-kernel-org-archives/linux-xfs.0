Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7AMrKnB146255 for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 17:53:21 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dDKx3gEMa3NYdRnB for <xfs@oss.sgi.com>;
	Fri, 10 Aug 2012 15:53:18 -0700 (PDT)
Date: Sat, 11 Aug 2012 08:53:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair - segemnation fault | git error
Message-ID: <20120810225310.GG2877@dastard>
References: <CADcDJaR52zwL+aMaUuQTvbYx2d11LRmzdURE2Ok8z0tKsYTv8A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADcDJaR52zwL+aMaUuQTvbYx2d11LRmzdURE2Ok8z0tKsYTv8A@mail.gmail.com>
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
To: Velimir Galic <veli.galic@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 10, 2012 at 10:23:03AM +0200, Velimir Galic wrote:
> hi Guys,
> 
> I hope you are able to help me, because i think that i
> tried everything that i know off to repair my raid after a disk failure.
> 
> Systemspecs:
> 
>    - HP N40L
>       - CPU: AMD Turion II @ 1,5GHZ
>       - 8GB ECC RAM
>       - Disks:
>          - 250GB | OS
>          - 4x2GB | RAID 5 | Softraid
>       - OS: Openmediavault @ 3.0.20 (last version)
> 
> 
> Problem:
> 
> In my raid a disk was fault so mdadm kicked the disk out of the raid. I put
> a replacement in the box and started a resync of the raid and than
> is happened, a second disk got lost in the raid. The raidsync wasn't

Ok, so you've lost a good chunk of the filesystem then? I don't lik
eto say it, but double disk failures tend to result in unrecoverable
data loss. Given the contents of this email, I know you don't have
backups to restore from, so you might be left with only bits and
pieces even if a repair can be made to run successfully.

> finished and now i'm fighting 3 weeks or more i don't no any more :-( to
> repair the file system.
> 
> I tried a lot of different versions of xfs_repair (2.9.4, 2.9.8, 2.10.2,
> 3.0.4, 3.1.2, 3.1.6, 3.1,8), but every precompiled version got an
> "segmentation fault" or hung at phase 3 with 100% cpu load for few day. I
> also tried different distros like ubuntu, debian, redhat, gentoo (yes, i'm
> a little bit desperate :-) )  Than i tried the git version and at first it
> looked good but than i got an another error but i don't understand what the
> problem is.

Perhaps you should tell us whatthe error is. i.e. attach the output
of xfs_repair when it fails.

> 
> tried options without any luck: xfs_repair -v -P | xfs_repair -v -P -m 6144
> | xfs_repair -v -P -L
> 
> Metadump of the filesystem isn't possible at this moment,

Why not?

> but i could
> bootup a live cd and give it a try with it. I'm pretty stuck and don't no
> what to do any more.

Run your compiled, unstripped xfs-repair binary under gdb and when
it segfaults, dump of the stack trace. That will at least tell use
where it is failing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
