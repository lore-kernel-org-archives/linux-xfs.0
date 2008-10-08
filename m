Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 13:43:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m98KhXbj023474
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 13:43:33 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17F44982559
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 13:45:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id V3nAx69txFYevHxh for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 13:45:13 -0700 (PDT)
Message-ID: <48ED1BD8.60309@sandeen.net>
Date: Wed, 08 Oct 2008 15:45:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsaild centisecs /proc wakeup control?
References: <48ED0DA9.7070002@tlinx.org>
In-Reply-To: <48ED0DA9.7070002@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:
> I was looking at powertop again recently, and noticed xfsbufd and xfsaild at the top
> of the wakeup list. 
> xfsbufd can be tuned with /proc/sys/fs/xfs/xfsbufd_centisecs along with 3 other
> time-related tunables.  However, I don't see one for xfsaild.  Is that an oversight?


On what kernel?

As far as the wakeups go, I thought this was fixed; see for example:
TAKE 977545 - xfsaild causing too many wakeups

on 2.6.27-rc8 with xfs mounted, and powertop 1.9, I don't see xfs up
very high at all:

Top causes for wakeups:
  29.4% ( 15.0)       <interrupt> : pata_sil680
   9.4% (  4.8)       <interrupt> : eth0
   7.8% (  4.0)            iscsid : __mod_timer (process_timeout)

...

   2.0% (  1.0)           xfsbufd : __mod_timer (process_timeout)
   2.0% (  1.0)           xfsaild : __mod_timer (process_timeout)


-Eric
