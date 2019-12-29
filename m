Return-Path: <SRS0=kaVg=2T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5410C2D0C0
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Dec 2019 05:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D3CE208C4
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Dec 2019 05:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=iith.ac.in header.i=@iith.ac.in header.b="5P2am2EC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfL2F6k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Dec 2019 00:58:40 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:32884 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfL2F6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Dec 2019 00:58:40 -0500
Received: by mail-ed1-f67.google.com with SMTP id r21so29192217edq.0
        for <linux-xfs@vger.kernel.org>; Sat, 28 Dec 2019 21:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iith.ac.in; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xir2VlUUCGiruyD7GilSO++SLfAm8nu7V1BznD0+lM8=;
        b=5P2am2EC1hwkrDzdG4wUk/2CnI/gW8LiwurlrriOm65lp9k24Qr1c6/7DPflbC5A9O
         TO8efyFXH5r+0WVtYaLEQb8z9p2xgLMtP/gnjVS1jZwU7ap6KIb8+HVV5+Tn1F0EXk1n
         +vWw/o/TmxpAsD2FLyacIByb/cG5s9PJVKCQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xir2VlUUCGiruyD7GilSO++SLfAm8nu7V1BznD0+lM8=;
        b=RdurI6PLuyEnWUmd/1Q1SDVXUNKh1taEQpV/wl9DDakZyTDSrrcgZhtlg7OvxV9fVC
         rEv4lu8UD3hjh/S+iWvUC0mVOlikNT9f6Hlps8RLpoPXu1HXFPFNwjTTufV9ZQGvazvV
         eEn1kfbZq7uVlq1/YcQeW+gM8NiDjn5h0Abr7qIvNbXbByG1SI4GA3yowUddpUWlVLZi
         PvQX8YiU6UYbIxbCANrNmzKvVBbTpEvQuT3nmjwcYio0K2DrI4DXmy62L/fuaZ+qsfhx
         jFc82IUXQd9/VmC+rG930IqKKBN05Qkk0oj718vXAtcpluzu0ZOrRCeLXNgJkPyUjAjv
         M3/A==
X-Gm-Message-State: APjAAAX+3ikNO8IFQUQOA1Ri5/DBn5JjIxsBaWsozYamCNwBxX8Aslvb
        5JdUT3w0s0bEvMk7Mkq898KRN3rtJ4wM4fIGFpEkaf+wKTU=
X-Google-Smtp-Source: APXvYqx0u/Q3fRv3tfNYbUlb6qqIb5yS82SSaeveK4ZCxRJmqalk1LVr6oWl3QabB2OtGzmiLB7Z0aB0rWoE3+QRB88=
X-Received: by 2002:a17:907:11cc:: with SMTP id va12mr63476744ejb.164.1577599118884;
 Sat, 28 Dec 2019 21:58:38 -0800 (PST)
MIME-Version: 1.0
References: <CAH3av2k4c63LKQ0eG9twweXEgC7QD7G_w3=c23tSO5rLP_cAfQ@mail.gmail.com>
 <FED1D514-006F-4522-A227-66889C82B82C@sandeen.net>
In-Reply-To: <FED1D514-006F-4522-A227-66889C82B82C@sandeen.net>
From:   Utpal Bora <cs14mtech11017@iith.ac.in>
Date:   Sun, 29 Dec 2019 11:28:02 +0530
Message-ID: <CAH3av2kFYraRHc-qVruXKMCjw7USaZHL0iYPwwWCpSyg=Y8=9g@mail.gmail.com>
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0 of
 512 bytes
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

Thank you for your help. Growing back lv to original size helped.

I am really thankful.

Is there a way for lvm to warn users while invoking lvreduce to check
if the file system should be shrunk before lvreduce.

Regards,

Utpal Bora
Ph.D. Scholar
Computer Science & Engineering
IIT Hyderabad
http://utpalbora.com
PGP key fingerprint: 2F12 635E 409F 11AC 1502  BB41 7705 9980 A062 FA70

Regards,

Utpal Bora
Ph.D. Scholar
Computer Science & Engineering
IIT Hyderabad
http://utpalbora.com
PGP key fingerprint: 2F12 635E 409F 11AC 1502  BB41 7705 9980 A062 FA70



On Sun, Dec 29, 2019 at 10:13 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On Dec 28, 2019, at 3:11 AM, Utpal Bora <cs14mtech11017@iith.ac.in> wrote=
:
> >
> > Hi,
> >
> > My XFS home drive is corrupt after trying to extend it with lvm.
> > This is what I did to extend the partition.
> > 1. Extend Volume group to use a new physical volume of around 1.2TB.
> > This was successful without any error.
> >    vgextend vg-1 /dev/sdc1
> >
> > 2. Extend logical volume (home-lv) to use the free space.
> >    lvextend -l 100%FREE /dev/mapper/vg--1-home--lv -r
> >
> This probably invoked xfs_growfs
>
> > 3. Resized home-lv and reduce 55 GB
> >   lvreduce -L 55G  /dev/mapper/vg--1-home--lv -r
> >
> XFS cannot shrink.  This corrupted your filesystem by truncating the bloc=
k device.
>
> > I assumed that -r will invoke xfs_grow internally.
> > Everything was working fine until the server was restarted.
> > After restart, the home volume is not mounting. Please see the followin=
g.
> >
> > server% sudo mount -t xfs /dev/mapper/vg--1-home--lv /home
> > mount: /home: can't read superblock on /dev/mapper/vg--1-home--lv.
> >
> > server% dmesg| tail
> > [162580.208796] attempt to access beyond end of device
> > [162580.208800] dm-3: rw=3D4096, want=3D6650552320, limit=3D6640066560
> > [162580.208805] XFS (dm-3): last sector read failed
>
> Because you chopped off 55g from the end.
>
> > server% sudo xfs_repair -n
>
> Repair cannot read blocks that have been removed from the filesystem.
>
>
> > /dev/mapper/vg--1-home--lv
> > Phase 1 - find and verify superblock...
> > xfs_repair: error - read only 0 of 512 bytes
>
> Failed to read a backup super beyond the end of the reduced lv.
>
> Grow the lv back to 100% I.e. the size before the lvreduce and it=E2=80=
=99ll probably be ok again
>
> -Eric
>
> > OS: Ubuntu Server 18.04.3
> > Kernel: 4.15.0-72-generic
> >
> > I have gone through the earlier posts on this subject. They did not hel=
p me.
> >
> > Is it possible to repair the XFS volume? Kindly suggest.
> >
> > Regards,
> >
> > Utpal Bora
> > Ph.D. Scholar
> > Computer Science & Engineering
> > IIT Hyderabad
> >
>
