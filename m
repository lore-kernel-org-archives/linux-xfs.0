Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41767 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbeJ1VXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Oct 2018 17:23:16 -0400
Received: by mail-lj1-f196.google.com with SMTP id u21-v6so5169821lja.8
        for <linux-xfs@vger.kernel.org>; Sun, 28 Oct 2018 05:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20181026201943.24131-1-stefanrin@gmail.com> <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
 <5228ed5f-b238-1596-a829-6bf482da7e2b@sandeen.net>
In-Reply-To: <5228ed5f-b238-1596-a829-6bf482da7e2b@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Sun, 28 Oct 2018 13:38:32 +0100
Message-ID: <CAAxjCExbUX1hDDV_0yK5Uu1eGf3aC8XT0CN-eL66+9GNDtdRVg@mail.gmail.com>
Subject: Re: [PATCH 0/5] v4 Try to squash metadump data leaks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sat, Oct 27, 2018 at 1:33 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> Also, here's an old script I had lying around to test metadump.  It's hacky, sorry.
>
> Things to watch out for... it looks for an "fsstress" binary from xfstests, so adjust that path.
> It freezes and unfreezes the test filesystem, if your mount fails it'll freeze
> the fs you're on.  ;)  There may be other rough spots.
>
> It also runs the xfs_metadump/xfs_db in your path; you could change that to a
> local ./xfs_metadump to run db/xfs_db from a git tree instead for testing
> w/o make install.
>
> Right now this is detecting some corruption induced by metadump/mdrestore
> with your full patchset in place, FWIW.
>
> Sorry I didn't send this sooner, kinda forgot I had it.  really should turn it into an xfstest.

Thanks! The corruption is caused by the last patch in the series. So
dev inodes can have attribute forks. I will have to zap the data and
the attr area separately.
