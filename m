Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4CCC6FD1F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 05:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCNFZH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 01:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCNFZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 01:25:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669956426E
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 22:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95B4615D4
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 05:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38004C433EF;
        Tue, 14 Mar 2023 05:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678771503;
        bh=cKqh3ZEG9qqfF4j8HmdiKrFPb+lG/kbD7IJmqLrE3HU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EGtgUq8AKfYjUyC5UM0p8WOIoYd/Vhz/iQyo9pODzMhEa3WqjmR+eYBr02A/BWugz
         h3zXjIL1hItC0EoMY7AnRx7DYzvuqUuNDcYtBXmDvcsr4+Nyn6ViNmYZEFEftVtoDV
         6wGdOuhpUN0WRMnEiRD0P7d6bgzzdaM6hntBdmvnMG+ll97izJ6CT2vra8LJCRj5Xz
         Q/Q2hqKwuLhYZgZ3JBW1hsUlcr1zsXGNiAkiRgB/uwPBU/pRPm39n7qKT4bRlur+DO
         OpE7Zcqa85V7iSWwPau5dlOGmlVR4ShZO1axmK27KBLJNZhGI+fN8iltdbBb64sQ59
         wRKSiasoCbMzw==
Date:   Mon, 13 Mar 2023 22:25:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 2/4] xfs: implement custom freeze/thaw functions
Message-ID: <20230314052502.GB11376@frogsfrogsfrogs>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
 <20230314042109.82161-3-catherine.hoang@oracle.com>
 <CAOQ4uxhKEhQ4X+rE4AYq70iEWKfqwQOZu47w_n1dbXd-wOeHTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhKEhQ4X+rE4AYq70iEWKfqwQOZu47w_n1dbXd-wOeHTw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 14, 2023 at 07:11:56AM +0200, Amir Goldstein wrote:
> On Tue, Mar 14, 2023 at 6:25 AM Catherine Hoang
> <catherine.hoang@oracle.com> wrote:
> >
> > Implement internal freeze/thaw functions and prevent other threads from changing
> > the freeze level by adding a new SB_FREEZE_ECLUSIVE level. This is required to
> 
> This looks troubling in several ways:
> - Layering violation
> - Duplication of subtle vfs code
> 
> > prevent concurrent transactions while we are updating the uuid.
> >
> 
> Wouldn't it be easier to hold s_umount while updating the uuid?

Why?  Userspace holds an open file descriptor, the fs won't get
unmounted.

> Let userspace freeze before XFS_IOC_SETFSUUID and let
> XFS_IOC_SETFSUUID take s_umount and verify that fs is frozen.

Ugh, no, I don't want *userspace* to have to know how to do that.

> > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > ---
> >  fs/xfs/xfs_super.c | 112 +++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_super.h |   5 ++
> >  2 files changed, 117 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 2479b5cbd75e..6a52ae660810 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -2279,6 +2279,118 @@ static inline int xfs_cpu_hotplug_init(void) { return 0; }
> >  static inline void xfs_cpu_hotplug_destroy(void) {}
> >  #endif
> >
> > +/*
> > + * We need to disable all writer threads, which means taking the first two
> > + * freeze levels to put userspace to sleep, and the third freeze level to
> > + * prevent background threads from starting new transactions.  Take one level
> > + * more to prevent other callers from unfreezing the filesystem while we run.
> > + */
> > +int
> > +xfs_internal_freeze(
> > +       struct xfs_mount        *mp)
> > +{
> > +       struct super_block      *sb = mp->m_super;
> > +       int                     level;
> > +       int                     error = 0;
> > +
> > +       /* Wait until we're ready to freeze. */
> > +       down_write(&sb->s_umount);
> > +       while (sb->s_writers.frozen != SB_UNFROZEN) {
> > +               up_write(&sb->s_umount);
> > +               delay(HZ / 10);
> > +               down_write(&sb->s_umount);
> > +       }
> 
> That can easily wait forever, without any task holding any lock.

Indeed, this needs at a bare minimum some kind of fatal_signal_pending
check every time through the loop.

> > +
> > +       if (sb_rdonly(sb)) {
> > +               sb->s_writers.frozen = SB_FREEZE_EXCLUSIVE;
> > +               goto done;
> > +       }
> > +
> > +       sb->s_writers.frozen = SB_FREEZE_WRITE;
> > +       /* Release s_umount to preserve sb_start_write -> s_umount ordering */
> > +       up_write(&sb->s_umount);
> > +       percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
> > +       down_write(&sb->s_umount);
> > +
> > +       /* Now we go and block page faults... */
> > +       sb->s_writers.frozen = SB_FREEZE_PAGEFAULT;
> > +       percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_PAGEFAULT - 1);
> > +
> > +       /*
> > +        * All writers are done so after syncing there won't be dirty data.
> > +        * Let xfs_fs_sync_fs flush dirty data so the VFS won't start writeback
> > +        * and to disable the background gc workers.
> > +        */
> > +       error = sync_filesystem(sb);
> > +       if (error) {
> > +               sb->s_writers.frozen = SB_UNFROZEN;
> > +               for (level = SB_FREEZE_PAGEFAULT - 1; level >= 0; level--)
> > +                       percpu_up_write(sb->s_writers.rw_sem + level);
> > +               wake_up(&sb->s_writers.wait_unfrozen);
> > +               up_write(&sb->s_umount);
> > +               return error;
> > +       }
> > +
> > +       /* Now wait for internal filesystem counter */
> > +       sb->s_writers.frozen = SB_FREEZE_FS;
> > +       percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_FS - 1);
> > +
> > +       xfs_log_clean(mp);

Hmm... some of these calls really ought to be returning errors.

> > +
> > +       /*
> > +        * To prevent anyone else from unfreezing us, set the VFS freeze
> > +        * level to one higher than FREEZE_COMPLETE.
> > +        */
> > +       sb->s_writers.frozen = SB_FREEZE_EXCLUSIVE;
> > +       for (level = SB_FREEZE_LEVELS - 1; level >= 0; level--)
> > +               percpu_rwsem_release(sb->s_writers.rw_sem + level, 0,
> > +                               _THIS_IP_);
> 
> If you really must introduce a new freeze level, you should do it in vfs
> and not inside xfs, even if xfs is the only current user of the new leve.

Luis is already trying to do something similar to this.  So far Jan and
I seem to be the only ones who have taken a look at this fs-internal
freeze...

https://lore.kernel.org/linux-fsdevel/20230114003409.1168311-4-mcgrof@kernel.org/

--D

> Thanks,
> Amir.
