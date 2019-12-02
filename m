Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D38BC432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 08:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2416721774
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 08:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="1il5N/XV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfLBIH5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 03:07:57 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:42794 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfLBIH5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 03:07:57 -0500
Received: by mail-il1-f195.google.com with SMTP id f6so28568329ilh.9
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2019 00:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTHpAcpxaL0fLhVh4ifBiC4bBd+zFXHbvQGf8Va51KE=;
        b=1il5N/XVPNbH4zOykB4Ai8OXT6IUXCHEsMGQWyXPC+kbhxYEk/tnqzKczWwG/F1wDz
         T6weWgNm42ZPvEqX5QliRtkzh5uyl9TyArWFRT4MAyNan5lbQqIiQ2eMWdM1Z1coTSpq
         5PStmQgDZhi1oZO/xAIsJXil/XJr0ExxVcuNsFGS8eZsA99Q98h+27ZBW1eypEhwzjHf
         V2O8PN2H+JIeiodegk8K9XPWSdzo4GquzSXBc5oPFMdCUhG23raZoN5N6vj2mx1S0STP
         HoT2/1IDOyik+6U64haK64TXky6k3KDwG/H3sxOWnGRuLJhzyBsVlnauJYS7+FMSFp66
         54PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aTHpAcpxaL0fLhVh4ifBiC4bBd+zFXHbvQGf8Va51KE=;
        b=r50tXgaDz0wm8ppVGwlMWayTQSM8JJH2zZ8PH1TTyG0mrBMi4I8eRBMrmRzE6B5HQg
         e33UaE8LoEZsREWO2WU/qDkDfQTNoD4OUg/MYIYy1z7spiDVPBcfS+0bkHOoKeAbZsN8
         Wt6lTmNJ7So7Ron5qjNHDN18nfPcx7ziix9bvsp4nSINdiqcBbvKoOrSG391bOlkGCSP
         FlkUBWUQrSjcFAGKY77zIpNXXHPiRwTB+l1dBkQKN6T2DHMWePVQAoPW8YIPZjnkqa76
         g4Q9TV/1Yb6Ju+FpLR0zxhU9FlF/NLkBT5J2S1Sg9qLVul3zXrXN8J/fq/pJdD4yguA9
         a3gw==
X-Gm-Message-State: APjAAAV3c2hm5x7MgD3qcjy3BtDtoo9ykFtN57cVM8XO8jqQZ8dV5Lvi
        lb7UD98zeOuMaFplUBPCBwV8ZsamohRkXrZfBjYwdVeu2ZU=
X-Google-Smtp-Source: APXvYqzcd1u5djLRoP5594H8wgyIBFVS7zvE/vtPhyVQiFFKMQkgTfY11ObVbBY7/1Fl0SKN1oqMWpH7NPzY+u6ckXE=
X-Received: by 2002:a92:ce92:: with SMTP id r18mr16838121ilo.135.1575274074964;
 Mon, 02 Dec 2019 00:07:54 -0800 (PST)
MIME-Version: 1.0
References: <20191122154314.GA31076@bfoster> <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster> <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
 <20191126115415.GA50477@bfoster> <CAOcd+r3h=0umb-wdY058rQ=kPHpksMOwSh=Jc-did_tLkaioFw@mail.gmail.com>
 <0a1f2372-5c5b-85c7-07b8-c4a958eaec47@sandeen.net> <20191127141929.GA20585@infradead.org>
 <20191130202853.GA2695@dread.disaster.area> <CAOcd+r21Ur=jxvJgUdXs+dQj37EnC=ZWP8F45sLesQFJ_GCejg@mail.gmail.com>
 <20191201215732.GB2695@dread.disaster.area>
