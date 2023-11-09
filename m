Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA3CC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 14:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjKIOqW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 09:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjKIOqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 09:46:21 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351C6327D;
        Thu,  9 Nov 2023 06:46:19 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7DA9667373; Thu,  9 Nov 2023 15:46:14 +0100 (CET)
Date:   Thu, 9 Nov 2023 15:46:14 +0100
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
Message-ID: <20231109144614.GA31340@lst.de>
References: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64> <CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com> <20231108225200.GY1205143@frogsfrogsfrogs> <20231109045150.GB28458@lst.de> <20231109073945.GE1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109073945.GE1205143@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 11:39:45PM -0800, Darrick J. Wong wrote:
> Dave and I started looking at this too, and came up with: For rtgroups
> filesystems, what if rtpick simply rotored the rtgroups?  And what if we
> didn't bother persisting the rotor value, which would make this casting
> nightmare go away in the long run.  It's not like we persist the agi
> rotors.

Yep.  We should still fix the cast and replace it with a proper union
or other means for pre-RTG file systems given that they will be around
for while.
