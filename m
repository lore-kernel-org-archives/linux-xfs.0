Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0043C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 01:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB10B206E9
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 01:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LnnVoKYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgFCBky (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 21:40:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726894AbgFCBky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 21:40:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591148452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PxpGBar+ICJodfJP5c1tDOt0Zt0ui3NMP6w/hD/iUII=;
        b=LnnVoKYzTmIHwG2IPhejHuDMWjdkzg9kRnUNZiuoaaEYBx1ske6397y9IojoFeapzDzhi4
        VVjxvottCUfUlGt7DjK5t8Ik8J+WmFpKbBNjJfBYH/i3J4GfZ06cKP1dtWqJXW6GYm3vn2
        oa2ZJGTgQ+csPcETWgzf8wp5/5MjcFc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-INyhvgaAPKqWAEzA3uwGRA-1; Tue, 02 Jun 2020 21:40:50 -0400
X-MC-Unique: INyhvgaAPKqWAEzA3uwGRA-1
Received: by mail-pl1-f200.google.com with SMTP id be7so404183plb.21
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jun 2020 18:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PxpGBar+ICJodfJP5c1tDOt0Zt0ui3NMP6w/hD/iUII=;
        b=OY01gdQkIWqKLN/ANHIrcAdo9wdX5/M0Tkbo21jI8KSrEfHBvgzP2w14XZKAAKyhf2
         AUDSixeMDN1vOwmU4edYndrV9+z5kTUSkpI29ZRowhMjo26EXajOy5OgPZQWW0BPiDgh
         gwgQB9f2tvj05vobEqNgVXGsCq6SkobEkp0zXCWmp7CQigCPr95l5Xramppia8y325u6
         +Ssb/6N1bcXmQpSjqYHzoprGk62+Q+/l9h8SuNC0SX7mAKI9y0+/GvvQYD3Hyza2DBIU
         bMZFgS8NpCMYwZJ3qMwrhhCAAnMyLF6TOolFnFMvRnnokig+w9jBgccqv8/36mldaGmk
         +uRw==
X-Gm-Message-State: AOAM531YiD0ifkLVw/kCs2iH8CqAbMgJyrZbXwL/G746RzBJpugZ2N65
        llNXfywTXs/ayIA3lHGv9PV91uhKbHEgggP+RDP8efUyxxWamxEFex38BPVe3Uis8mq/2BUFKyJ
        w2NFF8mq72q8uR9mPkCk9
X-Received: by 2002:a17:90a:df16:: with SMTP id gp22mr2450759pjb.6.1591148449420;
        Tue, 02 Jun 2020 18:40:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz22vsit263IDD5x7LepKMvFJ6U+sK/V3cOUwG2lIUyzvL/QgLQs0tLDr1Anzni5G8GllzvSQ==
X-Received: by 2002:a17:90a:df16:: with SMTP id gp22mr2450730pjb.6.1591148449042;
        Tue, 02 Jun 2020 18:40:49 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j130sm319056pfd.94.2020.06.02.18.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 18:40:48 -0700 (PDT)
Date:   Wed, 3 Jun 2020 09:40:39 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200603014039.GB12304@xiangao.remote.csb>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
 <20200603012734.GL2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603012734.GL2040@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 11:27:34AM +1000, Dave Chinner wrote:
> On Tue, Jun 02, 2020 at 10:52:38PM +0800, Gao Xiang wrote:
> > Sometimes no need to play with perag_tree since for many
> > cases perag can also be accessed by agbp reliably.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Hi Xiang,

Hi Dave,

> 
> One of the quirks of XFS is that we tend towards commit messages
> that explain the reason for the change than the actual change being
> made in the commit message. That means we'll put iinformation about
> how to reproduce bugs, the problem that needed to be solved,
> assumptions that are being made, etc into the commit message rather
> than describe what the change being made is. We can see what the
> change is from the code, but we may not be able to understand why
> the change is being made from reading the code.
> 
> Hence we try to put the "why?" into the commit message so that
> everyone reviewing the code knows this information without having to
> ask. This also means that we capture the reasons/thinking/issues
> that the commit address in the code repository and hence when we
> look up a change (e.g. when considering if we need to back port it
> to another kernel), we have a good idea of what problem that change
> is addressing. It also means that in a few months/years time when
> we've forgotten exactly why a specific change was made, the commit
> message should contain enough detail to remind us.

Okay, I understood. I'm a newbie to XFS here. I'll try to add more
reasons/thoughts from now on with my current limited knowledage
about XFS.

> 
> Perhaps something like this?
> 
> 	In the course of some operations, we look up the perag from
> 	the mount multiple times to get or change perag information.
> 	These are often very short pieces of code, so while the
> 	lookup cost is generally low, the cost of the lookup is far
> 	higher than the cost of the operation we are doing on the
> 	perag.
> 
> 	Since we changed buffers to hold references to the perag
> 	they are cached in, many modification contexts already hold
> 	active references to the perag that are held across these
> 	operations. This is especially true for any operation that
> 	is serialised by an allocation group header buffer.
> 
> 	In these cases, we can just use the buffer's reference to
> 	the perag to avoid needing to do lookups to access the
> 	perag. This means that many operations don't need to do
> 	perag lookups at all to access the perag because they've
> 	already looked up objects that own persistent references
> 	and hence can use that reference instead.
> 
> The first paragraph explains the problem. The second paragraph
> explains the underlying assumption the change depends on. And the
> third paragraph defines the scope we can apply the general pattern
> to.
> 
> It takes a while to get used to doing this - for any major change I
> tend to write the series description first (the requirements and
> design doc), then for each patch I write the commit message before
> I start modifying the code (detailed design). Treating the commit
> messages as design documentation really helps other people
> understand the changes being made....

Yeah, I saw many patchsets of you.. Partially due to my limited
knowledge and somewhat limited English skill though... But I will
write more as much as possible to get myself better...

> 
> > ---
> > Not sure addressing all the cases, but seems mostly.
> > Kindly correct me if something wrong somewhere...
> > 
> >  fs/xfs/libxfs/xfs_ag.c             |  4 ++--
> >  fs/xfs/libxfs/xfs_alloc.c          | 22 ++++++-----------
> >  fs/xfs/libxfs/xfs_alloc_btree.c    | 10 ++++----
> >  fs/xfs/libxfs/xfs_ialloc.c         | 28 ++++++----------------
> >  fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
> >  fs/xfs/libxfs/xfs_rmap_btree.c     |  5 ++--
> >  fs/xfs/xfs_inode.c                 | 38 +++++++++---------------------
> >  7 files changed, 35 insertions(+), 77 deletions(-)
> 
> There were more places using this pattern than I thought. :)
> 
> With an updated commit message,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks for your review. b.t.w, would you tend to drop all extra ASSERTs
or leave these ASSERTs for a while to catch potential issues on this
patch?... And in addition I will try to find more potential cases, if
not, I will just send out with updated commit messages (maybe without
iunlink orphan inode related part, just to confirm?).

Thanks,
Gao Xiang

> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

