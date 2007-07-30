Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jul 2007 13:11:22 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6UKBDbm026416
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 13:11:16 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6UKBHZu006023
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 16:11:17 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6UKBHEB478128
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 16:11:17 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6UKBHVE017115
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 16:11:17 -0400
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on
	software raid 5
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 15:11:06 -0500
Message-Id: <1185826266.9448.5.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org

On Mon, 2007-07-30 at 10:29 -0400, Justin Piszcz wrote:

> Overall JFS seems the fastest but reviewing the mailing list for JFS it 
> seems like there a lot of problems, especially when people who use JFS > 1 
> year, their speed goes to 5 MiB/s over time and the defragfs tool has been 
> removed(?) from the source/Makefile and on Google it says not to use it 
> due to corruption.

The defragfs tool was an unported holdover from OS/2, which is why it
was removed.  There never was a working Linux version.  I have some
ideas to improve jfs allocation to avoid fragmentation problems, but jfs
isn't my full-time job anymore, so I can't promise anything.  I'm not
sure about the corruption claims.  I'd like to hear some specifics on
that.

Anyway, for enterprise use, I couldn't recommend jfs, since there is no
full-time maintainer.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
