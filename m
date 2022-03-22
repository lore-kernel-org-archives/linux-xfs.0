Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779D8C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 22:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiCVWH3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 18:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiCVWH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 18:07:27 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28536E008
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 15:05:59 -0700 (PDT)
Received: from fsav112.sakura.ne.jp (fsav112.sakura.ne.jp [27.133.134.239])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22MM5v3O074199;
        Wed, 23 Mar 2022 07:05:57 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav112.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp);
 Wed, 23 Mar 2022 07:05:57 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22MM5u6a074194
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 23 Mar 2022 07:05:57 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <342c3dee-2acc-3983-ab38-7afe6c5ea677@I-love.SAKURA.ne.jp>
Date:   Wed, 23 Mar 2022 07:05:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>, Dave Chinner <david@fromorbit.com>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
 <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
 <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
 <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
 <20220322220007.GQ1544202@dread.disaster.area>
 <YjpHjRoq+WtOAmut@slm.duckdns.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YjpHjRoq+WtOAmut@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/03/23 7:02, Tejun Heo wrote:
> Hello,
> 
> On Wed, Mar 23, 2022 at 09:00:07AM +1100, Dave Chinner wrote:
>>> Yeah, you detected multiple issues at the same time. xfs sync is
>>> participating in memory reclaim
>>
>> No it isn't. What makes you think it is part of memory reclaim?
>>
>> The xfs-sync workqueue exists solely to perform async flushes of
>> dirty data at ENOSPC via sync_inodes_sb() because we can't call
>> sync_inodes_sb directly in the context that hit ENOSPC due to locks
>> and transaction contexts held. The paths that need this are
>> buffered writes and file create (on disk inode allocation), neither
>> of which are in the the memory reclaim path, either.
>>
>> So this work has nothing to do with memory reclaim, and as such it's
>> not tagged with WQ_MEM_RECLAIM.
> 
> Hmmm... yeah, I actually don't know the exact dependency here and the
> dependency may not be real - e.g. the conclusion might be that loop is
> conflating different uses and needs to split its use of workqueues into two
> separate ones. Tetsuo, can you post more details on the warning that you're
> seeing?
> 

It was reported at https://lore.kernel.org/all/20210322060334.GD32426@xsang-OptiPlex-9020/ .
