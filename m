Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36388 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbeHaUyD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 16:54:03 -0400
Date: Fri, 31 Aug 2018 09:45:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_scrub_all warning
Message-ID: <20180831164535.GA4355@magnolia>
References: <974f65da-60f9-55aa-2e27-3fe9abb64f97@bodenbinder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <974f65da-60f9-55aa-2e27-3fe9abb64f97@bodenbinder.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthias Bodenbinder <matthias@bodenbinder.de>
Cc: xfs <linux-xfs@vger.kernel.org>

[add linux-xfs to cc]

On Fri, Aug 31, 2018 at 07:31:25AM +0200, Matthias Bodenbinder wrote:
> Hello Darrick,
> 
> you are named as maintainer in the xfs_scrub_all python script which is
> coming with Manjaro Linux. Therefore I am writing to you about a
> "cosmetic" issue with invalid unit names.
> 
> I have / and /home setup as XFS. When I run the script I get the
> following output:
> 
> 1# xfs_scrub_all
> Scrubbing /home...
> Invalid unit name "xfs_scrub@/home" was escaped as "xfs_scrub@-home"
> (maybe you should use systemd-escape?)

Oh, lovely, systemd changed their escaping rules again...

> Starting Online XFS Metadata Check for /home...
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Info: AG 1 superblock: Optimization is possible.
> Info: AG 2 superblock: Optimization is possible.
> Info: AG 3 superblock: Optimization is possible.
> Scrubbing /home done, (err=0)
> Scrubbing /...
> Invalid unit name "xfs_scrub@/" was escaped as "xfs_scrub@-" (maybe you
> should use systemd-escape?)
> Started Online XFS Metadata Check for /home.
> Scrubbing / done, (err=0)
> 
> Can you fix that?

I think so.  If you remove the lines:

	if '-' not in path:
		return path

from systemd_escape() in /sbin/xfs_scrub_all, do the warnings go away?
Does scrub still work afterwards?

--D

> 
> Thanks
> 
> Matthias
> 
> 
