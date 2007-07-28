Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Jul 2007 06:09:08 -0700 (PDT)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6SD93bm016913
	for <xfs@oss.sgi.com>; Sat, 28 Jul 2007 06:09:05 -0700
Subject: Re: RFC: log record CRC validation
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com>
	<46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com>
	<46AAA340.60208@agami.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 28 Jul 2007 16:03:48 +0200
In-Reply-To: <46AAA340.60208@agami.com>
Message-ID: <p73odhwr5ff.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "William J. Earl" <earl@agami.com>
Cc: xfs-oss <xfs@oss.sgi.com>, David Chinner <dgc@sgi.com>, Michael Nishimoto <miken@agami.com>, markgw@sgi.com

"William J. Earl" <earl@agami.com> writes:

> It is usually
> cost-effective, however, to simply select a reliable disk subsystem.

In practice people don't run fully reliable disk subsystems
unfortunately. And also a previously reliable disk subsystem
might degrade over time. It's better to handle this case.

Also CPUs have gotten a lot faster recently with more cache
misses dominating than actual operations; CRCs on relatively small data
items that are already manipulated by the CPU (like file system
metadata) should be essentially free.

> With SATA, SAS, and FC, which have link-level integrity checks, silent
> data corruption on the link is unlikely.   

For TCP/IP networking that is in theory true too -- with L2 networks
usually having CRCs. In practice the TCP/UDP checksum finds a lot of
corruptions wherever they come from and there are even some that are
only detected by stronger checksums (like in SSL) or go undetected.

While disk subsystems are probably doing a bit better than IP networks
in terms of error rates they are far from perfect either.

-Andi
