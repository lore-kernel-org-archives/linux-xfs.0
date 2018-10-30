Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39088 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbeJ3VWt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 17:22:49 -0400
Received: by mail-lf1-f67.google.com with SMTP id n18so357458lfh.6
        for <linux-xfs@vger.kernel.org>; Tue, 30 Oct 2018 05:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20181026201943.24131-1-stefanrin@gmail.com> <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
 <5228ed5f-b238-1596-a829-6bf482da7e2b@sandeen.net> <CAAxjCExbUX1hDDV_0yK5Uu1eGf3aC8XT0CN-eL66+9GNDtdRVg@mail.gmail.com>
 <4f1f1db3-8689-dff1-3845-0a3e582fd849@sandeen.net>
In-Reply-To: <4f1f1db3-8689-dff1-3845-0a3e582fd849@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Tue, 30 Oct 2018 13:29:20 +0100
Message-ID: <CAAxjCEzE9dkTHQ7hZuUnTpNMCs4AzusFKyxejy1h8ZMXz3n8Qg@mail.gmail.com>
Subject: Re: [PATCH 0/5] v4 Try to squash metadump data leaks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 28, 2018 at 6:13 PM Eric Sandeen <sandeen@sandeen.net> wrote:
> Check patch 2 as well, the "break;" is also causing corruption I think,
> and it should probably just be a no-op ";"

Sorry about that. I think it's more than that. The single_fsb function
takes care to only write something out when there is something to
write and to only recalculate the crc when there has been a change.
I'd like to carry over this spirit, but I have the impression that in
the end the two functions would become so similar that they will just
merge into one.

> It may get resolved by the time you get to patch5 but best to not have
> regressions along the way.  Sorry for the piecemeal review here ;)
