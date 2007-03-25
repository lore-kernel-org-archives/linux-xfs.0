Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 Mar 2007 20:24:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2P3OX6p019912
	for <xfs@oss.sgi.com>; Sat, 24 Mar 2007 20:24:35 -0700
Date: Sun, 25 Mar 2007 14:24:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_repair on Debian testing 64bits
Message-ID: <20070325032418.GH32602149@melbourne.sgi.com>
References: <1174655443.5441.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174655443.5441.37.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Patrick =?iso-8859-1?Q?No=EBl?= <patrick.noel@argus-presse.fr>
Cc: xfs@oss.sgi.com

On Fri, Mar 23, 2007 at 02:10:42PM +0100, Patrick Noël wrote:
> 
> Hi,
> 
> i have a device with 5,3To under a debian (sarge) 32bits server.
> 
> When i try a xfs_repair (2.8.20) on 5,3To i have a message :
> 
> xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate
> memory [ ... ] 

Out of memory. Not surprising - 5.6To of filesystem could take between
10-20GB of RAM to repair successfully. Can't do that on  a 32bit machine.

> i tried mounting the device on a 64 bits (Debian testing) and with
> xfs_repair 2.8.20 there is no problem with memory but is very long (12
> hours between phase 1 and phase 6)

Repair duration is determined by the number of inodes in the filesystem.
Given the runtime you are reporting, I'd say you've got millions (perhaps
even tens of milllions) of inodes in the filesystem. Is that correct?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
