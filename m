Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36800 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbeEPO4B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 May 2018 10:56:01 -0400
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
 <20180514173610.GC4933@magnolia>
 <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
 <20180515075001.GA17568@infradead.org>
 <CAJCQCtRn2HV-y0EqjLkEHbzvTCeiDoETXKMeaXDrP42NjMRgHA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e9d32e1e-89ab-ac1d-817d-82f4a45e52b4@sandeen.net>
Date: Wed, 16 May 2018 09:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRn2HV-y0EqjLkEHbzvTCeiDoETXKMeaXDrP42NjMRgHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>



On 5/16/18 1:19 AM, Chris Murphy wrote:
> On Tue, May 15, 2018 at 1:50 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Mon, May 14, 2018 at 11:52:18AM -0600, Chris Murphy wrote:
>>> Is there a reason why this was made default before GRUB was fixed? Or
>>> would XFS devs prefer to not support /boot on XFS?
>>
>> A bootloader that reads any non-trivial file system (and that includes
>> XFS for sure) is a bad idea.
> 
> What constitutes non-trivial? It seems like this ship sailed a very
> long time ago. The Windows bootloader's first job is to teach the
> computer how to read NTFS, that's been true for over 20 years. Apple's
> done the same with journaled HFS+ and most recently with their switch
> to APFS. GRUB and syslinux have read Btrfs for around 8 years.
> 
>> So yes, if distros would not do that by
>> default it would help a lot.
> 
> Fedora does not do this by default, but it doesn't disallow it. The
> problem was discovered with a custom installation where /boot is a
> dedicated XFS volume; but it's also reproducible in the likely more
> common case where /boot is a directory on an XFS root fs.
> 
> Solutions are:
> 1. Update GRUB to support sparse inodes.
> 2. If /boot is on XFS, installer uses '-i sparse=0' at mkfs time.
> 3. Installer proscribes /boot on XFS (for any installation).
> 
> Fedora's release criteria requires that the system actually be able to
> boot following an installation, so it's not OK to just pancake and let
> the poor hapless user go find documentation or a bug report. Option 2
> gets a bit complicated to account for the /boot dir on XFS case. GRUB
> folks say they will eventually get to it, but have no time now or a
> time estimate, so off hand I'd say that's check back in ~6 months.
> 
> I'm thinking it'll end up needing to be option 3, in the short term at least.

while y'all were scurrying around hacking up fedora bits, I sent a patch
to fix grub, FWIW.  Hopefully Fedora will pick that up and move on.

-Eric
