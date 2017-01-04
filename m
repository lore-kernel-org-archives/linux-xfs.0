Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36625 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965712AbdADKWs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 05:22:48 -0500
Received: by mail-oi0-f67.google.com with SMTP id u15so73989212oie.3
        for <linux-xfs@vger.kernel.org>; Wed, 04 Jan 2017 02:21:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170103192426.GA14031@birch.djwong.org>
References: <1483107598-6779-1-git-send-email-hch@lst.de> <20170103192426.GA14031@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Jan 2017 12:21:26 +0200
Message-ID: <CAOQ4uxj0wxLq+=RXEo6FxCoEyncduheV0RC4gTfpS-=BLyuULA@mail.gmail.com>
Subject: Re: [PATCH, RFC] xfs: use per-AG reservations for the finobt
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Tue, Jan 3, 2017 at 9:24 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
...
>
> There's also the unsolved problem of what happens if we mount and find
> agf_freeblks < (sum(ask) - sum(used)) -- right now we eat that state and
> hope that we don't later ENOSPC and crash.  For reflink and rmap we will
> have always had the AG reservation and therefore it should never happen
> that we have fewer free blocks than reserved blocks.  (Unless the user
> does something pathological like using CoW to create many billions of
> separate rmap records...)
>

Darrick,

Can you explain the "Unless the user..." part?

Is it not possible to actively limit the user from getting to the
pathologic case?
If AG reservation size is a function of the maximum block refcount, then
an operation that is about to increase the maximum block refcount to a size
that will increase the worst case reservation beyond a certain percentage
of the AG (or beyond available space for that matter) should be denied
by a conservative ENOSPC.

I imagine it would be much easier and also understandable from user
POV to get a preventative ENOSPC for over cloning, then to get it
some time in the far future for trying to delete or deduplicate blocks.

Amir.
