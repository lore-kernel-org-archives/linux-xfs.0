Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F3747F5F
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 04:24:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 267F8AC005
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 02:24:09 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ixzoXc7Qt6hvfBoB for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 02:24:07 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W6HS4-0004fB-8I
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W6HS4-0004VI-73
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] metadump: discontiguous directory block support
Date: Thu, 23 Jan 2014 21:23:50 +1100
Message-Id: <1390472635-17225-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

In making xfs_repair handle discontiguous directory blocks properly,
it uncovered the fact that xfs_metadump has never handled
discontiguous directory blocks properly. It doesn't handle
discontiguous block format directories, and there are a couple of
other cases where it is just says "too hard" and gives up, leading
to un-obfuscated, corrupt or missing directory blocks in the
metadump image. xfs/291 on CRC enabled filesystems was causing all
three of these conditions to occur.

This patchset fixes metadump to fully support all forms of
discontiguous directory blocks. It changes the obfuscation code from
reading and extent at a time and trying to slice and dice the
objects within it - which will never work for objects that need CRC
recalculation as a result of obfuscation - to dealing with
individual objects. This does affect IO patterns somewhat - single
large contiguous IOs turn into multiple smaller sequential IOs - but
it means that we can use the object verifiers to do CRC
recalculation correctly.

It also means we can walk the extent tree to gather discontiguous
extents into a single buffer to build an object fom multiple IOs.
This is what all the other directory block IO does, and we need to
do it here too.

The result is that the code is simpler and more obvious in what it
does - the "walk over a large extent" code is generic rather than
object specific, and the discontiguous block code is separated from
the single block object code. Hence both cases are clearer and
easier to understand.

And it works, unlike the old code.

FWIW, with this fixed and xfs/291 passing, the only remaining
outstanding work that is blocking a 3.2.0 release is to trap IO
verifier errors in repair so we repair/rebuild objects based on CRC
errors.

Comments, flames, thoughts all welcome.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
