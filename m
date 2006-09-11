Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Sep 2006 18:10:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8B1ABDW031571
	for <xfs@oss.sgi.com>; Sun, 10 Sep 2006 18:10:22 -0700
Date: Mon, 11 Sep 2006 11:09:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_repair -d doesn't work
Message-ID: <20060911010916.GM10950339@melbourne.sgi.com>
References: <4504A3A9.4080704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4504A3A9.4080704@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Enrico Maria Crisostomo <enrico.m.crisostomo@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 11, 2006 at 01:45:45AM +0200, Enrico Maria Crisostomo wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi.
> 
> I'm running a slackware-current with xfsprogs-2.8.10_1. On some
> machine I ran many 2.6.17 kernel and one machine is showing the
> "directory problem": I cannot get rid of many "Filesystem "hda3": XFS
> internal error xfs_da_do_buf(2) at line 2212 of file
> fs/xfs/xfs_da_btree.c. Caller 0xe0ac57d9". As I'm now running
> 2.6.17.13 I think I'm at safe from this bug and the last thing to do
> is... repairing my root filesystem. Unfortunately xfs_repair -d and
> xfs_repair -n does not work, and it returns saying it could not
> initialize XFS library because the filesystem is mounted AND writable.
> What I did:
> - - remounted the file system read only: did not work, not even
> xfs_repair -n, which I expect to succeed always
> - - hacked /etc/mtab to change rw to ro: did not work, error is the same
> as before.

IIRC, we recently updated libxfs to look at /proc/mounts rather than
/etc/mtab to fix these sorts of problems.

As it is, to fix the "directory problem" you need a more recent
xfsprogs (2.8.11 IIRC), so I'd suggest the first thing to do is
upgrade your xfsprogs and try again.

> Can you suggest me some way to repair my file system

You should be able to boot to single user mode, remount the root
filesystem readonly and then "xfs_repair -d <dev>" to fix it. You
need to reboot after doing this....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
