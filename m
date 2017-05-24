Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:33028 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757479AbdEXGZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2017 02:25:11 -0400
Received: by mail-yb0-f195.google.com with SMTP id d72so6298795ybh.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2017 23:25:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTgtMPCdZA3SOV7UFmQ3Y83op2JHPh-0iSkm7-2SvMCXg@mail.gmail.com>
References: <20170518012618.GT4519@birch.djwong.org> <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard> <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org> <20170522020112.GV17542@dastard>
 <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com> <CAJCQCtTgtMPCdZA3SOV7UFmQ3Y83op2JHPh-0iSkm7-2SvMCXg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 24 May 2017 00:25:10 -0600
Message-ID: <CAJCQCtQGygHty6zmfKUqJq+R3CRFy-3CtoQOe8okSzYykOLxTA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, May 24, 2017 at 12:22 AM, Chris Murphy <lists@colorremedies.com> wrote:
> Here's an example from an updated system that
> fails to boot due to zero length grub.cfg;
>
> -rw-------. 1 root root 59650987 May 23 18:16
> initramfs-0-rescue-a0269ef67a5f4c1ca97e0817ac1c4a6d.img
> -rw-------. 1 root root 19764807 May 23 18:16 initramfs-4.11.0-2.fc26.x86_64.img
> -rw-r--r--. 1 root root   182704 Feb 10 22:58 memtest86+-5.01
> -rw-------. 1 root root  3548950 May  9 09:42 System.map-4.11.0-2.fc26.x86_64
> -rw-------. 1 root root        0 May 15 13:46 System.map-4.11.1-300.fc26.x86_64
> -rwxr-xr-x. 1 root root  7282776 May 23 18:16
> vmlinuz-0-rescue-a0269ef67a5f4c1ca97e0817ac1c4a6d
> -rwxr-xr-x. 1 root root  7282776 May  9 09:43 vmlinuz-4.11.0-2.fc26.x86_64
> -rwxr-xr-x. 1 root root        0 May 15 13:46 vmlinuz-4.11.1-300.fc26.x86_64
>
> -rw-rw-r--. 1 root root    0 May 23 18:44 grub.cfg

FWIW this was mounted with -o ro,norecovery following an update that
resulted in the problem of hitting the grub prompt instead of a boot
menu.

-- 
Chris Murphy
