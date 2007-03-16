Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 23:02:01 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2G61r6p023662
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 23:01:55 -0700
Subject: Re: [xfs-masters] XFS and booting
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <45FA1605.6080405@zytor.com>
References: <45FA1605.6080405@zytor.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 17:01:48 +1100
Message-Id: <1174024908.5051.230.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com

Hi,

On Thu, 2007-03-15 at 20:59 -0700, H. Peter Anvin wrote:
> I have been looking at adding XFS support to the syslinux bootloader 
> suite, and discovered, to my dismay:
> 
> No, for root partition installations because the XFS superblock is 
> written at block zero, where LILO would be installed. This is to 
> maintain compatibility with the IRIX on-disk format, and will not be 
> changed.

This FAQ entry could probably be worded a bit more diplomatically.
It is both the IRIX format (11+ years) and the last 6+ years of use
of XFS on Linux by many, many people (and many SGI / other companies
paying customers) that prevents this kind of change at this stage.

> This means that it's impossible to write a boot loader that actually 
> plays by the x86 platform rules and still can boot from XFS.  Other than 

Using lilo with an xfs root via the boot=/dev/hda and root=/dev/hda1
method (i.e. non-root-partition MBR) has been working OK for me and
others.  Is that not playing by the rules?  Is that an option for
your setup?  It's a third option to the two you listed anyway (grub
vs /boot, I mean).

> the GRUB option of spreading itself all over the disk in places it 
> shouldn't be, like the MBR, thus breaking e.g. softraid and creating all 
> kinds of unnecessary interoperability problems.
> 
> Anyway, since it looks like the damage of not offsetting the filesystem 
> has already been done, I'm trying to figure out what, if anything, can 

Or, worded another way, "the damage of designing a system having an MBR
in the first sector of space that is then allocated to filesystems" -
it's a shocker of a layering violation.

> be done about it.  A standard MBR will never be able to boot an XFS, but 
> perhaps a slightly modified MBR can be made to do that, without 
> introducing filesystem-instance-specific issues.  In particular, if 
> there is space anywhere in the superblock for a "boot sector pointer", 
> *and* there is a way to safely write this pointer, then a slightly 
> modified MBR could detect an XFS superblock and re-read a boot sector at 
> that offset.
> 
> Is this something that could be done?

It could be done - thats not the sound of me volunteering though ;) -
there is space available in most XFS filesystem geometries that could
be reclaimed for this kind of thing.

For example, for a 512 byte sector filesystem with a 4K blocksize, we
have unused sectors at bytes 2048->4096 (following the space used for
the first 4 sectors - SB, AGI AGF, AGFL, but before the first fsblock).
This is the default mkfs geometry, so by far most filesystems have the
free space here that could be utilised by a boot loader.  And there's
plenty of space in the superblock for a field with the meaning "the
boot sector lives here".  Actually, it'd be pretty straightforward to
do this in XFS - the trickier part is working out in mkfs all of the
geometries which do not result in freespace available for a boot sector,
but thats not really very hard either.

The important question is, would anyone use it, if such a feature was
available?  Eric/I/... well, anyone could probably hack up the XFS code
in a weekend to allow someone to test this out, but I'd want to be very
sure it wasn't going to be wasted effort...

cheers.

-- 
Nathan
