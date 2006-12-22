Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 12:53:02 -0800 (PST)
Received: from cfa.harvard.edu (cfa.harvard.edu [131.142.10.1])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBMKquqw031719
	for <linux-xfs@oss.sgi.com>; Fri, 22 Dec 2006 12:52:57 -0800
Date: Fri, 22 Dec 2006 15:51:08 -0500 (EST)
From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Reply-To: gbakos@cfa.harvard.edu
Subject: Re: unexpected XFS SB magic number
In-Reply-To: <1166818324.20632.35.camel@xenon.msp.redhat.com>
Message-ID: <Pine.SOL.4.58.0612221549060.2514@titan.cfa.harvard.edu>
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
 <1166818324.20632.35.camel@xenon.msp.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: linux-xfs@oss.sgi.com

Dear Russell,

RE:
> xfs_db /dev/sdc1
> sb 0
> p
> look like?


Unfortunately I can not enter interactive mode with xfs_db:

[root@localhost ~]# xfs_db /dev/sdc1
xfs_db: unexpected XFS SB magic number 0x45464920
xfs_db: size check failed
xfs_db: read failed: Invalid argument
xfs_db: data size check failed
xfs_db: failed to alloc 58876353264 bytes: Cannot allocate memory

[root@localhost ~]#

I also tried specifying the command on the cmdline:

xfs_db -c "sb 0" -c p /dev/sdc1

But I get exactly the same message.

Cheers,
Gaspar
