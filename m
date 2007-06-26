Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 09:14:10 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QGE1tL029882
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 09:14:03 -0700
Date: Tue, 26 Jun 2007 12:14:00 -0400
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 7/7][TAKE5] ext4: support new modes
Message-ID: <20070626161400.GE6652@schatzie.adilger.int>
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625135051.GH1951@amitarora.in.ibm.com> <20070625215625.GL5181@schatzie.adilger.int> <20070626120751.GC19870@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626120751.GC19870@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Jun 26, 2007  17:37 +0530, Amit K. Arora wrote:
> Hmm.. I am thinking of a scenario when the file system supports some
> individual flags, but does not support a particular combination of them.
> Just for example sake, assume we have FA_ZERO_SPACE mode also. Now, if a
> file system supports FA_ZERO_SPACE, FA_ALLOCATE, FA_DEALLOCATE and
> FA_RESV_SPACE; and no other mode (i.e. FA_UNRESV_SPACE is not supported
> for some reason). This means that although we support FA_FL_DEALLOC,
> FA_FL_KEEP_SIZE and FA_FL_DEL_DATA flags, but we do not support the
> combination of all these flags (which is nothing but FA_UNRESV_SPACE).

That is up to the filesystem to determine then.  I just thought it should
be clear to return an error for flags (or as you say combinations thereof)
that the filesystem doesn't understand.

That said, I'd think in most cases the flags are orthogonal, so if you
support some combination of the flags (e.g. FA_FL_DEL_DATA, FA_FL_DEALLOC)
then you will also support other combinations of those flags just from
the way it is coded.

> > I also thought another proposed flag was to determine whether mtime (and
> > maybe ctime) is changed when doing prealloc/dealloc space?  Default should
> > probably be to change mtime/ctime, and have FA_FL_NO_MTIME.  Someone else
> > should decide if we want to allow changing the file w/o changing ctime, if
> > that is required even though the file is not visibly changing.  Maybe the
> > ctime update should be implicit if the size or mtime are changing?
> 
> Is it really required ? I mean, why should we allow users not to update
> ctime/mtime even if the file metadata/data gets updated ? It sounds
> a bit "unnatural" to me.
> Is there any application scenario in your mind, when you suggest of
> giving this flexibility to userspace ?

One reason is that XFS does NOT update the mtime/ctime when doing the
XFS_IOC_* allocation ioctls.

> I think, modifying ctime/mtime should be dependent on the other flags.
> E.g., if we do not zero out data blocks on allocation/deallocation,
> update only ctime. Otherwise, update ctime and mtime both.

I'm only being the advocate for requirements David Chinner has put
forward due to existing behaviour in XFS.  This is one of the reasons
why I think the "flags" mechanism we now have - we can encode the
various different behaviours in any way we want and leave it to the
caller.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
