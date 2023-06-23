Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CC1EB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 23:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjFWX0f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 19:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjFWX0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 19:26:34 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078E51A4
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 16:26:33 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id a1e0cc1a2514c-78f14ef7c75so1648304241.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 16:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687562792; x=1690154792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATKOtkUKyfuXZnwcd8+0bSENn6pibDyNPbMHAVOdnIQ=;
        b=hnIAPRmM6oVBPCJ0N3bB0WHOuBkljRmXDz+cZeLsYghmZNhmo6znWfOpvrZ0FilNFQ
         PMz5rUeOzIJNwS6/oPgjAeFMINQg2F9Yz0Ml/r5w0KymM+Ux7JcZfLPFnQsJb0U4PJZ1
         ccBiANj9zK/j/XERDdxQtitLY6E9E6tysIttyVTOJFARTgL0KfW2nSk3ZwSOqHMwy5I7
         JrraDhHX64Tnp8IiF415cOpW+vK9mfiZCrZrS9DH7strnoTJqXP2cUwmr7NOasajTs1m
         6aZaLUPQaukhLXgxWKooxIiYkJ3TddRiHzWmBvkmklxCtjVaOKrJVy22kNmdCBdvLv+L
         V5gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687562792; x=1690154792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ATKOtkUKyfuXZnwcd8+0bSENn6pibDyNPbMHAVOdnIQ=;
        b=D88Scq1KHiRN29hg1FlpqcZtxWwvdXUwz7VSggWwpdouYA4Z/MOAQnifn3pQZURriZ
         GkuXWmBdOmgu+bB7kKXJeTiljUbhTyBx1AusTE2dV6NCmQLQFSA3QiqNVCzngPzdqswR
         NR3tEj4tIQ9WVZ5ullCcXyH9OUI9ZKvldGdA21UW8dwLk5pS53sUbPzIe5+I2d/Q6rlD
         KO6jBOy+BsrXw+2l7UIh/mXWjxP2z0IPECFoHAVwlNOqpwD9oT7mIZSlk4fBvUsgtx9H
         wn4NrXSz7uq6OqjOgNju41uDk94oto7gLTyOsW6srux2k9l6nj7HXho4TVdrWvi8JWlY
         WOdQ==
X-Gm-Message-State: AC+VfDzn0oW/4F3TNEPwO9rPFEyVe9DJqjkH54ifHNrgAKhl3wX1Zsz2
        mjQYotLLFBDqlElvFxlHFq+zmPOfhU9VCK3mbAun3HiEHCM=
X-Google-Smtp-Source: ACHHUZ5FyzpYUIbrPoLnbHWIQeq4foW3pAN0WmklT8w0YYkaeBifIuMkCLVPtOMSa8NaO879t1+Tt2vUO99M1eYYkZQ=
X-Received: by 2002:a05:6102:3d9f:b0:440:ce13:1eff with SMTP id
 h31-20020a0561023d9f00b00440ce131effmr4163816vsv.17.1687562791932; Fri, 23
 Jun 2023 16:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
 <3def220e-bc7b-ceb2-f875-cffe3af8471b@sandeen.net>
In-Reply-To: <3def220e-bc7b-ceb2-f875-cffe3af8471b@sandeen.net>
From:   Fernando CMK <ferna.cmk@gmail.com>
Date:   Fri, 23 Jun 2023 20:26:20 -0300
Message-ID: <CAEBim7DSUKg6TGZ_DKZ1rhbEHpfLN0aBDkc57gkgUgtnnc7xNQ@mail.gmail.com>
Subject: Re: xfs_rapair fails with err 117. Can I fix the fs or recover
 individual files somehow?
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 23, 2023 at 6:14=E2=80=AFPM Eric Sandeen <sandeen@sandeen.net> =
wrote:
>
> On 6/23/23 3:25 PM, Fernando CMK wrote:
> > Scenario
> >
> > opensuse 15.5, the fs was originally created on an earlier opensuse
> > release. The failed file system is on top of a mdadm raid 5, where
> > other xfs file systems were also created, but only this one is having
> > issues. The others are doing fine.
> >
> > xfs_repair and xfs_repair -L both fail:
>
> Full logs please, not the truncated version.

