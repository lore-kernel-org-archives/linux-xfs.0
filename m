Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E731C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 22:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLTWzr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 17:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLTWzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 17:55:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A36810C3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 14:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92CB6B81A40
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 22:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31260C433D2;
        Tue, 20 Dec 2022 22:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671576942;
        bh=9STm0HhHbUfuZ4BE7lXoLEHC3jdSnO12bfmTztliyYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NkHD+iJgRdCpFd7bRBGeH6d+icDac/DtFMd+8zLXLLKmm17qlVuCtOQF0PXMMjrZ/
         0sANpzi6fquUwicc59FdCeczz1yHPtEJvP0q+N9S+GqstrGQ/VkV1wIQ/YwzF5iKSD
         ydVIndwf1V26ZPRi48lLb5A4QfXCYzEd7lM+UqEWCX/RIVvr/Ewcc/pzOKucOl1Eed
         v7Dzv66a7UvzqZDNdhuMYB6laxO2XrHfoqKCzIYge/zonGGXEZ6unHWIxD9zIJwn6J
         Ere+zyO4aczNmrO363MuVq6xzBFvSvFWUUxCi/Kn7DY+9joTjO2tTl0Kry6zX4odx6
         40iY4KvnHQqhw==
Date:   Tue, 20 Dec 2022 14:55:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: Question about xfs/440
Message-ID: <Y6I9bdpTFhsa+eLW@magnolia>
References: <OS3PR01MB9499A747D11EFFD2654354D483E69@OS3PR01MB9499.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <OS3PR01MB9499A747D11EFFD2654354D483E69@OS3PR01MB9499.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 16, 2022 at 01:02:18PM +0000, yangx.jy@fujitsu.com wrote:
> Hi Darrick,
> 
> As you know, the following steps comes from xfs/440. I have two
> questions about these steps.
> The first one:
> Why repquota -u command shows "128" rather than "64" for fsgqa user
> after cp --reflink command is completed?

Quota resource usage are charged for each file, even for shared blocks.
There's no easy way to amortize the cost of a shared block among its
owners unless you can walk backwards from a piece of storage back to its
owners, which is too much work to make it worth the effort.

Hence reflinking a 64k file to another file creates 128k worth of usage.

> The second one:
> Why repquota -u command shows "1152" for fsgqa user after CoW(Copy on
> Write) is completed?

The space extents used to stage COW operations are separate space
allocations, which means they're charged to the quota and hang around
until writeback happens.  In xfs/440, we set a cow extent size hint of
1mb, so we've actually staged 1mb of cow so that appending writes to /b
will end up in contiguous space.  That's why usage goes from 128 to
1152.

--D

> 
> How does the kernel process reflink and CoW?
> How does the kernel calculate the number(e.g. 128，1152)?
> 
> # mount -o usrquota,grpquota /dev/pmem1 /mnt/scratch/
> # touch /mnt/scratch/a /mnt/scratch/force_fsgqa
> # chown fsgqa /mnt/scratch/a /mnt/scratch/force_fsgqa
> # xfs_io -c "pwrite -S 0x58 0 64k" /mnt/scratch/a
> # repquota -u /mnt/scratch/
> ...
>                         Block limits                File limits
> User            used    soft    hard  grace    used  soft  hard  grace
> ----------------------------------------------------------------------
> root      --       0       0       0              3     0     0
> fsgqa     --      64       0       0              2     0     0
> 
> # cp --reflink=always -p /mnt/scratch/a /mnt/scratch/b
> # repquota -u /mnt/scratch/
> ...
>                         Block limits                File limits
> User            used    soft    hard  grace    used  soft  hard  grace
> ----------------------------------------------------------------------
> root      --       0       0       0              3     0     0
> fsgqa     --     128       0       0              3     0     0
> 
> # xfs_io -c "pwrite -S 0x59 0 64k" /mnt/scratch/a
> # repquota -u /mnt/scratch/
> ...
>                         Block limits                File limits
> User            used    soft    hard  grace    used  soft  hard  grace
> ----------------------------------------------------------------------
> root      --       0       0       0              3     0     0
> fsgqa     --    1152       0       0              3     0     0
> 
> Best Regards,
> Xiao Yang
