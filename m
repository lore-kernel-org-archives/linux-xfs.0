Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CC6482CD
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 12:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706186743; cv=none; b=gL0TIPh0M9K9ZYXAC+rLAhKeOQzwIpfMzNlnUolSJXk/S2IzmiWgEo39jLph1aYu/si/3CG4ktB5vvuzpMiRWBj53MYvwmM409AN+zI/ytwQ5LMcGTfPu18gVaAsN36lHlpTN+BsHubnJc6Qei9MakKNfj2Psc9ytU00A7mCJl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706186743; c=relaxed/simple;
	bh=dKA/oy+L0AlZZxeXuxO7MEVUa/gaFM9BOO5uPR3D6AQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pY8sd2gN/7JkxNN/kchx3bTOCzGA3TgjvTQwc9+CqOCHjWZLVmO5Cr09BLTsrpWk9qL1eAj7NKeQA7MogPoUkpLlmQ4tBp7My75mCTi1QcQZ5RkzO/+3feGi5zNzkIjaDWUBGMrPNnyE7A33fFHoR5HKNoezK36QBUPaebB/b5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CWoJLnAF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWoJLnAF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706186740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LyC53Pwpali4OZl0rGIMyJZu+xLaBsk5Yj8WQL6CRTM=;
	b=CWoJLnAFolrCxApn0Xaxm+0rtvxu6pxMshYjObUfstM4LVf3oiJud5caPTmRh9eRMEH/G9
	RBFkhtIMFN1dXI0lnZgnWWF21WVPh7USwXo8tfsbPAARj4Arl0NumCJDgFrAPyP4Ks1hwB
	J5oB7kSoZbTiCcawZAPi5MPFMPQspeU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-iuQ02DgYOP6VPUt1R2KwVQ-1; Thu,
 25 Jan 2024 07:45:37 -0500
X-MC-Unique: iuQ02DgYOP6VPUt1R2KwVQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7A1438117FB;
	Thu, 25 Jan 2024 12:45:36 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6F121C060AF;
	Thu, 25 Jan 2024 12:45:36 +0000 (UTC)
Date: Thu, 25 Jan 2024 07:46:55 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <ZbJYP63PgykS1CwU@bfoster>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <Za3fwLKtjC+B8aZa@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za3fwLKtjC+B8aZa@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> > We've had reports on distro (pre-deferred inactivation) kernels that
> > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > lock when invoked on a frozen XFS fs. This occurs because
> > drop_caches acquires the lock and then blocks in xfs_inactive() on
> > transaction alloc for an inode that requires an eofb trim. unfreeze
> > then blocks on the same lock and the fs is deadlocked.
> 
> Yup, but why do we need to address that in upstream kernels?
> 
> > With deferred inactivation, the deadlock problem is no longer
> > present because ->destroy_inode() no longer blocks whether the fs is
> > frozen or not. There is still unfortunate behavior in that lookups
> > of a pending inactive inode spin loop waiting for the pending
> > inactive state to clear, which won't happen until the fs is
> > unfrozen.
> 
> Largely we took option 1 from the previous discussion:
> 
> | ISTM the currently most viable options we've discussed are:
> | 
> | 1. Leave things as is, accept potential for lookup stalls while frozen
> | and wait and see if this ever really becomes a problem for real users.
> 
> https://lore.kernel.org/linux-xfs/YeVxCXE6hXa1S%2Fic@bfoster/
> 
> And really it hasn't caused any serious problems with the upstream
> and distro kernels that have background inodegc.
> 

For quite a long time, neither did introduction of the reclaim s_umount
deadlock.

I can only speak for $employer distros of course, but my understanding
is that the kernels that do have deferred inactivation are still in the
early adoption phase of the typical lifecycle.

> Regardless, the spinning lookup problem seems pretty easy to avoid.
> We can turn it into a blocking lookup if the filesytsem is frozen
> simply by cycling sb_start_write/sb_end_write if there's a pending
> inactivation on that inode, and now the lookup blocks until the
> filesystem is thawed.
> 
> Alternatively, we could actually implement reinstantiation of the
> VFS inode portion of the inode and reactivate the inode if inodegc
> is pending. As darrick mentioned we didn't do this because of the
> difficulty in removing arbitrary items from the middle of llist
> structures.
> 
> However, it occurs to me that we don't even need to remove the inode
> from the inodegc list to recycle it. We can be lazy - just need to
> set a flag on the inode to cancel the inodegc and have inodegc clear
> the flag and skip over cancelled inodes instead of inactivating
> them.  Then if a gc cancelled inode then gets reclaimed by the VFS
> again, the inodegc queueing code can simply remove cancelled flag
> and it's already queued for processing....
> 

Interesting idea, though from looking through some code I'm skeptical
this is as simple as setting and clearing a flag.

> I think this avoids all the problems with needing to do inodegc
> cleanup while the filesystem is frozen, so I leaning towards this as
> the best way to solve this problem in the upstream kernel.
> 

"... avoids all the problems ..."

AFAIA the only concern was avoiding the unlikely "read into mapped
buffer" race situation, and that is fairly easy to avoid with further
improvements to the freeze interface. For example, the appended diff is
a quickly hacked up prototype (i.e. for conceptual purposes only) of
something I was thinking as a logical evolution from this patch.

