Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:54597 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHAL1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 07:27:54 -0400
Subject: Re: [PATCH] fs: xfs: Remove unused KM_NOSLEEP, change KM_SLEEP to 0.
References: <1564654042-9088-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801105537.GM7777@dread.disaster.area>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <62ec978e-c045-80ad-24a6-41da07d1b37d@i-love.sakura.ne.jp>
Date: Thu, 1 Aug 2019 20:27:47 +0900
MIME-Version: 1.0
In-Reply-To: <20190801105537.GM7777@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 2019/08/01 19:55, Dave Chinner wrote:
> On Thu, Aug 01, 2019 at 07:07:22PM +0900, Tetsuo Handa wrote:
>> Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
>> but removing KM_SLEEP requires modification of 97 locations, let's remove
>> KM_NOSLEEP branch and (for now) change KM_SLEEP to 0.
> 
> Just remove KM_SLEEP. It's trivial to do with a couple of quick sed
> scripts.

If you don't mind dropping "(__force xfs_km_flags_t)" cast, I can do it
within this patch (and will post as a reply to this message).
