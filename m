Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 08:58:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l58FwDWt001714
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 08:58:14 -0700
Message-ID: <46697C94.40401@sandeen.net>
Date: Fri, 08 Jun 2007 10:58:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: ways to restore data from crashed disk
References: <465EA882.3030403@deserver.nl> <465ECF9B.2000500@sandeen.net> <46684A9B.90908@deserver.nl> <46685C5F.5090804@sandeen.net> <4668D51F.8010804@deserver.nl>
In-Reply-To: <4668D51F.8010804@deserver.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jaap Struyk <japie@deserver.nl>
Cc: xfs@oss.sgi.com

Jaap Struyk wrote:
> Eric Sandeen schreef:
> 
>> when you are talking about sizes, do you mean space used (du) or max
>> offset (ls -l?)  max offset should be the same for your image file as
>> for your original device... 120G.
> 
> ls -l
> But I don't know what tot trust anymore, if I look with gparted at my
> partitions the old disk gaves me a partition of 140G with 106G used space.
> My new disk has a partition of 200G with 166G used space.
> If I create a new xfs partition it has about 10% used space (according
> to gparted, I suspect thats the size of the logfiles?) so from the 166G
> on the new disk 146G is the "real" used space so that should be the size
> of the image file. (nomather what ls -l tells me)
> Is this correct?

Ok.  repair is trying to read a superblock at:

superblock read failed, offset 103376846848, size 2048, ag 11, rval 0

103376846848 bytes... or about 96 MB (base 2) (or 103 base 10)

if ls -l on your image file is not at least that big, of course it can't
read it.  And if that's smaller than your filesystem, then the image
isn't right...

from your db output:

xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 36710528

it looks like the original filesystem was bigger than your image:

4096*36710528
150366322688 <-- 140 MB

so it looks like your image file is not correct... I'm not familiar with
the tool you're using, is it somehow compressing a sparse file or
something like that?

-Eric
