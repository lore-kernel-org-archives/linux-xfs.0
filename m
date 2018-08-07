Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f176.google.com ([209.85.208.176]:40921 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733213AbeHGRpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Aug 2018 13:45:46 -0400
Received: by mail-lj1-f176.google.com with SMTP id j19-v6so13769438ljc.7
        for <linux-xfs@vger.kernel.org>; Tue, 07 Aug 2018 08:30:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180807152806.GD30972@magnolia>
References: <20180806211032.16777-1-mbenatto@redhat.com> <20180807151050.GB30972@magnolia>
 <20180807152806.GD30972@magnolia>
From: Marco Benatto <mbenatto@redhat.com>
Date: Tue, 7 Aug 2018 12:30:13 -0300
Message-ID: <CAOGQQ29X6hrzfuGLq-T3xeTGumVOV1JB6goP57eQ-8wGoYEXsA@mail.gmail.com>
Subject: Re: [PATCH] design: Document project quota inode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

>
> Ugh, /me has post-review regrets... mind if I rearrange this a little?
>
> "Prior to version 5 filesystems, two inodes can be allocated for quota
> management.  The first inode will be used for user quotas.  The second
> inode will be used for group quotas or project quotas, depending on
> mount options.  Group and project quotas are mutually exclusive features
> in these environments.
>
> "In version 5 or later filesystems, each quota type is allocated its own
> inode, making it possible to use group and project quota management
> simultaneously."
>
> --D
>

No problem at all, this way looks better to me.

Thanks!
