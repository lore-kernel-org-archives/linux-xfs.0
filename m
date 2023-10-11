Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556A4CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 21:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbjJKVZQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 17:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjJKVZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 17:25:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D7290
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 14:25:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19FBC433C7;
        Wed, 11 Oct 2023 21:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697059514;
        bh=mV5bHGyuhPuGs+yvQ3SrUeARvkU/TkMjtvnpmopBYjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=clSKaNmNzPy5Ll9uVVfDwpu7w7+1hzBch3q4fp+OuscuJZpEbZeL/lsu6FFsGM3cn
         fC5cX1V7YuQOj86OfTGiLtSck36Odx2exynU1bD1J+2v1gVjZKTzMw8Ebp65NX2zdu
         fHcrBzqSztfi2/C6LfL0po8zsfb7GzamjeoG2jjAqvDexNUqgP/ihGz1SUPwNOzNqE
         rwFo7BxTwGpOXCVfTOpJhlvSo2S52MwKuzn3VJnUMqYUknBa4sHbR//GwAbssad+6x
         9OibpBRIlrHf1NzRJ/NeCU0nZ+JfMOW/l7BUewZlzUNnHgSYEbwY4QHHWOKoNmOGws
         RfD4lLNXmXMkA==
Date:   Wed, 11 Oct 2023 14:25:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, cheng.lin130@zte.com.cn,
        linux-xfs@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH] xfs: pin inodes that would otherwise overflow link count
Message-ID: <20231011212513.GZ21298@frogsfrogsfrogs>
References: <20231011203350.GY21298@frogsfrogsfrogs>
 <ZScOxEP5V/fQNDW8@dread.disaster.area>
 <ZScQRPEzGALKuSpk@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZScQRPEzGALKuSpk@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 08:14:44AM +1100, Dave Chinner wrote:
> On Thu, Oct 12, 2023 at 08:08:20AM +1100, Dave Chinner wrote:
> > On Wed, Oct 11, 2023 at 01:33:50PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > The VFS inc_nlink function does not explicitly check for integer
> > > overflows in the i_nlink field.  Instead, it checks the link count
> > > against s_max_links in the vfs_{link,create,rename} functions.  XFS
> > > sets the maximum link count to 2.1 billion, so integer overflows should
> > > not be a problem.
> > > 
> > > However.  It's possible that online repair could find that a file has
> > > more than four billion links, particularly if the link count got
> > 
> > I don't think we should be attempting to fix that online - if we've
> > really found an inode with 4 billion links then something else has
> > gone wrong during repair because we shouldn't get there in the first
> > place.
> > 
> > IOWs, we should be preventing a link count overflow at the time 
> > that the link count is being added and returning -EMLINK errors to
> > that operation. This prevents overflow, and so if repair does find
> > more than 2.1 billion links to the inode, there's clearly something
> > else very wrong (either in repair or a bug in the filesystem that
> > has leaked many, many link counts).
> > 
> > huh.
> > 
> > We set sb->s_max_links = XFS_MAXLINKS, but nowhere does the VFS
> > enforce that, nor does any XFS code. The lack of checking or
> > enforcement of filesystem max link count anywhere is ... not ideal.
> 
> No, wait, I read the cscope output wrong. sb->s_max_links *is*
> enforced at the VFS level, so we should never end up in a situation
> with link count greater than XFS_MAXLINKS inside the XFS code in
> normal operation. i.e. A count greater than that is an indication of
> a software bug or corruption, so we should definitely be verifying
> di_nlink is within the valid on-disk range regardless of anything
> else....

... and I just realized that the VFS doesn't check for underflows when
unlinking or rmdir'ing.  Maybe it should be doing that instead of
patching XFS and everything else?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
