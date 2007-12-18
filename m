Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 06:38:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBIEcmQD007390
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:38:53 -0800
Date: Wed, 19 Dec 2007 01:38:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Do not reset xfsquota flags on quotaless ro mount
Message-ID: <20071218143849.GP4396912@sgi.com>
References: <Pine.LNX.4.64.0712181459210.32270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712181459210.32270@fbirervta.pbzchgretzou.qr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, Dec 18, 2007 at 03:04:03PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> In https://bugzilla.novell.com/show_bug.cgi?id=345338 it is claimed that
> resetting the quota flags in the mounting sequence rw,ro,rw is a bug, but I

You mounted without quotas in the middle step, thereby invalidating
them.

> would say this is not the case, as quota is metadata, and the log is replayed
> in ro mode even for other filesystems. Yet, it is still not nice, and I have
> been trying with this patch, which does not do the right thing yet. (It does a
> recovery when mounting for the 3rd time, which probably just says that I did
> not know too much of xfs internals to cook up a nicely working patch.)
> Opinions?

Log recovery occurs on read only mounts. Log recovery on filesystems without
quota enabled ignores quota changes in the log (as quotas are not enabled
and hence we can't assume that there's dquots still on disk). Hence a
mount read only without quota enabled will leave quota inconsistent on disk.

i.e

> 	mount -o usrquota,grpquota /dev/mapper/myxfs /mnt
> 	umount /mnt
> 	mount -o ro /dev/mapper/myxfs /mnt

Quota is now potentially inconsistent, and hence:

> 	umount /mnt
> 	mount -o usrquota,grpquota /dev/mapper/myxfs /mnt

This mount *must* recalculate it. So, behaviour is as expected
given the above command sequence.

You should use this as the middle step:

	mount -o ro,usrquota,grpquota /dev/mapper/myxfs /mnt

So that log replay replays all the journalled quota changes so
that the quota remains consistent with the rest of the filesystem.
Then you wont see a recalc when you remount rw.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
