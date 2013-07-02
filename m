Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D7407F54
	for <xfs@OSS.SGI.com>; Tue,  2 Jul 2013 16:48:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B015CAC007
	for <xfs@OSS.SGI.com>; Tue,  2 Jul 2013 14:48:35 -0700 (PDT)
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id 2DGB6ymX5dZDK6IY for
	<xfs@OSS.SGI.com>; Tue, 02 Jul 2013 14:48:30 -0700 (PDT)
Received: from ty.sabi.co.UK (78.86.80.54) by april.london.02.net (8.5.140)
	id 50D0FF990E9A60D0 for xfs@OSS.SGI.com; Tue, 2 Jul 2013 22:48:30 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1Uu8Qy-0003ON-RO
	for <xfs@OSS.SGI.com>; Tue, 02 Jul 2013 22:48:24 +0100
MIME-Version: 1.0
Message-ID: <20947.19112.717569.762574@tree.ty.sabi.co.uk>
Date: Tue, 2 Jul 2013 22:48:24 +0100
Subject: Re: swidth in RAID
In-Reply-To: <EF4410B0-E6AE-4162-B69F-C8996E2D44D9@gmail.com>
References: <557F888F-34EA-4669-B861-C0B684DAD13D@gmail.com>
	<51D0A62E.2020309@hardwarefreak.com>
	<20130701013851.GC27780@dastard>
	<0DD94D98-18AA-441B-8F41-AD3AC1BCEC60@gmail.com>
	<20130701020939.GF27780@dastard>
	<51D0EDC8.2090706@hardwarefreak.com>
	<EF4410B0-E6AE-4162-B69F-C8996E2D44D9@gmail.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@OSS.SGI.com>

[ ... ]

>> RAID5	sw = (#disks - 1)
>> RAID6	sw = (#disks - 2)
>> RAID10       sw = (#disks / 2) [1]

What was probably all that needed saying for once is that
'swidth'/'sw' matter nearly only for avoiding read-modify-write,
and there is no reason to confuse the already confused by
mentioning here RAID10 (or RAID0) where read-modify-write won't
happen.

The somewhat secondary reason for which stripe width, or rather
something related to it, may matter even for non-parity RAID
sets is for filesystems that try to layout metadata tables so
that the metadata does not end up all on a subset of the disks
in the RAID set, which might occur if the metadata table
alignment is congruent with the "chunk" alignment.

That for example is likely to happen with 'ext[234]' filetrees,
and accordingly 'man mke2fs' rightly mentions for 'stripe-width'
(equivalent to 'swidth'/'sw') that is matters only for parity
RAID sets and because of read-modify-write:

  "This allows the block allocator to prevent read-modify-write
  of the parity in a RAID stripe if possible when the data is
  written."

and it is about 'stride' (the equivalent of 'su'/'sunit' in XFS)
that it says:

  "This mostly affects placement of filesystem metadata like
  bitmaps at mke2fs time to avoid placing them on a single disk,
  which can hurt performance.  It may also be used by the block
  allocator."

Uhm, I thougt that also affected placement of inode tables, but
I may be misremembering. Whether metadata alignment issues are
likley to happen with XFS, where metadata allocation is more
dynamic than for 'ext[234]', and whether it currently contains
code to deal with it, I don't remember.

Also, even assuming that 'sw' matters for RADI10 for reasons
other than parity updates that it does not do, the formula above
is simplistic:

>> [ ... ]
>> [1] If using the Linux md/RAID10 driver with one of the
>> non-standard layouts such as n2 or f2, the formula may
>> change. [ ... ]

Here the default is 'n' and the alternative layouts are 'o' and
'f', also with Linux MD there can be an odd number of members in
a RAID10 set. Not that matters as RAID10 (and some others) of
any shape does not have parity to update on write, so the
specific physical layouts of blocks is not relevant for RMW.

Anyhow I wrote a brief overall description of RMW here some time
ago:

  http://www.sabi.co.uk/blog/12-thr.html#120414

as RMW is an issue that matters in several cases other than
parity RAID.

Also because I think this is the third or fourth time that it
needed repeating in some mailing list that stripe width matters
almost only for RAID when there is parity, and thus almost
entirely not for RAID10.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
