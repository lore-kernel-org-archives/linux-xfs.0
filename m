Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:47069 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbeAVLjz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jan 2018 06:39:55 -0500
Received: by mail-wr0-f194.google.com with SMTP id g21so8267606wrb.13
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2018 03:39:55 -0800 (PST)
Date: Mon, 22 Jan 2018 12:39:50 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/4] Buffer's log item refactoring
Message-ID: <20180122113950.s5w6r6c67tgojh7p@odin.usersys.redhat.com>
References: <20180119140847.22934-1-cmaiolino@redhat.com>
 <20180119214341.GK25805@magnolia>
 <20180120045437.GN6304@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180120045437.GN6304@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Sat, Jan 20, 2018 at 03:54:37PM +1100, Dave Chinner wrote:
> On Fri, Jan 19, 2018 at 01:43:41PM -0800, Darrick J. Wong wrote:
> > On Fri, Jan 19, 2018 at 03:08:43PM +0100, Carlos Maiolino wrote:
> > > Hi,
> > > 
> > > A few time ago Christoph suggested to use list_head API to handle buffer's
> > > log_item_list.
> > > 
> > > This patchset aims to split the current bp->b_fspriv field into a specific field
> > > to hold the xfs_buf_log_item, and another to hold the list of log items attached
> > > to the buffer (3rd patch), and finally replace the singly linked list
> > > implementation by the list_head infra-structure (4th patch).
> > > 
> > > The first two patches are just a typedef removal of xfs_buf_log_item_t and
> > > xfs_buf_t, I did while studying how all the buffer I/O mechanism works, I
> > > thought since we plan to get rid of the typedefs in future, this might be
> > > useful.
> > > 
> > > I can rebase the 3rd and 4th patch on top of current xfs tree if the typedef
> > > removal patches are useless, you guys call.
> > 
> > Typedef removal seems useful... is this series based atop current for-next?
> 

It was rebased on xfs/for-next.

> The reason we haven't done this sort of thing in the past is that it
> causes problems for people with work under development that touches
> the same code. Changes like this have knock-on effects, and they are
> not necessary for the changes to the li_bio_list that the last two
> patches provide.
> 
> e.g. This is going to cause me pain, because I've got lots of
> modifications to xfs_buf related code pending in my dev tree. A
> quick glance shows a >50% hunk conflict rate across all the changes
> in my tree, and that's just the kernel side.  It's hard enough to
> rebase deep patch stacks correctly without having to deal with the
> noise introduced by this sort of tree-wide code cleanup....
> 
> The historic process is that we remove typedefs as we go, and when
> there are relatively few of them left we can do a sweep. The
> xfs_buf_log_item_t is at that threshold (only about 10 uses left).
> 
> However, there's ~150 xfs_buf_t references across the kernel code
> base, and there's another 175 across the xfsprogs code base of which
> only 40 are in the shared libxfs code (i.e. ~300 unique xfs_buf_t
> references). IMO it's still used in far to much code to do a sweep
> like this without making a lot of otherwise unnecessary work for
> others...
>

Ok, so I'll drop the typedef patches, well, should I drop both of them or just
the xfs_buf_t? Since the xfs_buf_log_item_t has very few usages now.

Cheers

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Carlos
