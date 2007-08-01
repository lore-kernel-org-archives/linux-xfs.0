Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 31 Jul 2007 19:24:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l712OKbm026662
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2007 19:24:23 -0700
Date: Wed, 1 Aug 2007 12:24:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RFC: log record CRC validation
Message-ID: <20070801022418.GR31489@sgi.com>
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com> <46A94963.7000103@agami.com> <20070727065930.GT12413810@sgi.com> <46AFD88E.9070403@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AFD88E.9070403@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: David Chinner <dgc@sgi.com>, markgw@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 31, 2007 at 05:49:18PM -0700, Michael Nishimoto wrote:
> David Chinner wrote:
> >On Thu, Jul 26, 2007 at 06:24:51PM -0700, Michael Nishimoto wrote:
> > > When a CRC error is found, your suggestion is correct.  Recovery
> > > should backup and process only completely good log records.  The code
> > > backs up in this same fashion when it encounters a region of
> > > missing sector updates because of the async nature of log
> > > writes and disk caches.
......
> >IOWs, I think that if we come across a bad CRC in a log record we
> >can replay up to that point but we've still got to abort the mount
> >and ask the user to run repair....
.....
> You are correct.  I didn't need the example -- just a reminder that
> CRC errors can occur anywhere, not just in the last 8 log-buffers
> worth of data. ;-)
> 
> And yes, repair is necessary now because we are no longer replaying
> a transaction which we thought was committed.

Ok, I'll make the mount replay up to previous good record and then
abort with -EUCLEAN.

> I have a request.  Can this be made a mkfs.xfs option, so it can be
> disabled?

It's a definite possibility, because....

> What are your plans for adding CRCs to other metadata objects?

Other objects will require some on-disk format change, and that will
require a feature bit to be set.

Basically, we can add CRCs to individual inodes without a version bump
as we have some empty space in the v2 inode core. That will make v2 inodes
the default, but we already have a superblock bit for that and all versions
of linux support v2 inodes so there is no issue there. This will require
userspace tool changes, though, because tools like repair will revert v2
inodes back to v1 format if the are not using project id's or the link count
fits into 16 bits.....

I haven't looked at great depth into other structures in terms of
implementation details. I know that if we use a 16 bit CRC on
directories we can get away without a on-disk format change as the
xfs_da_blkinfo structure has 16 bits of padding. However, given that
directory block size can reach 64k, a CRC16 check is really only
capable of single bit error detection. Hence I think we really need
CRC32 here which means an on-disk format change.

For the other types of btree blocks we will also need on-disk
changes as there is no padding we can use to hold a CRC in the
headers. Adding CRCs to the SB, AGF, AGI and AFGL is trivial but
really needs a feature bit to say they are there.

So, yes, this sort of change will require a feature bit and that
means it would be a mkfs option. I'd prefer to have all the changes
ready to go before releasing them into the wild so that we only
need a single feature bit, though there is the possibility of
separating the directory changes out into "version 3" directories.

Conversion of existing filesystems is harder because of the
repacking of structures required. if we are going to convert
filesystems, I would expect it to be done offline by xfs_repair
(Hi Barry!). Given that it will already need tobe modified to
validate CRCs, I think this is probably the best approach to this
problem right now.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
