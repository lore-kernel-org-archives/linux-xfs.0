Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38829 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752424AbdKOKOm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Nov 2017 05:14:42 -0500
Date: Wed, 15 Nov 2017 11:14:40 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Message-ID: <20171115101440.ar2yki5axehfq3bq@dhcp22.suse.cz>
References: <20171113103139.GA18936@yu-chen.sh.intel.com>
 <20171113225216.GJ5858@dastard>
 <20171114033959.GB23219@yu-chen.sh.intel.com>
 <20171114040232.GZ4094@dastard>
 <20171114163953.GA27880@yu-chen.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171114163953.GA27880@yu-chen.sh.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yu Chen <yu.c.chen@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jkosina@suse.cz>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Dan Williams <dan.j.williams@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, Hou Tao <houtao1@huawei.com>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 15-11-17 00:39:53, Yu Chen wrote:
[...]
> Before the filesystem freezing feature is merged into
> upstream, wouldn't it be nice if we have some compromise
> workaround for such kind of issues: how about treat the
> always-sleeping tasks as frozen? They are safe to be
> regarded as frozen because they do nothing.
> Here's a draft patch to get it done, and it can be
> optimized if the direction is acceptible.

I do not think this will fly. You have no guarantee those tasks wake up
at any moment after you consider them frozen and declare the system as
quiescent from the userspace POV.

> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 7381d49a44db..93e123a58558 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -100,8 +100,28 @@ static int try_to_freeze_tasks(bool user_only)
>  			read_lock(&tasklist_lock);
>  			for_each_process_thread(g, p) {
>  				if (p != current && !freezer_should_skip(p)
> -				    && freezing(p) && !frozen(p))
> -					sched_show_task(p);
> +				    && freezing(p) && !frozen(p)) {
> +					unsigned long cnt_ctx;
> +
> +					cnt_ctx = p->nvcsw + p->nivcsw;
> +					msleep(MSEC_PER_SEC);
> +					/* If the task keeps asleep for 1000 ms
> +					 * (actually should be:
> +					 * freeze_timeout_msecs+1000ms in theory)
> +					 * AKA, there is no context switch for the
> +					 * task during this period, we predict this
> +					 * task is not likely to do any work in the
> +					 * future and we can treat it as frozen.
> +					 */
> +					if ((p->state & TASK_NORMAL) &&
> +					   (cnt_ctx == (p->nvcsw + p->nivcsw))) {
> +						pr_err("(%s %c) is sleeping and safe to be treated as frozen\n",
> +							p->comm, task_state_to_char(p));
> +						todo = 0;
> +					} else {
> +						sched_show_task(p);
> +					}
> +				}
>  			}
>  			read_unlock(&tasklist_lock);
>  		}
> -- 
> 2.13.5
> 
> 
> 
> 
> 

-- 
Michal Hocko
SUSE Labs
