Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 10:38:43 -0700 (PDT)
Received: from web32910.mail.mud.yahoo.com (web32910.mail.mud.yahoo.com [209.191.69.110])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8QHcXbn000586
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:38:34 -0700
Date: Wed, 26 Sep 2007 10:38:33 -0700 (PDT)
From: "Bryan J. Smith" <thebs413@yahoo.com>
Reply-To: b.j.smith@ieee.org
Subject: Re: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <Pine.LNX.4.64.0709261258180.24646@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <216020.40502.qm@web32910.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I wonder where the bottleneck lies.

The microcontroller.

Listen, for the last time, hardware RAID is _not_ for non-blocking
I/O.  Hardware RAID is for in-line XOR streaming off-load, so it
doesn't tie up a system interconnect (which isn't an ideal use for
it).

A hardware RAID card is when you have other things going on in your
interconnect that you don't want the parity LOAD-XOR-STOR to take
away from what it could be using for the service.

It will _never_ have the "raw performance" of OS optimized software
RAID.  At the same time, OS optimized software RAID's impact on the
system interconnect is one of those "unmeasurable" details _unless_
you actually benchmark your application.

I have repeatedly had issues with elementary UDP/IP NFS performance
when the PIO of software RAID is hogging the system interconnect. 
Same deal for large numbers of large database record commits.


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
