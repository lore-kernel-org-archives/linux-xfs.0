Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 Aug 2006 02:16:08 -0700 (PDT)
Received: from mx.wurtel.net (xs.wurtel.net [83.68.3.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7C9FrDW021782
	for <xfs@oss.sgi.com>; Sat, 12 Aug 2006 02:15:56 -0700
Received: from wurtel ([192.168.1.1] helo=wurtel-ws.wurtel.net)
	by mx.wurtel.net with esmtp (Exim 3.36 #1 (Debian))
	id 1GBpZz-0002M3-00
	for <xfs@oss.sgi.com>; Sat, 12 Aug 2006 11:14:51 +0200
Received: from paul by wurtel-ws.wurtel.net with local (Exim 4.62)
	(envelope-from <paul@wurtel-ws.wurtel.net>)
	id 1GBpZz-0004Kz-KD
	for xfs@oss.sgi.com; Sat, 12 Aug 2006 11:14:51 +0200
Date: Sat, 12 Aug 2006 11:14:51 +0200
From: Paul Slootman <paul@wurtel.net>
Subject: Re: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
Message-ID: <20060812091451.GA16661@wurtel.net>
References: <20060810164222.GA16332@wurtel.net> <200608110125.LAA18091@larry.melbourne.sgi.com> <20060811090218.GB22934@wurtel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060811090218.GB22934@wurtel.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri 11 Aug 2006, Paul Slootman wrote:
> 
> Unfortunately, the filesystem panicked again last night.
> This was after the double repair, and rebooting into 2.6.17.7, which
> shouldn't have the bug, right?
> I'll run another repair now :-(

And again.
Curious fact appeared: the lost+found directory from the first time
(which I had moved to lost+found.x) could not be removed "Directory not
empty". This would indicate that the CVS repair version (of 2 days ago)
does not properly build the lost+found directory.

I've now zapped that directory with xfs_db, and am running the (daily?!)
xfs_repair at this moment. As the filesystem is 1.1TB, it takes a couple
of hours :(


Paul Slootman
