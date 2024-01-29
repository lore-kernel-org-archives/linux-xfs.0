Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEC2152E03
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706540466; cv=none; b=ddYfKJOMCtISAeCuiwmTxGSYvJQui7GN6zGQ24eqAX1teG1YPMkVnV4bh5CGbnIT1p2JHxkS+ZOtQA/vViX5veJ9quXg4yGiqM6OQ+SP0y0xYyv4X2skJqQdmOrE8Ku4JIecN25TSspq4jq+MxK7vXRwZr09fuCNOAB/Dlc98JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706540466; c=relaxed/simple;
	bh=kSQAXDNzRavPMmmYH1SXok8BdzuN78KwfGvy7h5/8UE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkLYakIkV4okLiR319kXGQk9htsVquGt/o3bCpONovFfkHKutrBnCcZE3G9tblHFcxT6i3BQFM/Ii8oAah0GQVPmuMWPrM+wQy9aZzLtE96TF4RWohjnJFwYMzU853IXSmsXEymFB5M/Rp2QiTZaSzSBMiWLXjAdtgylLDMSOcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FiMcNDTl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FiMcNDTl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706540459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ZPiVFefCKV0HUOv8kroxcQ6V+7nfr+54lHBboq2HR8=;
	b=FiMcNDTlDPpZydk5ALXcLLj2gPFfwFZyOflSq0VuYIPGMLOU9a9H2tfr1dkHk5U/fEeq44
	dzS2Xde5cJGc+kCPnGnHBPLy2jxCcSYB4L0up70R1qAiytATqLHf/7E1oCJ4Buv+0VAaVG
	euxFDToCOVLriFrQytH0htTuAw5OR8c=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-Bj6Q1sb_OG681hHycVWN_Q-1; Mon,
 29 Jan 2024 10:00:58 -0500
X-MC-Unique: Bj6Q1sb_OG681hHycVWN_Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC55128EC116;
	Mon, 29 Jan 2024 15:00:57 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B5BE492BC6;
	Mon, 29 Jan 2024 15:00:57 +0000 (UTC)
Date: Mon, 29 Jan 2024 10:02:16 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <Zbe9+EY5bLjhPPJn@bfoster>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <Za3fwLKtjC+B8aZa@dread.disaster.area>
 <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> > > > We've had reports on distro (pre-deferred inactivation) kernels that
> > > > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > > > lock when invoked on a frozen XFS fs. This occurs because
> > > > drop_caches acquires the lock and then blocks in xfs_inactive() on
> > > > transaction alloc for an inode that requires an eofb trim. unfreeze
> > > > then blocks on the same lock and the fs is deadlocked.
> > > 
> > > Yup, but why do we need to address that in upstream kernels?
> > > 
> > > > With deferred inactivation, the deadlock problem is no longer
> > > > present because ->destroy_inode() no longer blocks whether the fs is
> > > > frozen or not. There is still unfortunate behavior in that lookups
> > > > of a pending inactive inode spin loop waiting for the pending
> > > > inactive state to clear, which won't happen until the fs is
> > > > unfrozen.
> > > 
> > > Largely we took option 1 from the previous discussion:
> > > 
> > > | ISTM the currently most viable options we've discussed are:
> > > | 
> > > | 1. Leave things as is, accept potential for lookup stalls while frozen
> > > | and wait and see if this ever really becomes a problem for real users.
> > > 
> > > https://lore.kernel.org/linux-xfs/YeVxCXE6hXa1S%2Fic@bfoster/
> > > 
> > > And really it hasn't caused any serious problems with the upstream
> > > and distro kernels that have background inodegc.
> > > 
> > 
> > For quite a long time, neither did introduction of the reclaim s_umount
> > deadlock.
> 
> Yup, and that's *exactly* the problem we should be fixing here
> because that's the root cause of the deadlock you are trying to
> mitigate with these freeze-side blockgc flushes.
> 
> The deadlock in XFS inactivation is only the messenger - it's
> a symptom of the problem, and trying to prevent inactivation in that
> scenario is only addressing one specific symptom. It doesn't
> address any other potential avenue to the same deadlock in XFS or
> in any other filesystem that can be frozen.
> 

We address symptoms all the time. You've suggested several alternatives
in this thread that also only address symptoms. I see no reason why
symptoms and the cure must be addressed at the same time.

> > I can only speak for $employer distros of course, but my understanding
> > is that the kernels that do have deferred inactivation are still in the
> > early adoption phase of the typical lifecycle.
> 
> Fixing the (shrinker) s_umount vs thaw deadlock is relevant to
> current upstream kernels because it removes a landmine that any
> filesystem could step on. It is also a fix that could be backported
> to all downstream kernels, and in doing so will also solve the
> issue on the distro you care about....
> 

I don't think a novel upstream cross subsystem lock split exercise is
the most practical option for a stable kernel.

> I started on the VFS changes just before christmas, but I haven't
> got back to it yet because it wasn't particularly high priority. The
> patch below introduces the freeze serialisation lock, but doesn't
> yet reduce the s_umount scope of thaw. Maybe you can pick it up from
> here?
> 

