Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1359AC00A8F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Oct 2023 22:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjJWWiO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 18:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjJWWiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 18:38:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C683CA3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 15:38:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D2AC433C7;
        Mon, 23 Oct 2023 22:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698100691;
        bh=vA1Y4ccV01ZF/Fj23s9wmH5FgbkPa7s6VyAtYkdRKC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nRkQ20xPU/elTUdrd+KM4t6GWLWv9jE3rnYI4d59+cHIJHwIjacqA5/nOoP3SzaSO
         YRW8CBaIN++fYnnZsyTgHE5Q/yLMfK1k2m6x1NKjIrFeIAb+Hz2RVpttxGpN6kUsM9
         Q/D+VHG6VwvKN5LbT7c/EMSMAtdv7c1SO5fmLZMCsuNVKuR+Wxk/bzlTJcpoGqb2o4
         8tiRN0BJAzq9GMUnsw5CxXYMK7J4jaMcdh22zxtUcPC/ciKZp0CF3TLNz32PM97SAs
         GIidOj1cXJxJ6iwVowSGbViuS/i0HFWaSaA0k+D/0bmeGHFoQmFj1r4+tPH8RxGKLt
         erF5PZgHN+BVA==
Date:   Mon, 23 Oct 2023 15:38:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Brauner <brauner@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shirley Ma <shirley.ma@oracle.com>
Cc:     hch@lst.de, jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc7
Message-ID: <20231023223810.GW3195650@frogsfrogsfrogs>
References: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
 <CAHk-=whNsCXwidLvx8u_JBH91=Z5EFw9FVj57HQ51P7uWs4yGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whNsCXwidLvx8u_JBH91=Z5EFw9FVj57HQ51P7uWs4yGQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 21, 2023 at 09:46:35AM -0700, Linus Torvalds wrote:
> On Fri, 20 Oct 2023 at 23:27, Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > Please pull this branch with changes for iomap for 6.6-rc7.
> >
> > As usual, I did a test-merge with the main upstream branch as of a few
> > minutes ago, and didn't see any conflicts.  Please let me know if you
> > encounter any problems.
> 
> .. and as usual, the branch you point to does not actually exist.
> 
> Because you *again* pointed to the wrong tree.
> 
> This time I remembered what the mistake was last time, and picked out
> the right tree by hand, but *please* just fix your completely broken
> scripts or workflow.
> 
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-5
> 
> No.
> 
> It's pub/scm/fs/xfs/xfs-linux, once again.

Sorry about that.  After reviewing the output of git request-pull, I
have learned that if you provide a $url argument that does not point to
a repo containing $start, it will print a warning to stderr and emit a
garbage pull request to stdout anyway.  No --force required or anything.
Piping stdout to mutt without checking the return code is therefore a
bad idea.

I have now updated my wrapper script to buffer the entire pull request
contents and check the return value before proceeding.

It is a poor workman who blames his tools, so I declare publicly that
you have an idiot for a maintainer.

Christian: Do you have the bandwidth to take over fs/iomap/?

--D

> 
>                  Linus
