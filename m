Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C88DC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 04:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjKIEv6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 23:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjKIEv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 23:51:56 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10DA170F;
        Wed,  8 Nov 2023 20:51:53 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 42F3767373; Thu,  9 Nov 2023 05:51:50 +0100 (CET)
Date:   Thu, 9 Nov 2023 05:51:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Chandan Babu R <chandanbabu@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dchinner@redhat.com, hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com
Subject: Re: [GIT PULL] xfs: new code for 6.7
Message-ID: <20231109045150.GB28458@lst.de>
References: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64> <CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com> <20231108225200.GY1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108225200.GY1205143@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 02:52:00PM -0800, Darrick J. Wong wrote:
> > Also, xfs people may obviously have other preferences for how to deal
> > with the whole "now using tv_sec in the VFS inode as a 64-bit sequence
> > number" thing, and maybe you prefer to then update my fix to this all.
> > But that horrid casts certainly wasn't the right way to do it.
> 
> Yeah, I can work on that for the rt modernization patchset.

As someone who has just written some new code stealing this trick I
actually have a todo list item to make this less horrible as the cast
upset my stomache.  But shame on me for not actually noticing that it
is buggy as well (which honestly should be the standard assumption for
casts like this).
