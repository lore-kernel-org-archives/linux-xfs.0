Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A30897F3F
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2014 16:52:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 72F0A8F8049
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2014 14:52:01 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id zpjQNUhRcvRVIcCN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Dec 2014 14:51:59 -0800 (PST)
Date: Fri, 12 Dec 2014 23:51:56 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/11] quota: Switch ->get_dqblk() and ->set_dqblk() to
	use bytes as space units
Message-ID: <20141212225156.GA9674@quack.suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-11-git-send-email-jack@suse.cz>
	<20141118222952.GQ23575@dastard>
	<20141212095230.GB4813@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141212095230.GB4813@quack.suse.cz>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 12-12-14 10:52:30, Jan Kara wrote:
> On Wed 19-11-14 09:29:52, Dave Chinner wrote:
> > On Tue, Nov 11, 2014 at 10:04:24PM +0100, Jan Kara wrote:
> > > Currently ->get_dqblk() and ->set_dqblk() use struct fs_disk_quota which
> > > tracks space limits and usage in 512-byte blocks. However VFS quotas
> > > track usage in bytes (as some filesystems require that) and we need to
> > > somehow pass this information. Upto now it wasn't a problem because we
> > > didn't do any unit conversion (thus VFS quota routines happily stuck
> > > number of bytes into d_bcount field of struct fd_disk_quota). Only if
> > > you tried to use Q_XGETQUOTA or Q_XSETQLIM for VFS quotas (or Q_GETQUOTA
> > > / Q_SETQUOTA for XFS quotas), you got bogus results but noone really
> > > tried that. But when we want interfaces compatible we need to fix this.
> > > 
> > > So we bite the bullet and define another quota structure used for
> > > passing information from/to ->get_dqblk()/->set_dqblk. It's somewhat
> > > sad we have to have more conversion routines in fs/quota/quota.c but
> > > it seems cleaner than overloading e.g. units of d_bcount to bytes.
> > 
> > I don't really like the idea of having to copy the dquot information
> > an extra time. We now:
> > 
> > 	- copy from internal dquot to the new qc_dqblk
> > 	- copy from the new qc_dqblk to if_dqblk/xfs_dqblk
> > 	- copy if_dqblk/xfs_dqblk to the user buffer.
> > 
> > That's now three copies, and when we are having to deal with quota
> > reports containing hundreds of thousands of dquots that's going to
> > hrut performance.
> > 
> > We could probably get away with just one copy by passing a
> > filldir()-like context down into the filesystems to format their
> > internal dquot information directly into the user buffer in the
> > appropriate format. That way fs/quota/quota.c doesn't need
> > conversion routines, filesystems can optimise the formating to
> > minimise copying, and we can still provide generic routines for
> > filesystems using the generic quota infrastructure....
>   I was thinking about how this would look like. I don't have a problem to
> create a filldir() like callback that will be used for getting quota
> structures. However I don't see how we could reasonably get away with just
> one copy in general - that would mean that the interface functions in
> fs/quota.c (e.g. quota_getquota()) would have to determine whether XFS of
> VFS quota structures are used in the backing filesystem to provide proper
> callback and that's IMO too ugly to live.
> 
> We could definitely reduce the number of copies to two by changing e.g.
> copy_to_xfs_dqblk() to directly use __put_user() instead of first
> formatting proper structure on stack and then using copy_to_user(). However
> I'm not sure whether this will be any real performance win and using
> copy_to_user() seems easier to me...
> 
> Anyway I'll probably try changing number of copies to two and see whether
> there's any measurable impact.
  So when I change the number of copies to two by using __put_user, I get
about about 2.3% reduction in time for getting quota information for vfs
quotas (fully cached) and about 1.7% reduction in time for getting quota
information for xfs quotas.

For VFS quotas numbers are:
Average of 4 runs with 3 copies is 2.212286s (for 100000 getquota calls).
Average of 4 runs with 2 copies is 2.160500s (for 100000 getquota calls).

For XFS quotas numbers are:
Average of 4 runs with 3 copies is 1.584250s (for 100000 getquota calls).
Average of 4 runs with 2 copies is 1.557250s (for 100000 getquota calls).

So overall it seems to me that avoiding another copy is not worth the
bother...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
