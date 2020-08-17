Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECF6C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A44E320738
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ptAaqCtm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHQHoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 03:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHQHoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 03:44:21 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E558C061388
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 00:44:21 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g7so5955606plq.1
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 00:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kCKK1m4DeKXe8j07IISHG9uAZMSVEywH5nblLUgPc/Q=;
        b=ptAaqCtmxOsJjss59RwA87f84QrJHd7txxZ8F1E5QkLaCwC/QopyNH4yvlWSOm4ZbP
         Qrj5+e71us/Xst3OQLjGCA14dKTmj2Z3ba/uMJTdAmipe8dsmEDbP+jLhne2taAQ/UVs
         kD4xmu5fqmu8RCW1C/Gb854ylvT9DEliK3hTfg57nlBOYoqDm3MEFj1J8I8kfCvE7L7f
         SSw9H+4PPslwPAxhP8r9aOCg0Z/YtcMAP7+FktyPJ+rnB3dsUwFsqGLYeGSDA1EvRKnx
         KbhghiEVC63pXHvPjgJsOILHhtue4qpRFoebAyAX6B9nI62PMZL3et1kccPBrikVSk17
         KKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kCKK1m4DeKXe8j07IISHG9uAZMSVEywH5nblLUgPc/Q=;
        b=cIla3lqquSV3olnac7shjxECNZ5DZGfkLbyYJKHmYIbBtW8Jm7Iz7fymNFIx/sYQwP
         IBkHvg0d6s0ZTdhBbK34YsplKwCQXF0JyFWtVhuzG+Fxmy3w8fPkMH6U6FOJHD8AfH8F
         Xgja7ZB4M0/+xPIds4ZLPxceukJf020LWvJmWn/WzLUnEFHAJHeEblY8y3C/y6HqkzIR
         Rz96d0fayKlDgHspzGKzM3ATw0o4QqlgOA+mwZAakzYqOh9tmWDX3tDAF9RlStcK0gJ3
         2ahu66uadJGkbiW4oDoAOMOeJxLmc1WhAG8h7697aD1YQbKBKiMn89VKwPsPhfPRbOPT
         AGjw==
X-Gm-Message-State: AOAM5326BYB609Nk2xu+Hmcvpbyl+0C/IuTr7iv7m6fqxrVLfz8TSafj
        ORBhd9pmJm93tPAMUXwq5/XlYJA57zc=
X-Google-Smtp-Source: ABdhPJxoQDjAbxxSv65iWU8BwnCHEGRAkCoR4O6YxJQ+k2vKwLh5wh4ZhO1S5q5Zx9OldXJKTUJSIg==
X-Received: by 2002:a17:90a:e687:: with SMTP id s7mr11707855pjy.48.1597650259725;
        Mon, 17 Aug 2020 00:44:19 -0700 (PDT)
Received: from garuda.localnet ([171.48.27.213])
        by smtp.gmail.com with ESMTPSA id c17sm18059110pfp.214.2020.08.17.00.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 00:44:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V2 02/10] xfs: Check for extent overflow when trivally adding a new extent
Date:   Mon, 17 Aug 2020 13:14:16 +0530
Message-ID: <1740557.YaExq995uO@garuda>
In-Reply-To: <20200817065307.GB23516@infradead.org>
References: <20200814080833.84760-1-chandanrlinux@gmail.com> <20200814080833.84760-3-chandanrlinux@gmail.com> <20200817065307.GB23516@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 17 August 2020 12:23:07 PM IST Christoph Hellwig wrote:
> On Fri, Aug 14, 2020 at 01:38:25PM +0530, Chandan Babu R wrote:
> > When adding a new data extent (without modifying an inode's existing
> > extents) the extent count increases only by 1. This commit checks for
> > extent count overflow in such cases.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       | 8 ++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h | 2 ++
> >  fs/xfs/xfs_bmap_util.c         | 5 +++++
> >  fs/xfs/xfs_dquot.c             | 8 +++++++-
> >  fs/xfs/xfs_iomap.c             | 5 +++++
> >  fs/xfs/xfs_rtalloc.c           | 5 +++++
> >  6 files changed, 32 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 9c40d5971035..e64f645415b1 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4527,6 +4527,14 @@ xfs_bmapi_convert_delalloc(
> >  		return error;
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +
> > +	if (whichfork == XFS_DATA_FORK) {
> 
> Should we add COW fork special casing to xfs_iext_count_may_overflow
> instead?

I agree. Making xfs_iext_count_may_overflow() to always return success in the
case of CoW fork would mean that the if condition can be removed and hence
makes the code more readable.

> 
> > +		error = xfs_iext_count_may_overflow(ip, whichfork,
> > +				XFS_IEXT_ADD_CNT);
> 
> I find the XFS_IEXT_ADD_CNT define very confusing.  An explicit 1 passed
> for a counter parameter makes a lot more sense to me.

The reason to do this was to consolidate the comment descriptions at one
place. For e.g. the comment for XFS_IEXT_DIR_MANIP_CNT (from "[PATCH V2 05/10]
xfs: Check for extent overflow when adding/removing dir entries") is slightly
larger. Using constants (instead of macros) would mean that the same comment
has to be replicated across the 6 locations it is being used.

-- 
chandan



