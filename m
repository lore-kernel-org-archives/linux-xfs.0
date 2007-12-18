Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 04:33:03 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBICWtwg026687
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 04:32:58 -0800
Date: Tue, 18 Dec 2007 23:32:59 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: kernel oops on debian , 2.6.18-5
Message-ID: <20071218123259.GL4396912@sgi.com>
References: <476790D5.6040205@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476790D5.6040205@univ-nantes.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: xfs@oss.sgi.com, Jacky Carimalo <jacky.carimalo@univ-nantes.fr>

On Tue, Dec 18, 2007 at 10:20:21AM +0100, Yann Dupont wrote:
> Hello, we got a kernel oops, probably in xfs on a debian kernel.
> 
> This volume is on SAN + device mapper.
> this is a 1 TB  volume. It was in service for more than 2 ou 3 years. 
> There is a high humber of files on it, as this volume serves for a 
> rsyncd, where 200+ servers sync their root filesystem on it every day.
> 
> here is the oops :
> 
> Dec 16 23:27:32 inchgower kernel: XFS internal error 
> XFS_WANT_CORRUPTED_GOTO at line 1561 of file fs/xfs/xfs_alloc.c.  Caller 
> 0xffffffff881857b7
> Dec 16 23:27:32 inchgower kernel:
> Dec 16 23:27:32 inchgower kernel: Call Trace:
> Dec 16 23:27:32 inchgower kernel:  [<ffffffff88183ec0>] 
> :xfs:xfs_free_ag_extent+0x19f/0x67f

corrupted freespace btree. what does xfs_check tell you about the
filesystem on dm-3?

> Please note that it is not the "generic" debian kernel, but the vserver 
> one - but stock etch version anyway. We had not seen any problems with 
> this combination, (xfs + debian kernel-vserver) which is very largely 
> deployed here. This is a first.
> 
> Do you think the problems is due to xfs or other factors ?

Could be a hardware problem. Could be an XFs problem. Coul dbe a dm problem.
I really can't say from a shutdown message like this - all it tells us is
that a btree block was corrupted by something since the last time it was
checked....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
