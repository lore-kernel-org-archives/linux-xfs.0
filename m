Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893A3C49EA5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 15:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F6C161351
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 15:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhFRPfL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 11:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbhFRPe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 11:34:56 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C2EC0617A8;
        Fri, 18 Jun 2021 08:32:30 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d1so1714525ils.5;
        Fri, 18 Jun 2021 08:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EhrMINDxt2PQnFDv/ZYqHpNKxvmdwYP1AuGC1JrV4a8=;
        b=ril9/Mak8sEm6Trv0+UWl0YDpDxAUKKOCCdOyJvkpvScFo/rrBhkiJkxZImrxzLsfT
         kr3sZIfr5Hjvi2SyBj/solrAxqtUfwfYIi+3luE/sty/PSNjhNqxFZ6Exg6SuzoxsOQE
         +gMVvFht2xFzPxg1h153/Jh/FC4rIKHhHiH+rSQ+EGIh9cLfYPaWQ+ZME7TGsYyzrY8s
         czXV7Szo0XghiAYMxKl42jATThm4s6j9u+MZWcUJWFY0frFczYEC6oA699cCCQocKgnr
         0c8R2dcHVEeVFgcm01fhp5OLRq0Q45GSOhKTk0g3+H4QJapzIWmzqM1XUMbSOT+on8f7
         mrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EhrMINDxt2PQnFDv/ZYqHpNKxvmdwYP1AuGC1JrV4a8=;
        b=VrFSylrAYqVZDGBzMKZQJYfNKVxH21nI/E1COjscl/B+4+YWTUBFz5H4nxDF9ohvNK
         r0eAQS7fnrEQSKT0KQEzipZ3J/u984WkaVxxb7a/eHF0kpzzZrxP26zTA1HwiqXjJ6JT
         eHUhkQdARJ3sfEohoZH7zJGfn6B18vQCC91OQTj/ffEmmpR7/FIxBXW48OE2ExXwENZb
         ogugYvUcJTBrsOcuBEtyd+6c0Ktdz38A9R7iEUCpSSLsWLCO7ZoCN3cEafu6n7ubRYnI
         Q3VRfrEXb3KZABlwPTY8rf1eEMbu2y4I+nizrHkm8gwHay70YFQaMjCScZoSyk5wPKX7
         pK/g==
X-Gm-Message-State: AOAM530Ob2tY1pKrLZkLNethIWi3io0TdgOwQqvLNsgm4FUY4iAGHrKU
        /EDlXW4LoUGZ1Ca4hnHBONLLlN6+QxYt6bTwLlE=
X-Google-Smtp-Source: ABdhPJzg2WT52HIaQFpVG7wNYeydovJeMatQalL3pogdQzxPdV2dj9604nzVhjlb/2ucnVWSKTqZIqnZmnjLJf/KeOU=
X-Received: by 2002:a05:6e02:4e:: with SMTP id i14mr7580437ilr.72.1624030350004;
 Fri, 18 Jun 2021 08:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437774.3800603.15907676407985880109.stgit@locust> <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust> <YMsAEQsNhI1Y5JR8@infradead.org>
 <20210617171500.GC158186@locust> <YMyjgGEuLLcid9i+@infradead.org>
In-Reply-To: <YMyjgGEuLLcid9i+@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 18 Jun 2021 18:32:18 +0300
Message-ID: <CAOQ4uxjvkJh2XcfDgj7g+JUkFXEc36_6YOKQHJ=pX2hpGfUDhQ@mail.gmail.com>
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>,
        ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 4:47 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Jun 17, 2021 at 10:15:00AM -0700, Darrick J. Wong wrote:
> > I suppose I could make the '-g' switch call 'make group.list', though
> > that's just going to increase the amount of noise for anyone like me who
> > runs fstests with a mostly readonly rootfs.
>
> Just stick to the original version and see if anyone screams loud

What is the original version?

> enough.  Of course the best long-term plan would be to not even generate
> group files by just calculate the list in-memory.

Why in-memory?
check already creates $tmp.list with the list of test files right?
Any reason not to the group.list files under /tmp while preparing
the test list instead of creating them in the src directory?

Thanks,
Amir.
