Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85212C07545
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 11:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjJXLr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 07:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjJXLrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 07:47:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13302128
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 04:47:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC6EC433C7;
        Tue, 24 Oct 2023 11:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698148043;
        bh=JyWAb8ZHZK8jUotbEYIBEzVXIW6FDwpM3jjmNu5/IpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jsplmtvZ2nc2w/84Ft8AWcsgZPGZWEJxHBwnP05Wzd7s+ouTLbexdg3TR26Q67/V9
         9vppMT2kY3KCElBDUOo33kvoEeHQRF7soh5JoUKD2IZ1YlDZUAW/T8MWmGYhysbign
         EsLLGC76gZ7NDpURzBmTbeIdfi9j02JRVduiF8nWIUeQ5dTkF3IkWJjH40SjBgDEtE
         efpVonPPGj4nRL3AHyc5xZUahS7wwv7iYoOcKW4awHEN9LjLMzekrpBQfl7D9oBQjW
         CGHPq6z20FDTl9oiCcx1LLh5uc4ZmnaEzIobFhovRkxFW9L0tMqPaqZEt4y/4IpwWF
         q8RAodILfHStg==
Date:   Tue, 24 Oct 2023 13:47:17 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shirley Ma <shirley.ma@oracle.com>, hch@lst.de,
        jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc7
Message-ID: <20231024-flora-gerodet-8ec178f87fe9@brauner>
References: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
 <CAHk-=whNsCXwidLvx8u_JBH91=Z5EFw9FVj57HQ51P7uWs4yGQ@mail.gmail.com>
 <20231023223810.GW3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231023223810.GW3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2023 at 03:38:10PM -0700, Darrick J. Wong wrote:
> On Sat, Oct 21, 2023 at 09:46:35AM -0700, Linus Torvalds wrote:
> > On Fri, 20 Oct 2023 at 23:27, Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > Please pull this branch with changes for iomap for 6.6-rc7.
> > >
> > > As usual, I did a test-merge with the main upstream branch as of a few
> > > minutes ago, and didn't see any conflicts.  Please let me know if you
> > > encounter any problems.
> > 
> > .. and as usual, the branch you point to does not actually exist.
> > 
> > Because you *again* pointed to the wrong tree.
> > 
> > This time I remembered what the mistake was last time, and picked out
> > the right tree by hand, but *please* just fix your completely broken
> > scripts or workflow.
> > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-5
> > 
> > No.
> > 
> > It's pub/scm/fs/xfs/xfs-linux, once again.
> 
> Sorry about that.  After reviewing the output of git request-pull, I
> have learned that if you provide a $url argument that does not point to
> a repo containing $start, it will print a warning to stderr and emit a
> garbage pull request to stdout anyway.  No --force required or anything.
> Piping stdout to mutt without checking the return code is therefore a
> bad idea.
> 
> I have now updated my wrapper script to buffer the entire pull request
> contents and check the return value before proceeding.
> 
> It is a poor workman who blames his tools, so I declare publicly that
> you have an idiot for a maintainer.
> 
> Christian: Do you have the bandwidth to take over fs/iomap/?

If this helps you I will take iomap over but only if you and Christoph
stay around as main reviewers. There's not much point in me pretending I
can meaningfully review fs/iomap/ and I don't have the bandwith even if
I could. So not without clear reviewers.

But, - and I'm sorry if I may overstep bounds a little bit - I think
this self-castigation is really unwarranted. And we all very much know
that you definitely aren't an idiot. And personally I think we shouldn't
give the impression that we expect this sort of repentance when we make
mistakes.

In other words, if the sole reason you're proposing this is an
objectively false belief then I would suggest to reconsider.
