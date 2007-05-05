Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 May 2007 13:55:02 -0700 (PDT)
Received: from smtp104.sbc.mail.mud.yahoo.com (smtp104.sbc.mail.mud.yahoo.com [68.142.198.203])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l45KsxfB015700
	for <xfs@oss.sgi.com>; Sat, 5 May 2007 13:54:59 -0700
Date: Sat, 5 May 2007 13:54:56 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Linux SW RAID: HW Raid Controller/JBOD vs. Multiple PCI-e Cards?
Message-ID: <20070505205456.GA17112@tuatara.stupidest.org>
References: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Sat, May 05, 2007 at 12:33:49PM -0400, Justin Piszcz wrote:

> Also, when I run simultaenous dd's from all of the drives, I see
> 850-860MB/s, I am curious if there is some kind of limitation with
> software raid as to why I am not getting better than 500MB/s for
> sequential write speed?

What does "vmstat 1" output look like in both cases?  My guess is that
for large writes it's NOT CPU bound but it can't hurt to check.

> With 7 disks, I got about the same speed, adding 3 more for a total
> of 10 did not seem to help in regards to write.  However, read
> improved to 622MBs/ from about 420-430MB/s.

RAID is quirky.

It's worth fiddling with the stripe size as that can have a big
difference in terms of performance --- it's far from clear why on some
setups some values work well and other setups you want very different
values.

It would be good to know if anyone has ever studied stripe size and
also controller interleave/layout issues to get a good understanding
of why certain values are good and others are very poor and why it
varies so much from one setup to the other.

Also, 'dd performance' varies between the start of a disk and the end.
Typically you get better performance at the start of the disk so dd
might not be a very good benchmark here.

> However, if I want to upgrade to more than 12 disks, I am out of
> PCI-e slots, so I was wondering, does anyone on this list run a 16
> port Areca or 3ware card and use it for JBOD?  What kind of
> performance do you see when using mdadm with such a card?  Or if
> anyone uses mdadm with less than a 16 port card, I'd like to hear
> what kind of experiences you have seen with that type of
> configuration.

I've used some 2, 4 and 8 port 3ware cards.  As JBODS they worked
fine, as RAID cards I had no end of problems.  I'm happy to test
larger cards if someone wants to donate them :-)
