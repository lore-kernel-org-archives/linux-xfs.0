Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 17:32:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7S0WGDW025596
	for <xfs@oss.sgi.com>; Sun, 27 Aug 2006 17:32:31 -0700
Date: Mon, 28 Aug 2006 10:31:13 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [2.6 patch] fs/xfs/xfs_bmap.c:xfs_bmapi(): fix a bug
Message-ID: <20060828103113.A3119251@wobbly.melbourne.sgi.com>
References: <20060826150654.GE4765@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060826150654.GE4765@stusta.de>; from bunk@stusta.de on Sat, Aug 26, 2006 at 05:06:55PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Adrian Bunk <bunk@stusta.de>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Sat, Aug 26, 2006 at 05:06:55PM +0200, Adrian Bunk wrote:
> ...
> Since bma.conv is a char and XFS_BMAPI_CONVERT is 0x1000, bma.conv was 
> always assigned zero.

Yep, looks good, thanks Adrian.

cheers.

-- 
Nathan
