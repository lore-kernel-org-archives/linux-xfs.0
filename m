Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C77EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 01:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5085420772
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 01:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ma0T5zXL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgHSBOS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:14:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25687 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726871AbgHSBOR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 21:14:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597799654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J8IQep93IviP8SmvZow/Kub0NkRcQ+5S7cN6dQ/1s8M=;
        b=Ma0T5zXLmmD9crb6c3rmIRmrqBsJvBInSRUtB49T6RQCbzzqZxcPA6Vbv5VZED53h4dyOU
        rFWRP32rksR3ycNsda/t0wRWktskVthXPFk2QuVTxK7Y9q0I/KdHdQ4r4tZFGIrYgqmF5/
        EBcSOoMafVHjC3HV5i1sVWKr1v4ZmpI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-m18VLdTxPbmnEbIriXFAtg-1; Tue, 18 Aug 2020 21:14:12 -0400
X-MC-Unique: m18VLdTxPbmnEbIriXFAtg-1
Received: by mail-pf1-f199.google.com with SMTP id 4so13966495pfd.23
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 18:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J8IQep93IviP8SmvZow/Kub0NkRcQ+5S7cN6dQ/1s8M=;
        b=uBAwx40WNaBi3Y0khou+sZlNh8zNmQ1lFeYvu3QdLZxeBAKW6m61ys+GOGGQfB+jKO
         l3iGlHClEya+bzIFtscKStjTe2VwOQwS8Ss1nsc8HGDZN4bvbLIojofOxxmKHmusTWPa
         UohAOFGhPwV8w2t2ichPM4VEeGrPwZNOGVVQMMIRHWhNYKTy2xuigPhnIM0PkB9Tl2E8
         gLngjH/qhzrup9r/Yn9BUUQmLXAlEulOYs0LATrl7i5FkR8g2wR7emu0XGPYPFpH7wvK
         Woq2JhqGzoapQe53jK6+f/nHs7Qa+c5u9n4ZkFdxW5XaujuqpYK6G8j98/2JH8tdXeKV
         xSIQ==
X-Gm-Message-State: AOAM532dV/8rf5r4Wi0a2/lIdb4Rmn8Mfc/vhfcqKDQfel7a5ieWLYt1
        YSh3szlLohF95+C0OzQP82/9zPA0gLMh/CcJZDepQXS373O8xIxjMjTTcC4v5ZUCPnEF06RSDhZ
        NLy/9qnOCWxKwNuozE840
X-Received: by 2002:a17:902:714c:: with SMTP id u12mr17232560plm.290.1597799651327;
        Tue, 18 Aug 2020 18:14:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZDgZLp/uRuyjwO5Lcxuv589xKr4QTQkWrxftQ2P9dbo4Yoyk0pUO2gkUqgcC7wcS2JfUqlw==
X-Received: by 2002:a17:902:714c:: with SMTP id u12mr17232545plm.290.1597799650982;
        Tue, 18 Aug 2020 18:14:10 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 74sm25139532pfv.191.2020.08.18.18.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 18:14:10 -0700 (PDT)
Date:   Wed, 19 Aug 2020 09:14:00 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH v4 0/3] xfs: more unlinked inode list optimization v4
Message-ID: <20200819011400.GA22041@xiangao.remote.csb>
References: <20200724061259.5519-1-hsiangkao@redhat.com>
 <20200818133015.25398-1-hsiangkao@redhat.com>
 <20200819005334.GA6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819005334.GA6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Aug 18, 2020 at 05:53:34PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 18, 2020 at 09:30:12PM +0800, Gao Xiang wrote:
> > Hi forks,
> > 
> > This is RFC v4 version which is based on Dave's latest patchset:
> >  https://lore.kernel.org/r/20200812092556.2567285-1-david@fromorbit.com
> 
> As we already discussed on IRC, please send new revisions of patchsets
> as a separate thread from the old submission.

Okay, will definitely do later.

> 
> > I didn't send out v3 because it was based on Dave's previous RFC
> > patchset, but I'm still not quite sure to drop RFC tag since this
> > version is different from the previous versions...
> 
> Hm, this cover letter could use some tidying up, since it took me a bit
> of digging to figure out that yes, this is the successor of the old
> series that tried to get the AGI buffer lock out of the way if we're
> adding a newly unlinked inode to the end of the unlinked list.

I'm trying to sort out in the next revision if something shows unclear
in the code.

I talked with Dave person-to-person weeks ago about these constraints
on IRC, but I'm not sure I can write out some fluent formal words...

I think there are 2 independent things:
 1) avoiding taking AGI buffer lock if AGI buffer is untouched;
 2) adding a newly unlinked inode to the end of the unlinked list.

