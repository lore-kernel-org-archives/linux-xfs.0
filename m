Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C35F17F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 20:25:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5981BAC002
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 18:25:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IcjxdGFSYviRrHoR for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 18:25:10 -0700 (PDT)
Date: Mon, 15 Jul 2013 11:24:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Lockdep for 3.10.0+ for rm of kernel git...
Message-ID: <20130715012441.GG5228@dastard>
References: <51E1F1F4.40500@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51E1F1F4.40500@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Jul 13, 2013 at 08:33:56PM -0400, Michael L. Semon wrote:
> Hi!  Here's a lockdep that happened while executing an `rm -r linux` to 
> remove an old kernel git directory.  This is for a git 3.10.0+ kernel 
> on a non-CRC XFS filesystem that's less than a week old.
> 
> I'm not getting lockdep reports like this unless I'm minding my own 
> business.  xfstests could be running until there's a faint burning 
> electrical smell in the room, and this won't show up.  But if all I'm 
> doing is removing things to prepare for the next xfstests session or 
> git activity, then this lockdep will show up.  I'm not sure if I get 
> the same lockdep every time, but it's related to deletes somehow, and 
> it's newer than the production 3.10 kernel, AFAIK.
> 
> For the lockdeps, this pattern is prominent...
> 
>        CPU0
>        ----
>   lock(&(&ip->i_lock)->mr_lock);
>   <Interrupt>
>     lock(&(&ip->i_lock)->mr_lock);
> 
> ...and lockdep hasn't suggested the SMP scenario on XFS in some time.
> 
> There does seem to be some new lockdep work in the kernel, so maybe 
> it's not a regression but something else.
.....
>  [<c10a3d44>] __get_free_pages+0x1c/0x37
>  [<c1025dc4>] pte_alloc_one_kernel+0x14/0x16
>  [<c10b7716>] __pte_alloc_kernel+0x16/0x71
>  [<c10c0f27>] vmap_page_range_noflush+0x12c/0x13a
>  [<c10c1fdb>] vm_map_ram+0x32c/0x3d7
>  [<c10c1d21>] ? vm_map_ram+0x72/0x3d7
>  [<c1171d3b>] _xfs_buf_map_pages+0x5b/0xe1

It's vmap related. Again. Ignore it.

On the bright side, I think I've found precedence in the kernel for
getting this fixed, so stay tuned....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
