Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Aug 2006 11:10:41 -0700 (PDT)
Received: from mx.wurtel.net (a83-68-3-130.adsl.cistron.nl [83.68.3.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7AIAPDW020233
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 11:10:26 -0700
Received: from wurtel ([192.168.1.1] helo=wurtel-ws.wurtel.net)
	by mx.wurtel.net with esmtp (Exim 3.36 #1 (Debian))
	id 1GBDby-0007PP-00
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 18:42:22 +0200
Received: from paul by wurtel-ws.wurtel.net with local (Exim 4.62)
	(envelope-from <paul@wurtel-ws.wurtel.net>)
	id 1GBDby-0004XF-8s
	for xfs@oss.sgi.com; Thu, 10 Aug 2006 18:42:22 +0200
Date: Thu, 10 Aug 2006 18:42:22 +0200
From: Paul Slootman <paul@wurtel.net>
Subject: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
Message-ID: <20060810164222.GA16332@wurtel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I had problems due to the well-known endian bug.
I first ran xfs_repair on it from the standard Debian package,
version 2.6.20.  That gave a lot of output (which can be found at
http://www.xs4all.nl/~wurtel2/xfs_repair.out.4 ).

While that was running, I got today's CVS version and built that
(it reports version 2.8.11).  I ran that version against the
just-repaired filesystem, and got a number of additional errors,
notably:

empty data block 10 in directory inode 1343747104: junking block
empty data block 11 in directory inode 1343747104: junking block
empty data block 12 in directory inode 1343747104: junking block
free block 16777216 entry 10 for directory ino 1343747104 bad
rebuilding directory inode 1343747104

This 7 times; additionally, this was mentioned a couple of times:

cache_purge: shake on cache 0x5880a0 left 8 nodes!?

In fact, twice before the final "done.".

The second repair output can be found at
http://www.xs4all.nl/~wurtel2/xfs_repair.out.4b .

Should I be worried about that?  I tried a search for "shake on cache"
and found zero hits...

Additionally, the hash hit rates seem pretty bad. Anything to be
worried about, and could anything be done about it?


thanks,
Paul Slootman (please CC me on responses)
