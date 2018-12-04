Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:45429
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbeLDWJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 17:09:04 -0500
Date: Wed, 5 Dec 2018 09:09:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs/xfs: Add support for passing write life-time hint
 with log
Message-ID: <20181204220901.GP6311@dastard>
References: <CGME20181203131558epcas2p14b6b38cb67d4915b1ba782e11ce7ffe6@epcas2p1.samsung.com>
 <1543842769-6363-1-git-send-email-joshi.k@samsung.com>
 <f3d25c5b-6a96-397c-d947-370867401a83@applied-asynchrony.com>
 <20181203163457.GW8125@magnolia>
 <20181203200909.GD6311@dastard>
 <be079d8c-f9d0-f01e-a184-36cf53d16abf@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be079d8c-f9d0-f01e-a184-36cf53d16abf@samsung.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org, jooyoung.hwang@samsung.com, chur.lee@samsung.com, prakash.v@samsung.com

On Tue, Dec 04, 2018 at 05:41:26PM +0530, Kanchan Joshi wrote:
> I expect log to have lifetime as "SHORT" in general. Log is bound to
> be overwritten, as XFS continues performing transaction. So it is
> not good idea to place it (inside SSD) with some other meta/data
> that is more stable (or less stable, for that matter).
> By assigning a distinct write-hint (SHORT, or anything else than
> NONE) to log, this problem of mixing is solved.

So, we have different definitions of what is "short lived"
and what is "long lived". The log is a -static allocation- it never
moves and so it always gets overwritten in place. It exists for the
life of the filesystem, so it's a long-lived structure. Some
metadata moves around - it's allocated and freed on demand, but is
still overwritten in place while it's in use.

The in-use life time of metadata can be very short, but it can also
be very long. It may never get overwritten, or it could be
overwritten multiple times a second. We have no real idea what is
going to happen with each individual piece of metadata because it is
completely dependent on user workloads.

So from a metadata perspective, life-time refers to how long the
metadata is in use in the filesystem, not how often it is accessed
or written. There's no "one-size-fits-all" bucket here.

> Keeping a mount option seemed to offer more flexibility to
> admin/system-designers.

OTOH, it gives everyone who is not an expert in storage and
filesystem implemetnations an oportunity to screw up in new and
exciting ways that are difficult to detect and impossible for XFS
developers to reproduce or debug.

>
> Assuming a single large SSD, hosting two XFS
> volumes - one catering to fsync-heavy workloads, while another one
> with reduced frequency of log writes. In that situation, one would
> not want to mix the writes of two logs and instead prefer to
> configure one log as "SHORT" and another one as "MEDIUM or EXTREME".

Here's the problem: you're making an assumption that "frequency of
log writes" equates to "the log is overwritten more often", and
that's not true. Frequent fsyncs typically mean lots of small log
writes that block each other, while applicaitons that don't use
fsync will be doing lots large async log writes and potentially
writing a lot more metadata to the log because nothing is blocking
waiting on journal IO completion......

Filesystems rarely behave in the ways non-filesystem developers
expect them to.

> Also, this way (through mount option) seemed more in sync with how
> rest of the kernel currently deals with streams/write-hints. In
> order to be useful, write-hints need to be converted to specific
> stream numbers. For NVMe SSDs, this is done by nvme-core module, but
> only if it is loaded with "streams=1" option. F2FS has mount option
> for passing write-hints. Default behavior is passing no write-hint.

There is no need for mount options, because we already have a
fcntl() interface that applications can use for setting write hints
on files. It was introduced in 4.13, and XFS already plumbs it
through for buffered write IO.

FYI:

$ man fcntl
....
   File read/write hints

       Write lifetime hints can be used to inform the kernel about
       the relative expected lifetime of writes on a given inode or
       via  a  particular  open  file description.   (See open(2)
       for  an  explanation of open file descriptions.) In this
       context, the term "write lifetime" means the expected time
       the data will live on media, before being over¿ written or
       erased.
.....

And the interfaces are:

       F_GET_RW_HINT (uint64_t *; since Linux 4.13)
       F_SET_RW_HINT (uint64_t *; since Linux 4.13)
       F_GET_FILE_RW_HINT (uint64_t *; since Linux 4.13)
       F_SET_FILE_RW_HINT (uint64_t *; since Linux 4.13)

And the types are:

       RWH_WRITE_LIFE_NOT_SET
       RWH_WRITE_LIFE_NONE
       RWH_WRITE_LIFE_SHORT
       RWH_WRITE_LIFE_MEDIUM
       RWH_WRITE_LIFE_LONG
       RWH_WRITE_LIFE_EXTREME

We probably also should make sure direct IO uses this hint, too, and
ideally we want set the write hint for the metadata in that file to
the same value as the user data being written, as the file metadata
is likely to have a similar lifetime to the user data it refers to.

IOWs, we want different metadata to have appropriately different
write hints, some of it will be controllable by the user per-file
write hints, others will be controlled by the filesystem itself as
userspace has no visibility or control over how that internal
metadata is managed.

> To summarize, I have listed three schemes below. Please let me know
> which one sounds more acceptable for patch -
> 1. [Current proposal] Keep write-hint (NONE) as default, and make it
> overridable through mount option.
> 2. Keep immutable write-hint (say SHORT). Provide no mount option.
> 3. Keep write-hint (SHORT) as default, and make it overridable
> through mount option.

Option 4: let the filesystem decide what is best dynamically,
because the lifetime of metadata and how often it is written is
a dynamic property of the specific metadata type.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
