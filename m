Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Sep 2007 21:39:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8M4dPQ3010543
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2007 21:39:27 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 991C318003EF9
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2007 23:39:28 -0500 (CDT)
Message-ID: <46F49C80.60007@sandeen.net>
Date: Fri, 21 Sep 2007 23:39:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: something very strange w/ filestreams...
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

if I do:

for I in 173 174 178; do ./check $I; done

it's not terribly interesting, things seem to go ok, just normal
filestreams failures ;-)

if I do:

./check 173 174 178

things go very badly; the very first repair in 178 finds a horribly
corrupted filesystem, and repair tips over (memory appears corrupted, as
witnessed by):

> xfs_repair: zone calloc failed (, 572662388 bytes): Cannot allocate memory

hm, no zone name, length of 0x22222274?

I already provided a metadump image to Barry, but I wonder why the
timing(?) seems to make a difference here... first sign of things going
awry in repair is:

Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
bad length 131072 for agf 0, should be 4096
bad length # 131072 for agi 0, should be 4096
would reset bad agf for ag 0
would reset bad agi for ag 0
....

not sure what's going on here, but it only seems to happen if I do those
2 filestreams test immediately before 178...

oh, and this is over LVM, just for fun.

-Eric
