Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666CEC05027
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Feb 2023 22:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbjBCWBR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Feb 2023 17:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjBCWBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2023 17:01:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE67AB5D7;
        Fri,  3 Feb 2023 14:01:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 903D661DC6;
        Fri,  3 Feb 2023 22:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC5EC433EF;
        Fri,  3 Feb 2023 22:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675461672;
        bh=lJxffqdWzxp/gjecxBLsk6CKKLep4wnATuGV7wIwWXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fSvDQVx4b8d/9omyX+q+Lkl27HbwdbA8fMo0tT6G7WLu6rxGtTrt4AV0NRvZUnLpe
         Ib82KlOwfRQRMaxdUymUnJrs1A+HbNA5YK1vneClFms3KaNbZBbtspyQF17ISFUGi4
         iLoqBpDOHm1T5xH1CHNe4U3neyHZ7f1Nk1wa0pYpR6YHIhRn4M4zNtEovCiXuCj1NH
         SB2Jhfc7SfQOIP+ltLZs4XVjrn0mnfJ9zzsPSzFs1HfbKuGRIpL+j/IUYWIJHdzM5v
         r5k2yJmMrpSpQzqg3L2DqKkWEO6P3AfJseQcA2Apa5Karc8KfqlrTYffJQc+sLkPqq
         r4E8FeRJkw7Ag==
Date:   Fri, 3 Feb 2023 14:01:10 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH v2 00/11] fsverity: support for non-4K pages
Message-ID: <Y92EJjAHpwmagmTb@sol.localdomain>
References: <20221223203638.41293-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223203638.41293-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 23, 2022 at 12:36:27PM -0800, Eric Biggers wrote:
>   ext4: simplify ext4_readpage_limit()
>   f2fs: simplify f2fs_readpage_limit()
>   fs/buffer.c: support fsverity in block_read_full_folio()
>   ext4: allow verity with fs block size < PAGE_SIZE

I'd still appreciate acks from the other ext4 and f2fs developers on these!

- Eric
