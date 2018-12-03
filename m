Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f49.google.com ([209.85.210.49]:37195 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeLCTJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 14:09:37 -0500
Received: by mail-ot1-f49.google.com with SMTP id 40so12699387oth.4
        for <linux-xfs@vger.kernel.org>; Mon, 03 Dec 2018 11:09:35 -0800 (PST)
MIME-Version: 1.0
References: <CAHjZ2x7pVC+XU2BqXk2O4mEHAcH8bPsJzZsSdvBHqhCiMd0OQw@mail.gmail.com>
 <20181203183832.GB24487@magnolia>
In-Reply-To: <20181203183832.GB24487@magnolia>
From: Vincenzo Romano <vincenzo.romano@notorand.it>
Date: Mon, 3 Dec 2018 20:08:58 +0100
Message-ID: <CAHjZ2x6-Z1RKx3Qn4tuYZa6E1R1jqXmuUS2BsxBZ9mMS51=0DQ@mail.gmail.com>
Subject: Re: [QUESTION] XFS inode allocation policy
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Il giorno lun 3 dic 2018 alle ore 19:38 Darrick J. Wong
<darrick.wong@oracle.com> ha scritto:
>
> On Mon, Dec 03, 2018 at 03:31:46PM +0100, Vincenzo Romano wrote:
> > Hi all.
> > I am trying to recover a Linux XFS file system that has been partially
> > overwritten in its beginning part with an improper run of dd (disk
> > dump).
> > The original FS had been created from scratch (mkfs.xfs) and then
> > filled with a single TAR file.
> > I'd need to be pointed to the proper documentation (if any) to better
> > understand how the disk space has been used while writing that TAR
> > file.
> > I aim to reconstruct the surviving inode list to try to rescue as much
> > as possible of that TAR file.
>
> In general, directories are spread across the allocation groups, and
> files are allocated near the directory in which they were created.  The
> one huge tarball was probably in AG 0 along with the root directory,
> which means that both are likely unrecoverable.  That said, xfs_repair
> could be able to reconstruct the primary sb from a secondary copy (make
> a working copy and run xfs_repair -n against the working copy)... but
> the data might be still be unrecoverable.
>
> Definitely make a working copy of the disk and run your recovery tools
> against that working copy, leaving the original alone.  Good luck!

Thanks Darrick for the feedback.

I'd like to put some data here in order to get a more realistic
estimate from you (provided it's possible).
The device that's been freshly XFS-formatted is a 2TB disk.
The data that's been put onto it is a 1.3TB uncompressed TAR file.
The first 586MB of the XFS file system got overwitten with an UEFI boot image.
Do you think there's still some chance to recover a (trailing) part of
the TAR file?
Should I restore the original DOS partition table (with just one partition)?

Thanks again.

> --D
>
> > Many thanks in advance.
> >
> > --
> > Vincenzo Romano - NotOrAnd.IT
> > Information Technologies
> > --
> > NON QVIETIS MARIBVS NAVTA PERITVS



-- 
Vincenzo Romano - NotOrAnd.IT
Information Technologies
--
cel. +39 3398083886
--
NON QVIETIS MARIBVS NAVTA PERITVS
