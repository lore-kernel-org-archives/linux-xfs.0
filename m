Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHGOmb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 10:42:31 -0400
Date: Wed, 7 Aug 2019 07:42:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190807144215.GB7157@magnolia>
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
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Tue, Aug 06, 2019 at 10:41:38PM +0000, Luis Chamberlain wrote:
> On Mon, Aug 05, 2019 at 08:12:58AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 05, 2019 at 12:27:30PM +0200, Carlos Maiolino wrote:
> > > On Fri, Aug 02, 2019 at 08:14:00AM -0700, Darrick J. Wong wrote:
> > > > On Fri, Aug 02, 2019 at 11:19:39AM +0200, Carlos Maiolino wrote:
> > > > > Hi Darrick.
> > > > > 
> > > > > > > +		return error;
> > > > > > > +
> > > > > > > +	block = ur_block;
> > > > > > > +	error = bmap(inode, &block);
> > > > > > > +
> > > > > > > +	if (error)
> > > > > > > +		ur_block = 0;
> > > > > > > +	else
> > > > > > > +		ur_block = block;
> > > > > > 
> > > > > > What happens if ur_block > INT_MAX?  Shouldn't we return zero (i.e.
> > > > > > error) instead of truncating the value?  Maybe the code does this
> > > > > > somewhere else?  Here seemed like the obvious place for an overflow
> > > > > > check as we go from sector_t to int.
> > > > > > 
> > > > > 
> > > > > The behavior should still be the same. It will get truncated, unfortunately. I
> > > > > don't think we can actually change this behavior and return zero instead of
> > > > > truncating it.
> > > > 
> > > > But that's even worse, because the programs that rely on FIBMAP will now
> > > > receive *incorrect* results that may point at a different file and
> > > > definitely do not point at the correct file block.
> > > 
> > > How is this worse? This is exactly what happens today, on the original FIBMAP
> > > implementation.
> > 
> > Ok, I wasn't being 110% careful with my words.  Delete "will now" from
> > the sentence above.
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
> How long as it been broken for?

Probably since the beginning (ext2).

> And if we do fix it, I'd just like for
> a nice commit lot describing potential risks of not applying it. *If*
> the issue exists as-is today, the above contains a lot of information
> for addressing potential issues, even if theoretical.

I think a lot of the filesystems avoid the problem either by not
supporting > INT_MAX blocks in the first place or by detecting the
truncation in the fs-specific ->bmap method, so that might be why we
haven't been deluged by corruption reports.

--D

>   Luis
