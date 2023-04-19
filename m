Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C9EC77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 02:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjDSCKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 22:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjDSCKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Apr 2023 22:10:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C552658E
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2023 19:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26C7060B3B
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 02:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F33C433EF;
        Wed, 19 Apr 2023 02:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681870199;
        bh=0ISgh61QyytmDwc2E389w2odJiNQ7+YbLgyUAakQkM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gT1WFrQY2KXMHz9EKDn8O6r9ob7TJTbrqxRJGmqO0CmP5AmxOByfSwlY8xC3NICYw
         WDSqTg2HOyicSpHtQ3hk0GSssoxI7ZmK0sGTgVABMH5y3Su4X6WLhqzRPNnPrmorgy
         kWE9NjUlndK168WAKCGiFDwfISGD3XnpIBrhMF+vllBYd9BEz49FJbgaKA7Elg75QA
         irOBqlzh1Q0EhD0CROue1UTp5IdmT2wKpLRbNxkoEBjadtyLmo/23k6AsLTA261g/H
         Y1iTGimCB+rulmd+na8jLmvXy8p8/PcDgrA0OEdbQhP/NEY3MIg0OJBwxsT8JsX4Eb
         TMbHdlteVusFA==
Date:   Tue, 18 Apr 2023 19:09:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: could we add superblock to xfs logdev/rtdev?
Message-ID: <20230419020958.GD360889@frogsfrogsfrogs>
References: <20230419095757.220A.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419095757.220A.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2023 at 09:57:59AM +0800, Wang Yugui wrote:
> Hi,
> 
> could we add superblock to xfs logdev/rtdev?
> 
> then it will be reported by blkid well,
> and then we can find logdev/rtdev auto when xfs mount?

Some day we'll get to reviewing this, but online fsck, parent pointers,
and (probably) fsverity are first in line.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

--D

> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2023/04/19
> 
> 
