Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:34833 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751310AbdIAHCj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 03:02:39 -0400
Received: by mail-wr0-f178.google.com with SMTP id y15so4111976wrc.2
        for <linux-xfs@vger.kernel.org>; Fri, 01 Sep 2017 00:02:39 -0700 (PDT)
Date: Fri, 1 Sep 2017 09:02:35 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: What is the proper way to remove an xfs partition?
Message-ID: <20170901070235.2ftrgavxsajfccen@hades.localdomain>
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <e74da24b-b604-b9af-e6b7-6943543fa56a@sandeen.net>
 <a1e12c3c-5238-e319-e2ea-982606e808b3@zoho.com>
 <61ba3b74-7525-39a1-f8ba-0c3ce6519b00@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61ba3b74-7525-39a1-f8ba-0c3ce6519b00@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: ToddAndMargo <ToddAndMargo@zoho.com>, linux-xfs@vger.kernel.org

Hi,

> >>> Hi All,
> >>>
> >>> Fedora 26
> >>> BIOS boot = legacy (EUFI give me hives)
> >>>
> >>> I have a SATA backup drive formatted gpt, one partition, xfs. I went into gparted, erased the partition, recreated the partition as ext4 and formatted it as ext4.
> >>>
> >>> Then I mounted it as ext4, copied some files to it, unmounted it. When I went to remount it, mount told me there was something wrong with ext4.
> >>
> >> What "something" was that?
> > 
> > mount: /lin-bak: wrong fs type, bad option, bad superblock on /dev/sdd1, missing codepage or helper program, or other error.
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>        ^^^^^^^^^^^^
>  
> <snip>
> 
> >>> What is the official way to remove an xfs partition?
> >>
> >> It's not usually needed, but if you don't want the kernel and/or utilities to recognize an xfs block device as xfs anymore, simply zero the first 512 bytes of that block device.
> > 
> > I can do that!
> > 
> > I was concerned about the gpt stuff at the end of the drive.
> > Ignored if I clobber the first 512 bytes?
> 
> The filesystem signature on a partition is a separate issue from
> the partition table signatures on the disk...
>
The overall report sounds interesting, the only thing I could think from the
top of my head is that ext4 and xfs places superblocks on different locations of
the disk (xfs at the very beginning, and ext4 skipping the first 1024bytes). I
wonder if for some reason when initializing ext4, the xfs superblock was not
wiped out.

Maybe some ext4 option to not touch old data and so prevent it to trash out the
xfs superblock?

Or, as Eric said, a dmesg might be useful, maybe you just have some caching that
complete messed up your filesystem initialization?


> -Eric

-- 
Carlos
