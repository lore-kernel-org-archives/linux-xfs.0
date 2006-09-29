Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Sep 2006 17:48:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8T0mGaG015533
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 17:48:18 -0700
Message-Id: <200609290047.KAA01609@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_repair said "cache_purge: shake on cache 0x80f5288 left 1inodes!?"
Date: Fri, 29 Sep 2006 10:54:24 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
In-Reply-To: <1159458565.28220.12.camel@lasse>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?'H=E5kan_Lindqvist'?= <lindqvist@netstar.se>, xfs@oss.sgi.com

Hi, 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Håkan Lindqvist
> Sent: Friday, 29 September 2006 1:49 AM
> To: xfs@oss.sgi.com
> Subject: xfs_repair said "cache_purge: shake on cache 
> 0x80f5288 left 1inodes!?"
> 
> Hi!
> 
> When I ran xfs_repair (2.8.11) to fix a filesystem that had 
> been bitten
> by the Linux 2.6.17.<7 bug the following happened:
> 
> All seemed to go well, xfs_repair found the problematic 
> directory inode
> and rebuilded it.
> 
> At the end (right before printing "done"), it did however say
> "cache_purge: shake on cache 0x80f5288 left 1 inodes!?" thrice.
> 
> The filesystem appears to be fine so far (and the directory that
> previously caused the filesystem to shut down is ok again), but that
> error/warning message sounded a little scary.
> 
> Is this problem harmless or should I be worried?

This cache_purge comment is harmless. It's informing us that some buffers
have reference counts remaining that weren't unreferenced when read. All
dirty buffers do get written.

Barry.
