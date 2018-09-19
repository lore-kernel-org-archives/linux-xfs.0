Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56051 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731204AbeISUoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 16:44:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id f21-v6so6645786wmc.5
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 08:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20180919125617.28048-1-jtulak@redhat.com> <20180919125617.28048-2-jtulak@redhat.com>
 <20180919144853.GI20086@magnolia>
In-Reply-To: <20180919144853.GI20086@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 19 Sep 2018 17:05:38 +0200
Message-ID: <CACj3i73ARZddDcCp9BJ626eo3v4N-dy535qSRLZUPT3==rdZjA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mkfs: move 'mounted' check before 'existing fs' check
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

On Wed, Sep 19, 2018 at 4:49 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Sep 19, 2018 at 02:56:17PM +0200, Jan Tulak wrote:
> > Check if a device is mounted (and issue an error about that) before
> > asking for -f flag.
> >
> > Example of the old behaviour I'm changing:
> > $ mkfs.xfs /dev/sda1
> > mkfs.xfs: /dev/sda1 appears to contain an existing filesystem (xfs).
> > mkfs.xfs: Use the -f option to force overwrite.
> >
> > $ mkfs.xfs -f /dev/sda1
> > mkfs.xfs: /dev/sda1 contains a mounted filesystem
>
> I'm confused by the commit message -- what is the new behavior?
>
> Is it this?
>
> $ mkfs.xfs /dev/sda1
> mkfs.xfs: /dev/sda1 contains a mounted filesystem
>
> $ mkfs.xfs -f /dev/sda1
> mkfs.xfs: /dev/sda1 contains a mounted filesystem

Yes. I should put it right into the commit message.

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