Phase 1 - find and verify superblock...
       - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
       - zero log...
       - 16:14:46: zeroing log - 128000 of 128000 blocks done
       - scan filesystem freespace and inode maps...
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0xfa00000/0x10=
00
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x0/0x1000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x6d600000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x23280000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x1b580000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x27100000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x7d00000/0x10=
00
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block
0x3e80000/0x1000stripe width (17591899783168) is
too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0xbb80000/0x10=
00
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x13880000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x1f400000/0x1=
000
stripe width (17591899783168) is too largestripe width
(17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x3a980000/0x1=
000

stripe width (17591899783168) is too large
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x4a380000/0x1=
000
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x55f00000/0x1=
000

Metadata corruption detected at 0x55f819658658, xfs_sb block 0x2ee00000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x3e800000/0x1=
000
stripe width (17591899783168) is too largestripe width
(17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x4e200000/0x1=
000

Metadata corruption detected at 0x55f819658658, xfs_sb block 0x69780000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x2af80000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x61a80000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x79180000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x32c80000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x59d80000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x65900000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x36b00000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x46500000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x71480000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x52080000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x42680000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x5dc00000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x17700000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x75300000/0x1=
000
clearing needsrepair flag and regenerating metadata
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x7d000000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x84d00000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x88b80000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x8ca00000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x90880000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x98580000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x9c400000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x80e80000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0xa0280000/0x1=
000
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658658, xfs_sb block 0x94700000/0x1=
000
       - 16:14:46: scanning filesystem freespace - 42 of 42 allocation
groups done
       - found root inode chunk
Phase 3 - for each AG...
       - scan and clear agi unlinked lists...
       - 16:14:46: scanning agi unlinked lists - 42 of 42 allocation groups=
 done
       - process known inodes and perform inode discovery...
       - agno =3D 0
       - agno =3D 15
       - agno =3D 30
       - agno =3D 16
       - agno =3D 17
       - agno =3D 31
       - agno =3D 18
       - agno =3D 19
       - agno =3D 20
       - agno =3D 32
       - agno =3D 33
       - agno =3D 21
       - agno =3D 34
       - agno =3D 35
       - agno =3D 36
       - agno =3D 37
       - agno =3D 38
       - agno =3D 39
       - agno =3D 40
       - agno =3D 41
       - agno =3D 22
       - agno =3D 23
       - agno =3D 24
       - agno =3D 25
       - agno =3D 26
       - agno =3D 27
       - agno =3D 28
       - agno =3D 29
       - agno =3D 1
       - agno =3D 2
       - agno =3D 3
       - agno =3D 4
       - agno =3D 5
       - agno =3D 6
       - agno =3D 7
       - agno =3D 8
       - agno =3D 9
       - agno =3D 10
       - agno =3D 11
       - agno =3D 12
       - agno =3D 13
       - agno =3D 14
       - 16:15:10: process known inodes and inode discovery - 788480
of 788480 inodes done
       - process newly discovered inodes...
       - 16:15:10: process newly discovered inodes - 42 of 42
allocation groups done
Phase 4 - check for duplicate blocks...
       - setting up duplicate extent list...
       - 16:15:10: setting up duplicate extent list - 42 of 42
allocation groups done
       - check for inodes claiming duplicate blocks...
       - agno =3D 0
       - agno =3D 5
       - agno =3D 2
       - agno =3D 3
       - agno =3D 8
       - agno =3D 4
       - agno =3D 9
       - agno =3D 10
       - agno =3D 7
       - agno =3D 6
       - agno =3D 11
       - agno =3D 1
       - agno =3D 12
       - agno =3D 13
       - agno =3D 15
       - agno =3D 14
       - agno =3D 16
       - agno =3D 17
       - agno =3D 18
       - agno =3D 19
       - agno =3D 20
       - agno =3D 21
       - agno =3D 22
       - agno =3D 23
       - agno =3D 24
       - agno =3D 25
       - agno =3D 26
       - agno =3D 27
       - agno =3D 28
       - agno =3D 29
       - agno =3D 30
       - agno =3D 31
       - agno =3D 32
       - agno =3D 33
       - agno =3D 34
       - agno =3D 35
       - agno =3D 36
       - agno =3D 37
       - agno =3D 38
       - agno =3D 39
       - agno =3D 40
       - agno =3D 41
       - 16:15:10: check for inodes claiming duplicate blocks - 788480
of 788480 inodes done
Phase 5 - rebuild AG headers and trees...
       - 16:15:19: rebuild AG headers and trees - 42 of 42 allocation
groups done
       - reset superblock...
Phase 6 - check inode connectivity...
       - resetting contents of realtime bitmap and summary inodes
       - traversing filesystem ...
       - traversal finished ...
       - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
       - 16:15:34: verify and correct link counts - 42 of 42
allocation groups done
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658468, xfs_sb block 0x0/0x1000
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x8
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658468, xfs_sb block 0x0/0x1000
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x8
xfs_repair: Releasing dirty buffer to free list!
xfs_repair: Refusing to write a corrupt buffer to the data device!
xfs_repair: Lost a write to the data device!

fatal error -- File system metadata writeout failed, err=3D117.  Re-run
xfs_repair.



>
> > Phase 6 - check inode connectivity...
> >         - resetting contents of realtime bitmap and summary inodes
> >         - traversing filesystem ...
> >         - traversal finished ...
> >         - moving disconnected inodes to lost+found ...
> > Phase 7 - verify and correct link counts...
> >         - 16:15:34: verify and correct link counts - 42 of 42
> > allocation groups done
> > stripe width (17591899783168) is too large
> > Metadata corruption detected at 0x55f819658468, xfs_sb block 0x0/0x1000
> > libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x8
> > stripe width (17591899783168) is too large
>
> 0xFFFEEF00000 - that's suspicious. No idea how the stripe unit could
> have been set to something so big.
>
> > Metadata corruption detected at 0x55f819658468, xfs_sb block 0x0/0x1000
> > libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x8
> > xfs_repair: Releasing dirty buffer to free list!
> > xfs_repair: Refusing to write a corrupt buffer to the data device!
> > xfs_repair: Lost a write to the data device!
> >
> > fatal error -- File system metadata writeout failed, err=3D117.  Re-run
> > xfs_repair.
> >
> > I ran xfs_repair multiple times, but I always get the same error.
>
> First, what version of xfs_repair are you using? xfs_Repair -V.
> Latest is roughly the latest kernel, 6.x.
>
> > Is there any way to fix the above?
> >
> > I tried xfs_db on an image file I created from the file system, and I
> > can  see individual paths  and file "good":
>
> > xfs_db> path /certainpath
> > xfs_db> ls
> > 10         1550204032         directory      0x0000002e   1 . (good)
> > 12         1024               directory      0x0000172e   2 .. (good)
> > 25         1613125696         directory      0x99994f93  13 .AfterShotP=
ro (good)
> >
> >
> > Is there a way to extract files from the file system image without
> > mounting the fs ? Or is there a way to mount the file system
> > regardless of its state?
>
> mount -o ro,norecovery should get you something ...


nope :(

# mount ./disk-dump  -t xfs -o ro,norecovery /mnt
mount: /mnt: mount(2) system call failed: Structure needs cleaning.

# xfs_repair -V
xfs_repair version 5.13.0

kernel version:

5.14.21-150500.53-default #1 SMP PREEMPT_DYNAMIC Wed May 10 07:56:26
UTC 2023 (b630043) x86_64 x86_6
4 x86_64 GNU/Linux

>
> > Trying a regular mount, with or withour -o norecovery, I get:
> > mount: /mnt: mount(2) system call failed: Structure needs cleaning.
>
> ... oh. And what did the kernel dmesg say when that happened?

dmesg:

[ 1565.659025] XFS (loop6): SB validate failed with error -117.
[ 1590.584851] loop6: detected capacity change from 0 to 2726297600
[ 1590.585544] XFS (loop6): stripe width (17591899783168) is too large
[ 1590.585555] XFS (loop6): Metadata corruption detected at
xfs_sb_read_verify+0xf6/0x160 [xfs], xfs_sb block
0xffffffffffffffff
[ 1590.585787] XFS (loop6): Unmount and run xfs_repair
[ 1590.585803] XFS (loop6): First 128 bytes of corrupted metadata buffer:
[ 1590.585819] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 14 50 00
00  XFSB.........P..
[ 1590.585838] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
[ 1590.585854] 00000020: 25 eb 8c c0 aa ad 4e d8 88 92 2b 42 d8 a2 be
c3  %.....N...+B....
[ 1590.585868] 00000030: 00 00 00 00 08 00 00 08 00 00 00 00 00 00 04
00  ................
[ 1590.585882] 00000040: 00 00 00 00 00 00 04 01 00 00 00 00 00 00 04
02  ................
[ 1590.585896] 00000050: 00 00 00 01 00 7d 00 00 00 00 00 2a 00 00 00
00  .....}.....*....
[ 1590.585911] 00000060: 00 01 f4 00 bd a5 10 00 02 00 00 08 00 00 00
00  ................
[ 1590.585925] 00000070: 00 00 00 00 00 00 00 00 0c 0c 09 03 17 00 00
19  ................
[ 1590.585951] XFS (loop6): SB validate failed with error -117.

>
> What happened in between this filesystem being ok, and not being ok?
> What was the first sign of trouble?

Did an openSuSE dist update from 15.3 to 15.4. Then dist up'd to 15.5
where I'm at now. At 15.4 boot it was broken, had to log in in
maintenance mode and comment out mounting the file system in fstab.


>
> If you want to provide an xfs_metadump (compressed, on gdrive or
> something, you can email me off-list) I can take a look.

Let me see if I can do that.

>
> -Eric
>
> >
> >
> >
> >
> > Regards.
> >
>
