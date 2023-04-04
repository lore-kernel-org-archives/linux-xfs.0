Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9B8C761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 17:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbjDDRRd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 13:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbjDDRR1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 13:17:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E5844B5
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 10:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F6263798
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 17:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E1FC433D2;
        Tue,  4 Apr 2023 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680628635;
        bh=Acp0VIqbUsInQzDp4oQuehH/fkmHl7utSTsg/zX04P4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BsTsdJtfw6Q9Ntjt207p21mHVD6rBJHm9x9s3pr0h2brlDbKvaxYK38JLf+bH7ET+
         A0GIebrFL/3CrgIlbOc19Damkz8mTKsrVb2NOJv1ZVkbJAaMshCaz12wP0c2tXkpmB
         A15RVCF9eVqAqAFpdCFNpXEFyPoRu0yh2oNh5N5sBor77dThy+DyfklgPRNlaUxUbh
         +zfdbIP/Qon7v4HlcugROqkQ5jXdENXcfs4L3fmkar7RXSb86dN5tjMyPUvnLoVntX
         +iWpJDfdaMgG1MRt5onko/OTqORQaHScykiQOxApm/ZLR1n2wCPtINdiTPIQg4afDB
         IwmVZVf4O3rzQ==
Date:   Tue, 4 Apr 2023 10:17:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     david@fromorbit.com, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHSET 0/3] xfs: fix ascii-ci problems with userspace
Message-ID: <20230404171715.GE109974@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

My finger slipped and I accidentally added you to the To: list on this
new series.  This series needs to go through review on linux-xfs; when
this is ready to go I (or Dave) will send you a pull request.

Sorry about the noise.

--D

On Tue, Apr 04, 2023 at 10:07:00AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Last week, I was fiddling around with the metadump name obfuscation code
> while writing a debugger command to generate directories full of names
> that all have the same hash name.  I had a few questions about how well
> all that worked with ascii-ci mode, and discovered a nasty discrepancy
> between the kernel and glibc's implementations of the tolower()
> function.
> 
> I discovered that I could create a directory that is large enough to
> require separate leaf index blocks.  The hashes stored in the dabtree
> use the ascii-ci specific hash function, which uses a library function
> to convert the name to lowercase before hashing.  If the kernel and C
> library's versions of tolower do not behave exactly identically,
> xfs_ascii_ci_hashname will not produce the same results for the same
> inputs.  xfs_repair will deem the leaf information corrupt and rebuild
> the directory.  After that, lookups in the kernel will fail because the
> hash index doesn't work.
> 
> The kernel's tolower function will convert extended ascii uppercase
> letters (e.g. A-with-umlaut) to extended ascii lowercase letters (e.g.
> a-with-umlaut), whereas glibc's will only do that if you force LANG to
> ascii.  Tiny embedded libc implementations just plain won't do it at
> all, and the result is a mess.  Stabilize the behavior of the hash
> function by encoding the kernel's tolower function in libxfs, add it to
> the selftest, and fix xfs_scrub not handling this correctly.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-asciici-tolower-6.3
> ---
>  fs/xfs/libxfs/xfs_dir2.c |    4 -
>  fs/xfs/libxfs/xfs_dir2.h |   20 ++++
>  fs/xfs/scrub/dir.c       |    7 +-
>  fs/xfs/xfs_dahash_test.c |  211 ++++++++++++++++++++++++----------------------
>  4 files changed, 139 insertions(+), 103 deletions(-)
> 
