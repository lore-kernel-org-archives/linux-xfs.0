Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 May 2007 20:02:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4D32GfB025910
	for <xfs@oss.sgi.com>; Sat, 12 May 2007 20:02:17 -0700
Message-ID: <46467FB5.8080301@sandeen.net>
Date: Sat, 12 May 2007 22:02:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: updatedb triggers XFS internal error
References: <46449B2C.30208@dneg.com>
In-Reply-To: <46449B2C.30208@dneg.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Evan Fraser <evan@dneg.com>
Cc: xfs@oss.sgi.com

Evan Fraser wrote:
> Hello,
> I'm having a problem with one of my linux servers. whenever updatedb is 
> run, the following errors occur in the system log.
> 
> 0x0: c9 00 5a f1 3a 7f 66 be a3 c1 d4 7f e8 1d 6b c9
> Filesystem "md0": XFS internal error xfs_da_do_buf(2) at line 2271 of 
> file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8817957f

This indicates bad metadata magic read from disk.  You'll probably want 
to run xfs_repair; you can run it with -n to see what it *would* do 
first, to get an idea of how drastic the repair might be.  Repairing 
1.4T won't probably be lots of fun, but you've got corruption in there 
somewhere...

-Eric
