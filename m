Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727005AbeH0TVU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Aug 2018 15:21:20 -0400
Subject: Re: [PATCH v2 2/3] xfs: Prevent multiple wakeups of the same log
 space waiter
References: <1535316795-21560-1-git-send-email-longman@redhat.com>
 <1535316795-21560-3-git-send-email-longman@redhat.com>
 <20180827002134.GE2234@dastard>
From: Waiman Long <longman@redhat.com>
Message-ID: <c4ecb0d3-843b-3d9b-d7e0-acda77881f3a@redhat.com>
Date: Mon, 27 Aug 2018 11:34:13 -0400
MIME-Version: 1.0
In-Reply-To: <20180827002134.GE2234@dastard>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/26/2018 08:21 PM, Dave Chinner wrote:
> On Sun, Aug 26, 2018 at 04:53:14PM -0400, Waiman Long wrote:
>> The current log space reservation code allows multiple wakeups of the
>> same sleeping waiter to happen. This is a just a waste of cpu time as
>> well as increasing spin lock hold time. So a new XLOG_TIC_WAKING flag is
>> added to track if a task is being waken up and skip the wake_up_process()
>> call if the flag is set.
>>
>> Running the AIM7 fserver workload on a 2-socket 24-core 48-thread
>> Broadwell system with a small xfs filesystem on ramfs, the performance
>> increased from 91,486 jobs/min to 192,666 jobs/min with this change.
> Oh, I just noticed you are using a ramfs for this benchmark,
>
> tl; dr: Once you pass a certain point, ramdisks can be *much* slower
> than SSDs on journal intensive workloads like AIM7. Hence it would be
> useful to see if you have the same problems on, say, high
> performance nvme SSDs.

Oh sorry, I made a mistake.

There were some problems with my test configuration. I was actually
running the test on a regular enterprise-class disk device mount on /.

Filesystem                              1K-blocks     Used Available
Use% Mounted on
/dev/mapper/rhel_hp--xl420gen9--01-root  52403200 11284408  41118792  22% /

It was not an SSD, nor ramdisk. I reran the test on ramdisk, the
performance of the patched kernel was 679,880 jobs/min which was a bit
more than double the 285,221 score that I got on a regular disk.

So the filesystem used wasn't tiny, though it is still not very large.
The test was supposed to create 16 ramdisks and distribute the test
tasks to the ramdisks. Instead, they were all pounding on the same
filesystem worsening the spinlock contention problem.

Cheers,
Longman
