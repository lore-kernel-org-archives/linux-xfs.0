Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Nov 2006 15:18:54 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kANNIlaG031240
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 15:18:48 -0800
Date: Thu, 23 Nov 2006 18:18:00 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS CORRUPTION 2.6.17.13?
In-Reply-To: <20061123230744.GA11034@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0611231816340.18083@p34.internal.lan>
References: <Pine.LNX.4.64.0611201459420.17165@p34.internal.lan>
 <1164231716.19915.68.camel@xenon.msp.redhat.com>
 <Pine.LNX.4.64.0611231139040.32343@p34.internal.lan> <20061123230744.GA11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Ah,

I did not make a copy unfortunatley.

I used the default mkfs.xfs settings from Knoppix 4.0.2 I believe, 
whatever version of xfsprogs it has for a 400GB drive.

Any idea how it could have been 'trashed' in one way?  It appeared to 
occur shortly after boot-up, which then a backup occurs (heavy I/O) to a 
remote box via NFS.

Justin.

On Fri, 24 Nov 2006, David Chinner wrote:

> On Thu, Nov 23, 2006 at 11:40:38AM -0500, Justin Piszcz wrote:
> > Here is the info:
> > 
> > Script started on Thu Nov 23 09:55:38 2006
> > 1;36mroot@1[~]#0;39m xfs_repair -n /dev/hda2
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - scan filesystem freespace and inode maps...
> >         - found root inode chunk
> > Phase 3 - for each AG...
> >         - scan (but don't clear) agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> >         - agno = 4
> >         - agno = 5
> >         - agno = 6
> >         - agno = 7
> > data fork in regular inode 939526080 claims used block 114661
> > bad data fork in inode 939526080
> > would have cleared inode 939526080
> ......
> > data fork in regular inode 939526111 claims used block 114692
> > bad data fork in inode 939526111
> > would have cleared inode 939526111
> 
> Looks like half an inode cluster has been trashed in some way (32
> consecutive inodes are bad). All the following errors appear to be a
> direct result of these inodes being trashed. Are you using 256 byte
> inodes? if it is, that means that the 32 inodes would have been
> written in a single buffer, and so that buffer write would be
> suspect.
> 
> FWIW, Irix XFS actually validates inode buffers before they get
> written out, so if it was a bad write that might have been caught on
> irix. Unfortunately, we don't do those checks in Linux (most of the
> hooks are there, just not used) so it is possible that some kind of
> memory corruption has lead to this damaged state on disk.
> 
> Seeing as you've repair the filesystem, we can't really get a dump
> of the raw inode data to find out exactly how they were corrupted.
> Unless you have a copy of the fs around somewhere?
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