In-Reply-To: <20191201215732.GB2695@dread.disaster.area>
From:   Alex Lyakas <alex@zadara.com>
Date:   Mon, 2 Dec 2019 10:07:42 +0200
Message-ID: <CAOcd+r2gaoZz4=xWAh+d=-TNTOtBDvbEezN9OH3oks2p1TNhBg@mail.gmail.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Sun, Dec 1, 2019 at 11:57 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sun, Dec 01, 2019 at 11:00:32AM +0200, Alex Lyakas wrote:
> > Hi Dave,
> >
> > Thank you for your response.
> >
> > On Sat, Nov 30, 2019 at 10:28 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Wed, Nov 27, 2019 at 06:19:29AM -0800, Christoph Hellwig wrote:
> > > > Can we all take a little step back and think about the implications
> > > > of the original patch from Alex?  Because I think there is very little.
> > > > And updated sunit/swidth is just a little performance optimization,
> > > > and anyone who really cares about changing that after the fact can
> > > > trivially add those to fstab.
> > > >
> > > > So I think something like his original patch plus a message during
> > > > mount that the new values are not persisted should be perfectly fine.
> > >
> > > Well, the original purpose of the mount options was to persist a new
> > > sunit/swidth to the superblock...
> > >
> > > Let's ignore the fact that it was a result of a CXFS client mount
> > > bug trashing the existing sunit/swidth values, and instead focus on
> > > the fact we've been telling people for years that you "only need to
> > > set these once after a RAID reshape" and so we have a lot of users
> > > out there expecting it to persist the new values...
> > >
> > > I don't think we can just redefine the documented and expected
> > > behaviour of a mount option like this.
> > >
> > > With that in mind, the xfs(5) man page explicitly states this:
> > >
> > >         The sunit and swidth parameters specified must be compatible
> > >         with the existing filesystem alignment characteristics.  In
> > >         general,  that  means  the  only  valid changes to sunit are
> > >         increasing it by a power-of-2 multiple. Valid swidth values
> > >         are any integer multiple of a valid sunit value.
> > >
> > > Note the comment about changes to sunit? What is being done here -
> > > halving the sunit from 64 to 32 blocks is invalid, documented as
> > > invalid, but the kernel does not enforce this. We should fix the
> > > kernel code to enforce the alignment rules that the mount option
> > > is documented to require.
> > >
> > > If we want to change the alignment characteristics after mkfs, then
> > > use su=1,sw=1 as the initial values, then the first mount can use
> > > the options to change it to whatever is present after mkfs has run.
> >
> > If I understand your response correctly:
> > - some sunit/swidth changes during mount are legal and some aren't
> > - the legal changes should be persisted in the superblock
>
> Yup.
>
> > What about the repair? Even if user performs a legal change, it still
> > breaks the repairability of the file system.
>
> It is not a legal ichange if it moves the root inode to a new
> location. IOWs, if the alignment mods will result in the root inode
> changing location, then it should be rejected by the kernel.
>
> Anyway, we need more details about your test environment, because
> the example you gave:
>
> | # mkfs
> | mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=64,swidth=64 -l sunit=32 /dev/vda
> |
> | #mount with a different sunit/swidth:
> | mount -onoatime,sync,nouuid,sunit=32,swidth=32 /dev/vda /mnt/xfs
> |
> | #umount
> | umount /mnt/xfs
> |
> | #xfs_repair
> | xfs_repair -n /dev/vda
> | # reports false corruption and eventually segfaults[1]
>
> Does not reproduce the reported failure on my workstation running
> v5.3.0 kernel and a v5.0.0 xfsprogs:
>
> $ sudo mkfs.xfs -f -d file,name=1t.img,size=1t,sunit=64,swidth=64 -l sunit=32
> meta-data=1t.img                 isize=512    agcount=32, agsize=8388608 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=268435456, imaxpct=5
>          =                       sunit=8      swidth=8 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=131072, version=2
>          =                       sectsz=512   sunit=4 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

I believe in one of earlier emails in this thread, Brian mentioned
that this is related to "sparse inodes" being enabled:

"I couldn't reproduce this at first because sparse inodes is enabled
by default and that introduces more strict inode alignment requirements."

Can you please try mkfs'ing with spare inodes disabled?

Thanks,
Alex.


> $ sudo mount -o loop -o sunit=32,swidth=32 1t.img /mnt/1t
> $ sudo xfs_info /mnt/1t
> ....
> data     =                       bsize=4096   blocks=268435456, imaxpct=5
>          =                       sunit=4      swidth=4 blks
> ....
> $ sudo umount /mnt/1t
> $ sudo xfs_repair -f 1t.img
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - 08:42:14: scanning filesystem freespace - 32 of 32 allocation groups done
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
> ....
> Phase 7 - verify and correct link counts...
>         - 08:42:18: verify and correct link counts - 32 of 32 allocation groups done
> done
> $ echo $?
> 0
> $ sudo mount -o loop 1t.img /mnt/1t
> $ sudo xfs_info /mnt/1t
> ....
> data     =                       bsize=4096   blocks=268435456, imaxpct=5
>          =                       sunit=4      swidth=4 blks
> ....
> $
>
> So reducing the sunit doesn't necessarily change the root inode
> location, and so in some cases reducing the sunit doesn't change
> the root inode location, either.
>
> > For now, we made a local change to not persist sunit/swidth updates in
> > the superblock. Because we must have a working repair, and our kernel
> > (4.14 stable) allows any sunit/swidth changes.
>
> From the above, it's not clear where the problem lies - it may be
> that there's a bug in repair we've fixed since whatever version you
> are using....
>
> > We can definitely adhere to the recommended behavior of setting
> > sunit/swidth=1 during mkfs, provided the repair still works after
> > mounting with different sunit/swidth.
>
> ... hence I'd suggest that more investigation needs to be done
> before you do anything permanent...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
