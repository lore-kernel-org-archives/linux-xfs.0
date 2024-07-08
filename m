Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABB414BFBF
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 19:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720465205; cv=none; b=WbSfuO4YS9bHQQ1QQtys5DEMKqC9tBGr5eig+S6TZPUJBfXKunAo+dSR+TMuAeTIfOrCHiYOb+I5MJSDjSAuuxteRyiqjxi4dnRXyKA3rZtKj0Yzf9f1wYLxicJ1cqwQUL57rt5Jj2zJYdgy3gxNk6p49lXtzHwveivcgzgAlfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720465205; c=relaxed/simple;
	bh=xANuB3eEvE7FQhsl8NZNV7veDqL5bbw2/ygbNFGIxvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dB8MDrmb/N9TGAvorLg0eoF/fi4lEZ8XxLopBmvLAZUuVnN1ZcetCiDhKOSagsJqvgyrosL9Gt71jfMYlvIoB0MX7kPnlTHWURra2lwzVPiW+fEiSh8RNcAvRFlnzEtBu0lsjO+dRjF1jJ/6EVyiyoLAMgIp+ESBkIO+CW0MM9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEFvturS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEFvturS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB289C116B1;
	Mon,  8 Jul 2024 19:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720465205;
	bh=xANuB3eEvE7FQhsl8NZNV7veDqL5bbw2/ygbNFGIxvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AEFvturSInelQnKVylZB2WOqAX9CXnbyKkN0csrlW8gl3kVmPDtSZU5FyhaU0c1mT
	 snMzKBulT0TgNUdqDUsJy1I9X8AqFQ/FffsZFfn7wFbvssHkKAcepdXpO3kxEfF36C
	 TDvh7LwFS/zlvxConNZ93ybwENzzPwGKGIUVT1cpGqaO/v7uKwruurgrZyKA+oV+q8
	 Z5NmuKUOhl8JTudciqgG43+m504j7ofWNYlPxfswbPIkybJ+HqZXq5NjkCjdk7Y4Aw
	 63oIlWNUIy/z196uCFpiVuNH4VawO+mae1T6w1k8FQ5lR0uiH5NTA9iRRzgz041l5V
	 sPND2kEfuuT4Q==
Date: Mon, 8 Jul 2024 12:00:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Long Li <leo.lilong@huawei.com>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: eliminate lockdep false positives in
 xfs_attr_shortform_list
Message-ID: <20240708190005.GQ612460@frogsfrogsfrogs>
References: <20240622082631.2661148-1-leo.lilong@huawei.com>
 <20240624160342.GP3058325@frogsfrogsfrogs>
 <5ce25a1a-51d7-4cf3-a118-91eeeefe29a4@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ce25a1a-51d7-4cf3-a118-91eeeefe29a4@sandeen.net>

On Mon, Jul 08, 2024 at 10:40:37AM -0500, Eric Sandeen wrote:
> On 6/24/24 11:03 AM, Darrick J. Wong wrote:
> > On Sat, Jun 22, 2024 at 04:26:31PM +0800, Long Li wrote:
> >> xfs_attr_shortform_list() only called from a non-transactional context, it
> >> hold ilock before alloc memory and maybe trapped in memory reclaim. Since
> >> commit 204fae32d5f7("xfs: clean up remaining GFP_NOFS users") removed
> >> GFP_NOFS flag, lockdep warning will be report as [1]. Eliminate lockdep
> >> false positives by use __GFP_NOLOCKDEP to alloc memory
> >> in xfs_attr_shortform_list().
> >>
> >> [1] https://lore.kernel.org/linux-xfs/000000000000e33add0616358204@google.com/
> >> Reported-by: syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com
> >> Signed-off-by: Long Li <leo.lilong@huawei.com>
> >> ---
> >>  fs/xfs/xfs_attr_list.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> >> index 5c947e5ce8b8..8cd6088e6190 100644
> >> --- a/fs/xfs/xfs_attr_list.c
> >> +++ b/fs/xfs/xfs_attr_list.c
> >> @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
> >>  	 * It didn't all fit, so we have to sort everything on hashval.
> >>  	 */
> >>  	sbsize = sf->count * sizeof(*sbuf);
> >> -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
> >> +	sbp = sbuf = kmalloc(sbsize,
> >> +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> > 
> > Why wouldn't we memalloc_nofs_save any time we take an ILOCK when we're
> > not in transaction context?  Surely you'd want to NOFS /any/ allocation
> > when the ILOCK is held, right?
> 
> I'm not sure I understand this. AFAICT, this is indeed a false positive, and can
> be fixed by applying exactly the same pattern used elsewhere in
> 94a69db2367e ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
> 
> Using memalloc_nofs_save implies that this really /would/ deadlock without
> GFP_NOFS, right? Is that the case?
> 
> I was under the impression that this was simply a missed callsite in 94a69db2367e
> and as Long Li points out, other allocations under xfs_attr_list_ilocked()
> use the exact same (GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL) pattern
> proposed in this change.

Oh, now I see that the alleged deadlock is between the ILOCK of a
directory that we're accessing, and a different inode that we're trying
to reclaim.  Lockdep doesn't know that these two contexts are mutually
exclusive since reclaim cannot target an inode with an active ref.  NOFS
is a big hammer, which is why the proposal is to turn off lockdep for
the allocation?  Why not fix lockdep's tracking?

<sees another thread>
https://lore.kernel.org/linux-xfs/Zou8FCgPKqqWXKyS@dread.disaster.area/

We can't use an ILOCK subclass for the reclaim code because we've run
out of lockdep subclasses.  I guess you could abuse lockdep_set_class to
change the lockdep class of an ILOCK when the inode enters reclaim (and
change it back if the inode gets recycled) but that's a bit gross.

What if we got rid of XFS_ILOCK_RT{BITMAP,SUMMARY} to free up subclass
bits?

https://lore.kernel.org/linux-xfs/?q=xfs%3A+remove+XFS_ILOCK_RT

--D

> Thanks,
> -Eric
> 
