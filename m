Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CB9C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 05:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A515206DB
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 05:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rynhart-co-nz.20150623.gappssmtp.com header.i=@rynhart-co-nz.20150623.gappssmtp.com header.b="XizjtYp6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfKPFvz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 00:51:55 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36843 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfKPFvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 00:51:55 -0500
Received: by mail-lj1-f194.google.com with SMTP id k15so12929810lja.3
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 21:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rynhart-co-nz.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=21FxouQjGxBARaM5eHm2+SBpfijABQRd5VoXvEG7NWg=;
        b=XizjtYp6SrkGehidnIclqPvMJt/KT2fxoTBY7JW8iJowC7H1+7sIAT+du5MjpqHceA
         EHb+Pd1F+AMQl8TEP0KLcpTYiSK1Ik0Ka6H3D7yRGb1xag2Xkw8FZ4swJOvQ5DjopiGT
         eUs3jZIKkKIOlFmMabWEaJ3B1sRIEYiIYRCcnBm2Inubl8KurpXssTkgs9eu4eAOjbgu
         M0EJR2uQ5aLRA4zpralXPuBlsCAm97Xmy6kzSi5YjegB2kbJ6XjC//F9wtria/Y6ohM7
         QnwJ8WKFJvMo3OXSiVy0FlW/z5XuvKL0OuifeYN53uReDebSjFGpxefeEGnMizh+u+nY
         j25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=21FxouQjGxBARaM5eHm2+SBpfijABQRd5VoXvEG7NWg=;
        b=oH9KL4+liWYlSrEkPhTJfMp9AM5y8DHTloTQFsGDd8LnETTvVL89uI3wfBO4pq/KEj
         /vuzorHNC56pr2sh//csMVtWuK7FflPZlHBM0ucDJrgKCxutFJdIWFmdUCxpARL58s13
         0bD0dbJWR2urGCGzymtQpUn4wmICTJxlM+XPXCNmvCBYupgJkQ7vcCL1zsmHX3RqeJea
         IXblcCXNwlpyAXCZg0zU2QEXj+xQnnHnh4dxmNrwDs2LQiGuoGANUtjfH8jGSfGGmXub
         nF5WR7VlMIHuVMIsldnGxRUThXpkG8GTbwMDoBgCt93k4BXRa3SotDBiOTGyzx+IMVfA
         9m3w==
X-Gm-Message-State: APjAAAUrY5I2j3ofwiHbFrEd984ALxImk7bKBGA/xkf03xqMwdYwhXAN
        PEsLE8xCqp5iWLrwomkwnjkVjkfRiV6FlLZEE8VSLQ==
X-Google-Smtp-Source: APXvYqzWoGsRAzC2EqjX1jIfwbChzt15SGmBv9KtlUbAaNsjtewrBwyCwgNoK27vkn6Bwc7IOWDJmkqJqDN1DY2K748=
X-Received: by 2002:a2e:7204:: with SMTP id n4mr12968578ljc.139.1573883513261;
 Fri, 15 Nov 2019 21:51:53 -0800 (PST)
MIME-Version: 1.0
References: <CAMbe+5D9cSEpR2YTWTmigi77caw93p6qR-iAYf-X_3_OJQMROw@mail.gmail.com>
 <80429a04-4b19-ec4a-1255-67b15c7b01f5@sandeen.net>
In-Reply-To: <80429a04-4b19-ec4a-1255-67b15c7b01f5@sandeen.net>
From:   Patrick Rynhart <patrick@rynhart.co.nz>
Date:   Sat, 16 Nov 2019 18:51:41 +1300
Message-ID: <CAMbe+5A9OtVodSeiDo10ufAAT4Wn50yH0FjgdO_5_ax3dLvyCw@mail.gmail.com>
Subject: Re: Inflight Corruption of XFS filesystem on CentOS 7.7 VMs
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, 16 Nov 2019 at 18:29, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 11/15/19 9:33 PM, Patrick Rynhart wrote:
> > Hi all,
> >
> > A small number of our CentOS VMs (about 4 out of a fleet of 200) are
> > experiencing ongoing, regular XFS corruption - and I'm not sure how to
> > troubleshoot the problem.  They are all CentOS 7.7 VMs are are using
> > VMWare Paravirtual SCSI.  The version of xfsprogs being used is
> > 4.5.0-20.el7.x86_64, and the kernel is 3.10.0-1062.1.2.el7.x86_64.
> > The VMWare version is ESXi, 6.5.0, 14320405.
> >
> > When the fault happens - the VMs will go into single user mode with
> > the following text displayed on the console:
> >
> > sd 0:0:0:0: [sda] Assuming drive cache: write through
> > XFS (dm-0): Internal error XFS_WANT_CORRUPTED_GOTO at line 1664 of
> > file fs/xfs/libxfs
> > /xfs_alloc.c. Caller xfs_free_extent+0xaa/0x140 [xfs]
> > XFS (dm-0): Internal error xfs_trans_cancel at line 984 of file
> > fs/xfs/xfs_trans.c.
> > Caller xfs_efi_recover+0x17d/0x1a0 [xfs]
> > XFS (dm-0): Corruption of in-memory data detected. Shutting down filesystem
> > XFS (dm-0): Please umount the filesystem and rectify the problem(s)
> > XFS (dm-0): Failed to recover intents
>
> Seems like this is not the whole relevant log; "Failed to recover intents"
> indicates it was in log replay but we don't see that starting.  Did you
> cut out other interesting bits?

Thank you for the reply.  When the problem happens the system ends up
in the EL7 dracut emergency shell.  Here's a picture of what the
console looks like right now (I haven't rebooted yet):

https://pasteboard.co/IGUpPiN.png

How can I get some debug information re the (attempted ?) log replay
for debug / analysis ?

> -Eric