So, 2) can be achieved as well without 1) since AGI buffer lock is a
powerful lock and can be recursively taken, but if we'd like to add a
new per-AG iunlink lock, there are some new constraints (locking order
and deadlock concerns) than the current approach.

In summary, due to many exist paths (e.g. tmpfile path), we need to take
lock in the following order:
  AGI buffer lock -> per-AG iunlink lock.

Otherwise it could cause dead lock. And we cannot release per-AG iunlink
lock before all iunlink operations in this trans are commited, or it could
cause iunlink fs corruption...

> 
> > Changes since v2:
> >  - rebase on new patchset, and omit the original first patch
> >    "xfs: arrange all unlinked inodes into one list" since it now
> >    has better form in the base patchset;
> > 
> >  - a tail xfs_inode pointer is no longer needed since the original
> >    patchset introduced list_head iunlink infrastructure and it can
> >    be used to get the tail inode;
> > 
> >  - take pag_iunlink_mutex lock until all iunlink log items are
> >    committed. Otherwise, xfs_iunlink_log() order would not be equal
> >    to the trans commit order so it can mis-reorder and cause metadata
> >    corruption I mentioned in v2.
> > 
> >    In order to archive that, some recursive count is introduced since
> >    there could be several iunlink operations in one transaction,
> >    and introduce some per-AG fields as well since these operations
> >    in the transaction may not operate inodes in the same AG. we may
> >    also need to take AGI buffer lock in advance (e.g. whiteout rename
> >    path) due to iunlink operations and locking order constraint.
> >    For more details, see related inlined comments as well...
> > 
> >  - "xfs: get rid of unused pagi_unlinked_hash" would be better folded
> >    into original patchset since pagi_unlinked_hash is no longer needed.
> > 
> > ============
> > 
> > [Original text]
> > 
> > This RFC patchset mainly addresses the thoughts [*] and [**] from Dave's
> > original patchset,
> > https://lore.kernel.org/r/20200623095015.1934171-1-david@fromorbit.com
> > 
> > In short, it focues on the following ideas mentioned by Dave:
> >  - use bucket 0 instead of multiple buckets since in-memory double
> >    linked list finally works;
> > 
> >  - avoid taking AGI buffer and unnecessary AGI update if possible, so
> >    1) add a new lock and keep proper locking order to avoid deadlock;
> >    2) insert a new unlinked inode from the tail instead of head;
> > 
> > In addition, it's worth noticing 3 things:
> >  - xfs_iunlink_remove() should support old multiple buckets in order
> >    to keep old inode unlinked list (old image) working when recovering.
> > 
> >  - (but) OTOH, the old kernel recovery _shouldn't_ work with new image
> >    since the bucket_index from old xfs_iunlink_remove() is generated
> >    by the old formula (rather than keep in xfs_inode), which is now
> >    fixed as 0. So this feature is not forward compatible without some
> >    extra backport patches;
> 
> Oh?  These seem like serious limitations, are they still true?

Yeah, I think that's still true (I tested on my VM before).

Thanks,
Gao Xiang

> 
> --D
> 
> >  - a tail xfs_inode pointer is also added in the perag, which keeps 
> >    track of the tail of bucket 0 since it's mainly used for xfs_iunlink().
> > 
> > 
> > The git tree is also available at
> > git://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git tags/xfs/iunlink_opt_v4
> > 
> > Gitweb:
> > https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=xfs/iunlink_opt_v4
> > 
> > 
> > Some preliminary tests are done (including fstests, but there seems
> > some pre-exist failures and I haven't looked into yet). And I confirmed
> > there was no previous metadata corruption mentioned in RFC v2 anymore.
> > 
> > To confirm that I'm in the right direction, I post the latest version
> > now since it haven't been updated for a while.
> > 
> > Comments and directions are welcomed. :)
> > 
> > Thanks,
> > Gao Xiang
> > 
> > Gao Xiang (3):
> >   xfs: get rid of unused pagi_unlinked_hash
> >   xfs: introduce perag iunlink lock
> >   xfs: insert unlinked inodes from tail
> > 
> >  fs/xfs/xfs_inode.c        | 194 ++++++++++++++++++++++++++++++++------
> >  fs/xfs/xfs_inode.h        |   1 +
> >  fs/xfs/xfs_iunlink_item.c |  16 ++++
> >  fs/xfs/xfs_mount.c        |   4 +
> >  fs/xfs/xfs_mount.h        |  14 +--
> >  5 files changed, 193 insertions(+), 36 deletions(-)
> > 
> > -- 
> > 2.18.1
> > 
> 

