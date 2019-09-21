Return-Path: <SRS0=b7mv=XQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE25C3A5A2
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 02:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E5820C01
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 02:25:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxf0/Am5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfIUCZp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 22:25:45 -0400
Received: from mail-ua1-f52.google.com ([209.85.222.52]:40106 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730808AbfIUCZp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 22:25:45 -0400
Received: by mail-ua1-f52.google.com with SMTP id i13so2259146uaq.7
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2019 19:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Jf9e+kT9DycGShQqbPO07mb3xQDkBIb8/gciuGqBQ1I=;
        b=dxf0/Am560L7bmbhhlAyPilSBgdnIqw6iwB5MiHNu5H32+Q3+42IjuJBYb9lVXPb0F
         sEes5DQOXViMDHFoSGPOGPfri8mKOdOS2kWiR9GRwyCxTZSQ3RrZyTyKZw/V7738emOG
         iSFhwoA/MouAQHVAsAjlVA+VzswPlEtS8j+5zh0g59aBf79qSO8cd/Ilo+mYs++R+768
         dmba1dnBlF5XQKWE2B1nYS7DwA1/uFdu2n/4Ig8Kd3YQHRJ6B3evVIGca9zjDkQ5wGK/
         qN5Vn1xhxNUUS/JAVfmfmx9AWEQ7ghtiLvZXugRhZPCElSkBjs4zHY6eAgwVGY+Aa9pC
         L60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Jf9e+kT9DycGShQqbPO07mb3xQDkBIb8/gciuGqBQ1I=;
        b=IixFCXjwK+9vwEY9BHqBg+dHfxe0/yETa7vDIXltect7f7NID6QhPAFUy6/+dZiJOB
         JvSqwxrXV9hoG335YHLJb9qGm9Pe6pOOT906WcKNLGc5BNR0k69EXVAdhUpxkEVvkY8n
         Yegn2fc6AlE4/tR+mCQuTyrv+dfFUX3R+2KyrxcU8cmy7MZqrc85qz2ov+NYF19XuQyq
         eesogmWBB4kh7BrRZy4rsxlMGX/eaH04xR1L5YefMXZPdyVXSqw2ZoxL47au/1wVKRGR
         1lQIcW8yfCaxFqdbTxLylunws93NNsiiAbJaXp23HpEgJoEouTaRiCcjZouStCM4WFm9
         mrDQ==
X-Gm-Message-State: APjAAAUu8Ykl/dwHZyrem4Qo0PVgJKIiYDcRRe6pl/wVBUhE1ImBcLUN
        CY/kXW318Vvvo7+qeqIbUsjkBkG74DS723fOfwvrzb01
X-Google-Smtp-Source: APXvYqwg3l3c7GBp8UGcUmeChlfJ+b0O9lcIfXohQmD3oQDR02MjL3O3NG4cnSQ/HaL4/p0MZ1fYmRf6dvsGY4Ke5gA=
X-Received: by 2002:ab0:230:: with SMTP id 45mr11178907uas.115.1569032744178;
 Fri, 20 Sep 2019 19:25:44 -0700 (PDT)
MIME-Version: 1.0
From:   James Harvey <jamespharvey20@gmail.com>
Date:   Fri, 20 Sep 2019 22:25:33 -0400
Message-ID: <CA+X5Wn4YzR8fHys7aROYjCgz-KfW3pXij5pak9E__SvENpf6nQ@mail.gmail.com>
Subject: Write-hanging on XFS 5.1.15-5.16 - xfsaild/dm blocked -
 xlog_cli_push_work - xfs_log_worker
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is for XFS, bear with me...  In QEMU, I was having trouble with a
Btrfs filesystem with heavy I/O for a few hours going into a state
where until rebooted, anything writing to it would go into
uninterruptible sleep, but still usually allowed reads.

I tried XFS ad an alternative to Btrfs, to determine if this was the
fault of Btrfs or something lower-level like QEMU.  XFS had the same
exact symptoms, of going into this bad state within a few hours of
heavy I/O.  This led me to conclude it was probably a QEMU bug.

Turns out it wasn't.  XFS and Btrfs seem to have had similar looking
bugs.  Others had the same Btrfs problem, and it wound up being
discussed and a patch linked to here:
https://lore.kernel.org/linux-btrfs/CAL3q7H4peDv_bQa5vGJeOM=V--yq1a1=aHat5qcsXjbnDoSkDQ@mail.gmail.com/

I've been running the Btrfs patch for several days without a lockup,
which is way longer than I could go before.

I'm therefore concluding there wasn't a QEMU bug, which also leads me
to conclude the XFS crashes I experienced must have been an XFS bug.


I want to be upfront that although I will be happy to respond to
questions as well as I can, I won't be able to spend time trying
proposed patches or perform further diagnostics.  If that means this
bugreport never gets looked into, that's fine.  I'm not sending this
for it to be fixed for me, but just for everyone else.


I did find someone else with the same problem here:
https://superuser.com/questions/1458253/hanging-xfs-filesystem-on-encrypted-usb-device

You'll see I was able to replicate this within a couple of hours of
booting.  Gaps (i.e. Jul 4 - Jul 23) were when I was working on
something else or using Btrfs again, and do not indicate periods of it
working.  It never worked for more than a few hours with heavy I/O

When I mean heavy I/O, I mean saturating a Samsung 970 EVO 1TB with
random access.

You'll see at the end, the filesystem eventually got I/O errors.
There's definitely no hardware issue.  I was able to replicate this on
an identical system with completely different actual pieces of
hardware.

Like the superuser.com poster that I linked to above, I was using
LUKS.  I, of course, wasn't using a USB drive.


You can see all the relevant portions of journalctl with the
backtraces here: http://ix.io/1W7s

But, for searchability, I've included a portion of it here:

INFO: task xfsaild/dm-8:3642 blocked for more than 122 seconds.
      Not tainted 5.1.15.a-1-hardened #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsaild/dm-8    D    0  3642      2 0x80000080
Call Trace:
 ? __schedule+0x27c/0x8d0
 schedule+0x3c/0x80
 xfs_log_force+0x18d/0x310 [xfs]
 ? wake_up_q+0x70/0x70
 xfsaild+0x1c6/0x810 [xfs]
 ? sched_clock_cpu+0x10/0xd0
 kthread+0xfd/0x130
 ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
 ? kthread_park+0x90/0x90
 ret_from_fork+0x35/0x40
