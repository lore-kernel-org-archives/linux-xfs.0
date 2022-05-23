Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D09BC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 11:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiEWLQD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 07:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiEWLQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 07:16:02 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E891B43390
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 04:15:56 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id b200so3529911qkc.7
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 04:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yhISZpCkhqtXfdWEOEJIwh69Sn59+yuC/GwZwbNvj0=;
        b=gDCObgtbaP960+gRGlVxyAJcYWcclHGo1W63V3/kbLp6detYc33FZqlYUFoCDylwNj
         0XOBAno50M0UevkKngiu7pxZkxxDLWWnHmqfHRLzDwr9Zv5Z/7ZhrsPZ19KLxKDRsKh/
         CeCQ3dRl9xj5ovc4JcC84fU+ZaHsYWOZ4ge4z9sOvkLkp73rSjDNfxQTt3lGIx/+KKuG
         34+pCf8jQkQ4vEMt+ak5K745W+Pzl5HIxQMvXuLF2lAlMFBkqU7HJz5JRbMdNDLdh7/4
         6Nv86L/AzIwr8UOfP7kpTxDqCGeo/s/X0xhQDnqK6v8173QuSs8QWE+1if736/Dj4oSt
         0G7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yhISZpCkhqtXfdWEOEJIwh69Sn59+yuC/GwZwbNvj0=;
        b=wBJOzAZok0aAoEO3bybIJ/AcTSb6oODeQh2AJ4rYInumsSQUS0Mdc0qU3cxI0BV7Q8
         KwMIHyICjwQsyrWdGsQsuVInP/KjYteJ7jUv1IIytTWNb/+p7sbYjjLo9mIVr6kwbWDT
         Pqd7quNlP0yVpltDSGXt/IscBtpvI9GSi93gk8NIKBTaq0s8tu2QUp9eKdWxs0k+0/fS
         U5qSsfaFTGSRBsyroQg2EREzamM2M31Kbt6qvylpPv8d4i5AgKLbsZ9PFmvvsMtvzLP5
         t08WMDqm4tcPQ0t7+WDwYZ9gWDfUuAcbVayl1SpKimTuWd52Z5Ed2vfeev+IGZB3gasa
         Zqww==
X-Gm-Message-State: AOAM532Ik4Jz30smyWAeLn6yeDpEKfrhvAn+rTnbvJUrUAME8xTE9zdD
        Bt1/3xb49RgTAYxrB6XVFhtiofcBP/u2vQp8ea4=
X-Google-Smtp-Source: ABdhPJzp+LXJov8fWdYHjmYSYtqDdEKAIjcQho6/U18RKmf4Pjq24+2s0y8XLBhOUfhuA2ZVQFbOYAVPkYd84wQ78Go=
X-Received: by 2002:a37:6cc2:0:b0:6a3:769c:e5ba with SMTP id
 h185-20020a376cc2000000b006a3769ce5bamr3921233qkc.19.1653304556020; Mon, 23
 May 2022 04:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 23 May 2022 14:15:44 +0300
Message-ID: <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
Subject: Re: [PATCH V14 00/16] Bail out if transaction can cause extent count
 to overflow
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
>
> XFS does not check for possible overflow of per-inode extent counter
> fields when adding extents to either data or attr fork.
>
> For e.g.
> 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
>    then delete 50% of them in an alternating manner.
>
> 2. On a 4k block sized XFS filesystem instance, the above causes 98511
>    extents to be created in the attr fork of the inode.
>
>    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
>
> 3. The incore inode fork extent counter is a signed 32-bit
>    quantity. However, the on-disk extent counter is an unsigned 16-bit
>    quantity and hence cannot hold 98511 extents.
>
> 4. The following incorrect value is stored in the xattr extent counter,
>    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
>    core.naextents = -32561
>
> This patchset adds a new helper function
> (i.e. xfs_iext_count_may_overflow()) to check for overflow of the
> per-inode data and xattr extent counters and invokes it before
> starting an fs operation (e.g. creating a new directory entry). With
> this patchset applied, XFS detects counter overflows and returns with
> an error rather than causing a silent corruption.
>
> The patchset has been tested by executing xfstests with the following
> mkfs.xfs options,
> 1. -m crc=0 -b size=1k
> 2. -m crc=0 -b size=4k
> 3. -m crc=0 -b size=512
> 4. -m rmapbt=1,reflink=1 -b size=1k
> 5. -m rmapbt=1,reflink=1 -b size=4k
>
> The patches can also be obtained from
> https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v14.
>
> I have two patches that define the newly introduced error injection
> tags in xfsprogs
> (https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).
>
> I have also written tests
> (https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
> for verifying the checks introduced in the kernel.
>

Hi Chandan and XFS folks,

As you may have heard, I am working on producing a series of
xfs patches for stable v5.10.y.

My patch selection is documented at [1].
I am in the process of testing the backport patches against the 5.10.y
baseline using Luis' kdevops [2] fstests runner.

The configurations that we are testing are:
1. -m rmbat=0,reflink=1 -b size=4k (default)
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

This patch set is the only largish series that I selected, because:
- It applies cleanly to 5.10.y
- I evaluated it as low risk and high value
- Chandan has written good regression tests

I intend to post the rest of the individual selected patches
for review in small batches after they pass the tests, but w.r.t this
patch set -

Does anyone object to including it in the stable kernel
after it passes the tests?

Thanks,
Amir.

[1] https://github.com/amir73il/b4/blob/xfs-5.10.y/xfs-5.10..5.17-fixes.rst
[2] https://github.com/linux-kdevops/kdevops
