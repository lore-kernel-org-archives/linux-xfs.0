Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84F545022
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2024 12:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706185442; cv=none; b=QP9dJoQj+NBarUgBOjrHHk7CIWhcq/b1qct3i9z3+3tQP6oLng76SYqh9bC1SnlkK6ny23WnAvIRXCENFQFE9yUGjh0ZLxV+q9Rsq5W3UXYEt8r2B+/ozYLezGf8yRWo9rwN9uD3vbj0KSsGliUVkGmcjuliJbSkLjeKQU12IAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706185442; c=relaxed/simple;
	bh=75NtKh212K91J+rdXJxpoyHgN3SxvXEjG5Bqu91ba0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oq6dNWXqzNuJPO7Ut/b81nVHfzWwWOsA6fYO26Bd9UZmn+SXL1dnxPOeKHG67D+7/HJLg5G/QAAo4qJfjNsaO6H37zW4GxJSOCYEzvhRynOJc2jv8uD7+lcQm74bTmyHZCPZIrotxb00J+pGyz3f7+7evLrRUnjVn2KBEy1bH0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FeGvJVFC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FeGvJVFC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706185439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHuE1yUTg1A4ffGfc1rF8WDVdZnPcCuvs5CsB+g3diU=;
	b=FeGvJVFC5xQuACds6bR9f1Z0JA9Z8JGeP8F23iDsNzxZ2fVMXffjpu1mLwgjqOQmHQCRd2
	rsgYl/fpSTK3a6QJNZX+evZMoX6qsm3PKqjJFCXWK3cLI6gJUu7FK4kgKKff8usqrzMi8V
	jHgCTEkCeqQX1Omy8GbH+LGawg0QfWs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-5iBFOFwHNYC9ShuQYk7Scg-1; Thu, 25 Jan 2024 07:23:56 -0500
X-MC-Unique: 5iBFOFwHNYC9ShuQYk7Scg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FB64845E3A;
	Thu, 25 Jan 2024 12:23:56 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 379312166B32;
	Thu, 25 Jan 2024 12:23:56 +0000 (UTC)
Date: Thu, 25 Jan 2024 07:25:14 -0500
From: Brian Foster <bfoster@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <ZbJSmYR8KxMcSlTy@bfoster>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <CAOQ4uxjWm82=KSQYMPo06kxfU90OBpMDmmQfyZAMS_2ZfJHnrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjWm82=KSQYMPo06kxfU90OBpMDmmQfyZAMS_2ZfJHnrw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Sat, Jan 20, 2024 at 10:50:02AM +0200, Amir Goldstein wrote:
> On Fri, Jan 19, 2024 at 9:35 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > We've had reports on distro (pre-deferred inactivation) kernels that
> > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > lock when invoked on a frozen XFS fs. This occurs because
> > drop_caches acquires the lock and then blocks in xfs_inactive() on
> > transaction alloc for an inode that requires an eofb trim. unfreeze
> > then blocks on the same lock and the fs is deadlocked.
> >
> > With deferred inactivation, the deadlock problem is no longer
> > present because ->destroy_inode() no longer blocks whether the fs is
> > frozen or not. There is still unfortunate behavior in that lookups
> > of a pending inactive inode spin loop waiting for the pending
> > inactive state to clear, which won't happen until the fs is
> > unfrozen. This was always possible to some degree, but is
> > potentially amplified by the fact that reclaim no longer blocks on
> > the first inode that requires inactivation work. Instead, we
> > populate the inactivation queues indefinitely. The side effect can
> > be observed easily by invoking drop_caches on a frozen fs previously
> > populated with eofb and/or cowblocks inodes and then running
> > anything that relies on inode lookup (i.e., ls).
> >
> > To mitigate this behavior, invoke a non-sync blockgc scan during the
> > freeze sequence to minimize the chance that inode evictions require
> > inactivation while the fs is frozen. A synchronous scan would
> > provide more of a guarantee, but is potentially unsafe from
> > partially frozen context. This is because a file read task may be
> > blocked on a write fault while holding iolock (such as when reading
> > into a mapped buffer) and a sync scan retries indefinitely on iolock
> > failure. Therefore, this adds risk of potential livelock during the
> > freeze sequence.
> >
> > Finally, since the deadlock issue was present for such a long time,
> > also document the subtle ->destroy_inode() constraint to avoid
> > unintentional reintroduction of the deadlock problem in the future.
> >
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Is there an appropriate Fixes: commit that could be mentioned here?
> or at least a range of stable kernels to apply this suggested fix?
> 

