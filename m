Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E086C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6F2C221F8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbhATUGS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 15:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbhATT64 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 14:58:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 536BA235F7;
        Wed, 20 Jan 2021 19:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611172688;
        bh=ZK6/t3Y80r6CZOZG1jqpPVDuUvzc3Hw8nQWERsy7gMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZZMluErtTNzyIAcavUM+nPR2Ja0QOs1thZTHSxj09tRSZlDx2v96yF+REWlGZG+y+
         vQ/wquY18qvALQELs3fmVwWqkYvvV3//uPottNkW0KvpJKtu+n5tVM3qD5DExo9s96
         7KYRz2qbkH1FvBDx/d5nvk/AnqWPlfSSaXKZVmYYLA9Hf07OwZeSIxRdrdeXj3C2gZ
         zbkDKeJUZmpYWMZ7I7CniAdCt7dXUe3K9+aOvA8RvX50nTT/eeB4ztod+trWuKQMFH
         m5N8YSAVbAShrx9ADfS3310a8hU7NpYbGu69xHfncqlgt42CzMgVKCBkEmBU7kKm3c
         OlHZrLj2bkHJQ==
Date:   Wed, 20 Jan 2021 11:58:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: do not allow reflinking inodes with the dax flag
 set
Message-ID: <20210120195808.GQ3134581@magnolia>
References: <862a665f-3f1b-64e0-70eb-00cc35eaa2df@redhat.com>
 <20210108012952.GO6918@magnolia>
 <ec51e55e-648e-ad8b-a8dc-76b5c234637e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec51e55e-648e-ad8b-a8dc-76b5c234637e@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 07, 2021 at 08:54:29PM -0600, Eric Sandeen wrote:
> On 1/7/21 7:29 PM, Darrick J. Wong wrote:
> > On Thu, Jan 07, 2021 at 03:36:34PM -0600, Eric Sandeen wrote:
> >> Today, xfs_reflink_remap_prep() will reject inodes which are in the CPU
> >> direct access state, i.e. IS_DAX() is true.  However, it is possible to
> >> have inodes with the XFS_DIFLAG2_DAX set, but which are not activated as
> >> dax, due to the flag being set after the inode was loaded.
> >>
> >> To avoid confusion and make the lack of dax+reflink crystal clear for the
> >> user, reject reflink requests for both IS_DAX and XFS_DIFLAG2_DAX inodes
> >> unless DAX mode is impossible due to mounting with -o dax=never.
> > 
> > I thought we were allowing arbitrary combinations of DAX & REFLINK inode
> > flags now, since we're now officially ok with "you set the inode flag
> > but you don't get cpu direct access because $reasons"?
> 
> *shrug* I think "haha depending on the order and the state we may or may
> not let you reflink files with the dax flag set on disk so good luck" is
> pretty confusing, and I figured this made things more obvious.
> 
> I thought that should be an absolute, hch thought it should be ignored
> for dax=never, and now ... ?
> 
> I think the the current behavior is a bad user experience violating=
> principle of least surprise, but I guess we don't have agreement on that.

I guess not...? :(

In /me's head, S_DAX is a best-effort affair -- if the storage supports
it, and the cpu supports it, and the fs supports it, and the sysadmin
didn't forbid it, and there's no file state preventing it, *then* you
actually get S_DAX.  DIFLAG2_DAX is merely advisory, so it's perfectly
valid for reflink to come along and add a file state that (on this
kernel) prevents DIFLAG2_DAX from causing S_DAX to get set.

(We've probably already gone around and around on this elsewhere, but
I'm catching up on 6 weeks of email...)

> -Eric
> 
> > --D
> > 
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >> V2: Allow reflinking dax-flagged inodes in "mount -o dax=never" mode
> >>
> >> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> >> index 6fa05fb78189..e238a5b7b722 100644
> >> --- a/fs/xfs/xfs_reflink.c
> >> +++ b/fs/xfs/xfs_reflink.c
> >> @@ -1308,6 +1308,15 @@ xfs_reflink_remap_prep(
> >>  	if (IS_DAX(inode_in) || IS_DAX(inode_out))
> >>  		goto out_unlock;
> >>  
> >> +	/*
> >> +	 * Until we have dax+reflink, don't allow reflinking dax-flagged
> >> +	 * inodes unless we are in dax=never mode.
> >> +	 */
> >> +	if (!(mp->m_flags & XFS_MOUNT_DAX_NEVER) &&
> >> +	     (src->i_d.di_flags2 & XFS_DIFLAG2_DAX ||
> >> +	      dest->i_d.di_flags2 & XFS_DIFLAG2_DAX))

I think the bitflag tests need parentheses around them, right?

--D

> >> +		goto out_unlock;
> >> +
> >>  	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
> >>  			len, remap_flags);
> >>  	if (ret || *len == 0)
> >>
> > 
