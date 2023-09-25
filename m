Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9891CD54BE
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 19:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjIYTMb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 15:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbjIYTMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 15:12:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD4CBF;
        Mon, 25 Sep 2023 12:12:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5F4C433C7;
        Mon, 25 Sep 2023 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695669145;
        bh=PucnFeDcAVN1NNbBCz02YwzzvcIbDN/zcCe/g6iWNXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ha83ywe8nzG74DwN50jjgF6EqMzm70gYzSy7mDqmlZpHRhpAootFFMoqQPS3eD3KN
         MJa7lxWCrXQtbGhKWe59lNMIuQAK9jCKPIF6Ysr6uapbY/+FjeYYnzU/yXEy09bVq7
         r2ZgwdFgQzrCHjZb0IUR0bZRJdWqpCJJ7rc+u/BHr6u1xGgAlOYmEowCNDeWcv4Phf
         OLAUjPwxKLsGU3QyHSIvIjWReCY5Z04Oo0+Uc0zUun9svRs5JwvXndevgAwVt7KBwC
         eSfYcYFuvFBAlwKFgOPCYSvvm2Cj6cx3dNojKEaGgn/ESAvaeI0eyKO/Izm/KK7VOs
         1ICOaviIYQZuQ==
Date:   Mon, 25 Sep 2023 15:12:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 5.15 1/6] xfs: bound maximum wait time for inodegc work
Message-ID: <ZRHbl0XZlpLBLU4H@sashalap>
References: <20230922010156.1718782-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230922010156.1718782-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2023 at 06:01:51PM -0700, Leah Rumancik wrote:
>From: Dave Chinner <dchinner@redhat.com>
>
>[ Upstream commit 7cf2b0f9611b9971d663e1fc3206eeda3b902922 ]
>
>Currently inodegc work can sit queued on the per-cpu queue until
>the workqueue is either flushed of the queue reaches a depth that
>triggers work queuing (and later throttling). This means that we
>could queue work that waits for a long time for some other event to
>trigger flushing.
>
>Hence instead of just queueing work at a specific depth, use a
>delayed work that queues the work at a bound time. We can still
>schedule the work immediately at a given depth, but we no long need
>to worry about leaving a number of items on the list that won't get
>processed until external events prevail.
>
>Signed-off-by: Dave Chinner <dchinner@redhat.com>
>Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
>Acked-by: Darrick J. Wong <djwong@kernel.org>

Queued up all 6, thanks!

-- 
Thanks,
Sasha
