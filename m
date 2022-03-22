Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465B0C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 01:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiCVBdn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 21:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiCVBdm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 21:33:42 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1583CD8D6;
        Mon, 21 Mar 2022 18:32:15 -0700 (PDT)
Received: from fsav111.sakura.ne.jp (fsav111.sakura.ne.jp [27.133.134.238])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22M09w9u097617;
        Tue, 22 Mar 2022 09:09:58 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav111.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp);
 Tue, 22 Mar 2022 09:09:58 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22M09wdv097614
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 22 Mar 2022 09:09:58 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
Date:   Tue, 22 Mar 2022 09:09:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <e0a0bc94-e6de-b0e5-ee46-a76cd1570ea6@I-love.SAKURA.ne.jp>
 <YjNHzyTFHjh9v6k4@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <5542ef88-dcc9-0db5-7f01-ad5779d9bc07@I-love.SAKURA.ne.jp>
 <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
 <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
 <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/03/22 8:27, Tejun Heo wrote:
> On Tue, Mar 22, 2022 at 08:17:43AM +0900, Tetsuo Handa wrote:
>> On 2022/03/22 8:04, Tejun Heo wrote:
>>> But why are you dropping the flag from their intended users?
>>
>> As far as I can see, the only difference __WQ_LEGACY makes is whether
>> "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing !WQ_MEM_RECLAIM %s:%ps"
>> warning is printed or not. What are the intended users?
> 
> The old create_workqueue() and friends always imply WQ_MEM_RECLAIM because
> they all used to be served dedicated kthreads. The growing number of
> kthreads used this way became a headache. There were too many of these
> kthreads sitting around doing nothing. In some niche configurations, they
> ate up enough PIDs to cause boot failrues.

OK.

> 
> To address the issue, the new implementation made the workqueues share pools
> of workers. However, this means that forward progress can't be guaranteed
> under memory pressure, so workqueues which are depended upon during memory
> reclaim now need to set WQ_MEM_RECLAIM explicitly to request a dedicated
> rescuer thread.

OK.

> 
> The legacy flushing warning is telling us that those workqueues can be

s/can be/must be/ ?

> converted to alloc_workqueue + WQ_MEM_RECLAIM as we know them to be
> participating in memory reclaim (as they're flushing one of the explicitly
> marked workqueues). So, if you spot them, the right thing to do is
> converting all the involved workqueues to use alloc_workqueue() +
> WQ_MEM_RECLAIM.

Then, can the description of

	__WQ_LEGACY		= 1 << 18, /* internal: create*_workqueue() */

be improved to something like

	/*
	 * This flag disables deadlock detection which can happen when flushing
	 * a work item in !WQ_MEM_RECLAIM workqueue from WQ_MEM_RECLAIM workqueue.
	 * But try to avoid using this flag, by adding WQ_MEM_RECLAIM to all WQs which
	 * can be involved where a guarantee of forward progress under memory pressure
	 * is required.
	 */

? Current /* internal: create*_workqueue() */ tells me nothing.



My question is: I want to add WQ_MEM_RECLAIM flag to the WQ used by loop module
because this WQ is involved upon writeback operation. But unless I add both
__WQ_LEGACY | WQ_MEM_RECLAIM flags to the WQ used by loop module, we will hit

	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),

warning because e.g. xfs-sync WQ used by xfs module is not using WQ_MEM_RECLAIM flag.

	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
				XFS_WQFLAGS(WQ_FREEZABLE), 0, mp->m_super->s_id);

You are suggesting that the correct approach is to add WQ_MEM_RECLAIM flag to WQs
used by filesystems when adding WQ_MEM_RECLAIM flag to the WQ used by loop module
introduces possibility of hitting

	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),

warning (instead of either adding __WQ_LEGACY | WQ_MEM_RECLAIM flags to the WQ used
by loop module or giving up WQ_MEM_RECLAIM flag for the WQ used by loop module),
correct?

