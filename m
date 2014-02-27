Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 278697F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:21:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6214304077
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 23:21:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	k9i2Tzk3sh7NZTDU for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 23:21:35 -0800 (PST)
Date: Thu, 27 Feb 2014 18:21:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS on Fedora i686, armv7hl
Message-ID: <20140227072122.GL29907@dastard>
References: <8A28EF88-012E-4036-BDB6-E76B1CC569A7@colorremedies.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8A28EF88-012E-4036-BDB6-E76B1CC569A7@colorremedies.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chris Murphy <lists@colorremedies.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Feb 26, 2014 at 10:37:59PM -0700, Chris Murphy wrote:
> Hi,
> 
> Fedora is considering XFS as their default file system. They
> support three primary architectures: x86_64, i686, and armv7hl.
> Do XFS devs have any reservations about XFS as a default file
> system on either i686, or arm?

i686 is regularly tested on upstream dev kernels. ARM is less tested
as it's not the primary development platform for anyone - we tend to
rely on community feedback for arm because the hardware is so wide
and varied and there are some crackpot CPU cache architectures out
there in ARM land that we simply can't test against....

> So far the only thing I've run into with kernel
> 3.13.4-200.fc20.i686+PAE will not mount an XFS volume larger than
> 16TB.

That's not an XFS limit - that's a limit of the block device caused
by the page cache address space being limited to 16TB. Techinically
the XFS kernel doesn't have such a limit because it doesn't use the
block device address space to index or cache metadata, but that
doesn't help anyone if the userspace tools don't work on anything
larger than a 16TB block device.

As it is, you're crazy if you put more than a couple of TB of
storage on a 32 bit system. The machiens simply don't have the
process address space to repair a filesystem larger than a few
terabytes (i.e. 2GB RAM limit). That holds true for any filesystem -
ext3 and ext4 also have the same problems when running e2fsck...

> But I haven't tried filling a < 16TB volume with a
> significant amount of data while running 32bit, and anyway it's
> just easier to ask if there are other gotchas, or reservations
> about this combination.

It'll work just as well as ext3 and ext4 in such situations. That
doesn't mean we recommend that you do it ;)

> XFS (sdc): file system too large to be mounted on this system.
> [snip] XFS (sdc): Internal error xfs_sb_read_verify at line 630 of
> file fs/xfs/xfs_sb.c.  Caller 0xf8b19e1c [1]
> 
> 
> Thanks,
> 
> 
> Chris Murphy
> 
> 
> [1] The too large warning happens with ext4 at mount time also. A

*nod*. For the same reasons as XFS is limited to 16TB.

> Btrfs volume mounts OK, although I don't know if it actually
> withstands significant use.
> http://paste.fedoraproject.org/80784/93470280/

I bet that's because nobody has filled a btrfs filesystem past the
point where it tries to access beyond 16TB on a 32 bit system and so
it's never been reported as a bug... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
