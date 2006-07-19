Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 18:21:28 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6J1LCDW001010
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 18:21:13 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <17597.27469.834961.186850@base.ty.sabi.co.UK>
References: <1153150223.4532.24.camel@localhost.localdomain>
	 <17595.47312.720883.451573@base.ty.sabi.co.UK>
	 <1153262166.2669.267.camel@localhost.localdomain>
	 <17597.27469.834961.186850@base.ty.sabi.co.UK>
Content-Type: text/plain
Date: Tue, 18 Jul 2006 21:20:44 -0400
Message-Id: <1153272044.2669.282.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>
Cc: Linux XFS <linux-xfs@oss.sgi.com>

On Wed, 2006-07-19 at 00:14 +0100, Peter Grandi wrote:
> >>> On Tue, 18 Jul 2006 18:36:06 -0400, Ming Zhang
> >>> <mingz@ele.uri.edu> said:
> 
> mingz> [ .. ] example on what is an improper use?
> 
> Well, this mailing list is full of them :-). However it is
> easier to say what is an optimal use:
> 
>   * A 64 bit system.
>   * With a large, parallel storage system.

when u say large parallel storage system, you mean independent spindles
right? but most people will have all disks configured in one RAID5/6 and
thus it is not parallel any more.


>   * The block IO system handles all storage errors.

so current MD/LVM/SATA/SCSI layers are not good enough?

>   * With backups of the contents of the storage system.
> 
> In other words, an Altix in an enterprise computing room... :-)

just kidding, are you a SGI sales? ;)

> 
> Something like 64 bit systems running a UNIX-like OS, one system
> production and one for backup, each with some TiB of RAID10
> storage, both with UPSes giving a significant amount of uptime,
> and extensive hot swapping abilities. If you got that, XFS can
> give really good performance quite safely.
> 
> My impression is that the design of XFS was based on a focus on
> performance, at the file system level, via on-disk layout,
> massive ''transactions'', and parallel IO requests, assuming
> that the block IO subsystem handles every storage error issue
> both transparently and gracefully.
> 
> It is _possible_, and may even be appropriate after carefully
> thinking it through, to use XFS in a 32 bit system without UPS,
> and with no storage system redundancy, and with device errors
> not handled by the block IO system, and with little parallelism
> in the storage subsystem; e.g. a SOHO desktop or server.

i think with write barrier support, system without UPS should be ok.
considering even u have UPS, kernel oops in other parts still can take
the FS down.

 
> 
> But then I have seen people building RAIDs stuffing in a couple
> dozen drives from the same shipping box, so improper use of XFS
> is definitely a second order issue at that kind of level :-).
> 
> 
