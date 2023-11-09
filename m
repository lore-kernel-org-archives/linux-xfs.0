Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD68C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 16:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbjKIQvG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344246AbjKIQvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 11:51:05 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DF3210E;
        Thu,  9 Nov 2023 08:51:03 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 566CF68AA6; Thu,  9 Nov 2023 17:50:58 +0100 (CET)
Date:   Thu, 9 Nov 2023 17:50:57 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chandan Babu R <chandanbabu@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dchinner@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com
Subject: Re: [GIT PULL] xfs: new code for 6.7
Message-ID: <20231109165057.GA8083@lst.de>
References: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64> <CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com> <20231108225200.GY1205143@frogsfrogsfrogs> <20231109045150.GB28458@lst.de> <20231109073945.GE1205143@frogsfrogsfrogs> <20231109144614.GA31340@lst.de> <20231109163856.GG1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109163856.GG1205143@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 08:38:56AM -0800, Darrick J. Wong wrote:
> Dave suggested that we might restore the pre-4.6 behavior by explicitly
> encoding what we used to do:
> 
> 	inode->i_atime.tv_sec = seq & 0xFFFFFFFF;
> 	inode->i_atime.tv_nsec = seq >> 32;
> 
> (There's a helper in 6.7 for this, apparently.)
> 
> But then I pointed out that the entire rtpick sequence counter thing
> merely provides a *starting point* for rtbitmap searches.  So it's not
> like garbled values result in metadata inconsistency.  IOWs, it's
> apparently benign.
> 
> IOWs, how much does anyone care about improving on Linus' fixup?

I'd really like to see the cast of a pointer to a struct type to a
scalar gone, because those tend to hide bugs.

I'm not going to bother you too much with it, promised.
