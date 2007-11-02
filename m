Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 19:30:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA22UDO9017576
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 19:30:15 -0700
Message-ID: <472A8BB9.7040100@sandeen.net>
Date: Thu, 01 Nov 2007 21:30:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
References: <06CCEA2EB1B80A4A937ED59005FA855101AED1BE@svits26.main.ad.rit.edu> <472A87FA.7000804@sandeen.net> <9489F071-7966-4230-9DAC-D783B6B9600A@rit.edu>
In-Reply-To: <9489F071-7966-4230-9DAC-D783B6B9600A@rit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jay Sullivan <jpspgd@rit.edu>
Cc: xfs@oss.sgi.com

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
