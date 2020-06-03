Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC24FC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 03:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 852D6206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 03:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ju4a83Ms"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgFCDTh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 23:19:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25645 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725884AbgFCDTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 23:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591154375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8TZXjHZE+DVMbMl2MLiInRcnh+dVX5N7gXSqdqupY5s=;
        b=Ju4a83MsoxG9499bXMSpAzEeRg1Y+P/1CNm7hH5DBnZJYLfB50+ZdVXp8zdi1aD3Bd8Qhf
        Lmja3azSrxCMp+IugpP4TjZQXAHPAHTZROUVoBMpRtGaLBgFRDyjDIS1/thHBzBYw4aWU0
        vl2B0lWeU+IdLgru1V/xiRAKOop6UDg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-7CQ8J8YkO_yU0p9Yfvu7lw-1; Tue, 02 Jun 2020 23:19:33 -0400
X-MC-Unique: 7CQ8J8YkO_yU0p9Yfvu7lw-1
Received: by mail-pg1-f197.google.com with SMTP id n22so1081557pgd.18
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jun 2020 20:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8TZXjHZE+DVMbMl2MLiInRcnh+dVX5N7gXSqdqupY5s=;
        b=EPTlaaGNaI3YrYHORsmWCi/QKy1Yl/AnJlwFdv0bVbeeKlXDdVFo+t3TFbg+0YV8TC
         CErXSgQ/8qyDn7rHchnos5tWhRWTtw2/pX8KgHdgiNWt3ph7npDVqII+9bDwpqt39ual
         zQ+qRc0FoeDRnNVC57GrpEjBA19beK0F925+rXbgWBWkAszQnhU8VcngCdw4V7zaXNnQ
         IbX+YcuYKnVo0gsJZM7vkRut11wUYEDTgIJiXMHNkJaFe60D2R8KE1YMnvsBJE+29+70
         Bv2b27E2xofNKc6uYY54WRktyZUxDat1AagD/xOZuAvKD9DYF7je7GCJ0D+5EgR0yNzw
         OGIA==
X-Gm-Message-State: AOAM530B1mrj9aUxPkvex+Ge8bvnARTpbsAYoeRTBJ3MnAxBFgksplC8
        ztFalOlt/4QR+KHGcKItp8fEpW2iLS++dttZwktjC192yPPs+3fRDXx+AXUm/h3E2xaQszay9VE
        WHMCGvCVlvqGg9MteYnRX
X-Received: by 2002:a63:f959:: with SMTP id q25mr26030159pgk.137.1591154372164;
        Tue, 02 Jun 2020 20:19:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRjkykzT3gv0q0++JgULxplGod53Jr/ey3jExndRR9l+yjuBe5Y4Lrc4S5QbnkErAhbzVcYw==
X-Received: by 2002:a63:f959:: with SMTP id q25mr26030143pgk.137.1591154371853;
        Tue, 02 Jun 2020 20:19:31 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fy21sm462318pjb.38.2020.06.02.20.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 20:19:31 -0700 (PDT)
Date:   Wed, 3 Jun 2020 11:19:21 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200603031921.GB16546@xiangao.remote.csb>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
 <20200603012734.GL2040@dread.disaster.area>
 <20200603014039.GB12304@xiangao.remote.csb>
 <20200603030241.GM2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603030241.GM2040@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 01:02:41PM +1000, Dave Chinner wrote:
> On Wed, Jun 03, 2020 at 09:40:39AM +0800, Gao Xiang wrote:
> > On Wed, Jun 03, 2020 at 11:27:34AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 02, 2020 at 10:52:38PM +0800, Gao Xiang wrote:
> > > >  fs/xfs/libxfs/xfs_ag.c             |  4 ++--
> > > >  fs/xfs/libxfs/xfs_alloc.c          | 22 ++++++-----------
> > > >  fs/xfs/libxfs/xfs_alloc_btree.c    | 10 ++++----
> > > >  fs/xfs/libxfs/xfs_ialloc.c         | 28 ++++++----------------
> > > >  fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
> > > >  fs/xfs/libxfs/xfs_rmap_btree.c     |  5 ++--
> > > >  fs/xfs/xfs_inode.c                 | 38 +++++++++---------------------
> > > >  7 files changed, 35 insertions(+), 77 deletions(-)
> > > 
> > > There were more places using this pattern than I thought. :)
> > > 
> > > With an updated commit message,
> > > 
> > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Thanks for your review. b.t.w, would you tend to drop all extra ASSERTs
> > or leave these ASSERTs for a while to catch potential issues on this
> > patch?...
> 
> We typically use ASSERT() statements to document assumptions the
> function implementation makes. e.g. if we expect that the inode is
> locked on entry to a function, rather than adding that as a comment
> we'll do:
> 
> 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));

Yes, that's the typical use for most filesystems.

> 
> That way our debug builds validate that all the callers of the
> function are doing the right thing.
> 
> I frequently add ASSERT()s when debugging my code, but then remove
> once I've found the issue. Typically I'm adding asserts to cover
> conditions I know shouldn't occur, but could be caused by a bug and
> I try to place the asserts to catch the issue earlier than what I'm
> currently seeing. Depending on which debug assert fires first, I'll
> change/add/remove asserts to further narrow down the problem.
> 
> Hence the ASSERTs I tend to leave in the code are either documenting
> assumptions or were the ones that were most helpful in debugging the
> changes I was making.
> 
> I did think about the asserts you added, wondering if they were
> necessary. But then I noticed they were replicating a pattern in
> other parts of the code so they seemed like a reasonable addition.

Okay... I will follow your suggestion and fold in all remaining
ASSERTs (was not in this version) about this pattern. Will sort
out the next version later...

> 
> > And in addition I will try to find more potential cases, if
> > not, I will just send out with updated commit messages (maybe without
> > iunlink orphan inode related part, just to confirm?).
> 
> Your original patch is fine including those iunlink bits. I was was
> simply pointing out that spending more time cleaning up the iunlink
> code wasn't worth spending time on because I've got much more
> substantial changes that address those issues already...

Okay...

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

