Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 08:41:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6GFfHbm031629
	for <linux-xfs@oss.sgi.com>; Mon, 16 Jul 2007 08:41:19 -0700
Message-ID: <469B8DB0.7030303@sandeen.net>
Date: Mon, 16 Jul 2007 10:24:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: raid50 and 9TB volumes
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>	 <20070716130140.GC31489@sgi.com> <5d96567b0707160657x7b948026w89ef7c0241c41bf3@mail.gmail.com>
In-Reply-To: <5d96567b0707160657x7b948026w89ef7c0241c41bf3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

Raz wrote:

> Well you are right.  /proc/partitions  says:
>  ....
>     8   241  488384001 sdp1
>     9     1 3404964864 md1
>     9     2 3418684416 md2
>     9     3 6823647232 md3
> 
>  while xfs formats md3 as 9 TB.
>  If i am using LBD , what is the biggest size I can use on i386 ?

With LBD on, you *should* be able to get to 16TB (2^32 * 4096) in
general, assuming that everything in your IO path is clean.  (The 16TB
limit is due to page cache addressing on x86).

-Eric
