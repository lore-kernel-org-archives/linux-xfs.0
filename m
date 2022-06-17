Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73ACC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 07:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380572AbiFQH2i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 03:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380563AbiFQH2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 03:28:30 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE3C31398
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 00:28:11 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id g15so1645686vkm.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 00:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zevNsrAp6pkueiIgV2vbBmafMOKjGdOh6UcYV/SsrKU=;
        b=PGgAd7HzFLDdqjdJDImSMRQATQboN4qckwgeHhQ6b3pU89j6IGYL5/vR0vSrYxvcc9
         Q4m+3lmT/LxjY+fNRqox+ZOUT2d7VqRJ579gxHatAEqX4XzZmx2VwRurbxFRak6UFxdG
         oAfZuUisGQT+ERjDLCi3BDkj62eGVcPDnD7w8gOKn5m2RS2nLrGbqHNe/NvqF+C2vfNh
         fTtatPxYJlg7iWUavARxUzobuuPgfVs5ORcYvcczHg1jYfgQLwY6NB9NiI3mD4NFkLNt
         1eNAcRWrkMolJD/UmivByldQLtyCBAsA0Xj4yEcBn2Rcj9J4dUM/vV4XQIfPHr+iAZFt
         2Lqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zevNsrAp6pkueiIgV2vbBmafMOKjGdOh6UcYV/SsrKU=;
        b=CMANUHi9Mcr7oC4gkinp2kBjWf72K1umG7EHYheIK2OoLbvEfwHyKGXKwfG8iCIM27
         CsWhERumSpHvWAcYtldUs6h0KMED2rQmD+c74prmEOwTE11EaSM/2uKA1DV08rKflzsn
         8PsFi7k284ltu6QKdvurJDXUxaj5yGmtaw0HnBy5B+QzJKj85jim6S0Fn95ReMo9FH1t
         FP4Z7wQ2+iBr89P7y70s9DKAeRU8K7gUu+bph0gCHA5N+Qjrx/M8RXT7lEoAwrUWwzw+
         u4l8djL0KR2GRsaUkeL10uoGBNMkM/J9QRarwJ/rc0td85xbjE/xPxp/FHoymwPuu3fD
         PbMw==
X-Gm-Message-State: AJIora87/Oc46tx73TO5A6sCOc+EAi6rkE+Zhv3BBwMZE4IZbg94JGXz
        OS1dva++utk8S1ttiXnzbeJxwuohi+RrIY7gHmU=
X-Google-Smtp-Source: AGRyM1stIrM12xHAdNjvqEPZuTZlhsRRruvX7IZcaYzCmYWafViYrdBdtybT7LW7hl8GOdsJYplmSVdKG1uhEMlkztQ=
X-Received: by 2002:a05:6122:214d:b0:35d:94e0:55fb with SMTP id
 m13-20020a056122214d00b0035d94e055fbmr3975539vkd.3.1655450890432; Fri, 17 Jun
 2022 00:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220616182749.1200971-1-leah.rumancik@gmail.com> <20220616182749.1200971-9-leah.rumancik@gmail.com>
In-Reply-To: <20220616182749.1200971-9-leah.rumancik@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 17 Jun 2022 10:27:58 +0300
Message-ID: <CAOQ4uxhKqzgGy7iqEXELVMA9+2JtzzUaCUmpDWEai=AUKcOmpQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 CANDIDATE v2 8/8] xfs: use setattr_copy to set vfs
 inode attributes
To:     Leah Rumancik <leah.rumancik@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 9:29 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> From: "Darrick J. Wong" <djwong@kernel.org>
>
> [ Upstream commit e014f37db1a2d109afa750042ac4d69cf3e3d88e ]
>
> Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
> revocation isn't consistent with btrfs[1] or ext4.  Those two
> filesystems use the VFS function setattr_copy to convey certain
> attributes from struct iattr into the VFS inode structure.
>
> Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
> decide if it should clear setgid and setuid on a file attribute update.
> This is a second symptom of the problem that Filipe noticed.
>
> XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
> xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
> /not/ a simple copy function; it contains additional logic to clear the
> setgid bit when setting the mode, and XFS' version no longer matches.
>
> The VFS implements its own setuid/setgid stripping logic, which
> establishes consistent behavior.  It's a tad unfortunate that it's
> scattered across notify_change, should_remove_suid, and setattr_copy but
> XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
> functions and get rid of the old functions.
>
> [1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
>
> Fixes: 7fa294c8991c ("userns: Allow chown and setgid preservation")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> ---

Hi Leah,

Dave has raised a concern [1] about backporting fixes in this area because
there are other vfs fixes still in work.

For the fix "xfs: fix up non-directory creation in SGID directories",
both Christian
and Christoph said it should be backported regardless [2].

I am not sure what they would have to say about this one though?

Christian, Christoph,

In your opinion, is this one also worth backporting regardless of possible
future vfs fixes?

I did test the 5.10 backports both with and without these two patches,
so I could go either way.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/20220602005238.GK227878@dread.disaster.area/
[2] https://lore.kernel.org/linux-xfs/CAOQ4uxg4=m9zEFbDAKXx7CP7HYiMwtsYSJvq076oKpy-OhK1uw@mail.gmail.com/
