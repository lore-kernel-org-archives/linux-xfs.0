Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 17:48:57 -0800 (PST)
Received: from smtp109.sbc.mail.re2.yahoo.com (smtp109.sbc.mail.re2.yahoo.com [68.142.229.96])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P1mnqw016663
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 17:48:50 -0800
Message-ID: <45B80610.5010804@rcn.com>
Date: Wed, 24 Jan 2007 19:21:20 -0600
From: Bill Cizek <cizek@rcn.com>
MIME-Version: 1.0
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122115703.97ed54f3.akpm@osdl.org> <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> On Mon, 22 Jan 2007, Andrew Morton wrote:
>   
>>> On Sun, 21 Jan 2007 14:27:34 -0500 (EST) Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>> Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
>>> the OOM killer and kill all of my processes?
>>>       
> Running with PREEMPT OFF lets me copy the file!!  The machine LAGS 
> occasionally every 5-30-60 seconds or so VERY BADLY, talking 5-10 seconds 
> of lag, but hey, it does not crash!! I will boot the older kernel with 
> preempt on and see if I can get you that information you requested.
>   
Justin,

According to your kernel_ring_buffer.txt (attached to another email), 
you are using "anticipatory" as your io scheduler:
   289  Jan 24 18:35:25 p34 kernel: [    0.142130] io scheduler noop 
registered
   290  Jan 24 18:35:25 p34 kernel: [    0.142194] io scheduler 
anticipatory registered (default)

I had a problem with this scheduler where my system would occasionally 
lockup during heavy I/O.  Sometimes it would fix itself, sometimes I had 
to reboot.  I changed to the "CFQ" io scheduler and my system has worked 
fine since then.

CFQ has to be built into the kernel (under BlockLayer/IOSchedulers).  It 
can be selected as default or you can set it during runtime:

echo cfq > /sys/block/<disk>/queue/scheduler
...

Hope this helps,
Bill
