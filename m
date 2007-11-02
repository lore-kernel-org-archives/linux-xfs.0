Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Nov 2007 07:00:08 -0700 (PDT)
Received: from SVITS26.main.ad.rit.edu (svits26.main.ad.rit.edu [129.21.18.136])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA2E01B5002655
	for <xfs@oss.sgi.com>; Fri, 2 Nov 2007 07:00:04 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
Date: Fri, 2 Nov 2007 10:00:23 -0400
Message-ID: <06CCEA2EB1B80A4A937ED59005FA855101AED204@svits26.main.ad.rit.edu>
In-Reply-To: <472A8BB9.7040100@sandeen.net>
From: "Jay Sullivan" <jpspgd@rit.edu>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I lost the xfs_repair output on an xterm with only four lines of
scrollback...  I'll definitely be more careful to preserve more
'evidence' next time.  =(  "Pics or it didn't happen", right?

I just upgraded xfsprogs and will scan the disk during my next scheduled
downtime (probably in about 2 weeks).  I'm tempted to just wipe the
volume and start over:  I have enough 'spare' space lying around to copy
everything out to a fresh XFS volume.

Regarding "areca":  I'm using hardware RAID built into Apple XServe
RAIDs o'er LSI FC929X cards.

Someone else offered the likely explanation that the btree is corrupted.
Isn't this something xfs_repair should be able to fix?  Would it be
easier, safer, and faster to move the data to a new volume (and restore
corrupted files if/as I find them from backup)?  We're talking about
just less than 4TB of data which used to take about 6 hours to fsck (one
pass) with ext3.  Restoring the whole shebang from backups would
probably take the better part of 12 years (waiting for compression,
resetting ACLs, etc.)...

FWIW, another (way less important,) much busier and significantly larger
logical volume on the same array has been totally fine.  Murphy--go
figure.

Thanks!

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] 
Sent: Thursday, November 01, 2007 10:30 PM
To: Jay Sullivan
Cc: xfs@oss.sgi.com
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c

Jay Sullivan wrote:
> Good eye:  it wasn't mountable, thus the -L flag.  No recent  
> (unplanned) power outages.  The machine and the array that holds the  
> disks are both on serious batteries/UPS and the array's cache  
> batteries are in good health.

Did you have the xfs_repair output to see what it found?  You might also
grab the very latest xfsprogs (2.9.4) in case it's catching more cases.

I hate it when people suggest running memtest86, but I might do that
anyway.  :)

What controller are you using?  If you say "areca" I might be on to
something with some other bugs I've seen...

-Eric
