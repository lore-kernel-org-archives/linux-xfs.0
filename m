Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 20:16:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4G3GsfB013432
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 20:16:55 -0700
Date: Wed, 16 May 2007 13:16:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64 and powerpc
Message-ID: <20070516031626.GM85884050@sgi.com>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070515193722.GA3487@amitarora.in.ibm.com> <20070515195421.GA2948@amitarora.in.ibm.com> <20070515200359.GA5834@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515200359.GA5834@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Wed, May 16, 2007 at 01:33:59AM +0530, Amit K. Arora wrote:
> This patch implements sys_fallocate() and adds support on i386, x86_64
> and powerpc platforms.

Can you please pick up the ia64 support patch I posted as well?

> Changelog:
> ---------
> Note: The changes below are from the initial post (dated 26th April,
> 2007) and _not_ from TAKE2. The only difference from TAKE2 is the kernel
> version on which this patch is based. TAKE2 was based on 2.6.21 and this
> is based on 2.6.22-rc1.
> 
> Following changes were made to the previous version:
>  1) Added description before sys_fallocate() definition.
>  2) Return EINVAL for len<=0 (With new draft that Ulrich pointed to,
>     posix_fallocate should return EINVAL for len <= 0.
>  3) Return EOPNOTSUPP if mode is not one of FA_ALLOCATE or FA_DEALLOCATE
>  4) Do not return ENODEV for dirs (let individual file systems decide if
>     they want to support preallocation to directories or not.
>  5) Check for wrap through zero.
>  6) Update c/mtime if fallocate() succeeds.

Please don't make this always happen. c/mtime updates should be dependent
on the mode being used and whether there is visible change to the file. If no
userspace visible changes to the file occurred, then timestamps should not
be changed.

e.g. FA_ALLOCATE that changes file size requires same semantics of ftruncate()
extending the file, otherwise no change in timestamps should occur.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
