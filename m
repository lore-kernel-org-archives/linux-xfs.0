Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 17:14:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m990Dxtg011384
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 17:14:00 -0700
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CCFA4D0146
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 17:15:39 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id t5aDvdUaHGg7tXNT for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 17:15:39 -0700 (PDT)
Message-ID: <48ED4D24.8020208@tlinx.org>
Date: Wed, 08 Oct 2008 17:15:32 -0700
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfsaild centisecs /proc wakeup control?
References: <48ED0DA9.7070002@tlinx.org> <48ED1BD8.60309@sandeen.net>
In-Reply-To: <48ED1BD8.60309@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> On what kernel?
2.6.26.0 (haven't rebooted to 2.6.26.5 yet)
> As far as the wakeups go, I thought this was fixed; see for example:
> TAKE 977545 - xfsaild causing too many wakeups
---
   It may  be fixed in a newer kernel...(referring to David's later comment)..

Just looked at it with powertop 1.10:


Wakeups-from-idle per second :  7.1     interval: 10.0s

Top causes for wakeups:
  42.9% (  6.0)           xfsaild : schedule_timeout (process_timeout)
  14.3% (  2.0)     <kernel core> : clocksource_register (clocksource_watchdog)
   8.6% (  1.2)           xfsbufd : schedule_timeout (process_timeout)
   7.1% (  1.0)                ip : tg3_open (tg3_timer)
