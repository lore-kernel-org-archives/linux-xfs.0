Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 00:09:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q79u7k008749
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:09:56 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A21B81AF3AC5
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:11:30 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id pq7CpFule2x1M69G for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:11:30 -0700 (PDT)
Date: Fri, 26 Sep 2008 17:11:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Clarification about NULLs in the file after a crash
Message-ID: <20080926071128.GN27997@disturbed>
References: <607544.16970.qm@web65603.mail.ac4.yahoo.com> <48DC770D.1000308@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC770D.1000308@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: pvlogin@yahoo.com, xfs@oss.sgi.com

On Fri, Sep 26, 2008 at 03:45:49PM +1000, Lachlan McIlroy wrote:
> p v wrote:
>> Let's say that I did lseek/writev 10x - if I crash
>> after that according to the FAQ I can get NULLs in the file
>> - but - can I get it only at the end of the file or is it
>> possible to get NULLs in the middle as well? I could modify
>> my application to recover if it was only at the end
>> (ftruncate up to the last initialized data in the file) but
>> I cannot traverse the whole file and I don't want to
>> create checkpoints by doing fdatasync from time to time (at
>> that point I would consider to go up to the fixed version of
>> xfs).
> Good question.  I think you could get gaps of NULLs in the start
> or middle of the file if the VM flushed data from the middle or
> end of the file first and then the inode was updated on disk.
> Since data at the start of the file has not been written out
> yet then no extents may have been allocated there yet either.
>
> That's just a guess though - I don't know if it could actually
> happen that way.

Yes, you can certainly still get NULLs in the middle of the file.
It just depends on the timing and writeback patterns. if you are
in low memory conditions, the VM will do random page writeback
which means that there is no guarantee which page gets written
first....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
