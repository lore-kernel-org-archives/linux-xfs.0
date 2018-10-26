Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38151 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbeJ0DPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 23:15:38 -0400
Received: by mail-lj1-f193.google.com with SMTP id k11-v6so2053138lja.5
        for <linux-xfs@vger.kernel.org>; Fri, 26 Oct 2018 11:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <20181011194424.20306-1-stefanrin@gmail.com> <5209fec0-c7b3-ae1f-a909-23adfdee1072@sandeen.net>
 <69b32a73-f6c1-8991-af1e-d1818266c985@sandeen.net> <CAAxjCEwKqkK6RuE34tXXW=hZXyw5JsU2bhVh73ZRfyW2rGxmXQ@mail.gmail.com>
 <db5b1207-0b8f-cbc6-370f-c2c9d07e8407@sandeen.net>
In-Reply-To: <db5b1207-0b8f-cbc6-370f-c2c9d07e8407@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Fri, 26 Oct 2018 20:37:17 +0200
Message-ID: <CAAxjCEzarDyUJuNSyFh8CKiF7zz-KHnze3eycEsZ4MsOx28KdQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Try to squash metadump data leaks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 2:36 PM Eric Sandeen <sandeen@sandeen.net> wrote:
> On 10/26/18 12:29 AM, Stefan Ring wrote:
> > On Fri, Oct 26, 2018 at 2:36 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> >>> Hm, I think another case we're missing is interior nodes on multi-fsb objects,
> >> i.e. everything under /* Zero unused part of interior nodes */ seems to be
> >> missing for the process_multi_fsb_objects case as well.  Urk, what a mess.
> >
> > It is a classic game of whack-a-mole ;). I do understand that it is
> > this way for historical reasons, but if it would be redone today, it
> > should obviously use zeroed buffers for writing out and copy just the
> > bits that are known to be needed.
>
> Yeah, I was thinking about that last night.  I'm not sure it'd be a whole
> lot easier, though - for every single type of metadata block we either
> need to zap the holes or copy the bits, but every boundary is the same
> and would need to be computed and handled regardless.
> I'm not sure it'd be a win.

Yes, it would not be any easier. But it would be (amost) immediately
obvious when something was missed.
