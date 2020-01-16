Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263E6C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 14:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F13B12075B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 14:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgAPOAH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 09:00:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:42742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgAPOAH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Jan 2020 09:00:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1341EAD5E;
        Thu, 16 Jan 2020 14:00:04 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 62CD91E06F1; Thu, 16 Jan 2020 15:00:04 +0100 (CET)
Date:   Thu, 16 Jan 2020 15:00:04 +0100
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: RFC: hold i_rwsem until aio completes
Message-ID: <20200116140004.GE8446@quack2.suse.cz>
References: <20200114161225.309792-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114161225.309792-1-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello!

On Tue 14-01-20 17:12:13, Christoph Hellwig wrote:
> Asynchronous read/write operations currently use a rather magic locking
> scheme, were access to file data is normally protected using a rw_semaphore,
> but if we are doing aio where the syscall returns to userspace before the
> I/O has completed we also use an atomic_t to track the outstanding aio
> ops.  This scheme has lead to lots of subtle bugs in file systems where
> didn't wait to the count to reach zero, and due to its adhoc nature also
> means we have to serialize direct I/O writes that are smaller than the
> file system block size.
> 
> All this is solved by releasing i_rwsem only when the I/O has actually
> completed, but doings so is against to mantras of Linux locking primites:
> 
>  (1) no unlocking by another process than the one that acquired it
>  (2) no return to userspace with locks held

I'd like to note that using i_dio_count has also one advantage you didn't
mention. For AIO case, if you need to hold i_rwsem in exclusive mode,
holding the i_rwsem just for submission part is a significant performance
advantage (shorter lock hold times allow for higher IO parallelism). I
guess this could be mitigated by downgrading the lock to shared mode
once the IO is submitted. But there will be still some degradation visible
for the cases of mixed exclusive and shared acquisitions because shared
holders will be blocking exclusive ones for longer time.

This may be especially painful for filesystems that don't implement DIO
overwrites with i_rwsem in shared mode...


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
