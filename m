Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:34617 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753341AbdCOSPc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Mar 2017 14:15:32 -0400
Received: by mail-yw0-f177.google.com with SMTP id p77so16203447ywg.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2017 11:15:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
 <20170315072349.GZ5280@birch.djwong.org> <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 15 Mar 2017 12:15:29 -0600
Message-ID: <CAJCQCtSk83ocw-iTinZk2ncOZDqhJiZzJN=kk5OtsYznvfO+ug@mail.gmail.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode 661690
 is free, would correct imap
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Mar 15, 2017 at 12:11 PM, Chris Murphy <lists@colorremedies.com> wrote:
> I'm guessing the slowness of
> systemd debug is

resulting in the difference; more time to commit the changes?

Anyway, it looks / is remounted read-only before reboot. Note, this is
a single partition/volume setup, so /boot/grub2/grub.cfg being
modified by grubby is on the fs being remounted read-only and reboot
time.

-- 
Chris Murphy
