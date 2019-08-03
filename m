Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36858 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387926AbfHCBNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 21:13:11 -0400
Date: Fri, 2 Aug 2019 18:11:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS file system corruption, refuses to mount
Message-ID: <20190803011106.GJ7138@magnolia>
References: <20181211183203.7fdbca0f@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211183203.7fdbca0f@lud1.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 02, 2019 at 09:53:56PM -0300, Luciano ES wrote:
> I've had this internal disk running for a long time. I had to 
> disconnect it from the SATA and power plugs for two days. 
> Now it won't mount. 
> 
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/cab3,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> 
> I get this in dmesg:
> 
> [   30.301450] XFS (dm-1): Mounting V5 Filesystem
> [   30.426206] XFS (dm-1): Corruption warning: Metadata has LSN
> (16:367696) ahead of current LSN (16:367520). Please unmount and run
> xfs_repair (>= v4.3) to resolve.

Hm, I think this means the superblock LSN is behind the log LSN, which
could mean that... software is buggy?  The disk didn't flush its cache
before it was unplugged?  Something else?

What kernel & xfsprogs?

And how did you disconnect it from the power plugs?

> [   30.426209] XFS (dm-1): log mount/recovery failed: error -22
> [   30.426310] XFS (dm-1): log mount failed
> 
> Note that the entire disk is encrypted with cryptsetup/LUKS, 
> which is working fine. Wrong passwords fail. The right password 
> opens it. But then it refuses to mount.
> 
> This has been happening a lot to me with XFS file systems. 
> Why is this happening?
> 
> Is there something I can do to recover the data?

Try xfs_repair -n to see what it would do if you ran repair?

--D

> -- 
> Luciano ES
> >>