Hmm.. well I didn't really consider this a bug upstream. The above is
more historical reference to an issue that has since gone away, but
trying to use the bug report on a stable kernel to be forward looking
about improving on potentially awkward behavior of the latest upstream
kernel under the same sort of circumstances (i.e. reclaim while frozen).

I suppose something like this would be potentially useful for stable
kernels that don't include background inactivation. I haven't audited
which stable kernels might fall in that category (if any), but alas it
probably doesn't matter because this patch likely wasn't going anywhere
anyways.

Brian

> Thanks,
> Amir.
> 
> > ---
> >
> > Hi all,
> >
> > There was a good amount of discussion on the first version of this patch
> > [1] a couple or so years ago now. The main issue was that using a sync
> > scan is unsafe in certain cases (best described here [2]), so this
> > best-effort approach was considered as a fallback option to improve
> > behavior.
> >
> > The reason I'm reposting this is that it is one of several options for
> > dealing with the aforementioned deadlock on stable/distro kernels, so it
> > seems to have mutual benefit. Looking back through the original
> > discussion, I think there are several ways this could be improved to
> > provide the benefit of a sync scan. For example, if the scan could be
> > made to run before faults are locked out (re [3]), that may be
> > sufficient to allow a sync scan. Or now that freeze_super() actually
> > checks for ->sync_fs() errors, an async scan could be followed by a
> > check for tagged blockgc entries that triggers an -EBUSY or some error
> > return to fail the freeze, which would most likely be a rare and
> > transient situation. Etc.
> >
> > These thoughts are mainly incremental improvements upon some form of
> > freeze time scan and may not be of significant additional value given
> > current upstream behavior, so this patch takes the simple, best effort
> > approach. Thoughts?
> >
> > Brian
> >
> > [1] https://lore.kernel.org/linux-xfs/20220113133701.629593-1-bfoster@redhat.com/
> > [2] https://lore.kernel.org/linux-xfs/20220115224030.GA59729@dread.disaster.area/
> > [3] https://lore.kernel.org/linux-xfs/Yehvc4g+WakcG1mP@bfoster/
> >
> >  fs/xfs/xfs_super.c | 24 ++++++++++++++++--------
> >  1 file changed, 16 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index d0009430a627..43e72e266666 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -657,8 +657,13 @@ xfs_fs_alloc_inode(
> >  }
> >
> >  /*
> > - * Now that the generic code is guaranteed not to be accessing
> > - * the linux inode, we can inactivate and reclaim the inode.
> > + * Now that the generic code is guaranteed not to be accessing the inode, we can
> > + * inactivate and reclaim it.
> > + *
> > + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
> > + * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
> > + * allocation in this context. A transaction alloc that blocks on frozen state
> > + * from a context with ->s_umount held will deadlock with unfreeze.
> >   */
> >  STATIC void
> >  xfs_fs_destroy_inode(
> > @@ -811,15 +816,18 @@ xfs_fs_sync_fs(
> >          * down inodegc because once SB_FREEZE_FS is set it's too late to
> >          * prevent inactivation races with freeze. The fs doesn't get called
> >          * again by the freezing process until after SB_FREEZE_FS has been set,
> > -        * so it's now or never.  Same logic applies to speculative allocation
> > -        * garbage collection.
> > +        * so it's now or never.
> >          *
> > -        * We don't care if this is a normal syncfs call that does this or
> > -        * freeze that does this - we can run this multiple times without issue
> > -        * and we won't race with a restart because a restart can only occur
> > -        * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> > +        * The same logic applies to block garbage collection. Run a best-effort
> > +        * blockgc scan to reduce the working set of inodes that the shrinker
> > +        * would send to inactivation queue purgatory while frozen. We can't run
> > +        * a sync scan with page faults blocked because that could potentially
> > +        * livelock against a read task blocked on a page fault (i.e. if reading
> > +        * into a mapped buffer) while holding iolock.
> >          */
> >         if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> > +               xfs_blockgc_free_space(mp, NULL);
> > +
> >                 xfs_inodegc_stop(mp);
> >                 xfs_blockgc_stop(mp);
> >         }
> > --
> > 2.42.0
> >
> >
> 

