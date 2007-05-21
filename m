Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 20:21:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4L3KvfB021385
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 20:20:59 -0700
Date: Mon, 21 May 2007 13:25:06 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [xfs-masters] 2.6.22-rc2 built on ppc
Message-ID: <9BA71D7C90D3CBF30ABEF4AF@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070520111408.GF3253@aragorn.home.lxtec.de>
References: <20070520111408.GF3253@aragorn.home.lxtec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: riesebie@lxtec.de
Cc: xfs@oss.sgi.com

Hi there,

--On 20 May 2007 1:14:08 PM +0200 Elimar Riesebieter <riesebie@lxtec.de> wrote:

> Hi,
> FYI, building the kernel with
> gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
> on my powerbook (PPC) gives:
>
> ...
> fs/xfs/xfs_bmap.c: In function 'xfs_bmap_rtalloc':
> fs/xfs/xfs_bmap.c:2650: warning: 'rtx' is used uninitialized in this function
> fs/xfs/linux-2.6/xfs_lrw.c: In function 'xfs_iozero':
> fs/xfs/linux-2.6/xfs_lrw.c:162: warning: 'memclear_highpage_flush' is deprecated (declared at
> include/linux/highmem.h:115) ...
>
The memclear deprecated warning is well known and the 1 line fix of calling
zero_user_page() will be updated shortly
(after I update our sgi 2.6.x-xfs tree to latest mainline and then push our
 xfs-linux tree to git).

The rtx one is not really a problem. rtx is initialised by being passed to a function
and only is uninitialised in the error case where it is then not referenced.
However, we can init it on definition to shut the warning up.

Thanks,
Tim.
