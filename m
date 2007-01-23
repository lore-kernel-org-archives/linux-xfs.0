Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 05:47:49 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NDlgqw001511
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 05:47:43 -0800
Date: Tue, 23 Jan 2007 08:46:48 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
In-Reply-To: <45B60403.1060201@tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0701230846410.8978@p34.internal.lan>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
 <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown>
 <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan> <45B5ECAA.6000100@tls.msk.ru>
 <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan> <45B60403.1060201@tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Tue, 23 Jan 2007, Michael Tokarev wrote:

> Justin Piszcz wrote:
> > 
> > On Tue, 23 Jan 2007, Michael Tokarev wrote:
> > 
> >> Disabling pre-emption on critical and/or server machines seems to be a good
> >> idea in the first place.  IMHO anyway.. ;)
> >
> > So bottom line is make sure not to use preemption on servers or else you 
> > will get weird spinlock/deadlocks on RAID devices--GOOD To know!
> 
> This is not a reason.  The reason is that preemption usually works worse
> on servers, esp. high-loaded servers - the more often you interrupt a
> (kernel) work, the more nedleess context switches you'll have, and the
> more slow the whole thing works.
> 
> Another point is that with preemption enabled, we have more chances to
> hit one or another bug somewhere.  Those bugs should be found and fixed
> for sure, but important servers/data isn't a place usually for bughunting.
> 
> /mjt
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks for the update/info.

Justin.
