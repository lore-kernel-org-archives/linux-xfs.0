Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:33961 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934880AbdCVPgX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 11:36:23 -0400
Received: by mail-yw0-f174.google.com with SMTP id p77so130077636ywg.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Mar 2017 08:36:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170322043438.GD17542@dastard>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
 <20170315072349.GZ5280@birch.djwong.org> <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
 <20170315191355.GF5280@birch.djwong.org> <20170315193040.GG5280@birch.djwong.org>
 <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
 <CAJCQCtRVuKiOMdtGLb3QbR8uCTXbhFMnNQgPzzZWG7y6URawHQ@mail.gmail.com> <20170322043438.GD17542@dastard>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 22 Mar 2017 09:36:21 -0600
Message-ID: <CAJCQCtQ6VXd4s=SZcMuSbEhN7yRKRk0GULY2isbg2ZAh5RW+=w@mail.gmail.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode 661690
 is free, would correct imap
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Tue, Mar 21, 2017 at 10:34 PM, Dave Chinner <david@fromorbit.com> wrote:

> FYI, I've ranted previously over many years about how broken grub's
> kernel update and retreival process is fundamentally broken, but
> it's never been fixed(*). As a result, I don't use grub on any of my
> systems, nor do I recommend that anyone else use it.

OK I follow all the previous comments, thanks, but here is where
there's a departure.

On Ubuntu systems, maybe all Debian systems, they are using
grub-mkconfig script, possibly in the form of update-grub, to create a
completely new grub.cfg. That script writes out grub.cfg.new and then
renames it to grub.cfg.

Fedora/RH systems don't use that at all. They don't use anything from
upstream GRUB to do updates in fact. The kernel RPM uses
new-kernel-pkg which in turn calls things like dracut, and eventually
it has grubby modify the grub.cfg in place. The grubby package has no
relationship at all with upstream grub. Directly modifying grub.cfg
and overwriting it seems risky, but I'm pretty sure that's how it
works.


> (*) The simple fix for grub to freeze/unfreeze the filesystem rather
> than/after calling sync() - this does the same thing as remount-ro,
> but unlike remount-ro it does not fail if there are writable file
> descriptors open.


OK. It looks to me like systemd eventually gives up on the remount-ro,
and then just reboots. That strikes me as a flawed design. Systemd
needs to wait longer (which is vague advice), or maybe after the 3rd
failed remount-ro, insert a freeze/unfreeze, then reboot. How does
that sound?


-- 
Chris Murphy
