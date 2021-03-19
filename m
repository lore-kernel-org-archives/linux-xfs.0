Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BBAC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F72A64F69
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhCSGBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 02:01:15 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:59798 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233756AbhCSGAr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 02:00:47 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8E22A6427B;
        Fri, 19 Mar 2021 17:00:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lN8Be-004D95-VV; Fri, 19 Mar 2021 17:00:42 +1100
Date:   Fri, 19 Mar 2021 17:00:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>
Subject: Re: [PATCH] xfs: use has_capability_noaudit() instead of capable()
 where appropriate
Message-ID: <20210319060042.GS63242@dread.disaster.area>
References: <20210316173226.2220046-1-omosnace@redhat.com>
 <20210316205010.GN63242@dread.disaster.area>
 <CAFqZXNv5GPCU040gO3s-o2UTkXF3HExSkx2AjzE+4VC1REsQBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqZXNv5GPCU040gO3s-o2UTkXF3HExSkx2AjzE+4VC1REsQBg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=PBgVJ15w2z5VK2qaOZYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 10:51:29AM +0100, Ondrej Mosnacek wrote:
> On Tue, Mar 16, 2021 at 10:09 PM Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Mar 16, 2021 at 06:32:26PM +0100, Ondrej Mosnacek wrote:
> > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > index bca48b308c02..a99d19c2c11f 100644
> > > --- a/fs/xfs/xfs_xattr.c
> > > +++ b/fs/xfs/xfs_xattr.c
> > > @@ -164,7 +164,7 @@ xfs_xattr_put_listent(
> > >                * Only show root namespace entries if we are actually allowed to
> > >                * see them.
> > >                */
> > > -             if (!capable(CAP_SYS_ADMIN))
> > > +             if (!has_capability_noaudit(current, CAP_SYS_ADMIN))
> > >                       return;
> > >
> > >               prefix = XATTR_TRUSTED_PREFIX;
> >
> > This one should absolutely report a denial - someone has tried to
> > read the trusted xattr namespace without permission to do so. That's
> > exactly the sort of thing I'd want to see in an audit log - just
> > because we just elide the xattrs rather than return an error doesn't
> > mean we should not leave an audit trail from the attempted access
> > of kernel trusted attributes...
> 
> I'm not sure about that... without CAP_SYS_ADMIN the caller would
> still get the ACL xattrs, no?

Looks like it, but I have no idea if that's even correct behaviour
or not - access to posix ACL is supposed to be controlled by
the VFS.

> IIUC, it's a filter to not show
> restricted xattrs to unprivileged users via listxattr(2)**, where the
> user is not saying "give me the trusted xattrs", just "give me
> whatever I'm allowed to see", so logging the denial wouldn't make much
> sense - the user may not even care about trusted xattrs when doing the
> syscall (and in 99% of cases a user without CAP_SYS_ADMIN really
> won't).

Ok, I keep forgetting that only XFS has attr_list(3) interfaces
(which predate Linux VFS/syscall xattr support, IIRC) and that
interface requires userspace to pass ATTR_ROOT to retrieve trusted
namespace xattrs...

For while it's a silent content filter for one user interface, it's
an explicit request from another user interface. Make of that what
you will....

> (**) But I don't understand how exactly that function is used and what
> the XFS_ATTR_ROOT flag means, so I may be getting it wrong...

It's the on-disk format flag that says the xattr is in the "root"
namespace (i.e. requires "root" permissions to access). XFS came
from Irix which had different xattr namespaces for system, security,
etc, hence the stuff is stored on XFS is named somewhat differently
compared to native linux filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