> > This was always possible to some degree, but is
> > potentially amplified by the fact that reclaim no longer blocks on
> > the first inode that requires inactivation work. Instead, we
> > populate the inactivation queues indefinitely. The side effect can
> > be observed easily by invoking drop_caches on a frozen fs previously
> > populated with eofb and/or cowblocks inodes and then running
> > anything that relies on inode lookup (i.e., ls).
> 
> As we discussed last time, that is largely avoidable by only queuing
> inodes that absolutely need cleanup work. i.e. call
> xfs_can_free_eofblocks() and make it return false is the filesystem
> has an elevated freeze state because eof block clearing at reclaim
> is not essential for correct operation - the inode simply behaves as
> if it has XFS_DIFLAG_PREALLOC set on it. This will happen with any
> inode that has had fallocate() called on it, so it's not like it's a
> rare occurrence, either.
> 

Fortunately a simple scan mostly handles this case.

> The cowblocks case is much a much rarer situation, so that case could
> potentially just queue inodes those until the freeze goes away.
> 

And this as well.

> But if we can reinstantiate inodegc queued inodes as per my
> suggestion above then we can just leave the inodegc queuing
> unchanged and just not care how long they block for because if they
> are needed again whilst queued we can reuse them immediately....
> 

"... leave the inodegc queueing unchanged and just not care how long
they block for ..."

This reads to me as.. "leave inodes on the queue for non-deterministic
time where the memory asked for by reclaim can't be released," just
conveniently worded as if this behavior were somehow advantageous. ;)

Regardless, I'll just drop this patch. There's not enough objective
analysis here to make it clear to me how any of this is intended to try
and improve upon the patch as posted. I mainly sent this for posterity
since I had dug up the old discussion and realized I never followed up
from when it was suggested.

TLDR: option #1 it is...

> > Finally, since the deadlock issue was present for such a long time,
> > also document the subtle ->destroy_inode() constraint to avoid
> > unintentional reintroduction of the deadlock problem in the future.
> 
> That's still useful, though.
> 

Heh, well $maintainer can feel free to strip the rest out if you just
want a comment update.

Brian

--- 8< ---

Prototype to hook the filesystem into the various stages of freezing the
superblock:

diff --git a/fs/super.c b/fs/super.c
index 076392396e72..9eca666cb55b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1961,6 +1961,7 @@ static int wait_for_partially_frozen(struct super_block *sb)
 int freeze_super(struct super_block *sb, enum freeze_holder who)
 {
 	int ret;
+	bool per_stage = sb->s_iflags & SB_I_FREEZE_HACK;
 
 	atomic_inc(&sb->s_active);
 	if (!super_lock_excl(sb))
@@ -2015,6 +2016,11 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
 	if (!super_lock_excl(sb))
 		WARN(1, "Dying superblock while freezing!");
 
+	if (per_stage) {
+		ret = sb->s_op->freeze_fs(sb);
+		BUG_ON(ret);
+	}
+
 	/* Now we go and block page faults... */
 	sb->s_writers.frozen = SB_FREEZE_PAGEFAULT;
 	sb_wait_write(sb, SB_FREEZE_PAGEFAULT);
@@ -2029,6 +2035,11 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
 		return ret;
 	}
 
+	if (per_stage) {
+		ret = sb->s_op->freeze_fs(sb);
+		BUG_ON(ret);
+	}
+
 	/* Now wait for internal filesystem counter */
 	sb->s_writers.frozen = SB_FREEZE_FS;
 	sb_wait_write(sb, SB_FREEZE_FS);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d0009430a627..d9dec07e5184 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -805,25 +805,6 @@ xfs_fs_sync_fs(
 		flush_delayed_work(&mp->m_log->l_work);
 	}
 
-	/*
-	 * If we are called with page faults frozen out, it means we are about
-	 * to freeze the transaction subsystem. Take the opportunity to shut
-	 * down inodegc because once SB_FREEZE_FS is set it's too late to
-	 * prevent inactivation races with freeze. The fs doesn't get called
-	 * again by the freezing process until after SB_FREEZE_FS has been set,
-	 * so it's now or never.  Same logic applies to speculative allocation
-	 * garbage collection.
-	 *
-	 * We don't care if this is a normal syncfs call that does this or
-	 * freeze that does this - we can run this multiple times without issue
-	 * and we won't race with a restart because a restart can only occur
-	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
-	 */
-	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
-		xfs_inodegc_stop(mp);
-		xfs_blockgc_stop(mp);
-	}
-
 	return 0;
 }
 
@@ -937,6 +918,23 @@ xfs_fs_freeze(
 	struct xfs_mount	*mp = XFS_M(sb);
 	unsigned int		flags;
 	int			ret;
+	unsigned short		stage = sb->s_writers.frozen;
+
+	trace_printk("%d: stage %u\n", __LINE__, stage);
+
+	if (stage == SB_FREEZE_WRITE) {
+		struct xfs_icwalk       icw = {0};
+
+		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
+		xfs_blockgc_free_space(mp, &icw);
+
+		xfs_inodegc_stop(mp);
+		xfs_blockgc_stop(mp);
+		return 0;
+	}
+
+	if (stage != SB_FREEZE_FS)
+		return 0;
 
 	/*
 	 * The filesystem is now frozen far enough that memory reclaim
@@ -1688,7 +1686,7 @@ xfs_fs_fill_super(
 		sb->s_time_max = XFS_LEGACY_TIME_MAX;
 	}
 	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
-	sb->s_iflags |= SB_I_CGROUPWB;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_FREEZE_HACK;
 
 	set_posix_acl_flag(sb);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 98b7a7a8c42e..5349563a860e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1170,6 +1170,7 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_I_TS_EXPIRY_WARNED 0x00000400 /* warned about timestamp range expiry */
 #define SB_I_RETIRED	0x00000800	/* superblock shouldn't be reused */
 #define SB_I_NOUMASK	0x00001000	/* VFS does not apply umask */
+#define SB_I_FREEZE_HACK	0x00002000
 
 /* Possible states of 'frozen' field */
 enum {

