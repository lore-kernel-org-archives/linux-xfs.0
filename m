Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532B8C4320A
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Aug 2021 21:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 347F460F14
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Aug 2021 21:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhHGVqp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 7 Aug 2021 17:46:45 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58931 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhHGVqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Aug 2021 17:46:44 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 473BD80B7B9;
        Sun,  8 Aug 2021 07:46:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mCU99-00FhOC-CE; Sun, 08 Aug 2021 07:46:23 +1000
Date:   Sun, 8 Aug 2021 07:46:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/29] xfsprogs: Drop the 'platform_' prefix
Message-ID: <20210807214623.GA3657114@dread.disaster.area>
References: <20210806212318.440144-1-preichl@redhat.com>
 <20210806230501.GG2757197@dread.disaster.area>
 <ea2b07fb-a664-3566-687c-43ffac1af4a8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea2b07fb-a664-3566-687c-43ffac1af4a8@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=8nJEP1OIZ-IA:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8
        a=gSwGhRh_aois6OdoZ-gA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 07, 2021 at 05:13:33PM +0200, Pavel Reichl wrote:
> 
> On 8/7/21 1:05 AM, Dave Chinner wrote:
> > On Fri, Aug 06, 2021 at 11:22:49PM +0200, Pavel Reichl wrote:
> > > Stop using commands with 'platform_' prefix. Either use directly linux
> > > standard command or drop the prefix from the function name.
> > Looks like all of the patches in this series are missing
> > signed-off-by lines.  Most of them have empty commit messages, too,
> Sorry about the missing signed-off-by, I really need to have a
> check-list before posting patches...or send more patches :-).

Having a checklist is a good idea. :)

> > which we don't tend to do very often.
> > 
> > >   51 files changed, 284 insertions(+), 151 deletions(-)
> > IMO, 29 patches for such a small change is way too fine grained for
> > working through efficiently.  Empty commit messages tend to be a
> > sign that you can aggregate patches together.... i.e.  One patch for
> > all the uuid changes (currently 7 patches) with a description of why
> > you're changing the platform_uuid interface, one for all the mount
> > related stuff (at least 5 patches now), one for all the block device
> > stuff (8 or so patches), one for all the path bits, and then one for
> > whatever is left over.
> OK, I'll do this in the next version.
> > 
> > Every patch has overhead, be it to produce, maintain, review, test,
> > merge, etc. Breaking stuff down unnecessarily just increases the
> > amount of work everyone has to do at every step. So if you find that
> > you are writing dozens of patches that each have a trivial change in
> > them that you are boiler-plating commit messages, you've probably
> > made the overall changeset too fine grained.
> OK, sincerely thank you for the 'rules-of-thump'. However, In the
> first version of the patch set I grouped the changes into way less patches
> and passed along a question about the preferred granularity of patches
> and got the following answer:
> 
> >   * What would be best for the reviewer - should I prepare a separate
> >   patch for every function rename or should I squash the changes into
> >   one huge patch?
> > One patch per function, please.
> 
> However, I agree that I should have mentioned that some patches would
> be too small and not blindly follow the request...I'll do better next
> time.

Yeah, I tend to push back on black and white process requirements
like this.  Everything has shades of grey. The process of responding
to so many small, trivial changes broken up like this is not an
efficient or effective use of developer time.

One function per patch makes sense when there are lots of changes to
a single function. But for stuff where there is only one or two
users (e.g. platform_discard, platform_findrawpath, platform*_block*
etc) splitting them in to single patches is not efficient.

I always think of it like this: would I like to have to reply to 29
emails just to add RVBs for such a change? Responding to 29 emails
is a decent chunk of time that every reviewer must invest. Is the
change complex enough to need such fine grained review effort.

In this case, I think no, especially because it hid where a
significant issue was introduced....

> > Also....
> > 
> > >   libxfs/init.c               | 32 ++++++------
> > >   libxfs/libxfs_io.h          |  2 +-
> > >   libxfs/libxfs_priv.h        |  3 +-
> > >   libxfs/rdwr.c               |  4 +-
> > >   libxfs/xfs_ag.c             |  6 +--
> > >   libxfs/xfs_attr_leaf.c      |  2 +-
> > >   libxfs/xfs_attr_remote.c    |  2 +-
> > >   libxfs/xfs_btree.c          |  4 +-
> > >   libxfs/xfs_da_btree.c       |  2 +-
> > >   libxfs/xfs_dir2_block.c     |  2 +-
> > >   libxfs/xfs_dir2_data.c      |  2 +-
> > >   libxfs/xfs_dir2_leaf.c      |  2 +-
> > >   libxfs/xfs_dir2_node.c      |  2 +-
> > >   libxfs/xfs_dquot_buf.c      |  2 +-
> > >   libxfs/xfs_ialloc.c         |  4 +-
> > >   libxfs/xfs_inode_buf.c      |  2 +-
> > >   libxfs/xfs_sb.c             |  6 +--
> > >   libxfs/xfs_symlink_remote.c |  2 +-
> > Why are all these libxfs files being changed?
> 
> I believe this is because of patch #6 - xfsprogs: Stop using
> platform_uuid_copy()
> 
> Here I dropped the usage of platform_uuid_copy() even in libxfs by:
> 
> 1) removing the uuid_copy() macro that was implemented by calling
>    platform_uuid_copy() in libxfs/libxfs_priv.h
> 
>  -#define uuid_copy(s,d) platform_uuid_copy((s),(d))
> 
> 2) using directly standard uuid_copy() instead
>    Which resulted into plenty of trivial changes all over libxfs, the
>    core of the changes being that uuid params are passed-by-value to
>    standard uuid_copy(), but to libxfs' uuid_copy() it is
>    passed-by-reference.
> 
>    E.g.
> - uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
> +               uuid_copy(agf->agf_uuid, mp->m_sb.sb_meta_uuid);

Ok, this is something that should definitely be mentioned in the
commit message because it's not just a rename.

As it is, this is the sort of problem we have to solve in userspace.
That was the purpose of the #define uuid_copy() you removed - it
translates the kernel API to the userspace API. We still need
something like that, which means the platform_uuid_copy()
change-over likely needs it's own patch and documentation (because
it's not just a straight rename anymore.

We do not want to make libxfs code unnecessarily different between
user and kernel space because that increases the overhead of porting
changes between kernel <-> userspace code bases. Hence we really
need to solve the "same function name, different calling convention"
in some way in userspace without requiring code diffs between kernel
and userspace.

Maybe some pre-processor magic can be done here in userspace. Maybe
we need to rename uuid_copy() in both the kernel and userspace, so
both have a static inline wrapper that can call the native
uuid_copy() with the correct parameters (another reason for it being
a separate patch so it can be easily ported).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
