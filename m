Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 10 Nov 2007 16:00:18 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAB00Abr019076
	for <linux-xfs@oss.sgi.com>; Sat, 10 Nov 2007 16:00:12 -0800
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by ishtar.tlinx.org (8.13.3/8.12.10/SuSE Linux 0.7) with ESMTP id lAANciJe013460
	for <linux-xfs@oss.sgi.com>; Sat, 10 Nov 2007 15:38:44 -0800
Message-ID: <47364104.8020106@tlinx.org>
Date: Sat, 10 Nov 2007 15:38:44 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: minor CPU wake-up question
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux-Xfs <linux-xfs@oss.sgi.com>

I recently ran into "powertop" (fr. lesswatts.org) that shows how often
interrupts awaken a processor under a tickless kernel.

The display indicates the counts are over a 10 second period. 
Barring any disk activity, why would xfsbufd wake up each copy of itself
up when there doesn't seem like there would be anything to do.

Is a separate process really needed for each partition (that seems to be
the case)?  I don't know if it is 1 interrupt/bufd or 6 on 1, but
it is fairly constant with 6 interrupts each period.
FWIW, dirty_writeback_centiseconds is set to 1500(1499) and makes
no difference in the count.

It doesn't seem to be a big deal, other than it is at the top of the
interrupt-chart with usually 60% or more of the ticks.  Might be nice
to not have it on top if it isn't necessary...


  63.2% (  6.0)           xfsbufd : schedule_timeout (process_timeout)
  21.1% (  2.0)     <kernel core> : clocksource_register 
(clocksource_watchdog)
   2.1% (  0.2)     <kernel core> : __netdev_watchdog_up (dev_watchdog)
   2.1% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn)
   2.1% (  0.2)     <kernel core> : neigh_table_init_no_netlink 
(neigh_periodic_
   2.1% (  0.2)              init : schedule_timeout (process_timeout)
   1.1% (  0.1)          xfssyncd : schedule_timeout (process_timeout)
   1.1% (  0.1)     <kernel core> : init_nonfatal_mce_checker 
(delayed_work_time
   1.1% (  0.1)              cron : do_nanosleep (hrtimer_wakeup)
   1.1% (  0.1)              nscd : schedule_timeout (process_timeout)
   1.1% (  0.1)        irqbalance : do_nanosleep (hrtimer_wakeup)
   1.1% (  0.1)     <kernel core> : __neigh_event_send (neigh_timer_handler)
   1.1% (  0.1)     <kernel core> : dst_run_gc (dst_run_gc)
----
