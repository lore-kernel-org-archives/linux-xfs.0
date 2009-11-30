Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUEFTYr016981 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 08:15:29 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0795F4C7795
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 06:15:58 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id J187r3IsXYF76FDB for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2009 06:15:58 -0800 (PST)
Date: Mon, 30 Nov 2009 09:15:57 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: 2.6.31.6: XFS DEBUG: Assertions cause kernel OOPS.
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF3A@cf--amer001e--3.americas.sgi.com>
Message-ID: <alpine.DEB.2.00.0911300915260.20343@p34.internal.lan>
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF3A@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com



On Mon, 30 Nov 2009, Alex Elder wrote:

> Justin Piszcz wrote:
>> Hi,
>>
>> I wanted to compile my kernel with DEBUG for XFS and also kernel frame pointers
>> to catch any issues.
>>
>> However, DEBUG for XFS does more harm than good?
>
> It should not.  This simple patch would improve things
> but I'll add to my to-do list a review of assertions
> to find and fix things of this type.
>
> 					-Alex
>
> diff -Naur old/fs/xfs/xfs_bmap.c new/fs/xfs/xfs_bmap.c
> --- old/fs/xfs/xfs_bmap.c       2009-11-30 07:55:59.000000000 -0600
> +++ new/fs/xfs/xfs_bmap.c       2009-11-30 07:56:43.000000000 -0600
> @@ -4843,6 +4843,7 @@
>        orig_mval = mval;
>        orig_nmap = *nmap;
> #endif
> +       ASSERT(nmap != NULL);
>        ASSERT(*nmap >= 1);
>        ASSERT(*nmap <= XFS_BMAP_MAX_NMAP || !(flags & XFS_BMAPI_WRITE));
>        whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
>
>

The patch failed against 2.6.31.6 but I added that line at that point anyway,
ok thanks will let you know if I see anything else with DEBUG enabled.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
