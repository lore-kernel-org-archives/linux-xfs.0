Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfHLTyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:54:18 -0400
Date: Mon, 12 Aug 2019 12:54:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.
Message-ID: <20190812195409.GJ7138@magnolia>
References: <62ec978e-c045-80ad-24a6-41da07d1b37d@i-love.sakura.ne.jp>
 <1564658887-12654-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801203945.GC7138@magnolia>
 <6e50eef5-434e-a81e-9001-f3deabfa7cc9@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e50eef5-434e-a81e-9001-f3deabfa7cc9@i-love.sakura.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Aug 12, 2019 at 07:59:30PM +0900, Tetsuo Handa wrote:
> On 2019/08/02 5:39, Darrick J. Wong wrote:
> > On Thu, Aug 01, 2019 at 08:28:07PM +0900, Tetsuo Handa wrote:
> >> Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
> >> we can remove KM_NOSLEEP and replace KM_SLEEP with 0.
> >>
> >> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > 
> > Ahh, right, KM_{NO,}SLEEP are mutually exclusive values encoded
> > alongside a bit flag set (ala fallocate mode)....
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> 
> Thank you. Please apply to xfs tree.

Will do.

--D
