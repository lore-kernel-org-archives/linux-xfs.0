Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A46C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 13:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1808020857
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 13:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hRYOQw8I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgLANNf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgLANNf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 08:13:35 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BCBC0613D4
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 05:12:55 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id h7so754494pjk.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 05:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f6NVadUH9IgGq0mWwYFUWXIdG1tWgD62S/R/jtofxEI=;
        b=hRYOQw8Irnn8weJEukbpMprdZXd+wDbq8NQ3GXvoKJPAFsZP6OpDUbCI9+No0G3iIz
         daOwmfEGU4LYU18CKnnJ+s8Jo45ATwj9AS2djZH6a7Lo2aaZEpeW2V+AuT2lXz3fdU01
         u8VK3MoPdbQT/SuUygyYHW1WYwXYhqJ+R7Eg4gOi8MNm12V0172gPFDQBynRmji1WTq4
         fAyAhSJioimqp1fMSJs0ZI0fL0lGx764SCt5GaU2gldF0j6euiBq/5QZ6io6oB255g0r
         EIAZd//MYz1yLj7zkGqzybis1lDWDYLhfAfTk2KfgQoy5EIQjuH9Wf6V4RT/VrdFgBAv
         ZYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f6NVadUH9IgGq0mWwYFUWXIdG1tWgD62S/R/jtofxEI=;
        b=Km7t/DTAJAK7Bhqj5DWuOVW2Q3is+aC0i//YcjbqvLWIDmHCaFxyoO/hV88YQU3BjY
         GQ7dP1XnBZa89NwGz41HFbaXrYJWVxzao38iWNCfU6RsDV1yguUyfp82n/+1TQDN5Jk/
         /d90OajavljW4bT82VOaAFAn0mTct4EQud5qmIqE2lIKSMDb/++nkYPp97dhBU4PttWC
         6ZdSygGYrWJpD4Yj1OT52Q2MhFRoJvUQGRkE12Qa1YL08tcEsHH3agiWlTbemaN2qm45
         Z6g/JvWNojhqLqGc9WugWNJF0a8AS2xzXA0MYxGdO9+3O5VVowto7RkavGBP/vjolniX
         016w==
X-Gm-Message-State: AOAM532YXuc3FVSacxhufso/O2EjEdNWkxUYAsCkBa1K9eiPMydd4zt4
        1Vw+wNw//MpINyxVkpC+7FU=
X-Google-Smtp-Source: ABdhPJzWLmcLWehj3mZ2uKyMA8LV1d7T5GMf5fZz5qbeTpJW5Dgre/aQj+avvfB/l+R6xAF+a0OqCg==
X-Received: by 2002:a17:90a:1696:: with SMTP id o22mr2631821pja.44.1606828374793;
        Tue, 01 Dec 2020 05:12:54 -0800 (PST)
Received: from garuda.localnet ([122.171.217.238])
        by smtp.gmail.com with ESMTPSA id oc13sm2490139pjb.5.2020.12.01.05.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 05:12:54 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: Maximum height of rmapbt when reflink feature is enabled
Date:   Tue, 01 Dec 2020 18:42:51 +0530
Message-ID: <2114686.IuJF2Ahm34@garuda>
In-Reply-To: <20201130220347.GI2842436@dread.disaster.area>
References: <3275346.ciGmp8L3Sz@garuda> <20201130192605.GB143049@magnolia> <20201130220347.GI2842436@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 01 Dec 2020 09:03:47 +1100, Dave Chinner  wrote:
> On Mon, Nov 30, 2020 at 11:26:05AM -0800, Darrick J. Wong wrote:
> > On Mon, Nov 30, 2020 at 02:35:21PM +0530, Chandan Babu R wrote:
> > > I have come across a "log reservation" calculation issue when
> > > increasing XFS_BTREE_MAXLEVELS to 10 which is in turn required for
> > 
> > Hmm.  That will increase the size of the btree cursor structure even
> > farther.  It's already gotten pretty bad with the realtime rmap and
> > reflink patchsets since the realtime volume can have 2^63 blocks, which
> > implies a theoretical maximum rtrmapbt height of 21 levels and a maximum
> > rtrefcountbt height of 13 levels.
> 
> The cursor is dynamically allocated, yes? So what we need to do is
> drop the idea that the btree is a fixed size and base it's size on
> the actual number of levels iwe calculated for that the btree it is
> being allocated for, right?
> 
> > (These heights are absurd, since they imply a data device of 2^63
> > blocks...)
> > 
> > I suspect that we need to split MAXLEVELS into two values -- one for
> > per-AG btrees, and one for per-file btrees,
> 
> We already do that. XFS_BTREE_MAXLEVELS is supposed to only be for
> per-AG btrees.  It is not used for BMBTs at all, they use
> mp->m_bm_maxlevels[] which have max height calculations done at
> mount time.
> 
> The problem is the cursor, because right now max mp->m_bm_maxlevels
> fits within the XFS_BTREE_MAXLEVELS limit for the per-AG trees as
> well, because everything is limited to less than 2^32 records...
> 
> > and then refactor the btree
> > cursor so that the level data are a single VLA at the end.  I started a
> > patchset to do all that[1], but it's incomplete.
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=btree-dynamic-depth&id=692f761838dd821cd8cc5b3d1c66d6b1ac8ec05b
>

Darrick, I will rebase my "Extend data fork extent count field" patches on top
your patch with required fixes applied. Please let me know if you have any
objection to it.

> Yeah, this, along with dynamic sizing of the rmapbt based
> on the physical AG size when refcount is enabled...
> 
> And then we just don't have to care about the 1kB block size case at
> all....
> 

-- 
chandan



