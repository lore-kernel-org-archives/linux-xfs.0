Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 15:02:41 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.186])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4UM2aWt008237
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 15:02:37 -0700
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Date: Wed, 30 May 2007 23:48:53 +0200
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz> <20070530170530.GA4197@tuatara.stupidest.org>
In-Reply-To: <20070530170530.GA4197@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200705302348.54259.arnd@arndb.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Michal Marek <mmarek@suse.cz>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wednesday 30 May 2007, Chris Wedgwood wrote:
> 
> On Wed, May 30, 2007 at 02:59:55PM +0200, Michal Marek wrote:
> 
> > +typedef struct xfs_fsop_geom_v132 {
> 
> wouldn't xfs_fsop_geom_v1_32
>                          ^
> 
> > +     __u32           blocksize;      /* filesystem (data) block size */
> 
> [...]
> 
> > +     __u32           dirblocksize;   /* directory block size, bytes  */
> > +} __attribute__((packed)) xfs_fsop_geom_v132_t;
> 
> and xfs_fsop_geom_v1_32_t
>                     ^
> 
> read better there?

Actually, the current convention would be struct compat_xfs_fsop_geom_v1
and compat_xfs_fsop_geom_v1_t.

	Arnd <><
