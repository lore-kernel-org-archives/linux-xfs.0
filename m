Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:65395 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731215AbfHAVNf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 17:13:35 -0400
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801185057.GT30113@42.do-not-panic.com>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <e901d22d-18b5-abde-15d1-777a6417f6c8@i-love.sakura.ne.jp>
Date: Fri, 2 Aug 2019 06:13:12 +0900
MIME-Version: 1.0
In-Reply-To: <20190801185057.GT30113@42.do-not-panic.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>

On 2019/08/02 3:50, Luis Chamberlain wrote:
> That's quite an opaque commit log for what started off as a severe email
> thread of potential leak of information. As such, can you expand on this
> commit log considerably to explain the situation a bit better? Your
> initial thread here provided much clearer evidence of the issue. As-is
> this commit log tells the reader *nothing* about the potential harm in
> not applying this patch.
> 
> You had mentioned you identified this issue present on at least
> 4.18 till 5.3-rc1. So, I'm at least inclined to consider this for
> stable for at least v4.19.
> 
> However, what about older kernels? Now that you have identified
> a fix, were the flag changed in prior commits, is it a regression
> that perhaps added KM_MAYFAIL at some point?

I only checked 4.18+ so that RHEL8 will backport this patch. According to
Brian Foster, commit eb01c9cd87 ("[XFS] Remove the xlog_ticket allocator")
( https://git.kernel.org/linus/eb01c9cd87 ) which dates back to April 2008
added KM_MAYFAIL flag for this allocation

-	buf = (xfs_caddr_t) kmem_zalloc(PAGE_SIZE, KM_SLEEP);
+	tic = kmem_zone_zalloc(xfs_log_ticket_zone, KM_SLEEP|KM_MAYFAIL);

though Dave Chinner thinks that the log ticket rework is irrelevant.
Do we need to find which commit made this problem visible?
