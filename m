Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A465C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 04:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiA0ETk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jan 2022 23:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiA0ETj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jan 2022 23:19:39 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE750C06161C;
        Wed, 26 Jan 2022 20:19:38 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nCwFy-005E2b-3w; Thu, 27 Jan 2022 04:19:34 +0000
Date:   Thu, 27 Jan 2022 04:19:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125224551.GQ59729@dread.disaster.area>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 26, 2022 at 09:45:51AM +1100, Dave Chinner wrote:

> Right, background inactivation does not improve performance - it's
> necessary to get the transactions out of the evict() path. All we
> wanted was to ensure that there were no performance degradations as
> a result of background inactivation, not that it was faster.
> 
> If you want to confirm that there is an increase in cold cache
> access when the batch size is increased, cpu profiles with 'perf
> top'/'perf record/report' and CPU cache performance metric reporting
> via 'perf stat -dddd' are your friend. See elsewhere in the thread
> where I mention those things to Paul.

Dave, do you see a plausible way to eventually drop Ian's bandaid?
I'm not asking for that to happen this cycle and for backports Ian's
patch is obviously fine.

What I really want to avoid is the situation when we are stuck with
keeping that bandaid in fs/namei.c, since all ways to avoid seeing
reused inodes would hurt XFS too badly.  And the benchmarks in this
thread do look like that.

Are there any realistic prospects of having xfs_iget() deal with
reuse case by allocating new in-core inode and flipping whatever
references you've got in XFS journalling data structures to the
new copy?  If I understood what you said on IRC correctly, that is...

Again, I'm not asking if it can be done this cycle; having a
realistic path to doing that eventually would be fine by me.
