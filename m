Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2C2C77B6C
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 21:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDLVyR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 17:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLVyR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 17:54:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F274486
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 14:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D795762D7A
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 21:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC5EC433D2;
        Wed, 12 Apr 2023 21:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681336455;
        bh=WCrocOXN+DEmhm85LfBEeAr55ktte2HToyrYnWms1kQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o3TeqvRZfCkfEhH8BrZ87yzs0Xsq2e+CmignSU2toPlhHt9hgSykH6hbfYsnBa0B3
         aCw3C1HobxNqPaTEz1SQwMBlEa3pLZX8mEehPxGN/Za4uOp2EvXhXEe6JHELQaAf1k
         aZbqDsTsMsqGyKGUAp7y+4ihbhZuk1eEz2rmdxX60ZeoLw5/52gpwmX31cLFst2ZIb
         HJ6vWEL6pbMjnpMStBsHlgDYGH8S0OUSrKn37TfMGZLcjuFa3TerM2dOfe5sUmT6xe
         +FRdF1XQMSh523s8u3n4NgLRDzAip3Aj3UMBtoLUIBXVQ5N1h4n9whIBUOunCnUugC
         fJ8jMk2/E16ag==
Date:   Wed, 12 Apr 2023 14:54:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     dchinner@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 14/22] xfs: fix bugs in parent pointer checking
Message-ID: <20230412215414.GI360895@frogsfrogsfrogs>
References: <168127095051.417736.2174858080826643116.stg-ugh@frogsfrogsfrogs>
 <20230412063115.GJ3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412063115.GJ3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 04:31:15PM +1000, Dave Chinner wrote:
> On Tue, Apr 11, 2023 at 08:48:26PM -0700, Darrick J. Wong wrote:
> > Hi Dave,
> > 
> > Please pull this branch with changes for xfs.
> > 
> > As usual, I did a test-merge with the main upstream branch as of a few
> > minutes ago, and didn't see any conflicts.  Please let me know if you
> > encounter any problems.
> > 
> > --D
> > 
> > The following changes since commit 0916056eba4fd816f8042a3960597c316ea10256:
> > 
> > xfs: fix parent pointer scrub racing with subdirectory reparenting (2023-04-11 19:00:20 -0700)
> > 
> > are available in the Git repository at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-parent-fixes-6.4_2023-04-11
> > 
> > for you to fetch changes up to 0916056eba4fd816f8042a3960597c316ea10256:
> > 
> > xfs: fix parent pointer scrub racing with subdirectory reparenting (2023-04-11 19:00:20 -0700)
> > 
> > ----------------------------------------------------------------
> > xfs: fix bugs in parent pointer checking [v24.5]
> > 
> > Jan Kara pointed out that the VFS doesn't take i_rwsem of a child
> > subdirectory that is being moved from one parent to another.  Upon
> > deeper analysis, I realized that this was the source of a very hard to
> > trigger false corruption report in the parent pointer checking code.
> > 
> > Now that we've refactored how directory walks work in scrub, we can also
> > get rid of all the unnecessary and broken locking to make parent pointer
> > scrubbing work properly.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > ----------------------------------------------------------------
> 
> Empty pull request?
> 
> Looks like the next pull-req is empty, too, and the commits that are
> supposed to be in these are in pull-req after that?

Ahaha, yep, a stupid bug in my script that turns stgit patches into
branches for pushing to kernel.org.  It ought to be sorting topics in
the order that the tagged patches appear in the stgit branch, but
clearly it isn't doing that for generating pull requests.

I'll sort this out and resend.  Unless you'd rather just pull #20 and
only have to do that once?

Either way, I'll fix my dumb script.


--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
