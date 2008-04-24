Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 10:17:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OHHO4Z007956
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 10:17:26 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64D4AE3324
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 10:18:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id j7deiZIpJEQfeWal for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 10:18:05 -0700 (PDT)
Message-ID: <4810C0D3.1070107@sandeen.net>
Date: Thu, 24 Apr 2008 12:18:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid)
 and to 0.6% of EXT3 (3ware hardware raid)
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>
In-Reply-To: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Darling <darlingm@gmail.com>
Cc: xfs@oss.sgi.com

Michael Darling wrote:
> I am preparing a new server, and benchmarking EXT3 against XFS, both using
> software RAID and hardware RAID using a 3ware 9650SE-4LPML.
> 
> Using bonnie++ as a benchmark, I am seeing significant performance boosts in
> my block sequential reads and writes moving from EXT3 to XFS.  I am aware
> that XFS won't create and delete files as quickly as EXT3, however I am
> seeing drops from 29455/second to 1957/second using software RAID, and from
> 32524/second to 189/second using hardware RAID.  I'm not sure if when using
> software raid, if creating and deleting files should drop to 6.6% of EXT3.
> But, what I'm pretty sure of, is when using hardware raid, that creating and
> deleting files shouldn't drop to 0.6% of EXT3.

Chris Mason reminded me that bonnie++ may not be creating enough files
to actually cause much if any IO on ext3; you might play with the -n
option to get it to the point where it's actually doing a significant
number of creates (I don't know what the default is offhand... checks
source... it's 16k maybe?) but more sustained creation might be interesting.

-Eric
