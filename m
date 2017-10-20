Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO11.lge.com ([156.147.23.51]:40893 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdJTGOK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 02:14:10 -0400
Date: Fri, 20 Oct 2017 15:14:06 +0900
From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: [RESEND PATCH 1/3] completion: Add support for initializing
 completion with lockdep_map
Message-ID: <20171020061406.GF3310@X58A-UD3R>
References: <1508319532-24655-1-git-send-email-byungchul.park@lge.com>
 <1508319532-24655-2-git-send-email-byungchul.park@lge.com>
 <1508455438.4542.4.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508455438.4542.4.camel@wdc.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "amir73il@gmail.com" <amir73il@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "oleg@redhat.com" <oleg@redhat.com>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "johannes.berg@intel.com" <johannes.berg@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "kernel-team@lge.com" <kernel-team@lge.com>, "david@fromorbit.com" <david@fromorbit.com>

On Thu, Oct 19, 2017 at 11:24:00PM +0000, Bart Van Assche wrote:
> Are there any completion objects for which the cross-release checking is
> useful? Are there any wait_for_completion() callers that hold a mutex or
> other locking object?

Check /proc/lockdep, then you can find all dependencies wrt cross-lock.
I named a lock class of wait_for_completion(), a sting starting with
"(complete)".

For example, in my machine:

console_lock -> (complete)&req.done
cpu_hotplug_lock.rw_sem -> (complete)&st->done_up
cpuhp_state_mutex -> (complete)&st->done_up

and so on.
