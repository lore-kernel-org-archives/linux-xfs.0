Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAADA1A5B9E
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 05:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967499; cv=none; b=iJuNIHWWsET3KyhhInng/Z+a4QIb8wo244BzEvbXYKwCEYRYzX8oKbOsiZrAlZAZui1ARj3RaxJdSNeWot2DdPN66Q5bkqSeRAYGiA2lThtWiWAuaCX5oz9V0EMH9ikHNN4FTmxPoAaOCIwPfmcBMsWGL5lKdQeFEqMxF9DmpZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967499; c=relaxed/simple;
	bh=ZETr4Nsx/SipW7sQGKVOS/w5h4dcrdsMjyHaBp4OARc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvWEbvKdhOFetaJAT7zoPU6VE7JTFZFXkMQkYctk6C4VdyurDPjvvqddmf9HRkrdHrYZz+mJk1PBnMwlZAlUJtIyHu3A/AH+JgS/V1YCL17qfiLJJhM0RYHW/ibJTwhei1Xytvtx7fXkDk7oBQFVXDBQb/DCWFtbXjNHc5H1r0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClGtJIw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClGtJIw+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 25A5C1F000FF;
	Mon, 21 Sep 2026 05:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967497;
	bh=Sv08ulLWpOPTSQJaRamYwssnb1nuTDoK0/DYLZDdAlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ClGtJIw+paGLdz0UVsxwJ3ND6qisZLCQXB1oacQyd7NGgpHgAevjdmh/3fGJk1sNj
	 RPJMXTgQ4DVDNC6IrjUH9kwha3VdgG/cE5BrOBlNgY3yzHTdkcmtysxdpVK2d8VKp2
	 cvvVgGl2lxISe0Fr2NU2CbouzJyp/3Vkh+kDppXtC1K3uOhNe/8oRNsWVt2QN4cIga
	 1K+fNhc0XDHhX2j0nXXFcNaOhnnH+jzvSZE1CTIAwTExnFtW3R90qb+UpZQsYtsdXJ
	 LRovEvQR6tkWTYzZfQqAoRaAgmHCWlbSnVBwl/uZyXVuJ3RAkonqI77UrnfXOJjDrA
	 mVYQuGdMsW4rw==
Date: Sun, 20 Sep 2026 22:11:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH for-next v2] xfs: fix NOFS state corruption in btree
 split worker
Message-ID: <20260921051136.GJ2705364@frogsfrogsfrogs>
References: <20260920073014.2843814-1-wangkefeng.wang@huawei.com>
 <20260921034842.GH2705364@frogsfrogsfrogs>
 <c781e564-dc88-42a3-9457-f197d5ad83a1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c781e564-dc88-42a3-9457-f197d5ad83a1@huawei.com>

On Mon, Sep 21, 2026 at 12:50:37PM +0800, Kefeng Wang wrote:
> 
> 
> On 9/21/2026 11:48 AM, Darrick J. Wong wrote:
> > On Sun, Sep 20, 2026 at 03:30:14PM +0800, Kefeng Wang wrote:
> > > xfs_btree_split_worker() calls xfs_trans_set_context() and
> > > xfs_trans_clear_context() on the caller's transaction, overwriting
> > > tp->t_pflags with the worker's NOFS state. When the caller already has
> > > PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> > > the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> > > the caller's NOFS protection.
> > > 
> > > Use memalloc_nofs_save/restore with a local variable instead so
> > > tp->t_pflags is never touched.
> > > 
> > > Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
> > > Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> > > ---
> > > v2:
> > > - Send bugfix only based on xfs-linux/for-next, suggested by Carlos[1]
> > >    https://lore.kernel.org/linux-xfs/aqqGiu9W0G7dquoY@nidhogg.toxiclabs.cc/
> > > v1:
> > > - https://lore.kernel.org/linux-xfs/20260911104227.2028941-1-wangkefeng.wang@huawei.com/
> > > 
> > >   fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
> > >   1 file changed, 8 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index 60ef7f08b1d3..239741132914 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > @@ -3010,6 +3010,7 @@ xfs_btree_split_worker(
> > >   						struct xfs_btree_split_args, work);
> > >   	unsigned long		pflags;
> > >   	unsigned long		new_pflags = 0;
> > > +	unsigned long		nofs_flags;
> > 
> > Might want to call this old_pflags?  We're adding NOFS, which means that
> > this variable is just the old value.
> 
> $ git grep -w "= memalloc_nofs_save" fs/xfs/
> fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
> fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
> fs/xfs/scrub/xfile.c:   pflags = memalloc_nofs_save();
> fs/xfs/xfs_aops.c:              nofs_flag = memalloc_nofs_save();
> fs/xfs/xfs_dquot.c:     nofs_flags = memalloc_nofs_save();
> fs/xfs/xfs_file.c:      nofs_flag = memalloc_nofs_save();
> fs/xfs/xfs_file.c:      nofs_flag = memalloc_nofs_save();
> fs/xfs/xfs_icache.c:    nofs_flag = memalloc_nofs_save();
> fs/xfs/xfs_ioend.c:     nofs_flag = memalloc_nofs_save();
> fs/xfs/xfs_log_cil.c:   unsigned int            nofs_flags =
> memalloc_nofs_save();
> fs/xfs/xfs_log_recover.c:       unsigned int    nofs_flags =
> memalloc_nofs_save();
> fs/xfs/xfs_super.c:     flags = memalloc_nofs_save();
> fs/xfs/xfs_trans.h:     tp->t_pflags = memalloc_nofs_save();
> fs/xfs/xfs_zone_gc.c:   nofs_flag = memalloc_nofs_save();
> 
> The most places are using the nofs flag, I could change it
> to old_pflags if needed.>
> > Also, doesn't memalloc_nofs_save return an unsigned int?
> > 
> 
> Sorry, I fixed the conflict but missed the type change.
> Should I resend a new version with the renaming(nofs_flag -> old_pflags)?

Eh, I suppose we're not at all consistent, so pflags/nofs_flag is fine.
But we should still use the correct type to avoid wasting stack space.

--D
