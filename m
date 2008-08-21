Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Aug 2008 23:30:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7L6UiUs009939
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 23:30:44 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77583F8FD63
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 23:32:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Z4XqlFJfddPAIA96 for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 23:32:04 -0700 (PDT)
Message-ID: <48AD0BE3.7020403@sandeen.net>
Date: Thu, 21 Aug 2008 01:32:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 5 concurrent bonnie runs failing after first pass .
References: <Pine.LNX.4.64.0808201853480.26204@filesrv1.baby-dragons.com>
In-Reply-To: <Pine.LNX.4.64.0808201853480.26204@filesrv1.baby-dragons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: xfs@oss.sgi.com, linux-raid maillist <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>

Mr. James W. Laferriere wrote:
>  	Hello Dave (& Dan & All) ,
>  	Even with your patch to xfs (49641f1acfdfd437ed9b0a70b86bf36626c02afe) 
> Under some conditions multiple concurrent bonnie runs just halt .  No log to 
> dmesg or serial console .  But there is a message from something when bonnie 
> halts . 

that "something" == bonnie ...

>  Also note the really low I/O .
> 
> 
> --- Bad Bonnie --- (multiple concurrent processes)
> filesrv2,136G,,,14389,16,10165,13,,,64722,9,134.3,0,16,212,2,+++++,+++,206,2,226,1,+++++,+++,177,2
> semop: semop failed.
> : Resource temporarily unavailable
> 

Is it unique to xfs?

this is an error from bonnie's semop() call; it's not immediately clear
that there is a problem with xfs.  Is bonnie deadlocking?  Is xfs stuck?

echo w > /proc/sysrq-trigger to see if there are stuck processes and
where they are.

-Eric
