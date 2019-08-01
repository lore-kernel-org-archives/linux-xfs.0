Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56772 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbfHAK4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 06:56:47 -0400
Date: Thu, 1 Aug 2019 20:55:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: xfs: Remove unused KM_NOSLEEP, change KM_SLEEP to 0.
Message-ID: <20190801105537.GM7777@dread.disaster.area>
References: <1564654042-9088-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564654042-9088-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 07:07:22PM +0900, Tetsuo Handa wrote:
> Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
> but removing KM_SLEEP requires modification of 97 locations, let's remove
> KM_NOSLEEP branch and (for now) change KM_SLEEP to 0.

Just remove KM_SLEEP. It's trivial to do with a couple of quick sed
scripts.

Off the top of my head, this should largely do it:

for f in `git grep -l KM_SLEEP fs/xfs`; do \
	 sed -i -e 's/KM_SLEEP | //' \
		 -e 's/KM_SLEEP|//' \
		 -e 's/KM_SLEEP)/0)/' $f; \
done


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
