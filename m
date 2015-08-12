Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70EE47F50
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 19:57:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E08FFAC007
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:57:28 -0700 (PDT)
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51]) by
	cuda.sgi.com with ESMTP id 0j9Lvn5ctUFBUSDD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 17:57:24 -0700 (PDT)
From: <katsuki.uwatoko@toshiba.co.jp>
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
Date: Wed, 12 Aug 2015 00:56:25 +0000
Message-ID: <C6D0D499B56584katsuki.uwatoko@toshiba.co.jp>
References: <5579B804.9050707@skylable.com>
	<20150612122108.GB60661@bfoster.bfoster>
	<557AD4D4.3010901@skylable.com> <20150612225209.GA20262@dastard>
In-Reply-To: <20150612225209.GA20262@dastard>
Content-Language: en-US
Content-ID: <EBEB34008B81394EB126AAB83ED27EE4@toshiba.local>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, linux-arm-kernel@lists.infradead.org, david@fromorbit.com
Cc: gangchen@rdamicro.com, linux@arm.linux.org.uk, karanvir.singh@hgst.com, bfoster@redhat.com, sandeen@sandeen.net, luca@skylable.com, christopher.squires@hgst.com, edwin@skylable.com, wayne.burri@hgst.com

On Sat, 13 Jun 2015 08:52:09 +1000, Dave Chinner wrote:

> Yup, that's looking like a toolchain bug. Thread about arm directory
> read corruption:

I think that this is not a toolchain bug, this is related to 
Subject: [PATCH v2 1/1] ARM : missing corrupted reg in __do_div_asm
http://www.spinics.net/lists/arm-kernel/msg426684.html

--

The problematic line in xfs is: 
irecs->br_startblock = XFS_DADDR_TO_FSB(mp, mappedbno)
in xfs_dabuf_map()/fs/xfs/xfs_da_btree.c.

The expansion of it is: 

  ld = mappedbno >> mp->m_blkbb_log;
  do_div(ld, mp->m_sb.sb_agblocks);
  startblock = ld << mp->m_sb.sb_agblklog;
  ld = mappedbno >> mp->m_blkbb_log;
  startblock |= do_div(ld, mp->m_sb.sb_agblocks);
  irecs->br_startblock = startblock;

The assembler of these are:

:
	bl	__do_div64
	ldr	r1, [sp, #44]
	subs	r3, r7, #32
	orr	r1, r1, r2, lsr r5
	add	r5, sp, #80
	str	r5, [sp, #64]
	ldr	r5, [sp, #60]
	movpl	r1, r2, asl r3
	mov	r2, r2, asl r7
	str	r2, [sp, #40]
	str	r1, [sp, #44]
	mov	r1, r9
	str	r5, [sp, #96]
	mov	r7, #0
	ldr	r2, [sp, #96]
	mov	r5, #1
	ldr	fp, [sp, #64]
	str	r7, [sp, #84]
	mov	r9, r2, asr #31
	str	r7, [sp, #104]
	bl	__do_div64
:

by GCC 4.7.2 with -O2 option.

Because a result of do_div is stored in the 1st arg (r0),
r0, which is "ld" in the C,  must be reloaded after the 1st call of do_div, before the 2nd call of do_div.
But it is not reloaded in the above assembler.
The problem is macro __do_div_asm, as the patch describes.

I confirmed that the patch fixed this problem.

	mov	r1, sl
	str	r2, [sp, #56]
	mov	r0, fp
	bl	__do_div64
	ldr	ip, [sp, #36]
	rsb	r6, r5, #32
	subs	r3, r5, #32
	ldr	r1, [sp, #56]
	orr	ip, ip, r2, lsr r6
	str	r7, [sp, #96]
	mov	r6, #1
	str	r8, [sp, #80]
	mov	r0, ip
	str	r1, [sp, #52]
	movpl	r0, r2, asl r3
	mov	r2, r2, asl r5
	str	r0, [sp, #36]
	mov	r1, sl
	str	r2, [sp, #32]
	mov	r0, fp
	bl	__do_div64

by GCC 4.7.2 with -O2 option and the patch.

Thank you,
-- 
UWATOKO
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
