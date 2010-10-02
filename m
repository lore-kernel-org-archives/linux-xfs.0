Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o92AY9Ax175164 for <xfs@oss.sgi.com>; Sat, 2 Oct 2010 05:34:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADB03BD8F1
	for <xfs@oss.sgi.com>; Sat,  2 Oct 2010 03:35:08 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	QI8MnaQczksFUisE for <xfs@oss.sgi.com>;
	Sat, 02 Oct 2010 03:35:08 -0700 (PDT)
Date: Sat, 2 Oct 2010 20:35:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Quota confusion
Message-ID: <20101002103505.GD4681@dastard>
References: <4CA55F09.2010609@sauce.co.nz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CA55F09.2010609@sauce.co.nz>
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
To: Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

On Fri, Oct 01, 2010 at 05:09:45PM +1300, Richard Scobie wrote:
> I am setting up project quota at 95% of  the storage capacity. df shows:
> 
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/dm-0            13672271872 11816602148 1855669724  87% /mnt/storage1
> 
> so I set it:
> 
> limit -p bhard=12988658278k 1
> 
> but when I do an xfs_quota "quota -p 1":
> 
> Disk quotas for Project shares (1)
> Filesystem              Blocks      Quota      Limit  Warn/Time
> Mounted on
> /dev/dm-0           11816148292          0 12988658280   00
> [--------] /mnt/storage1
> 
> the number of blocks is less than the limit.

Ok, that looks normal.

> Also, an xfs_quota df:
> 
> Filesystem           1K-blocks       Used  Available  Use% Pathname
> /dev/dm-0           13672271872 11816602148 1855669724   87% /mnt/storage1
> /dev/dm-0           13672271872 23632296584 1855669724  173%
> /mnt/storage1/share
> 
> I do not understand the lower "Used" figure.

Hmmm - looks like a directory quota output for a specific directory
(/mnt/storage1/share), and for some reason the used field is roughly
double the correct value. Can you post your project quota config
files?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
