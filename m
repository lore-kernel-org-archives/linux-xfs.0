Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 23:57:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S6vRDW027882
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 23:57:34 -0700
Received: from pcbnaujok (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA18277 for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 16:56:52 +1000
Message-Id: <200607280656.QAA18277@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: Problem with xfs_repair
Date: Fri, 28 Jul 2006 17:01:01 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20060728064505.GA14714@charite.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi Ralf, 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Ralf Hildebrandt
> Sent: Friday, 28 July 2006 4:45 PM
> To: xfs@oss.sgi.com
> Subject: Problem with xfs_repair
> 
> xfs_repair gave me this when repairing my / fs using a 
> knoppix boot cd:
> 
> Phase 1 - find and verify superblock...
 [snip]
> 
> fatal error -- can't read block 16777216 for directory inode 167785633
> 
> a) How can I find out which file/directory this inode belongs to?
> b) Can I mark the block defektiv somehow?

You have hit a recent regression that is covered in the FAQ http://oss.sgi.com/projects/xfs/faq.html#dir2

You have two options:
  1. Do the steps in the FAQ
  2. Try the xfs_repair patch I just posted to this list.
