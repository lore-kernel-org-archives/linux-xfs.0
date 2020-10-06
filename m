Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2820C4741F
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 14:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3E420760
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 14:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgJFOFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 10:05:10 -0400
Received: from sandeen.net ([63.231.237.45]:37530 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgJFOEU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 10:04:20 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A995248C696;
        Tue,  6 Oct 2020 09:03:21 -0500 (CDT)
To:     Pavel Reichl <preichl@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201005213852.233004-1-preichl@redhat.com>
 <20201005213852.233004-5-preichl@redhat.com>
 <20201006041426.GH49547@magnolia>
 <1796931d-fe5d-2d81-e5bc-2369f89a4688@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <c2349a06-8ad3-664c-9510-40394fb08288@sandeen.net>
Date:   Tue, 6 Oct 2020 09:04:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1796931d-fe5d-2d81-e5bc-2369f89a4688@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/6/20 5:50 AM, Pavel Reichl wrote:
>> Also, we're not really releasing the lock itself here, right?  We're
>> merely updating lockdep's bookkeepping so that the worker can make
>> itself look like the lock owner (to lockdep, anyway).
> Hmm...I'm afraid I don't follow - yes we are doing this to satisfy lockdep's bookkeeping,
> however we actually do this by releasing the lock in one kernel thread and acquiring it in another.

it's the difference between actually releasing the lock itself, and
telling lockdep that we're releasing the "ownership" of the lock for tracking
purposes; I agree that "rwsem_release" is a bit confusingly named.

> 
>> Does this exist as a helper anywhere in the kernel?  I don't really like
>> XFS poking into the rw_semaphore innards, though I concede that this
>> lock transferring dance is probably pretty rare.
> I'll try to look for it.
> 

Other code I see just calls rwsem_release directly - ocfs2, jbd2, kernfs etc.

I think a clearer comment might suffice, not sure what Darrick thinks, maybe something
like this:

+	/*
+	 * Let lockdep know that we won't own i_lock when we hand off
+	 * to the worker thread
+	 */
+	rwsem_release(&cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
 	queue_work(xfs_alloc_wq, &args.work);
+
 	wait_for_completion(&done);
+	/* We own the i_lock again */
+	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);

and similar comments in the worker:

+	/* Let lockdep know that we own the i_lock for now */
+	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
...

etc

-Eric
