Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C34CC7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjFFJRE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbjFFJQw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53448E49
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC6862F76
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 09:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDDFC433A1;
        Tue,  6 Jun 2023 09:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686043007;
        bh=v+E9ITGDjmpL4nNKytGq1LaTsrO3U4Yr3AtrPdMbI04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z1Q0XkxtWduT1Dwn+3hea1KNSyaXMaADnLxwGgirbww/tibB4pSNYPyIagpqUnL0P
         V5xP0xfuoZfI5a9ID8N6U8TLFZBeSDvw3bi1yGL2Y0RMeqABxg/0qsWiGIUAr3sEYX
         cOMdeJsqb3FIn9gSDJkFNXrnbsFGLKEPS4nD+CsQvk0NAVXruohdaIyNASpLbzvqSZ
         jVJlMvoYU3HSNF1Nzzvf8D+ItZE81CO4BmrUKd3Ssx6Ke+8fkKCIl573WO4/6HoLSn
         jlWGPh1YYgpADTOFKeZnWC2q/juO/Tge6GdSCQSQryMVQNEnA9FTCqtSRdue1D1OTF
         u57lKMQ4DGv4Q==
Date:   Tue, 6 Jun 2023 11:16:43 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/2] xfs_repair: fix missing corruption detection
Message-ID: <20230606091643.gc72r6wxkadenyy2@andromeda>
References: <ylt88sC7wPqlsEe-9kVGAOzvu9xJonNujqD2n1YCftGJgq3r3dGy0wswBrjsSKtsPcypJo5q9wncj9pGilR8BQ==@protonmail.internalid>
 <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:37:18AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> As part of QAing the parent pointers patchset, I noticed a couple of bad
> bugs in xfs_repair.  The first is our handling of directories containing
> the same name more than once -- we flag that and store both names, but
> then we rebuild the directory with both of the offending names!  So, fix
> that.
> 
> The other problem I noticed is that if the inobt is broken, many inodes
> end up in the uncertain list.  Those files will get added back to the
> filesystem indexes without the attr forks being checked, which means
> that any corruption in them will not be found or fixed.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 

Looks good, will test.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos

> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fix-da-breakage
> ---
>  repair/dino_chunks.c |    6 ++++--
>  repair/phase6.c      |    3 ++-
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
