Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47J8IcC131973 for <xfs@oss.sgi.com>; Mon, 7 May 2012 14:08:18 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id fFvhgtcd9rKsjcu2 for
	<xfs@oss.sgi.com>; Mon, 07 May 2012 12:08:16 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: suddenly slow writes on XFS Filesystem
Date: Mon, 7 May 2012 21:08:14 +0200
References: <4FA63DDA.9070707@profihost.ag> <4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	(sfid-20120507_185142_476909_3A22D91B)
In-Reply-To: <4FA7FA14.6080700@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201205072108.15134.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com, stan@hardwarefreak.com
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Am Montag, 7. Mai 2012 schrieb Stan Hoeppner:
> What I would suggest is doing an xfsdump to a filesystem on another LUN
> or machine, expand the size of this LUN by 50% or more (I gather this
> is an external RAID), format it appropriately, then xfsrestore.  This
> will eliminate your current free space fragmentation, and the 50% size
> increase will delay the next occurrence of this problem.  If you can't
> expand the LUN, simply do the xfsdump/format/xfsrestore, which will
> give you contiguous free space.

Maybe the new dm thin provisioning could help here? But it might just move 
the fragmentation from the filesystem to the device mapper layer. I did not 
yet check the implementation details of the new thin provisioning target.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
