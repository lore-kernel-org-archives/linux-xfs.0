Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45301 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbeJZOFQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 10:05:16 -0400
Received: by mail-lf1-f65.google.com with SMTP id c24-v6so8525291lfi.12
        for <linux-xfs@vger.kernel.org>; Thu, 25 Oct 2018 22:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <20181011194424.20306-1-stefanrin@gmail.com> <5209fec0-c7b3-ae1f-a909-23adfdee1072@sandeen.net>
 <69b32a73-f6c1-8991-af1e-d1818266c985@sandeen.net>
In-Reply-To: <69b32a73-f6c1-8991-af1e-d1818266c985@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Fri, 26 Oct 2018 07:29:29 +0200
Message-ID: <CAAxjCEwKqkK6RuE34tXXW=hZXyw5JsU2bhVh73ZRfyW2rGxmXQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Try to squash metadump data leaks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 2:36 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>> Hm, I think another case we're missing is interior nodes on multi-fsb objects,
> i.e. everything under /* Zero unused part of interior nodes */ seems to be
> missing for the process_multi_fsb_objects case as well.  Urk, what a mess.

It is a classic game of whack-a-mole ;). I do understand that it is
this way for historical reasons, but if it would be redone today, it
should obviously use zeroed buffers for writing out and copy just the
bits that are known to be needed.
