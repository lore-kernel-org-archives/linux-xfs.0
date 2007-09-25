Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 16:38:59 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PNcqQ3014606
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 16:38:54 -0700
Date: Tue, 25 Sep 2007 19:38:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <498689.78850.qm@web32907.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0709251938400.7763@p34.internal.lan>
References: <498689.78850.qm@web32907.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: b.j.smith@ieee.org
Cc: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com



On Tue, 25 Sep 2007, Bryan J. Smith wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> Just out of curisosity have you tried SW RAID5 on this array?
>> Also what do you get if you use RAID0 (hw or sw)?
>
> According to him, if I read it correclty, it is an external FC RAID-5
> chassis.  I.e., all of the logic is in the chassis.  So your question
> is N/A.
>
> Although I'm more than ready to be proven incorrect.
>
> Furthermore, what benchmark do you use?  If dd on the volume itself,
> software RAID wins, hands down.  Doesn't matter what size you give
> it, it literally copies (and doesn't recalculate) the parity.  It's
> the rawest form of non-blocking I/O, and uses virtually no system
> interconnect to the CPU (just pushes disk-mem-disk).
>
> -- 
> Bryan J. Smith   Professional, Technical Annoyance
> b.j.smith@ieee.org    http://thebs413.blogspot.com
> --------------------------------------------------
>     Fission Power:  An Inconvenient Solution
>

bonnie++, iozone, etc..

all show ~430-460 MiB/s write and ~550 MiB/s read

Justin.
