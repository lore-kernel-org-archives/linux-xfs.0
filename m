Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8477AC64E7C
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 20:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33132221FA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 20:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389415AbgLBUnJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 15:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389358AbgLBUnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 15:43:08 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0870C061A04
        for <linux-xfs@vger.kernel.org>; Wed,  2 Dec 2020 12:42:27 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id u18so6823240lfd.9
        for <linux-xfs@vger.kernel.org>; Wed, 02 Dec 2020 12:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F3btiNSHm6jRc+pdBtMLFUAxRzWlf/wPyv3Pzid5Qtc=;
        b=Z11LEqV8wdrsHfKnZ1gN+6MxuQLN4JBrl/ZQBEaq6vQOuLOGiyyvqkeCcPCYRhQDIv
         ZPmJT1ekDNw917/6qDlUXjz9Xu/yQOcMPNWuaxXaYoEorXu9QNfEuCP35vSG8m9tWndO
         8uCAyKVBZS5tHpQHBWAexF8LHzVQcFWUxGxD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F3btiNSHm6jRc+pdBtMLFUAxRzWlf/wPyv3Pzid5Qtc=;
        b=S08VYYG/9Gq51L+3GrRmn377Pzu3hLbrGHNUtvTWjg9sa2LZHMFbIHqxHUeYLFyUXj
         twl869NUiMJhjAh1MquK9kCZzkNXMuyBcxyRknlrD4loDxyx2K6279IY+1nunZgGIRa0
         DwD8GdjmFJYrAeUJC1obzU/ZgsLroxu8zdpTRIh/Fc8QB7TgWV87WTgmvtHNhTUhdjMA
         zJwFK4LiH8Y7SpE4r8IGGZSY/KmLSV7z52Eqwsoqzd7/5961b+JRQ0bdlphm27u0toYx
         znovBz1FvZHRnGMcCkffOYSrUym7kPfYCpm1gkrAQlZ7pOg7GPEYEluGlQWpybBmsMDs
         PYeA==
X-Gm-Message-State: AOAM5329+2JnZqpv+tVLVqqhhEOrPcax+S144VkM2RnNtOJi3rVgM2fq
        cYAPl8+16EFqREtOgvTJHPEZV/bZpm01yQ==
X-Google-Smtp-Source: ABdhPJxGWX1Di6xp94FttLX3pDU6IVx5TgAOAiOXltOKoflgIgxs5FntjB0SUcILp11LnSfWT6eCLQ==
X-Received: by 2002:a19:ac44:: with SMTP id r4mr2019572lfc.168.1606941745835;
        Wed, 02 Dec 2020 12:42:25 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id o130sm801150lff.277.2020.12.02.12.42.24
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 12:42:24 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id q13so6822668lfr.10
        for <linux-xfs@vger.kernel.org>; Wed, 02 Dec 2020 12:42:24 -0800 (PST)
X-Received: by 2002:a19:ed0f:: with SMTP id y15mr1907270lfy.352.1606941744281;
 Wed, 02 Dec 2020 12:42:24 -0800 (PST)
MIME-Version: 1.0
References: <e388f379-cd11-a5d2-db82-aa1aa518a582@redhat.com>
 <7027520f-7c79-087e-1d00-743bdefa1a1e@redhat.com> <20201202021633.GA1455219@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20201202021633.GA1455219@iweiny-DESK2.sc.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 2 Dec 2020 12:42:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjiU5Fq7aG0-H6QN1ZsK-U3Hw1K310N2z_eCPPDTKeysA@mail.gmail.com>
Message-ID: <CAHk-=wjiU5Fq7aG0-H6QN1ZsK-U3Hw1K310N2z_eCPPDTKeysA@mail.gmail.com>
Subject: Re: [PATCH 1/2] uapi: fix statx attribute value overlap for DAX & MOUNT_ROOT
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 1, 2020 at 6:16 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> This will force a change to xfstests at a minimum.  And I do know of users who
> have been using this value.  But I have gotten inquires about using the feature
> so there are users out there.

If it's only a few tests that fail, I wouldn't worry about it, and the
tests should just be updated.

But if there are real user concerns, we may need to have some kind of
compat code. Because of the whole "no regressions" thing.

What would the typical failure cases be in practice?

            Linus
