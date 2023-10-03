Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B12E75451
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Oct 2023 11:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjJCLvL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjJCLvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 07:51:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0095A3
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 04:51:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCB7C433C7;
        Tue,  3 Oct 2023 11:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696333867;
        bh=612PEr6dhfiiXad21E3wJ6MsRRhhhqfgNpta+RkHdEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cuAfxgIR1h6e7kOdwfzp2Fxo2LmsdSZ5Pv3uJeAznISvkfp/mzjk9EEz5dmFregdQ
         K4aEnxOt+YtcxehInTO/iNl5ahWVdy9jPF2O6f3ddktJCuZJfxbzDpOiVCCIs7NV1M
         ZR4mgBNVVA72KR//fji0Vehbwa5OFdLE3rtEppaIyHj8c6ouY17uE+WE6vhVqEp/BJ
         aEYsbnsnxSW93uRkScXzQpzFqVb7lrHIUYruvBeGTwPeFVQ8lwUuaynVf41AeZhOXl
         vigRRtPt0gR+BiBubf7SFa07yMjtSZG3TfwQFYuR2HF0ttDQBPSuT9Sw26hV0/nwDX
         erw5g7rR3VxmQ==
Date:   Tue, 3 Oct 2023 13:51:04 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/3] xfsprogs: adjust defaults for 6.6 LTS kernels
Message-ID: <20231003115104.3mvybiaezk6pdzpx@andromeda>
References: <yYhBoMPNLxCHrIeX3b1PpvoBD6ldkuAl-kVPhaeM0nsUAoKVIpIGK4-HTmZFhRcMbLo2FutpL7v8k5fNiynxjg==@protonmail.internalid>
 <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 25, 2023 at 02:59:19PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series enables reverse mapping and 64-bit extent counts by default.
> These features are stable enough now, and with online fsck finished,
> there's a compelling reason to start enabling it on customer systems.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 

For the series:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos

> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=lts-6.6-stuff
> ---
>  man/man8/mkfs.xfs.8.in |   11 ++++++-----
>  mkfs/Makefile          |    3 ++-
>  mkfs/lts_6.6.conf      |   14 ++++++++++++++
>  mkfs/xfs_mkfs.c        |    4 ++--
>  4 files changed, 24 insertions(+), 8 deletions(-)
>  create mode 100644 mkfs/lts_6.6.conf
> 
