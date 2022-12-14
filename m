Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F294C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 12:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237841AbiLNMeO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Dec 2022 07:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237905AbiLNMdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2022 07:33:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8A5275F9
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 04:31:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 057E461A14
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 12:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A22C433D2;
        Wed, 14 Dec 2022 12:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671021094;
        bh=HxOR82ZmL5ri/H04itHIvf72WHysRAlzH8AXy+SIFjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BidZVj0SLOHtdEDH2dMnjL7FXZLTqPowPH/nrAKeSOpyQor9IotHgpoC60DdmkLZN
         SPeopOzrLPNp/SXgvaXGhahyOP6dLDEXlVknPGmBCfF9gM4ItID2OGfDrLxb1c0otA
         j0tHQSRPvuwm55aLAluZxWssnD5v2v3oBOHcifKlkUO0gt5UYecgjBlabFq+BSzBCH
         rL2Go2qYx67dlSBb/BYVYkUWPgzbGBJEKif7pb8B9Y8ST5LnzeGd7/Oj5Z0wFf0OA6
         ozVD8GxlxdtKaFIpkiW5uh3jVNRh4dKEAZCFC8ZeuRvDuruztD7h6RuNwk61STfOax
         ZdiG8abFixaFg==
Date:   Wed, 14 Dec 2022 13:31:29 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/2] xfsprogs: random fixes for 6.1, part 2
Message-ID: <20221214123129.prfhdw5muaw4zfdr@andromeda>
References: <WB-YtuPdt3dQP5Mq_d7zIPvl9D2SwK2INUA72m_LPSP0m8TCLLKHpROJHWeh3WR6__1UfPyVJjOMyBQAUvzXBQ==@protonmail.internalid>
 <167096037742.1739636.10785934352963408920.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167096037742.1739636.10785934352963408920.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 11:39:37AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This is the second rollup of all the random fixes I've collected for
> xfsprogs 6.1.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 

Series looks good, will test.
Thanks Darrick.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.1
> ---
>  db/btblock.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  db/btblock.h |    6 +++++
>  db/field.c   |    8 +++++++
>  db/field.h   |    4 +++
>  db/type.c    |    6 ++---
>  io/fsmap.c   |    4 ++-
>  6 files changed, 93 insertions(+), 5 deletions(-)
> 

-- 
Carlos Maiolino
