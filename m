Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 10:55:29 -0700 (PDT)
Received: from web32904.mail.mud.yahoo.com (web32904.mail.mud.yahoo.com [209.191.69.81])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8QHtKKd005615
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:55:23 -0700
Date: Wed, 26 Sep 2007 10:55:19 -0700 (PDT)
From: "Bryan J. Smith" <b.j.smith@ieee.org>
Reply-To: b.j.smith@ieee.org
Subject: Re: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <Pine.LNX.4.64.0709261339310.24646@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <347332.44288.qm@web32904.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>, b.j.smith@ieee.org
Cc: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I agree and this makes sense but in real-world loads it makes me
> wonder, at least with the 2.4 kernel.

It took 3Ware (actually AMCC) a good 18 months to get the firmware
and driver tuned well.  I purposely avoided any new 3Ware solution
until a good 12-18 months after release because of such.

The 9550SX series was the first microcontroller approach (PowerPC 400
series) done by 3Ware.  All of their prior designs were an older
64-bit ASIC design with SRAM (and only DRAM slapped on, poorly, in
the 9500S), which only worked well for RAID-0/1/10, not 5.

That was well into the 2.6 era.  I'd say you're well out of date with
what 3Ware, let alone the Intel X-Scale-based Areca, are actually
capable of with RAID-5/6 now.

-- Bryan

P.S.  Both AMD and Intel are currently putting serious R&D into the
first embedded x86 designs with added ASICs for Network, Storage,
etc...  I.e., this is going to be mainstream shortly, as AMD got out
of 29000 long ago, and Intel is putting less and less focus on
IOP33x/34x X-Scale.  NPE, SPE and other units can literally handle
DTRs that are 10x of what a general CPU/interconnect LOAD-op-STOR can
do.

I.e., Don't be surprised when your 2009+ server mainboard ICH is
actually an embedded x86 processor with NPE and SPE units.  That will
finally remove the whole "separate card" in general.


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
