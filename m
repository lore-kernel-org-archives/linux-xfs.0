Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E800DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 21:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiA1V7t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 16:59:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39500 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiA1V7s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jan 2022 16:59:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56190B81DF3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 21:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086F2C340E7;
        Fri, 28 Jan 2022 21:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643407186;
        bh=kL3l4o74jTcs9cV7xe1p6qyZt6cQSmcIIK8W9O9y6aM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eD8db5TXc/E4JvJnxmr+gWjULccq8RVy1VWa38sA2ytRMCYAtFZDAIvRAMYXizSND
         DqcZn81XykdeBHXz2yzwYkod1iYnSaWA92f4vZBJCD2mqZXHopdiGR9i9eGkO37cce
         wU6uWPdE2IHVSjTjQAXrWhgbVipGNkZ3aS0HNaiOa+NOZ2akgUnlpiAWyaKqMuQvOv
         rPowcRKmSNNPVCQPiZDu8jrm5wrmikrVLJYaX59iojKJUjWgsMuAgQkElAsnHFmlxk
         Sn8UYwqaQi9ojPwxPN5L1VAdU4Fw8LZ2LESedbit+Z61ztLo4Q4DVgVyowESfYm+IF
         xp3PMNtOk1hSQ==
Date:   Fri, 28 Jan 2022 13:59:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/45] libxfs: remove pointless *XFS_MOUNT* flags
Message-ID: <20220128215945.GG13540@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263805814.860211.18062742237091017727.stgit@magnolia>
 <21a7d548-6542-4c07-b007-0b4951d16875@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21a7d548-6542-4c07-b007-0b4951d16875@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 28, 2022 at 02:01:53PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:20 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Get rid of these flags and the m_flags field, since none of them do
> > anything anymore.
> 
> > diff --git a/db/attrset.c b/db/attrset.c
> > index 98a08a49..6441809a 100644
> > --- a/db/attrset.c
> > +++ b/db/attrset.c
> > @@ -107,7 +107,6 @@ attr_set_f(
> >   			break;
> >   		case 'n':
> > -			mp->m_flags |= LIBXFS_MOUNT_COMPAT_ATTR;
> >   			break;
> 
> That leaves an interesting no-op! I think IRC discussion ended at
> "haha it was a no-op before, too!" but maybe a comment to note the
> weird wart would be reasonable while we work out what to do with
> it, since it's so blazingly obvious now.

Ok, I'll go add a comment.

> 
> >   		/* value length */
> > @@ -169,7 +168,6 @@ attr_set_f(
> >   	set_cur_inode(iocur_top->ino);
> >   out:
> > -	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
> >   	if (args.dp)
> >   		libxfs_irele(args.dp);
> >   	if (args.value)
> > @@ -211,7 +209,6 @@ attr_remove_f(
> >   			break;
> >   		case 'n':
> > -			mp->m_flags |= LIBXFS_MOUNT_COMPAT_ATTR;
> >   			break;
> 
> here as well
> 
> ...
> 
> > diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
> > index 592e4502..d43914b9 100644
> > --- a/libxlog/xfs_log_recover.c
> > +++ b/libxlog/xfs_log_recover.c
> > @@ -827,7 +827,6 @@ xlog_find_tail(
> >   			 * superblock counters from the perag headers if we
> >   			 * have a filesystem using non-persistent counters.
> >   			 */
> > -			log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
> >   		}
> >   	}
> 
> Preceeding comment should go too, then, or maybe we should leave the
> equivalent opstate in place there? I'm not sure if the libxlog copies are
> supposed to stay as true as possible to kernelspace, or if we expect them
> to diverge and remove the pointless bits.  Probably the latter, right?
> So probably just nuke the comment.

The comment doesn't make sense anymore so I'll remove it.

As for libxlog, the kernel has diverged so far from userspace at this
point that it probably doesn't matter.

--D

> -Eric
