Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 May 2007 07:18:11 -0700 (PDT)
Received: from gk.uu.epigenomics.net (gk.uu.epigenomics.net [195.127.125.226])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4IEI6fB013278
	for <xfs@oss.sgi.com>; Fri, 18 May 2007 07:18:08 -0700
From: linux-xfs@ml.epigenomics.com
Subject: Re: xfs_repair: buf calloc failed (4132 bytes): Cannot allocate memory
Date: Fri, 18 May 2007 14:18:04 +0000 (UTC)
Message-ID: <slrnf4rdcs.r0v.robert.sander@snell.epigenomics.epi>
References: <slrnf4j7ge.aje.robert.sander@snell.epigenomics.epi> <op.tsehgekef8dyj1@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, 16 May 2007 13:32:28 +1000,
 "Barry Naujok" <bnaujok@melbourne.sgi.com> wrote:
>
> With 18 million inodes, 1.2TB of space, it will use a lot of memory.
> Assuming you are using a recent xfsprogs (2.8.11 or later), you can
> reduce memory usage by adding "-o bhash=512" which will limit the
> number of buffers cached in xfs_repair. In this scenario, the cache
> will overflow RAM rather easily with the number of inodes to be
> scanned.

Thank you. That did it. xfs_repair was able to complete without memory
error.

Greetings
-- 
Robert Sander                     Senior Manager Information Systems
Epigenomics AG    Kleine Praesidentenstr. 1    10178 Berlin, Germany
phone:+49-30-24345-0                            fax:+49-30-24345-555
http://www.epigenomics.com             robert.sander@epigenomics.com
