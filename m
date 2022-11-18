Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DE0C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Nov 2022 14:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241896AbiKROq1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Nov 2022 09:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbiKROqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Nov 2022 09:46:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338B76D4AB
        for <linux-xfs@vger.kernel.org>; Fri, 18 Nov 2022 06:46:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C383D62569
        for <linux-xfs@vger.kernel.org>; Fri, 18 Nov 2022 14:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FD2C433D6;
        Fri, 18 Nov 2022 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668782780;
        bh=m6Ve3tmtjtQet3e58iCRFwSIbyAAPjUkzbW7WO0qjQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mFirUaxbmuiqbMhOqEhfLyzgKDGLc04s7xCQHv7a+kP3TLVfruZnn0ozBzUvYAf7p
         +eRzDB0DJ6H/PK1bbRFHPbxPN6xeCmFjvwjArL7Sg7jtCDmwC6r2Dy1EtKpL+nWQLR
         tinjZMGtNJAXlQM8RPLlYMYekwKp++REn+Epu0HkfYvoeJ5SlgBiA0iCWr8HdwPR9J
         aQ6/c9q6me+Uz9wJj0cjYUCR/BmQFvDWP15IX6zGglhINnh9FrmSKN4+o2PH1WKfE9
         k+Jt/h1WtS9bwRHBgS43X/V+CxI3vxWEey5HPz5DZqamCh8U8FIS2ndnBS1KytTa7O
         QNeSfsuO+qmow==
Date:   Fri, 18 Nov 2022 15:46:15 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/7] xfsprogs: random fixes for 6.0
Message-ID: <20221118144615.o6l7v6cgehirk2n2@andromeda>
References: <3bbCi5OklUNOpVog9KVqiGD2TPkUD4x6PJjtZuKJCzP-QYMXvnqh7kZB8Vnp2BnxW6jn-dlyN7DIFoDTnryqNw==@protonmail.internalid>
 <166795950005.3761353.14062544433865007925.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166795950005.3761353.14062544433865007925.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 08, 2022 at 06:05:00PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This is a rollup of all the random fixes I've collected for xfsprogs
> 6.0.  At this point it's just an assorted collection, no particular
> theme.  Many of them are leftovers from the last posting.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.0
> ---
>  db/btblock.c             |    2 +
>  db/namei.c               |    2 +
>  db/write.c               |    4 +-
>  io/pread.c               |    2 +
>  libfrog/linux.c          |    1 +
>  libxfs/libxfs_api_defs.h |    2 +
>  libxfs/libxfs_io.h       |    1 +
>  libxfs/libxfs_priv.h     |    2 +
>  libxfs/rdwr.c            |    8 +++++
>  libxfs/util.c            |    1 +
>  mkfs/xfs_mkfs.c          |    2 +
>  repair/phase2.c          |    8 +++++
>  repair/phase6.c          |    9 +++++
>  repair/protos.h          |    1 +
>  repair/xfs_repair.c      |   77 ++++++++++++++++++++++++++++++++++++++++------
>  scrub/inodes.c           |    2 +
>  16 files changed, 105 insertions(+), 19 deletions(-)
> 

The whole series looks good. Will test

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos Maiolino
