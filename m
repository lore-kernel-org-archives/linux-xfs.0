Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RFp5fv143233 for <xfs@oss.sgi.com>; Thu, 27 May 2010 10:51:06 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ADCF145314F
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 08:53:28 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id egwuNZ3s8Fddfo0C for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 08:53:28 -0700 (PDT)
Date: Tue, 25 May 2010 16:41:45 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/8] Test basic quota enforcement
Message-ID: <20100525144145.GD3783@quack.suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-4-git-send-email-jack@suse.cz>
	<20100525100635.GA21252@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100525100635.GA21252@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 25-05-10 06:06:35, Christoph Hellwig wrote:
> On Mon, May 24, 2010 at 04:14:14PM +0200, Jan Kara wrote:
> > Add a test which checks whether basic quota enforcement works.
> 
> This one fails for me when testing and xfs filesystem on latest Linus'
> tree (with Debian -testing userspace):
> 
> --- 230.out	2010-05-25 09:49:35.000000000 +0000
> +++ 230.out.bad	2010-05-25 09:52:49.000000000 +0000
> @@ -4,20 +4,22 @@
>  
>  ### create files, setting up ownership (type=u)
>  ### some buffered IO (type=u)
> +pwrite64: Disk quota exceeded
  Hmm, the test fails differently for XFS in my setting but it fails as
well. One reason is that XFS starts counting grace time when user reaches
softlimit while VFS quotas start counting grace time when user exceeds
softlimit.
  Another reason probably is that limit 12 KB is too tight for XFS to write
a 4 KB file probably due to delayed allocation. So I'll try to loosen the
limits a bit to make test 230 work also for xfs. Thanks for report.

									Honza

>  *** Report for user quotas on device [SCR_DEV]
>  Block grace time: 00:00; Inode grace time: 00:00
>                          Block limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     --       4       4      12              2     2     4       
> +fsgqa     --       0       4      12              2     2     4  00:00
>  
>  
> +pwrite64: Disk quota exceeded
>  *** Report for user quotas on device [SCR_DEV]
>  Block grace time: 00:00; Inode grace time: 00:00
>                          Block limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     +-       8       4      12  00:00       2     2     4       
> +fsgqa     --       0       4      12              2     2     4  00:00
>  
>  
>  pwrite64: Disk quota exceeded
> @@ -26,7 +28,7 @@
>                          Block limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     +-      12       4      12  00:00       2     2     4       
> +fsgqa     --       0       4      12              2     2     4  00:00
>  
>  
>  pwrite64: Disk quota exceeded
> @@ -35,24 +37,26 @@
>                          Block limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     +-       8       4      12   none       2     2     4       
> +fsgqa     --       0       4      12              2     2     4   none
>  
>  
> +touch: cannot touch `[SCR_MNT]/file3': Disk quota exceeded
>  *** Report for user quotas on device [SCR_DEV]
>  Block grace time: 00:00; Inode grace time: 00:00
>                          Block limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     ++       8       4      12   none       3     2     4  00:00
> +fsgqa     --       0       4      12              2     2     4   none
>  
>  
> +touch: cannot touch `[SCR_MNT]/file4': Disk quota exceeded
>  touch: cannot touch `[SCR_MNT]/file5': Disk quota exceeded
>  *** Report for user quotas on device [SCR_DEV]
>  Block grace time: 00:00; Inode grace time: 00:00
>                          Block limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     ++       8       4      12   none       4     2     4  00:00
> +fsgqa     --       0       4      12              2     2     4   none
>  
>  
>  touch: cannot touch `[SCR_MNT]/file4': Disk quota exceeded
> @@ -61,7 +65,7 @@
>                          Block limits                File limits
>  User            used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     ++       8       4      12   none       3     2     4   none
> +fsgqa     --       0       4      12              2     2     4   none
>  
>  
>  
> @@ -69,20 +73,22 @@
>  
>  ### create files, setting up ownership (type=g)
>  ### some buffered IO (type=g)
> +pwrite64: Disk quota exceeded
>  *** Report for group quotas on device [SCR_DEV]
>  Block grace time: 00:00; Inode grace time: 00:00
>                          Block limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     --       4       4      12              2     2     4       
> +fsgqa     --       0       4      12              2     2     4  00:00
>  
>  
> +pwrite64: Disk quota exceeded
>  *** Report for group quotas on device [SCR_DEV]
>  Block grace time: 00:00; Inode grace time: 00:00
>                          Block limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     +-       8       4      12  00:00       2     2     4       
> +fsgqa     --       0       4      12              2     2     4  00:00
>  
>  
>  pwrite64: Disk quota exceeded
> @@ -91,7 +97,7 @@
>                          Block limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     +-      12       4      12  00:00       2     2     4       
> +fsgqa     --       0       4      12              2     2     4  00:00
>  
>  
>  pwrite64: Disk quota exceeded
> @@ -100,24 +106,26 @@
>                          Block limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     +-       8       4      12   none       2     2     4       
> +fsgqa     --       0       4      12              2     2     4   none
>  
>  
> +touch: cannot touch `[SCR_MNT]/file3': Disk quota exceeded
>  *** Report for group quotas on device [SCR_DEV]
>  Block grace time: 00:00; Inode grace time: 00:00
>                          Block limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     ++       8       4      12   none       3     2     4  00:00
> +fsgqa     --       0       4      12              2     2     4   none
>  
>  
> +touch: cannot touch `[SCR_MNT]/file4': Disk quota exceeded
>  touch: cannot touch `[SCR_MNT]/file5': Disk quota exceeded
>  *** Report for group quotas on device [SCR_DEV]
>  Block grace time: 00:00; Inode grace time: 00:00
>                          Block limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     ++       8       4      12   none       4     2     4  00:00
> +fsgqa     --       0       4      12              2     2     4   none
>  
>  
>  touch: cannot touch `[SCR_MNT]/file4': Disk quota exceeded
> @@ -126,6 +134,6 @@
>                          Block limits                File limits
>  Group           used    soft    hard  grace    used  soft  hard  grace
>  ----------------------------------------------------------------------
> -fsgqa     ++       8       4      12   none       3     2     4   none
> +fsgqa     --       0       4      12              2     2     4   none
>  
>  
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
