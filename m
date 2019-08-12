Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:64218 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfHLK7h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 06:59:37 -0400
Subject: Re: [PATCH] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.
References: <62ec978e-c045-80ad-24a6-41da07d1b37d@i-love.sakura.ne.jp>
 <1564658887-12654-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801203945.GC7138@magnolia>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <6e50eef5-434e-a81e-9001-f3deabfa7cc9@i-love.sakura.ne.jp>
Date: Mon, 12 Aug 2019 19:59:30 +0900
MIME-Version: 1.0
In-Reply-To: <20190801203945.GC7138@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 2019/08/02 5:39, Darrick J. Wong wrote:
> On Thu, Aug 01, 2019 at 08:28:07PM +0900, Tetsuo Handa wrote:
>> Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
>> we can remove KM_NOSLEEP and replace KM_SLEEP with 0.
>>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> Ahh, right, KM_{NO,}SLEEP are mutually exclusive values encoded
> alongside a bit flag set (ala fallocate mode)....
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Thank you. Please apply to xfs tree.
