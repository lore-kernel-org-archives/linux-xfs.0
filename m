Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC50BC4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 09:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E872072D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 09:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KQEG/dZO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgCWJWW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 05:22:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:34710 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727669AbgCWJWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 05:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584955340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AwgAIx1Hjc28iKBcvG/TifBA0x7SOxs3EdKSWXaUMhA=;
        b=KQEG/dZO3ROJ2XIo4kivUoa2cq2g8wWcHi7inDGsozKWPhz0DVqtH2qplkK5NT3lfhR5/T
        GJjJ9GBQ09/21yiNuahD0WYgku7IcHBE1+3Bf5Ks9cC3YdZA1Pb585/jJqx/ovV7iLFl5k
        jxUbjmGXhqwXOpsZnaLLctcbgeaTVAs=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-DhkajujnNmaf7mY45TyqUA-1; Mon, 23 Mar 2020 05:22:13 -0400
X-MC-Unique: DhkajujnNmaf7mY45TyqUA-1
Received: by mail-ua1-f71.google.com with SMTP id x22so4729779ual.9
        for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2020 02:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AwgAIx1Hjc28iKBcvG/TifBA0x7SOxs3EdKSWXaUMhA=;
        b=F4rf1E4H0oJDxJnGDfkYE3PuxfC97Q6YI+hF6molYyVGbE8ZAESbrN7209tRneIzHy
         cFYO+DZOVv3o0SN8iQ2yWw60z4l21Xb2wBxgWlxXkM7bEhC3a/9oPYf8GX30Q67ksFts
         LSRRu3eAJvb+68i+ivuDh4vFQgpEJgVyQYNSGwFK4mXkeMWMqOLwwpBh4L/qdbss8U+M
         I9Ujkc7/mZSExDcmrON9M/9mDe2OlZps/EkQNuBTpY1qTaOb5aV+N2v5i9EpTHsNbfIo
         lHv+7KwYuphTdamANdHG097b2lk9T/ioClbOrh+GS+Z8qBYcYdbas3U/Bk6bSw8IPXDG
         vqcg==
X-Gm-Message-State: ANhLgQ0xP6LXQhZba4X9MUrGETvvrrLu7qhkLFjjq8LiEP68qx7CvS/l
        nAfrXDO5XSkO+AwCCz3duLJL5DldWmVYRse4e8jhWM2wtDd0jAwfg81IxX617ibkdoFD2EsAWgw
        GIMrKkTfvPBFfgaBRKLscvd4HRmtJU38fCodg
X-Received: by 2002:a67:7c4:: with SMTP id 187mr15252502vsh.216.1584955333291;
        Mon, 23 Mar 2020 02:22:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsX6YQcPTEfQjq7SpDlClXkCnFbDRaQ4ZGXnhRkAjKA/5Sf/UITCP7b4WA9vzGcC3wQOLfwpy5PaeqeG38juRI=
X-Received: by 2002:a67:7c4:: with SMTP id 187mr15252493vsh.216.1584955333082;
 Mon, 23 Mar 2020 02:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200320210317.1071747-1-preichl@redhat.com> <20200323032809.GA29339@magnolia>
In-Reply-To: <20200323032809.GA29339@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Mon, 23 Mar 2020 10:22:02 +0100
Message-ID: <CAJc7PzXuRHhYztic9vZsspiHiP-vL_0HANd8x76Y+OdRVw6wwg@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] xfs: Remove wrappers for some semaphores
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Oh, thanks for the heads up...I'll try to investigate.

On Mon, Mar 23, 2020 at 4:28 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Fri, Mar 20, 2020 at 10:03:13PM +0100, Pavel Reichl wrote:
> > Remove some wrappers that we have in XFS around the read-write semaphore
> > locks.
> >
> > The goal of this cleanup is to remove mrlock_t structure and its mr*()
> > wrapper functions and replace it with native rw_semaphore type and its
> > native calls.
>
> Hmmm, there's something funny about this patchset that causes my fstests
> vm to explode with isilocked assertions everywhere... I'll look more
> tomorrow (it's still the weekend here) but figured I should tell you
> sooner than later.
>
> --D
>
> > Pavel Reichl (4):
> >   xfs: Refactor xfs_isilocked()
> >   xfs: clean up whitespace in xfs_isilocked() calls
> >   xfs: xfs_isilocked() can only check a single lock type
> >   xfs: replace mrlock_t with rw_semaphores
> >
> >  fs/xfs/libxfs/xfs_bmap.c |   8 +--
> >  fs/xfs/mrlock.h          |  78 -----------------------------
> >  fs/xfs/xfs_file.c        |   3 +-
> >  fs/xfs/xfs_inode.c       | 104 ++++++++++++++++++++++++++-------------
> >  fs/xfs/xfs_inode.h       |  25 ++++++----
> >  fs/xfs/xfs_iops.c        |   4 +-
> >  fs/xfs/xfs_linux.h       |   2 +-
> >  fs/xfs/xfs_qm.c          |   2 +-
> >  fs/xfs/xfs_super.c       |   6 +--
> >  9 files changed, 98 insertions(+), 134 deletions(-)
> >  delete mode 100644 fs/xfs/mrlock.h
> >
> > --
> > 2.25.1
> >
>

