Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:37987 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbeEPGTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 02:19:49 -0400
Received: by mail-ot0-f169.google.com with SMTP id n3-v6so3107060ota.5
        for <linux-xfs@vger.kernel.org>; Tue, 15 May 2018 23:19:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180515075001.GA17568@infradead.org>
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
 <20180514173610.GC4933@magnolia> <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
 <20180515075001.GA17568@infradead.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 16 May 2018 00:19:48 -0600
Message-ID: <CAJCQCtRn2HV-y0EqjLkEHbzvTCeiDoETXKMeaXDrP42NjMRgHA@mail.gmail.com>
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Tue, May 15, 2018 at 1:50 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, May 14, 2018 at 11:52:18AM -0600, Chris Murphy wrote:
>> Is there a reason why this was made default before GRUB was fixed? Or
>> would XFS devs prefer to not support /boot on XFS?
>
> A bootloader that reads any non-trivial file system (and that includes
> XFS for sure) is a bad idea.

What constitutes non-trivial? It seems like this ship sailed a very
long time ago. The Windows bootloader's first job is to teach the
computer how to read NTFS, that's been true for over 20 years. Apple's
done the same with journaled HFS+ and most recently with their switch
to APFS. GRUB and syslinux have read Btrfs for around 8 years.

> So yes, if distros would not do that by
> default it would help a lot.

Fedora does not do this by default, but it doesn't disallow it. The
problem was discovered with a custom installation where /boot is a
dedicated XFS volume; but it's also reproducible in the likely more
common case where /boot is a directory on an XFS root fs.

Solutions are:
1. Update GRUB to support sparse inodes.
2. If /boot is on XFS, installer uses '-i sparse=0' at mkfs time.
3. Installer proscribes /boot on XFS (for any installation).

Fedora's release criteria requires that the system actually be able to
boot following an installation, so it's not OK to just pancake and let
the poor hapless user go find documentation or a bug report. Option 2
gets a bit complicated to account for the /boot dir on XFS case. GRUB
folks say they will eventually get to it, but have no time now or a
time estimate, so off hand I'd say that's check back in ~6 months.

I'm thinking it'll end up needing to be option 3, in the short term at least.


-- 
Chris Murphy
