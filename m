Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 16:37:25 -0800 (PST)
Received: from smtp103.mail.mud.yahoo.com (smtp103.mail.mud.yahoo.com [209.191.85.213])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P0bGqw000327
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 16:37:19 -0800
Message-ID: <45B7FB71.5030603@yahoo.com.au>
Date: Thu, 25 Jan 2007 11:36:01 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122115703.97ed54f3.akpm@osdl.org> <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> On Mon, 22 Jan 2007, Andrew Morton wrote:

>>After the oom-killing, please see if you can free up the ZONE_NORMAL memory
>>via a few `echo 3 > /proc/sys/vm/drop_caches' commands.  See if you can
>>work out what happened to the missing couple-of-hundred MB from
>>ZONE_NORMAL.
>>
> 
> Running with PREEMPT OFF lets me copy the file!!  The machine LAGS 
> occasionally every 5-30-60 seconds or so VERY BADLY, talking 5-10 seconds 
> of lag, but hey, it does not crash!! I will boot the older kernel with 
> preempt on and see if I can get you that information you requested.

It wouldn't be a bad idea to recompile the new kernel with preempt on
and get the info from there.

It is usually best to be working with the most recent kernels. We can
always backport any important fixes if we need to.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
