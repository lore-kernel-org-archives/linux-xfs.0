Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 10:18:00 -0700 (PDT)
Received: from smtp101.plus.mail.re1.yahoo.com (smtp101.plus.mail.re1.yahoo.com [69.147.102.64])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6IHHobm002405
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 10:17:52 -0700
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
From: "Bryan J. Smith" <b.j.smith@ieee.org>
In-Reply-To: <Pine.LNX.4.64.0707181225560.26004@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
	 <469DF039.4040906@theendofthetunnel.de>
	 <Pine.LNX.4.64.0707181225560.26004@p34.internal.lan>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 13:18:54 -0400
Message-Id: <1184779134.3641.17.camel@portatux64.mobile.smithconcepts.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Hannes Dorbath <light@theendofthetunnel.de>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org

On Wed, 2007-07-18 at 12:26 -0400, Justin Piszcz wrote:
> I will try these options during future testing and re-visit the speeds of 
> regular HW RAID5, thanks!  I know they are part of the 3ware doc and I 
> need to re-bench with these.

3Ware cards should be "tuned" for optimal performance, especially if you
have the battery backup unit (BBU) on the 9500 and later cards** , and
some of the settings can be made more "lax."  It's hard to gage hardware
RAID v. software RAID, especially since the latter can cache commits --
at least from the standpoint of various benchmark utilities (like
Bonnie).  There are various arguments that go back'n forth on this.

But if you're using 3Ware in JBOD with software RAID because you've been
fed the standard and quite _incorrect_ statement that you can do
hot-swap, understand that you can't get fully supported hot-swap without
using the 3Ware's hardware RAID volume management (with the segmentation
of its on-board microcontroller intelligence).  3Ware gets a bad rep
because too many MD advocates out there proliferate the 3Ware supports
hot-swap in JBOD -- you need to leverage kernel hot-plug and other
kernel facilities for hot-swap if you use MD software RAID.

You don't need to use the various kernel facilities if you let the 3Ware
intelligence management the volumes.  That's a major, major, missing
piece of information that I've seen far too many MD advocates omit.

-- Bryan

**NOTE:  Earlier cards (6000-9000, pre-9500) only use SRAM logic, no
DRAM cell, so they don't need a BBU.  Long story, SRAM combinational
circuits don't need to be "refreshed" and the board's capacitors can
store enough charge to keep values in SRAM circuits (at least long
enough to flush to disk or once the disks are powered again).  Of
course, on those earlier cards, the SRAM is small, too small to buffer
most sustained RAID-5 writes so I'd only use RAID-10 on them.

-- 
Bryan J. Smith         Professional, Technical Annoyance
mailto:b.j.smith@ieee.org   http://thebs413.blogspot.com
--------------------------------------------------------
        Fission Power:  An Inconvenient Solution
