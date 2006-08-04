Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 03:07:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k74A6fDW029596
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 03:06:52 -0700
Date: Fri, 4 Aug 2006 20:05:50 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: 2.6.18-rc3-git3 - XFS - BUG: unable to handle kernel NULL pointer dereference at virtual address 00000078
Message-ID: <20060804200549.A2414667@wobbly.melbourne.sgi.com>
References: <9a8748490608040122l69ff139dtaae27e8981022dae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490608040122l69ff139dtaae27e8981022dae@mail.gmail.com>; from jesper.juhl@gmail.com on Fri, Aug 04, 2006 at 10:22:21AM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: jesper.juhl@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Aug 04, 2006 at 10:22:21AM +0200, Jesper Juhl wrote:
> I just hit a BUG that looks XFS related.
> 
> The machine is running 2.6.18-rc3-git3
> 
> (more info below the BUG messages)
> 

Thanks for reporting, Jesper - is it reproducible?  Could you try this
patch for me?  We had a couple of other reports of this, but the earlier
reporters have vanished ... could you let me know if this helps?

cheers.

-- 
Nathan

--- fs/xfs/xfs_alloc.c.orig	2006-08-04 20:00:34.333456250 +1000
+++ fs/xfs/xfs_alloc.c	2006-08-04 20:00:50.586472000 +1000
@@ -1949,14 +1949,8 @@ xfs_alloc_fix_freelist(
 		 * the restrictions correctly.  Can happen for free calls
 		 * on a completely full ag.
 		 */
-		if (targs.agbno == NULLAGBLOCK) {
-			if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
-				xfs_trans_brelse(tp, agflbp);
-				args->agbp = NULL;
-				return 0;
-			}
+		if (targs.agbno == NULLAGBLOCK)
 			break;
-		}
 		/*
 		 * Put each allocated block on the list.
 		 */
