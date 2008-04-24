Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 21:01:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3O415Gp013034
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 21:01:06 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05E14DF178
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 21:01:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id tgDYVlo2YIsXTCXy for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 21:01:46 -0700 (PDT)
Message-ID: <4810062F.50100@sandeen.net>
Date: Wed, 23 Apr 2008 23:01:51 -0500
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

So I played with this a little on 2.6.25, on plain partitions.

I saw similar numbers; for example, sequential creates:

ext3:		23698/s
xfs:		  319/s
xfs,nobarrier:	 4478/s


then on a whim I tried an external log on a devicemapper zero target :)

xfs,fakelog:	15156/s

Others can probably wax eloquent as to why xfs is slower on this test,
but it's not unique to your setup, at least.

-Eric
