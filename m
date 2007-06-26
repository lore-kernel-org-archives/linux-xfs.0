Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 05:07:54 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QC7jtL005651
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 05:07:46 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5QC8tqG008650
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 08:08:55 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5QC7kds481730
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 08:07:46 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5QC7kWC015907
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 08:07:46 -0400
Date: Tue, 26 Jun 2007 17:37:52 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/7][TAKE5] ext4: support new modes
Message-ID: <20070626120751.GC19870@amitarora.in.ibm.com>
References: <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625135051.GH1951@amitarora.in.ibm.com> <20070625215625.GL5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625215625.GL5181@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, Jun 25, 2007 at 03:56:25PM -0600, Andreas Dilger wrote:
> On Jun 25, 2007  19:20 +0530, Amit K. Arora wrote:
> > @@ -2499,7 +2500,8 @@ long ext4_fallocate(struct inode *inode,
> >  	 * currently supporting (pre)allocate mode for extent-based
> >  	 * files _only_
> >  	 */
> > -	if (mode != FA_ALLOCATE || !(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) ||
> > +		!(mode == FA_ALLOCATE || mode == FA_RESV_SPACE))
> >  		return -EOPNOTSUPP;
> 
> This should probably just check for the individual flags it can support
> (e.g. no FA_FL_DEALLOC, no FA_FL_DEL_DATA).

Hmm.. I am thinking of a scenario when the file system supports some
individual flags, but does not support a particular combination of them.
Just for example sake, assume we have FA_ZERO_SPACE mode also. Now, if a
file system supports FA_ZERO_SPACE, FA_ALLOCATE, FA_DEALLOCATE and
FA_RESV_SPACE; and no other mode (i.e. FA_UNRESV_SPACE is not supported
for some reason). This means that although we support FA_FL_DEALLOC,
FA_FL_KEEP_SIZE and FA_FL_DEL_DATA flags, but we do not support the
combination of all these flags (which is nothing but FA_UNRESV_SPACE).
 
> I also thought another proposed flag was to determine whether mtime (and
> maybe ctime) is changed when doing prealloc/dealloc space?  Default should
> probably be to change mtime/ctime, and have FA_FL_NO_MTIME.  Someone else
> should decide if we want to allow changing the file w/o changing ctime, if
> that is required even though the file is not visibly changing.  Maybe the
> ctime update should be implicit if the size or mtime are changing?

Is it really required ? I mean, why should we allow users not to update
ctime/mtime even if the file metadata/data gets updated ? It sounds
a bit "unnatural" to me.
Is there any application scenario in your mind, when you suggest of
giving this flexibility to userspace ?

I think, modifying ctime/mtime should be dependent on the other flags.
E.g., if we do not zero out data blocks on allocation/deallocation,
update only ctime. Otherwise, update ctime and mtime both.

--
Regards,
Amit Arora
