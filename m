Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5562F7F50
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 22:14:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 207AD8F8035
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 20:14:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cjpO5r97qVqFHVvm for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 20:14:10 -0700 (PDT)
Date: Wed, 12 Aug 2015 13:14:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
Message-ID: <20150812031407.GB20596@dastard>
References: <5579B804.9050707@skylable.com>
	<20150612122108.GB60661@bfoster.bfoster>
	<557AD4D4.3010901@skylable.com> <20150612225209.GA20262@dastard>
	<C6D0D499B56584katsuki.uwatoko@toshiba.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C6D0D499B56584katsuki.uwatoko@toshiba.co.jp>
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
To: katsuki.uwatoko@toshiba.co.jp
Cc: gangchen@rdamicro.com, linux@arm.linux.org.uk, karanvir.singh@hgst.com, bfoster@redhat.com, sandeen@sandeen.net, luca@skylable.com, xfs@oss.sgi.com, christopher.squires@hgst.com, edwin@skylable.com, wayne.burri@hgst.com, linux-arm-kernel@lists.infradead.org

On Wed, Aug 12, 2015 at 12:56:25AM +0000, katsuki.uwatoko@toshiba.co.jp wrote:
> On Sat, 13 Jun 2015 08:52:09 +1000, Dave Chinner wrote:
> 
> > Yup, that's looking like a toolchain bug. Thread about arm directory
> > read corruption:
> 
> I think that this is not a toolchain bug, this is related to 
> Subject: [PATCH v2 1/1] ARM : missing corrupted reg in __do_div_asm
> http://www.spinics.net/lists/arm-kernel/msg426684.html

Interesting! Very good work finding that bug, Katsuki-san. 

FWIW, I suspect this fix will need to go back into stable kernels,
too.

> --
> 
> The problematic line in xfs is: 
> irecs->br_startblock = XFS_DADDR_TO_FSB(mp, mappedbno)
> in xfs_dabuf_map()/fs/xfs/xfs_da_btree.c.
> 
> The expansion of it is: 
> 
>   ld = mappedbno >> mp->m_blkbb_log;
>   do_div(ld, mp->m_sb.sb_agblocks);
>   startblock = ld << mp->m_sb.sb_agblklog;
>   ld = mappedbno >> mp->m_blkbb_log;
>   startblock |= do_div(ld, mp->m_sb.sb_agblocks);
>   irecs->br_startblock = startblock;
> 
> The assembler of these are:
> 
> :
> 	bl	__do_div64
> 	ldr	r1, [sp, #44]
> 	subs	r3, r7, #32
> 	orr	r1, r1, r2, lsr r5
> 	add	r5, sp, #80
> 	str	r5, [sp, #64]
> 	ldr	r5, [sp, #60]
> 	movpl	r1, r2, asl r3
> 	mov	r2, r2, asl r7
> 	str	r2, [sp, #40]
> 	str	r1, [sp, #44]
> 	mov	r1, r9
> 	str	r5, [sp, #96]
> 	mov	r7, #0
> 	ldr	r2, [sp, #96]
> 	mov	r5, #1
> 	ldr	fp, [sp, #64]
> 	str	r7, [sp, #84]
> 	mov	r9, r2, asr #31
> 	str	r7, [sp, #104]
> 	bl	__do_div64
> :
> 
> by GCC 4.7.2 with -O2 option.

To close the loop, what code do the other versions GCC produce for
this macro?  Evidence so far says that the result depends on the
compiler version, so I would like to have confirmation that other
versions of the compiler generate working code.  There are other
XFS_DADDR_TO_FSB() calls in the XFS code, too - do they demonstrate
the same problem, maybe with different compiler versions?

Basically I'm asking what is the scope of the problem you've found?
i.e. when was the bug introduced, what compilers expose it, etc
so that when ARM users report XFS corruptions we have some idea of
whether their kernel/compiler combination might have caused the
issue they are seeing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
