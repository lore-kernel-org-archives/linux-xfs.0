Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414EEE7737C
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Sep 2023 17:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbjI3RVc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Sep 2023 13:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjI3RVc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Sep 2023 13:21:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D6CDD;
        Sat, 30 Sep 2023 10:21:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3042C433C8;
        Sat, 30 Sep 2023 17:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696094490;
        bh=040kTFk3t5OYkySQC/I2pYHwVrPb1tnb/Ke5P3nUgKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=otdWHsNy2exebBZRGLMkXODLlok7j/UEA158rfvlirMNSwCFMnStDchWNM/g+3fbg
         tz1AH420Az/WCN46hEXGLR3YYJkBilfuznkB4Ti1uEgbQQf1AfXhNRuroJIOk2rFkB
         feUZl8n9N8fNcqlogbgKFxRG0T9oUEgCG3z0McrHbkzE0rGIHeQrCU0odh/gyOgMtp
         oniEJPB1SIQzBe2Dx5ItxtrVngRmJFIw4YYP/ianULrFTFpgaJ5/QX9fIimX6c4RLO
         ZrUbC+nMGBpJEBBMmFR7FrS6rKxUdPhITYIyKMYBTbVkxAS+iAQSaaFGf78XnRiy2P
         SrtrFetdfzqRA==
Date:   Sat, 30 Sep 2023 10:21:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     bodonnel@redhat.com, geert+renesas@glider.be, hch@lst.de,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc4
Message-ID: <20230930172129.GA21298@frogsfrogsfrogs>
References: <169608776189.1016505.15445601632237284088.stg-ugh@frogsfrogsfrogs>
 <CAHk-=wjHA1d1kGhnzfXw7BsLuR93CPizeFzN0sNJruWsqvqzTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjHA1d1kGhnzfXw7BsLuR93CPizeFzN0sNJruWsqvqzTQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 30, 2023 at 09:52:41AM -0700, Linus Torvalds wrote:
> On Sat, 30 Sept 2023 at 08:31, Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-4
> 
> No such tag - and not even a branch with a matching commit.

Doh, wrong repo.  I'm kinda surprised that git request-pull didn't
complain about that.  Will send a new one.

--D

> Forgot to push out?
> 
>                  Linus
