Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41262 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751133AbdJCVEx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 17:04:53 -0400
Date: Wed, 4 Oct 2017 08:04:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171003210449.GO3666@dastard>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003185313.1017-6-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 11:53:13AM -0700, Luis R. Rodriguez wrote:
> Now that all filesystems which used to rely on kthread
> freezing have been converted to filesystem freeze/thawing
> we can remove the kernel kthread freezer.

Really? There's no other subsystem that relies on kernel thread
and workqueue freezing to function correctly on suspend?

> -/**
> - * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
> - *
> - * On success, returns 0.  On failure, -errno and only the kernel threads are
> - * thawed, so as to give a chance to the caller to do additional cleanups
> - * (if any) before thawing the userspace tasks. So, it is the responsibility
> - * of the caller to thaw the userspace tasks, when the time is right.
> - */
> -int freeze_kernel_threads(void)
> -{
> -	int error;
> -
> -	pr_info("Freezing remaining freezable tasks ... ");
> -
> -	pm_nosig_freezing = true;
> -	error = try_to_freeze_tasks(false);

This freezes workqueues as well as kernel threads, so this affects
any subsystem that uses WQ_FREEZABLE. A quick glance tells me this
includes graphics drivers, spi devices, usb hubs, power management,
and a few filesystems, too.

> -	if (!error)
> -		pr_cont("done.");
> -
> -	pr_cont("\n");
> -	BUG_ON(in_atomic());
> -
> -	if (error)
> -		thaw_kernel_threads();
> -	return error;
> -}
> -
>  void thaw_processes(void)
>  {
>  	struct task_struct *g, *p;
> @@ -234,23 +207,3 @@ void thaw_processes(void)
>  	pr_cont("done.\n");
>  	trace_suspend_resume(TPS("thaw_processes"), 0, false);
>  }
> -
> -void thaw_kernel_threads(void)
> -{
> -	struct task_struct *g, *p;
> -
> -	pm_nosig_freezing = false;
> -	pr_info("Restarting kernel threads ... ");
> -
> -	thaw_workqueues();

And this is where the workqueues are thawed.

So I doubt we can safely remove all this code like this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
