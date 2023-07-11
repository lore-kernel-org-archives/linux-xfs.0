Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46500C001DF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 15:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjGKPns (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 11:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbjGKPnJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 11:43:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73A1736
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 08:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D6B61529
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 15:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85158C433C9;
        Tue, 11 Jul 2023 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689090174;
        bh=CTZv+uGsbkFWSSp5DdKL+xgjoPEBdNgMCK1onOOx54c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eLeUa+WyQpoyeGo78KyDh8kef3WEbVJrehkA3GZvnl0fS/N+KWtQ71NJeLdaeDjqL
         8tImx++E8m4aA7L4gxSk3eNJ48P6PBS2A4VTIWIef+qVUgwaN1Q2yf+3BY43I8FqJ8
         bkAa6n02SyMfKKSSrjT6FiVF1WpsuV3stzKLHKRQ5y09PXGhlCdm4vpcI0iorAoEPa
         KbxVl8Qf3/aZYiOkb6OCeEleJLpkQc4cThK6e/rQ5YtUjBM6OYssOJQ+i2XTJrRG84
         1Jd+1pKOsDMzzvOHR4IflnvgabR1mQUEY6bePR5fOq98jCgMazn1mNHnOF1cRdP2Jt
         QeOFOK2Le/Uug==
Date:   Tue, 11 Jul 2023 08:42:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Eugene K." <eugene@railglorg.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS writing issue
Message-ID: <20230711154254.GC108251@frogsfrogsfrogs>
References: <583703ce-1515-a436-1f34-3386150a03c2@railglorg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <583703ce-1515-a436-1f34-3386150a03c2@railglorg.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 05:31:13PM +0200, Eugene K. wrote:
> Hello.
> 
> During investigation of flapping performance problem, it was detected that
> once a process writes big amount of data in a row, the filesystem focus on
> this writing and no other process can perform any IO on this filesystem.
> 
> We have noticed huge %iowait on software raid1 (mdraid) that runs on 2 SSD
> drives - on every attempt to write more than 1GB.
> 
> The issue happens on any server running 6.4.2, 6.4.0, 6.3.3, 6.2.12 kernel.
> Upon investigating and testing it appeared that server IO performance can be
> completely killed with a single command:
> 
> #cat /dev/zero > ./removeme
> 
> assuming the ~/removeme file resides on rootfs and rootfs is XFS.
> 
> While running this, the server becomes so unresponsive that after ~15
> seconds it's not even possible to login via ssh!
> 
> We did reproduce this on every machine with XFS as rootfs running mentioned
> kernels. However, when we converted rootfs from XFS to EXT4(and btrfs), the
> problem disappeared - with the same OS, same kernel binary, same hardware,
> just using ext4 or btrfs instead of xfs.

So use ext4.

--D

> Note. During the hang and being unresponsive, SSD drives are writing data at
> expected performance. Just all the processes except the writing one hang.
> 
> 
