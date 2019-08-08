Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37088 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731226AbfHHHND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 03:13:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id b3so1400053wro.4
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 00:13:01 -0700 (PDT)
Date: Thu, 8 Aug 2019 09:12:58 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190808071257.ufbk5i35xpkf4byh@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
 <20190731231217.GV1561054@magnolia>
 <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
 <20190802151400.GG7138@magnolia>
 <20190805102729.ooda6sg65j65ojd4@pegasus.maiolino.io>
 <20190805151258.GD7129@magnolia>
 <20190806224138.GW30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806224138.GW30113@42.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

> > 
> > > Maybe I am not seeing something or having a different thinking you have, but
> > > this is the behavior we have now, without my patches. And we can't really change
> > > it; the user view of this implementation.
> > > That's why I didn't try to change the result, so the truncation still happens.
> > 
> > I understand that we're not generally supposed to change existing
> > userspace interfaces, but the fact remains that allowing truncated
> > responses causes *filesystem corruption*.
> > 
> > We know that the most well known FIBMAP callers are bootloaders, and we
> > know what they do with the information they get -- they use it to record
> > the block map of boot files.  So if the IPL/grub/whatever installer
> > queries the boot file and the boot file is at block 12345678901 (a
> > 34-bit number), this interface truncates that to 3755744309 (a 32-bit
> > number) and that's where the bootloader will think its boot files are.
> > The installation succeeds, the user reboots and *kaboom* the system no
> > longer boots because the contents of block 3755744309 is not a bootloader.
> > 
> > Worse yet, grub1 used FIBMAP data to record the location of the grub
> > environment file and installed itself between the MBR and the start of
> > partition 1.  If the environment file is at offset 1234578901, grub will
> > write status data to its environment file (which it thinks is at
> > 3755744309) and *KABOOM* we've just destroyed whatever was in that
> > block.
> > 
> > Far better for the bootloader installation script to hit an error and
> > force the admin to deal with the situation than for the system to become
> > unbootable.  That's *why* the (newer) iomap bmap implementation does not
> > return truncated mappings, even though the classic implementation does.
> > 
> > The classic code returning truncated results is a broken behavior.
> 
> How long as it been broken for? And if we do fix it, I'd just like for
> a nice commit lot describing potential risks of not applying it. *If*
> the issue exists as-is today, the above contains a lot of information
> for addressing potential issues, even if theoretical.
> 

It's broken since forever. This has always been the FIBMAP behavior.


>   Luis

-- 
Carlos
