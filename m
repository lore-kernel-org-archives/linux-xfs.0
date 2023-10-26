Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5578CC0032E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Oct 2023 03:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjJZDN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 23:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjJZDN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 23:13:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20DEA3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 20:13:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87746C433C8;
        Thu, 26 Oct 2023 03:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698290005;
        bh=Oz/rTWDKHh2WvX35S+jhyPYm+PkIYHXo/U4AnKQMXI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ewICjSJxzrDAXZ9cB2xnKoYpRW20FbePATjZpqBxL/TLfxvxPFeK0af86AFDOvOQq
         AqjNiMQwcISg3MyzJ/Gzyx9shAbCMIDorqDaROCmYxP/lzgAW+akdYMhLggff5pF8Q
         ORDp/hqgHeg/NmZYfROReKWG2k4h2XHke5JIr/iXvtxShng41k7kG42/rU16hJAcKz
         OXJw51qOfJ72JhHAsWCFYtROi2OSFoMxr+hHoWXiXsLCI/Z3qzHkyjGm/INZZvqGvo
         gym5fFUh6t/lTPgJKEIb4HnZODvNQde+f2UJpcarw7T/T6BOhZO/ViqtuW5pPH0Oz/
         50L6B3JTfrd6w==
Date:   Wed, 25 Oct 2023 20:13:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shirley Ma <shirley.ma@oracle.com>, hch@lst.de,
        jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc7
Message-ID: <20231026031325.GH3195650@frogsfrogsfrogs>
References: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
 <CAHk-=whNsCXwidLvx8u_JBH91=Z5EFw9FVj57HQ51P7uWs4yGQ@mail.gmail.com>
 <20231023223810.GW3195650@frogsfrogsfrogs>
 <20231024-flora-gerodet-8ec178f87fe9@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024-flora-gerodet-8ec178f87fe9@brauner>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 01:47:17PM +0200, Christian Brauner wrote:
> On Mon, Oct 23, 2023 at 03:38:10PM -0700, Darrick J. Wong wrote:
> > On Sat, Oct 21, 2023 at 09:46:35AM -0700, Linus Torvalds wrote:
> > > On Fri, 20 Oct 2023 at 23:27, Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > Please pull this branch with changes for iomap for 6.6-rc7.
> > > >
> > > > As usual, I did a test-merge with the main upstream branch as of a few
> > > > minutes ago, and didn't see any conflicts.  Please let me know if you
> > > > encounter any problems.
> > > 
> > > .. and as usual, the branch you point to does not actually exist.
> > > 
> > > Because you *again* pointed to the wrong tree.
> > > 
> > > This time I remembered what the mistake was last time, and picked out
> > > the right tree by hand, but *please* just fix your completely broken
> > > scripts or workflow.
> > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-5
> > > 
> > > No.
> > > 
> > > It's pub/scm/fs/xfs/xfs-linux, once again.
> > 
> > Sorry about that.  After reviewing the output of git request-pull, I
> > have learned that if you provide a $url argument that does not point to
> > a repo containing $start, it will print a warning to stderr and emit a
> > garbage pull request to stdout anyway.  No --force required or anything.
> > Piping stdout to mutt without checking the return code is therefore a
> > bad idea.
> > 
> > I have now updated my wrapper script to buffer the entire pull request
> > contents and check the return value before proceeding.
> > 
> > It is a poor workman who blames his tools, so I declare publicly that
> > you have an idiot for a maintainer.
> > 
> > Christian: Do you have the bandwidth to take over fs/iomap/?
> 
> If this helps you I will take iomap over but only if you and Christoph
> stay around as main reviewers.

I can't speak for Christoph, but I am very much willing to continue
developing patches for fs/iomap, running the QA farm to make sure it's
working properly, and reviewing everyone else's patches.  Same as I do
now.

What I would like to concentrate on in the future are:

(a) improving documentation and cleanups that other fs maintainers have
    been asking for and I haven't had time to work on

(b) helping interested fs maintainers port their fs to iomap for better
    performance

(c) figuring out how to integrate smoothly with things like fsverity and
    fscrypt

(d) not stepping on *your* toes every time you want to change something
    in the vfs only to have it collide with iomap changes that you
    didn't see

Similar to what we just did with XFS, I propose breaking up the iomap
Maintainer role into pieces that are more manageable by a single person.
As RM, all you'd have to do is integrate reviewed patches and pull
requests into one of your work branches.  That gives you final say over
what goes in and how it goes in, instead of letting branches collide in
for-next without warning.

You can still forward on the review requests and bug reports to me.
That part isn't changing.  I've enjoyed working with you and hope
that'll continue well into the future. :)

> There's not much point in me pretending I
> can meaningfully review fs/iomap/ and I don't have the bandwith even if
> I could. So not without clear reviewers.

I hope the above assuades your concerns/fears!

> But, - and I'm sorry if I may overstep bounds a little bit - I think
> this self-castigation is really unwarranted. And we all very much know
> that you definitely aren't an idiot. And personally I think we shouldn't
> give the impression that we expect this sort of repentance when we make
> mistakes.
> 
> In other words, if the sole reason you're proposing this is an
> objectively false belief then I would suggest to reconsider.

Quite the opposite, these are changes that I've been wanting to make for
months. :)

--D
