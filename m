Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410D0C197A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 18:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjKTSYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjKTSX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 13:23:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B906DBC
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 10:23:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393DEC433C7;
        Mon, 20 Nov 2023 18:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700504633;
        bh=mJtUTm0q94esQJ9EifNFdO2Asl4HOfidMGOcSA8tQuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GzYepcYHMSCeWH/k3q4K6fpBp8OripnwdpxwVOiV1JEnmVzpCyWgazlb4IzZ2AQ83
         os5HTRfWF8keBsJ77uPRRC+2T3Wb65Ud6BRGF/Mo0a24btZPOgiL0xH3VTvhAUd86/
         uh0q54Xxi2o6GNb8lsYo6/4rwsyPIdUhU5LlEIlDxXndavqXt9t+hc4VusfL5E6mpX
         6TtLmJOSeASsMEzFVH+gXylkYewFQewrUQGJL1/uMhyOgDPu6ELa1U/kxzGEj94tpu
         lJJvXmyxjsXrzYZGTLCXa6kn88oPF4lsWFHWaCrjc5AsyC9fkWvPfXbT3CX1OU6w69
         9qW8sbJ/oM4pg==
Date:   Mon, 20 Nov 2023 19:23:48 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: Re: [PATCH 1/2] libxf-apply: Ignore Merge commits
Message-ID: <xmpiepfj3kazvnmt73sretdrlgb73yevbrkqlu5cmttx36sktu@7ygzafdwqc3n>
References: <20231120151056.710510-1-cem@kernel.org>
 <e8FRxymrRSM5hsIvCPFSIaKX6Kek84D_V1O1uu1KFzu39MEgJr135uimQh_X-e3L-TUhtz_2iKIMKuVWJXF6zA==@protonmail.internalid>
 <20231120165151.GD36190@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120165151.GD36190@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 20, 2023 at 08:51:51AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 20, 2023 at 04:10:46PM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Merge commits in the kernel tree, only polutes the patch list to be
> > imported into libxfs, explicitly ignore them.
> >
> > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > ---
> >
> > I'm considering here my own usecase, I never used merge commits, and sometimes
> > they break the synchronization, so they make no good for me during libxfs-sync.
> 
> The downside of ignoring merge commits is that Linus edited
> xfs_rtbitmap.c in the 6.7 merge commit to get rid of the weird code that
> casts a struct timespec64 to a u64 rtpick sequence counter and has
> screwed things up for years.

Well... My curse catches me again... Every time I say "I am not going to use
it", something happens to prove me wrong :)

Thanks for letting me know, I didn't get to 6.7 libxfs-sync yet, so, please,
just ignore this patch.

Carlos
> 
> --D
> 
> >  tools/libxfs-apply | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> > index 097a695f9..aa2530f4d 100755
> > --- a/tools/libxfs-apply
> > +++ b/tools/libxfs-apply
> > @@ -445,8 +445,8 @@ fi
> >
> >  # grab and echo the list of commits for confirmation
> >  echo "Commits to apply:"
> > -commit_list=`git rev-list $hashr | tac`
> > -git log --oneline $hashr |tac
> > +commit_list=`git rev-list --no-merges $hashr | tac`
> > +git log --oneline --no-merges $hashr |tac
> >  read -r -p "Proceed [y|N]? " response
> >  if [ -z "$response" -o "$response" != "y" ]; then
> >  	fail "Aborted!"
> > --
> > 2.41.0
> >
