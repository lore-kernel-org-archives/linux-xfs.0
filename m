Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 11:00:53 -0700 (PDT)
Received: from web32907.mail.mud.yahoo.com (web32907.mail.mud.yahoo.com [209.191.69.84])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8PI0kQ3019402
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 11:00:48 -0700
Date: Tue, 25 Sep 2007 11:00:49 -0700 (PDT)
From: "Bryan J. Smith" <thebs413@yahoo.com>
Reply-To: b.j.smith@ieee.org
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <Pine.LNX.4.64.0709251248210.15156@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <498689.78850.qm@web32907.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Just out of curisosity have you tried SW RAID5 on this array?
> Also what do you get if you use RAID0 (hw or sw)?

According to him, if I read it correclty, it is an external FC RAID-5
chassis.  I.e., all of the logic is in the chassis.  So your question
is N/A.

Although I'm more than ready to be proven incorrect.

Furthermore, what benchmark do you use?  If dd on the volume itself,
software RAID wins, hands down.  Doesn't matter what size you give
it, it literally copies (and doesn't recalculate) the parity.  It's
the rawest form of non-blocking I/O, and uses virtually no system
interconnect to the CPU (just pushes disk-mem-disk). 

-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
