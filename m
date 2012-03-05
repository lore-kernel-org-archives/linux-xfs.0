Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q251AadB069228 for <xfs@oss.sgi.com>; Sun, 4 Mar 2012 19:10:36 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	idJM7cR5MyiIIJnr for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 17:10:34 -0800 (PST)
Date: Mon, 5 Mar 2012 12:10:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: failed to set versionnum in AG 1
Message-ID: <20120305011032.GL5091@dastard>
References: <alpine.LRH.2.02.1203041803340.8964@mail.vlasiu.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1203041803340.8964@mail.vlasiu.net>
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
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

On Sun, Mar 04, 2012 at 06:09:12PM +0200, Gabriel VLASIU wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi!
> 
> On all my older partitions with xfs I have this problem:
> 
> # xfs_db -x /dev/sdh1
> xfs_db> version
> versionnum [0xb4b4+0x8] = V4,ATTR,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2

it already has the attr2 feature bit set.

> xfs_db> version attr2
> writing all SBs
> Superblock has mismatched features2 fields, skipping modification
> failed to set versionnum in AG 1
> versionnum [0xb4b4+0x8] = V4,ATTR,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2

What version of xfs_db are you using?

And why do you need to set the attr2 feature this way? It gets set
automatically when it gets used because on recent kernels it is the
default mount option. If you have an older kernel and need to turn
attr2 on, then simply add the "attr2" field to the mount options on
the filesystem. Once xfs_info reports attr=2 for the filesytem, you
can remove the attr2 mount option...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