I don't disagree with this idea or as a general direction, but there's
too much additional risk, complexity and unknown here that I don't think
this is the best next step. My preference is to improve on problematic
behaviors with something like the async scan patch, unlink the user
reported issue(s) from the broader design flaw(s), and then address the
latter as a follow on effort.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> fsfreeze: separate freeze/thaw from s_umount
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Holding the s_umount lock exclusive across the entire freeze/thaw
> operations is problematic as we do substantial operations in those
> operations, and we can have non-freeze/thaw operations block whilst
> holding s_umount. This can lead to deadlocks on thaw when something
> blocks on a freeze holding the s_umount lock.
> 
> Whilst this might seem like a theoretical problem, consider that the
> superblock shrinker runs under s_umount protection. This means the
> inode eviction and freeing path runs under s_umount and can run
> whilst a filesystem is frozen. If a filesystem blocks in a
> shrinker-run evict path because the filesystem is frozen, then the
> thaw will deadlock attempting to obtain the s_umount lock and the
> system is toast.
> 
> This *used* to happen with XFS. The changes in 5.14 to move to
> background inode inactivation moved XFS inode inactivation out of
> the ->destroy_inode() path, and so moved the garbage collection
> transactions from the evict path to a background kworker thread.
> These transactions from the shrinker context could deadlock the
> filesystem, and it was trivially reproducable by running "freeze,
> drop_caches; thaw" on an active system.
> 
> Whilst XFS tripped over this, it is possible that any filesystem
> that runs garbage collection operations when inodes are reclaimed
> can block holding the s_umount lock waiting for a freeze condition
> to be lifted.
> 
> We can't avoid holding the s_umount lock in the superblock shrinker
> - it is needed to provide existence guarantees so the superblock and
> internal filesystem structures cannot be torn down whilst the
> shrinker is running. Hence we need to address the way freeze/thaw
> use the s_umount lock.
> 
> Realistically, the only thing that the s_umount lock is needed for
> is to ensure that the freeze/thaw has a valid active superblock
> reference. It also serves to serialise freeze/thaw against other
> freeze/thaw operations, and this is where the problem lies. That is,
> thaw needs to take the s_umount before it starts thawing the
> filesystem to serialise against other freeze/thaw operations. It
> then holds the s_umount lock until the fs is thawed and then calls
> deactive_locked_super() to drop the active sb reference the freeze
> gained.
> 
> Realistically, the thaw only needs to hold the s_umount lock for the
> call to deactive_locked_super() - as long as we can serialise
> thaw against other concurrent freeze/thaw operations we don't need
> s_umount for the thawing process at all.
> 
> Moving the thaw process out from under the s_umount lock and then
> only taking the s_umount lock to call deactive_locked_super() then
> avoids all the deadlock problems with blocking holding the s_umount
> lock waiting for thaw to complete - the thaw completes, wakes
> waiters which then run to completion, drop the s_umount lock and the
> thaw then gains the s_umount lock and drops the active sb reference.
> 
> TO do this, introduce a new freeze lock to the superblock. This will
> be used to serialise freeze/thaw operations, and avoid the need to
> hold the s_umount lock across these operations. The s_umount lock is
> still needed to gain/drop active sb references, but once we have
> that reference in freeze we don't need the s_umount lock any more.
> 
> However, we probably still want to serialise freeze against remount,
> so we keep the s_umount lock held across freeze. We might be able to
> reduce the scope of the s_umount lock in future, but that's not
> necessary right now to alleviate the deadlock condition.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/super.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 61c19e3f06d8..96f3edf7c66b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -334,6 +334,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  	INIT_LIST_HEAD(&s->s_mounts);
>  	s->s_user_ns = get_user_ns(user_ns);
>  	init_rwsem(&s->s_umount);
> +	sema_init(&s->s_freeze_lock, 1);
>  	lockdep_set_class(&s->s_umount, &type->s_umount_key);
>  	/*
>  	 * sget() can have s_umount recursion.
> @@ -1216,6 +1217,7 @@ static void do_thaw_all_callback(struct super_block *sb)
>  		if (IS_ENABLED(CONFIG_BLOCK))
>  			while (sb->s_bdev && !thaw_bdev(sb->s_bdev))
>  				pr_warn("Emergency Thaw on %pg\n", sb->s_bdev);
> +		down(&sb->s_freeze_lock);
>  		thaw_super_locked(sb, FREEZE_HOLDER_USERSPACE);
>  	} else {
>  		super_unlock_excl(sb);
> @@ -1966,10 +1968,12 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
>  	atomic_inc(&sb->s_active);
>  	if (!super_lock_excl(sb))
>  		WARN(1, "Dying superblock while freezing!");
> +	down(&sb->s_freeze_lock);
>  
>  retry:
>  	if (sb->s_writers.frozen == SB_FREEZE_COMPLETE) {
>  		if (sb->s_writers.freeze_holders & who) {
> +			up(&sb->s_freeze_lock);
>  			deactivate_locked_super(sb);
>  			return -EBUSY;
>  		}
> @@ -1981,6 +1985,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
>  		 * freeze and assign the active ref to the freeze.
>  		 */
>  		sb->s_writers.freeze_holders |= who;
> +		up(&sb->s_freeze_lock);
>  		super_unlock_excl(sb);
>  		return 0;
>  	}
> @@ -1988,6 +1993,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
>  	if (sb->s_writers.frozen != SB_UNFROZEN) {
>  		ret = wait_for_partially_frozen(sb);
>  		if (ret) {
> +			up(&sb->s_freeze_lock);
>  			deactivate_locked_super(sb);
>  			return ret;
>  		}
> @@ -1996,6 +2002,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
>  	}
>  
>  	if (!(sb->s_flags & SB_BORN)) {
> +		up(&sb->s_freeze_lock);
>  		super_unlock_excl(sb);
>  		return 0;	/* sic - it's "nothing to do" */
>  	}
> @@ -2005,16 +2012,19 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
>  		sb->s_writers.freeze_holders |= who;
>  		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
>  		wake_up_var(&sb->s_writers.frozen);
> +		up(&sb->s_freeze_lock);
>  		super_unlock_excl(sb);
>  		return 0;
>  	}
>  
>  	sb->s_writers.frozen = SB_FREEZE_WRITE;
>  	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
> +	up(&sb->s_freeze_lock);
>  	super_unlock_excl(sb);
>  	sb_wait_write(sb, SB_FREEZE_WRITE);
>  	if (!super_lock_excl(sb))
>  		WARN(1, "Dying superblock while freezing!");
> +	down(&sb->s_freeze_lock);
>  
>  	/* Now we go and block page faults... */
>  	sb->s_writers.frozen = SB_FREEZE_PAGEFAULT;
> @@ -2026,6 +2036,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
>  		sb->s_writers.frozen = SB_UNFROZEN;
>  		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
>  		wake_up_var(&sb->s_writers.frozen);
> +		up(&sb->s_freeze_lock);
>  		deactivate_locked_super(sb);
>  		return ret;
>  	}
> @@ -2042,6 +2053,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
>  			sb->s_writers.frozen = SB_UNFROZEN;
>  			sb_freeze_unlock(sb, SB_FREEZE_FS);
>  			wake_up_var(&sb->s_writers.frozen);
> +			up(&sb->s_freeze_lock);
>  			deactivate_locked_super(sb);
>  			return ret;
>  		}
> @@ -2054,6 +2066,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
>  	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
>  	wake_up_var(&sb->s_writers.frozen);
>  	lockdep_sb_freeze_release(sb);
> +	up(&sb->s_freeze_lock);
>  	super_unlock_excl(sb);
>  	return 0;
>  }
> @@ -2071,6 +2084,7 @@ static int thaw_super_locked(struct super_block *sb, enum freeze_holder who)
>  
>  	if (sb->s_writers.frozen == SB_FREEZE_COMPLETE) {
>  		if (!(sb->s_writers.freeze_holders & who)) {
> +			up(&sb->s_freeze_lock);
>  			super_unlock_excl(sb);
>  			return -EINVAL;
>  		}
> @@ -2082,10 +2096,12 @@ static int thaw_super_locked(struct super_block *sb, enum freeze_holder who)
>  		 */
>  		if (sb->s_writers.freeze_holders & ~who) {
>  			sb->s_writers.freeze_holders &= ~who;
> +			up(&sb->s_freeze_lock);
>  			deactivate_locked_super(sb);
>  			return 0;
>  		}
>  	} else {
> +		up(&sb->s_freeze_lock);
>  		super_unlock_excl(sb);
>  		return -EINVAL;
>  	}
> @@ -2104,6 +2120,7 @@ static int thaw_super_locked(struct super_block *sb, enum freeze_holder who)
>  		if (error) {
>  			printk(KERN_ERR "VFS:Filesystem thaw failed\n");
>  			lockdep_sb_freeze_release(sb);
> +			up(&sb->s_freeze_lock);
>  			super_unlock_excl(sb);
>  			return error;
>  		}
> @@ -2114,6 +2131,7 @@ static int thaw_super_locked(struct super_block *sb, enum freeze_holder who)
>  	wake_up_var(&sb->s_writers.frozen);
>  	sb_freeze_unlock(sb, SB_FREEZE_FS);
>  out:
> +	up(&sb->s_freeze_lock);
>  	deactivate_locked_super(sb);
>  	return 0;
>  }
> @@ -2134,6 +2152,7 @@ int thaw_super(struct super_block *sb, enum freeze_holder who)
>  {
>  	if (!super_lock_excl(sb))
>  		WARN(1, "Dying superblock while thawing!");
> +	down(&sb->s_freeze_lock);
>  	return thaw_super_locked(sb, who);
>  }
>  EXPORT_SYMBOL(thaw_super);
> 

