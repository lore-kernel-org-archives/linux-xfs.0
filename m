Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Dec 2006 10:06:49 -0800 (PST)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBRI6fqw022684
	for <linux-xfs@oss.sgi.com>; Wed, 27 Dec 2006 10:06:43 -0800
Date: Wed, 27 Dec 2006 19:05:42 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: Possible performance problem introduced between kernel 2.6.15 and 2.6.17 on xfs code
Message-ID: <20061227180542.GA6888@teal.hq.k1024.org>
References: <458D4845.2010803@emaze.net> <458D4EEB.3060501@sandeen.net> <458DCB8D.3040804@emaze.net> <4592942C.5000306@sandeen.net> <4592B581.7080806@emaze.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4592B581.7080806@emaze.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Francesco Degrassi <francesco.degrassi@emaze.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@oss.sgi.com

On Wed, Dec 27, 2006 at 07:03:45PM +0100, Francesco Degrassi wrote:
> I tried ext2, ext3, jfs, reiser3, vfat and the problem does not show up.
> Anyway i discovered that if i create a regular file in an XFS partition,
> create an XFS filesystem on it as if it was a regular block device, and
> mount it with the loop device, the problem does NOT manifest.
> So it seems to affect XFS filesystems on regular block devices only ?
> I'm confused.

This is probably not related, but I remember that barriers were added
sometime between 2.6.15 and 2.6.17 and probably barriers are not enabled
on a loop filesystem. Maybe the gnome vfs thing does some sync which
force flushes or such. I'm no expert, just guessing.

Just to invalidate this (probably wrong) guess, could you try to mount
/tmp with "-o nobarrier" and re-test?

Iustin, who wishes md raid1 would support barriers.
