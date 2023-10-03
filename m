Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22E5E75450
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Oct 2023 11:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbjJCLdm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJCLdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 07:33:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCA69E
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 04:33:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE577C433C8;
        Tue,  3 Oct 2023 11:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696332818;
        bh=ee++UI9rCAbVlDSgbTxGIbC/RLW7SXPPa88vtIk/NU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r2+lyLkQaUjii+HT0uxwDGeMR+szTry7s5UVD29+Im3F/M4h5dbdNSHWpVocRzYiN
         Vg4lL94ToI3O0nqGai5X5epH7gzgFG3FY2uViDNFX6+YyprrYvD8nbCH/QpOBKuPke
         o2UfRMBu6C7xHDMC3wweHMwd3xlU5O9yFm9Vh3EtOWahIG4poYXEX0ntZ5yREGSo6u
         4oQ/EuQ4Khi5RWEwwZg9NynVeCVptF51g8mjtDVwMd+7++Ra+PRqSnV7+ujJHHjzM4
         5g2u29opIAl9fTnbNKXeWJ7f+Q71OLPpyoI7pp+rhBtMJp5WJyPsKc7H7O5v1RlFXf
         ytnfBIXx6vVag==
Date:   Tue, 3 Oct 2023 13:33:34 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.2 0/3] xfsprogs: force rebuilding of metadata
Message-ID: <20231003113334.zi7p7c77pqvesmfb@andromeda>
References: <iq6M2jOFTA7tpkemhj2B-jYNUxbdZWyn_T3zy7D3OK-XjdJMLzOaQp_x201-WWr0NRp1s5vaAspRGyQm7l2hqQ==@protonmail.internalid>
 <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 25, 2023 at 02:58:44PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This patchset adds a new IFLAG to the scrub ioctl so that userspace can
> force a rebuild of an otherwise consistent piece of metadata.  This will
> eventually enable the use of online repair to relocate metadata during a
> filesystem reorganization (e.g. shrink).  For now, it facilitates stress
> testing of online repair without needing the debugging knobs to be
> enabled.

Series look fine, although it requires a libxfs-sync to v6.6 before it can be
applied/tested.

Once I do a libxfs sync for v6.6 I'll apply/test this series.

By now, consider it a conditional RwB :)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos

> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-force-rebuild
> ---
>  io/scrub.c        |   24 ++++++++++++++-------
>  man/man8/xfs_io.8 |    3 +++
>  scrub/phase1.c    |   28 ++++++++++++++++++++++++
>  scrub/scrub.c     |   61 ++++++++++++++++++++++++++++-------------------------
>  scrub/scrub.h     |    1 +
>  scrub/xfs_scrub.c |    3 +++
>  scrub/xfs_scrub.h |    1 +
>  7 files changed, 84 insertions(+), 37 deletions(-)
> 
