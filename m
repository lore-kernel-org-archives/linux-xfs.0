Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jul 2007 21:50:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6U4o2bm014969
	for <xfs@oss.sgi.com>; Sun, 29 Jul 2007 21:50:05 -0700
Received: from [134.14.55.100] (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA29269; Mon, 30 Jul 2007 14:50:02 +1000
Message-ID: <46AD6DE9.5090806@sgi.com>
Date: Mon, 30 Jul 2007 14:49:45 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: demand reaping of filestreams objects
References: <20070723021051.GV12413810@sgi.com>
In-Reply-To: <20070723021051.GV12413810@sgi.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Now that the problems with cancel_rearming_delayed_workqueue()
> deadlocks have been fixed, we can go back to only running
> the reaping when we have objects to time out. This prevents
> the reaper from running when there is nothing to do.
> 
> Cheers,
> 
> Dave.

You probably meant to remove the printk's,

@@ -206,8 +206,12 @@ _xfs_mru_cache_list_insert(
...
+		if (!mru->queued) {
+			printk("reaper started\n");

@@ -271,29 +275,27 @@ _xfs_mru_cache_reap(
+	} else
+	printk("reaper stopped\n");


Apart from that it looks good, much simpler.

Don
