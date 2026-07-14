Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6544444C648;
	Tue, 14 Jul 2026 19:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784058051; cv=none; b=hm7HMGcdwOY+f3bGxqBpZLQS2aGijSTvHLnf8bl6vYOVPGh6MPbOIi5VAbaOKwLNjIsDf9GK++kC68KxPA6311nCpyNmXdNGv7/kyaJT0dtvtSYPK9NyEVJISmSKyNxB8EeWfK7Ey26e1wfe5aQaN10LkYs0xe0BwypBDWmzQ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784058051; c=relaxed/simple;
	bh=LGEIhAx/I9C+YE4u3XIJEGM9PbhXn6eNPevg0Fuq4fA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1RTKFxtNPlFLDPFpDzjC3fLlugqCGXXbVWYRBUNOTSbvfYgEXS+HmYRHwtyWJOc/gNpU0m9yV9yrIelYLboOqk/6GZJlR8z7mFPGRGa7unmW7+OJguja/+jympLsyn7aVOjGTf4Mzefp493nN/ly+B90D5e1pCWcf15Yst2fvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4xC+CcP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4xC+CcP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E359A1F000E9;
	Tue, 14 Jul 2026 19:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784058050;
	bh=CQCrjQQzaUpz/v8ckIuRdvW2TCep34nrPG3OYLIBgiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k4xC+CcPAwbnR/9hz7sD71iooEzMARD5jC00FfRkrlycSnQiT+FAVgVVkPQWcpUMg
	 I7Mah+oa71BpEVnqJDHNfKJ30FOWpOnsMRbLWl4ZmM9btVE1vkJrIXzuJ7V+gnH8Iv
	 T3IsQhd2QvpC8fDKBLgOvhfnyYMfesg9EXmv7yOY5Sh+K37Fz/xYtysggjJHJO9Ixx
	 kAxHoekf5l384f17erwqOLuOXtGAbdl1GWPa4oAbzh9aVdB0EjIy5WVsjVbelIHPxf
	 RjS9D5rTBgrviahFMOjuxctDkJu3ftBSxSejKQPcScdo098Xgc1oWbrhqcNuPwCPwQ
	 DXyd+pR0Ezdtw==
Date: Tue, 14 Jul 2026 12:40:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Ibrahim Hashimov <security@auditcode.ai>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] xfs: bounds-check buffer log item's dirty bitmap
Message-ID: <20260714194049.GI7380@frogsfrogsfrogs>
References: <20260714172730.73160-1-security@auditcode.ai>
 <20260714175532.74257-1-security@auditcode.ai>
 <20260714180152.GH7398@frogsfrogsfrogs>
 <alaL6C6Gy717Jk2J@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alaL6C6Gy717Jk2J@bfoster>

On Tue, Jul 14, 2026 at 03:20:08PM -0400, Brian Foster wrote:
> On Tue, Jul 14, 2026 at 11:01:52AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 14, 2026 at 07:55:32PM +0200, Ibrahim Hashimov wrote:
> > > xlog_recover_do_reg_buffer() replays each dirty region described by a
> > > buffer log item's bitmap into the buffer read for that item:
> > > 
> > > 	memcpy(xfs_buf_offset(bp, (uint)bit << XFS_BLF_SHIFT),
> > > 		item->ri_buf[i].iov_base,
> > > 		nbits << XFS_BLF_SHIFT);
> > > 
> > > The destination offset (bit/nbits, from the logged dirty bitmap) and the
> > > buffer size (from the logged blf_len) are both attacker-controlled and
> > > otherwise unrelated, yet the only thing bounding the copy is an ASSERT(),
> > > which compiles away on production kernels. A crafted image logging a
> > > small blf_len together with a bitmap bit past the end of that buffer
> > > drives the memcpy() past the buffer's allocation, corrupting adjacent
> > > kernel heap during mount-time log recovery. This is reachable by anyone
> > > who can get a crafted image mounted -- the malicious-filesystem threat
> > > model XFS already guards against elsewhere.
> > > 
> > > Turn the ASSERT() into a real XFS_IS_CORRUPT() check that aborts recovery
> > > of the buffer with -EFSCORRUPTED, consistent with the validate-and-fail
> > > idiom already used in xlog_recover_do_inode_buffer() and
> > > xfs_dquot_item_recover.c. xlog_recover_do_reg_buffer() therefore becomes
> > > STATIC int and its three callers propagate the error.
> > > 
> > > Found and confirmed with KASAN on a CONFIG_XFS_DEBUG=n build: the crafted
> > > image trips a slab-out-of-bounds write before this change and fails
> > > recovery cleanly with -EFSCORRUPTED after it.
> > > 
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> > > Assisted-by: AuditCode-AI:2026.07
> > 
> > Looks fine to me now, thanks for making those edits.
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > --D
> > 
> > > ---
> > > v4: fold xlog_recover_do_dquot_buffer()'s bool return and error
> > >     out-parameter into a single int return (1 if dirty, 0 if clean, or a
> > >     negative errno on failure), per Darrick's review. No behavioural
> > >     change.
> > > v3: trim the changelog per Brian Foster's review. Add a Fixes: tag --
> > >     the destination-bounds check has been an ASSERT since the initial git
> > >     import (2.6.12-rc2), so it predates the git era.
> > > v2: resend; v1 went out with an empty Subject line due to a local
> > >     git send-email glitch (leading blank line in the patch file).
> > > 
> > >  fs/xfs/xfs_buf_item_recover.c | 56 ++++++++++++++++++++++++++++-------------
> > >  1 file changed, 40 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> > > index 02b95b89d1b5..cf2b07ebc6f3 100644
> > > --- a/fs/xfs/xfs_buf_item_recover.c
> > > +++ b/fs/xfs/xfs_buf_item_recover.c
> ...
> > > @@ -1081,11 +1103,10 @@ xlog_recover_buf_commit_pass2(
> > >  			goto out_release;
> > >  	} else if (buf_f->blf_flags &
> > >  		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
> > > -		bool	dirty;
> > > -
> > > -		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
> > > -		if (!dirty)
> > > +		error = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
> > > +		if (error <= 0)
> > >  			goto out_release;
> 
> I might suggest something like:
> 
> 		/* reset error since > 0 means to write the buffer */

I /did/ actually suggest adding a comment in my reply to V3:

		/* write dirty buffer */
		error = 0;

but I've gotten so burnt out on arguing with programmers who quietly
drop comments that I've stopped pushing back.  Thanks, Brian, for taking
up the mantle. :)

--D

> ... or maybe we can phrase that better. But regardless LGTM now as well,
> thanks:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > > +		error = 0;
> > >  	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
> > >  			xfs_buf_daddr(bp) == 0) {
> > >  		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
> > > @@ -1105,7 +1126,10 @@ xlog_recover_buf_commit_pass2(
> > >  			xfs_buf_relse(rtsb_bp);
> > >  		}
> > >  	} else {
> > > -		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> > > +		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> > > +						   current_lsn);
> > > +		if (error)
> > > +			goto out_release;
> > >  	}
> > >  
> > >  	/*
> > > -- 
> > > 2.50.1 (Apple Git-155)
> > 
> 
> 
