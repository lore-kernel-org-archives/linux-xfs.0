Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 17:28:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8J0S9Zd017422
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 17:28:11 -0700
Message-Id: <200609190027.KAA27712@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_check - out of memory | xfs_repair - superblock error reading
Date: Tue, 19 Sep 2006 10:33:31 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <8B10E861-C427-4F9F-B0C4-7A87DB77236B@astro.wisc.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Stephan Jansen' <jansen@astro.wisc.edu>, xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Stephan Jansen
> Sent: Tuesday, 19 September 2006 8:56 AM
> To: xfs@oss.sgi.com
> Subject: Re: xfs_check - out of memory | xfs_repair - 
> superblock error reading
> 
> 
> I was just going to create a 3TB filesystem on a 32 bit system.  So
> xfs_check will not work?  How about xfs_repair?  I assume that will
> work but would like to know beforehand.

Just to let you know, I'm currently working on memory optimisations for
xfs_repair and when it's released, it should work on your system. Memory
usage will grow with inode count and free space fragementation and not based
on filesystem size as it currently does.

The first set of changes have been done and are currently being tested.
