Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:62845 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfHLK5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 06:57:44 -0400
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801185057.GT30113@42.do-not-panic.com> <20190801204614.GD7138@magnolia>
 <20190802222158.GU30113@42.do-not-panic.com>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <126f1f28-de58-815c-bd37-424a06216884@i-love.sakura.ne.jp>
Date: Mon, 12 Aug 2019 19:57:27 +0900
MIME-Version: 1.0
In-Reply-To: <20190802222158.GU30113@42.do-not-panic.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>

On 2019/08/03 7:21, Luis Chamberlain wrote:
>> I'm pretty sure this didn't solve the underlying stale data exposure
>> problem, which might be why you think this is "opaque".  It fixes a bug
>> that causes data writeback failure (which was the exposure vector this
>> time) but I think the ultimate fix for the exposure problem are the two
>> patches I linked to quite a ways back in this discussion....
>>
>> --D
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=bd012b434a56d9fac3cbc33062b8e2cd6e1ad0a0
>> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=adcf7c0c87191fd3616813c8ce9790f89a9a8eba
> 
> Got it, thanks! Even with this, I still think the current commit could
> say a bit a more about the effects of not having this patch applied.
> What are the effects of say having the above two patches applied but not
> the one being submitted now?

Is this patch going to be applied as-is? Or, someone have a plan to rewrite the changelog?
