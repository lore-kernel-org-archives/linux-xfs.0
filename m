Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 04:49:09 -0800 (PST)
Received: from hobbit.corpit.ru (hobbit.corpit.ru [81.13.94.6])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NCn2qw020935
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 04:49:03 -0800
Message-ID: <45B60403.1060201@tls.msk.ru>
Date: Tue, 23 Jan 2007 15:48:03 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan> <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown> <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan> <45B5ECAA.6000100@tls.msk.ru> <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

Justin Piszcz wrote:
> 
> On Tue, 23 Jan 2007, Michael Tokarev wrote:
> 
>> Disabling pre-emption on critical and/or server machines seems to be a good
>> idea in the first place.  IMHO anyway.. ;)
>
> So bottom line is make sure not to use preemption on servers or else you 
> will get weird spinlock/deadlocks on RAID devices--GOOD To know!

This is not a reason.  The reason is that preemption usually works worse
on servers, esp. high-loaded servers - the more often you interrupt a
(kernel) work, the more nedleess context switches you'll have, and the
more slow the whole thing works.

Another point is that with preemption enabled, we have more chances to
hit one or another bug somewhere.  Those bugs should be found and fixed
for sure, but important servers/data isn't a place usually for bughunting.

/mjt
