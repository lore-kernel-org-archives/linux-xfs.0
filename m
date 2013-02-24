Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 008337F37
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 17:39:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E3A3D8F8037
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 15:39:23 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZD9YqaNHmE1r5XkA for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 15:39:22 -0800 (PST)
Date: Mon, 25 Feb 2013 10:39:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs: Cannot allocate memory on an online resize
	60GB->120GB, 30+GB free RAM.
Message-ID: <20130224233920.GE5551@dastard>
References: <CAG+9BZWD9mg+NAy+QdobPRkQJS4b6TTkiAvKWD4Q-gLH0AYU3g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAG+9BZWD9mg+NAy+QdobPRkQJS4b6TTkiAvKWD4Q-gLH0AYU3g@mail.gmail.com>
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
To: wolfwings@wolfwings.us
Cc: xfs@oss.sgi.com

On Sun, Feb 24, 2013 at 03:37:39PM -0600, wolfwings@wolfwings.us wrote:
> Complete error message:
> 
> > xfs_growfs /
> meta-data=/dev/sdc4              isize=256    agcount=4, agsize=5999616 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=23998464, imaxpct=25
>          =                       sunit=512    swidth=512 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=11720, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Cannot allocate memory

You are running what kernel? 3.7.6, .7 or .8? if so, upgrade to to
3.7.9, and the problem should be fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
