Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0823CD98E6
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 03:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344954AbjJKDGw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 23:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344939AbjJKDGv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 23:06:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B8B94
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2023 20:06:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8BEC433C8;
        Wed, 11 Oct 2023 03:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696993608;
        bh=zcsVFpW9VLyMPFD7tqkCxIR2MRFUnQPc2SsPeS78L0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n4GW7n2F1o8I/2ixJJmELu6wEdrpK+3YiId36NQ75+IfTaq0IZPUiCV8KkoWwv6wG
         osXVi4pdfmp21JNP3nH3dWRPj0lg3A8w1Ar9i2xvxK7c8YkWJZOkpFk3T5WK1u5hSH
         WVvaWfcjhaDTuzAbCdbZgOs42FkUgNVvp+KDVN1ktAZjyUk4kPZKj98ttwOwjqK5qK
         De5ZiuYywWkpndR1+bm5K/u+zpIogtgIswZuoDiPFX1IkHf7fwyjQu2bx8kf6qTJSO
         0Gryks1lmlwfhWMtBi3GzS2jCrkXha7f30PCPRgLpWxKKw3gXCbbLwMR57gTS0+NQH
         2f0ddtE/os6tQ==
Date:   Tue, 10 Oct 2023 20:06:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 06/28] fsverity: add drop_page() callout
Message-ID: <20231011030646.GA1185@sol.localdomain>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-7-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-7-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:00PM +0200, Andrey Albershteyn wrote:
> Allow filesystem to make additional processing on verified pages
> instead of just dropping a reference. This will be used by XFS for
> internal buffer cache manipulation in further patches. The btrfs,
> ext4, and f2fs just drop the reference.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/verity/read_metadata.c |  4 ++--
>  fs/verity/verify.c        |  6 +++---
>  include/linux/fsverity.h  | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 5 deletions(-)

The changes from this patch all get superseded by the changes in patch 10 that
make it drop_block instead.  So that puts this patch in a weird position where
there's no real point in reviewing it alone.  Maybe fold it into patch 10?  I
suppose you're trying not to make that patch too large, but perhaps there's a
better way to split it up.

- Eric
