Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbeLCSil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 13:38:41 -0500
Date: Mon, 3 Dec 2018 10:38:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [QUESTION] XFS inode allocation policy
Message-ID: <20181203183832.GB24487@magnolia>
References: <CAHjZ2x7pVC+XU2BqXk2O4mEHAcH8bPsJzZsSdvBHqhCiMd0OQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHjZ2x7pVC+XU2BqXk2O4mEHAcH8bPsJzZsSdvBHqhCiMd0OQw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vincenzo Romano <vincenzo.romano@notorand.it>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 03:31:46PM +0100, Vincenzo Romano wrote:
> Hi all.
> I am trying to recover a Linux XFS file system that has been partially
> overwritten in its beginning part with an improper run of dd (disk
> dump).
> The original FS had been created from scratch (mkfs.xfs) and then
> filled with a single TAR file.
> I'd need to be pointed to the proper documentation (if any) to better
> understand how the disk space has been used while writing that TAR
> file.
> I aim to reconstruct the surviving inode list to try to rescue as much
> as possible of that TAR file.

In general, directories are spread across the allocation groups, and
files are allocated near the directory in which they were created.  The
one huge tarball was probably in AG 0 along with the root directory,
which means that both are likely unrecoverable.  That said, xfs_repair
could be able to reconstruct the primary sb from a secondary copy (make
a working copy and run xfs_repair -n against the working copy)... but
the data might be still be unrecoverable.

Definitely make a working copy of the disk and run your recovery tools
against that working copy, leaving the original alone.  Good luck!

--D

> Many thanks in advance.
> 
> -- 
> Vincenzo Romano - NotOrAnd.IT
> Information Technologies
> --
> NON QVIETIS MARIBVS NAVTA PERITVS
