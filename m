Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C731E75450
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Oct 2023 11:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjJCLrW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjJCLrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 07:47:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDEBA3
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 04:47:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351EDC433C8;
        Tue,  3 Oct 2023 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696333639;
        bh=muez06mnvvrLvPPKvCakQCI4uvfmyp96hXfruY19sgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PzYWtxhJnBF+B96amHIEEWXudqJ1xfdiz2E3ip4aYRQbWTOpXLUt7XjTlhu/pNbTy
         MF630u+KaLDn9xV9PBwvEOE0qLe4+ctX6jZ9SqgQPUUyrEGfCdO8LDUrL3nscnKSzc
         HIT5PEsOEA3rs08D4aUyII3yRDgQGTMCf3oEPwn7k6XRtRv2tD+ycQh5qjVkljlnYI
         YvvToyHSV5b6ts76GUkKwJTkc08GUQ0vUxyiP5RntukdQ7qmA3R0O/NHWyK5nCYq+t
         4vfwBHoldr+kUB8FfuwBeBcbga4507fl0unUP5eBYyUwIpUSAVLqsmP6f1dAQ0A/+u
         o8eX5jupP7/jw==
Date:   Tue, 3 Oct 2023 13:47:15 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/2] xfs_db: use directio for filesystem access
Message-ID: <20231003114715.jwze4wspx7wd2mtu@andromeda>
References: <KT7JxvGZnq9-QNN8kBpbKekDJ2BKLQOGCjpSETPSGhPryNhXo_L71VZTCaXaI2AY3cjBINdJO97ZbUCOOYZSeg==@protonmail.internalid>
 <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 25, 2023 at 02:59:04PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> xfs_db doesn't even try to use directio to access block devices.  This
> is rather strange, since mkfs, copy, and repair use it.  Modify xfs_db
> to set LIBXFS_DIRECT so that we don't have to deal with the bdev
> pagecache being out of sync with what the kernel might have written
> directly to the block device.
> 
> While we're at it, if we're using directio to the block device, don't
> fail if we can't set the bufferhead size to the sectorsize, because
> we're not using the pagecache anyway.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

The series looks good, thanks!

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos

> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=db-use-directio
> ---
>  db/init.c     |    1 +
>  libxfs/init.c |    8 ++++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
