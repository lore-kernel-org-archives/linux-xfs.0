Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 09:23:05 -0800 (PST)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NHMuqw016497
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 09:22:57 -0800
Date: Tue, 23 Jan 2007 17:58:03 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: how to sync / commit data to disk?
Message-ID: <20070123165803.GA17430@teal.hq.k1024.org>
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Gervai <grinapo@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 23, 2007 at 04:16:59PM +0100, Peter Gervai wrote:
> My educated guess would be
> xfs_freeze -f
> sync
> xfs_freeze -u
> 
> but I give a large chance to be wrong about it.
> 
> Ideas?

I usually unmount the /boot partition if I need to reinstall grub (which
is a rare event). Since nowadays klogd doesn't keep /boot/System.map
open anymore, there is no reason not to do an umount/grub install/mount
sequence.

Iustin
