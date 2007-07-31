Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jul 2007 18:53:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6V1r5bm026504
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 18:53:07 -0700
Date: Tue, 31 Jul 2007 11:53:00 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Repeated XFS corruption -Corruption of in-memory data detected
Message-ID: <20070731015300.GM31489@sgi.com>
References: <1b0b1fc90707300910va417055mb1e64126c1519c9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b0b1fc90707300910va417055mb1e64126c1519c9f@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ryan Bair <ryandbair@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[cc xfs@oss.sgi.com]

On Mon, Jul 30, 2007 at 12:10:52PM -0400, Ryan Bair wrote:
> Kernel: 2.6.18-4-amd64 (Debian 2.6.18.dfsg.1-12etch2) Debian Etch
> System: Dell PowerEdge 1850
> Processor: 3.2 GHz Intel Xeon w/ microcode v1.14a, Hyperthreading disabled.
> RAM: 2x1GB ECC DDR-400
> RAID Controller: Dell PERC5/E using megaraid driver
> 
> I got another unexpected error on my XFS partition today. I was able
> to reboot the system normally and the journal recovered on the
> following mount. Shortly thereafter, the error occurred again. After
> this the filesystem was no longer able to be mounted as the error
> would occur immediately.
> 
> The volume is on a 9.5TB LVM2 volume on a Dell MD1000 loaded with 15
> 750GB drives in a RAID5 set. Writeback is disabled. Memtest86+ was run
> on this system for 48 hours without fault. The system is otherwise
> stable.

<sigh>

You're the second person today to report a software RAID5+XFS corruption on
the 2.6.18-4 Debian kernel. Almost the same signature as well - that is a
corrupted free space btree.

> XFS was able to repair the damage, but previously the drive returned
> to its corrupted state within a few hours of heavy I/O.

The other report was a shutdown before corruption got to disk,
so maybe they are different problems.

Can you post the repair output so we can see what the damage was?
Also, can you post your md/dm config so I can see if I can recreate
a similar config?

Also, seeing as the previous report was caught before corruption
got to disk, I suspected memory corruption of some kind. Can
you enable slab, vm and filesystem debugging for you kernel and
run with that?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
