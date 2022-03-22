Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8E5C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 23:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiCVXeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 19:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbiCVXeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 19:34:20 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89A76E29C
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 16:32:51 -0700 (PDT)
Received: from fsav118.sakura.ne.jp (fsav118.sakura.ne.jp [27.133.134.245])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22MNWno9016886;
        Wed, 23 Mar 2022 08:32:49 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav118.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp);
 Wed, 23 Mar 2022 08:32:49 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22MNWnoQ016883
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 23 Mar 2022 08:32:49 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <fd10ea3c-fb18-2bb0-d630-4d3cb1f48394@I-love.SAKURA.ne.jp>
Date:   Wed, 23 Mar 2022 08:32:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, Tejun Heo <tj@kernel.org>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
 <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
 <20220322220007.GQ1544202@dread.disaster.area>
 <YjpHjRoq+WtOAmut@slm.duckdns.org>
 <342c3dee-2acc-3983-ab38-7afe6c5ea677@I-love.SAKURA.ne.jp>
 <YjpLfK+glfSPe09Q@slm.duckdns.org>
 <20220322225914.GR1544202@dread.disaster.area>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20220322225914.GR1544202@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/03/23 7:59, Dave Chinner wrote:
> I don't know what the solution is, but if the fix is "xfs needs to
> mark a workqueue that has nothing to do with memory reclaim as
> WQ_MEM_RECLAIM because of the loop device" then we're talking about
> playing workqueue whack-a-mole across the entire kernel forever
> more....

During an attempt to fix lockdep warning caused by calling destroy_workqueue()
when loop device's autoclear operation is triggered with disk->open_mutex held,
Christoph has proposed a patch which avoids calling destroy_workqueue() by using
a global WQ. But like demonstrated at
https://lkml.kernel.org/r/22b51922-30c6-e4ed-ace9-5620f877682c@i-love.sakura.ne.jp ,
I confirmed that the loop module needs to reserve one "struct task_struct" on each
loop device's WQ. And creating per loop device WQ with WQ_MEM_RECLAIM flag is the
only available method for reserving "struct task_struct" on each loop device's WQ.
That is, WQ_MEM_RECLAIM flag is required for not only surviving memory pressure
situation but also surviving max active limitation.

But like demonstrated at
https://lkml.kernel.org/r/61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp ,
creating per loop device WQ with WQ_MEM_RECLAIM flag without __WQ_LEGACY flag will hit
this "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing !WQ_MEM_RECLAIM %s:%ps" warning.

And if WQs used by filesystem side do not want to use WQ_MEM_RECLAIM flag, the loop
module would have to abuse __WQ_LEGACY flag in order to suppress this warning.
