Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 19:30:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6J2UBbm022723
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 19:30:24 -0700
Date: Thu, 19 Jul 2007 12:30:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Allocating inodes from a single block
Message-ID: <20070719023005.GB12413810@sgi.com>
References: <469D0666.6040908@agami.com> <20070717201921.GA26309@tuatara.stupidest.org> <469D7035.2020507@sandeen.net> <1184724090.15488.553.camel@edge.yarra.acx> <20070718035012.GA12413810@sgi.com> <469E65AF.4080003@bycast.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E65AF.4080003@bycast.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mike Montour <mmontour@bycast.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 18, 2007 at 12:10:39PM -0700, Mike Montour wrote:
> David Chinner wrote:
> > The issue here is not the cluster size - that is purely an in-memory
> > arrangement for reading/writing muliple inodes at once. The issue
> > here is inode *chunks* (as Eric pointed out).
> >
> > [...]
> > The best you can do to try to avoid these sorts of problems is
> > use the "ikeep" option to keep empty inode chunks around. That way
> > if you remove a bunch of files then fragement free space you'll
> > still be able to create new files until you run out of pre-allocated
> > inodes....
> >   
> 
> What would it take to add an option to mkfs.xfs (or to create a
> dedicated tool) that would efficiently[1] pre-allocate a specified
> number of inode chunks when a filesystem is created?

Like an extension to mkfs.xfs's prototype file?

> This filesystem was created with "-i maxpct=0,size=2048", so a new chunk
> of 64 inodes would require an extent of 128 KiB (32 * 4KiB blocks).

i.e. worst case.

> 1. "efficiently" = significantly faster than a userspace script to
> 'touch' a few million files and then 'rm' them.

A "bulk create" option has long been considered to optimise filesystem
restore - precreating lots of inodes in an efficient manner is pretty
much a prereq for this.

The other option (and one that I prefer) is extending xfs_fsr to b
able to defragment free space. i.e. to compact space in each AG. To
do this efficiently, however, we really need a reverse map to determine
the owners of the blocks we want to move...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
