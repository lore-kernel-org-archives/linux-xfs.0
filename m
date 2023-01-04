Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4242EC4708D
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Jan 2023 06:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbjADG6d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Jan 2023 01:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjADG6Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2023 01:58:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFCFDFD0;
        Tue,  3 Jan 2023 22:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38420B81203;
        Wed,  4 Jan 2023 06:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAB0C433D2;
        Wed,  4 Jan 2023 06:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672815492;
        bh=vWfykaBxFK2pbWTG8aqUgsTxDhfUAki+UHVh3CZ1kTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qwTIUFZ70fsAPevhykQFaIiev2rVp1Zi6w8IBwq0eEjefZZTS0vCq4zoZVpWesh/q
         +BQiFRv6kiTpn/0OYS6Ge3NjGTVzcH0zT9EWfba6XrDjW4X6ElYC3XjEDOt5iuF69R
         bSbsEN8OHTKbQL5JcvI/uhUmZpUlEXI730THT+mZKU95gXFs3KOH3TrUYJ+hjvcDEc
         792voQwfxHzXs8in+F8Wzpe3PnRZbukSaABO2HlkDYrxboe2cC+/K4K4QREP1aXcKh
         ZgfthXZGBf8M62pHfy5B14c4kbBDpx0X/jiFj6p/m+ScG+Br2yrRPSMDsY/0MWpryv
         WBuD1ek9Zzt3Q==
Date:   Tue, 3 Jan 2023 22:58:10 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/4] fsverity cleanups
Message-ID: <Y7UjgiewvGecg9XQ@sol.localdomain>
References: <20221214224304.145712-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214224304.145712-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 14, 2022 at 02:43:00PM -0800, Eric Biggers wrote:
> This series implements a few cleanups that have been suggested 
> in the thread "[RFC PATCH 00/11] fs-verity support for XFS"
> (https://lore.kernel.org/linux-fsdevel/20221213172935.680971-1-aalbersh@redhat.com/T/#u).
> 
> This applies to mainline (commit 93761c93e9da).
> 
> Eric Biggers (4):
>   fsverity: optimize fsverity_file_open() on non-verity files
>   fsverity: optimize fsverity_prepare_setattr() on non-verity files
>   fsverity: optimize fsverity_cleanup_inode() on non-verity files
>   fsverity: pass pos and size to ->write_merkle_tree_block
> 
>  fs/btrfs/verity.c        | 19 ++++-------
>  fs/ext4/verity.c         |  6 ++--
>  fs/f2fs/verity.c         |  6 ++--
>  fs/verity/enable.c       |  4 +--
>  fs/verity/open.c         | 46 ++++---------------------
>  include/linux/fsverity.h | 74 +++++++++++++++++++++++++++++++++-------
>  6 files changed, 84 insertions(+), 71 deletions(-)
> 
> 

Applied for 6.3.  (To
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=fsverity for now,
but there might be a new git repo soon, as is being discussed elsewhere.)

- Eric
