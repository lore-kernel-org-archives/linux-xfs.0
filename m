Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4682D3220;
	Wed, 25 Mar 2026 05:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774417623; cv=none; b=rVkBIK00dLVY6I1Pg6VKgzkpMSgAAusFBCvyoBcxmJy4lO5qYrgOqniqI3LtoOkoExLjhFKbOFBH0gK4QXNK9eQow6gdwlqyA7vXyKMP6s/tM3n6HlGmd4E+exp0P9SekptpcUfGS9XjL28Ik8BZCwLKDbl1GWfuNyvouT4HzVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774417623; c=relaxed/simple;
	bh=HAnha9yh6vdarKTSWV1edook/DYK4jnSa8SZcie+7yQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXxwegv/wRncxDX9mJK+OShxQqGSl2tchwAoFrKrjLCyN7pTPKyFo6umv0hhM0buxBTSqw2dd7oP5uhNRobJVjILaY6T4LMq7bWBdrAudCM1adzzFeBBqAm9QfRrUoz/XsM3wrFQgLmtVgDIpm3B7SKpJxpmBlM5j6+qePhxr58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U9JU8OQx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U9JU8OQx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rbExNmcz/T6tiSDMBuiMhGBIc1YqVjNZA8H6mFu6YfU=; b=U9JU8OQxb3tAgNjp0r/zhVnI8d
	kPiJyaQcakMjl2XMxaLlsBb5PKPmmSZpL+izkB8EKnA29bjRaLCaPbnlxwKPXVGbRAU1Mg92J/hX6
	QUSEK9WoblRwTVQ+NxL9+qj4HL/GQmFzf5plk8UA1lKIiDfSLbMIKYHxcgY7QiN2q44nFC0REndu0
	Ur1kBTIGAmHIMR27gw7c0GFHjw0NgwNdE0UNuxZ+ERS3jdow1Jcv1OfFofOdxKEPdV+7At352oep+
	PU+m1LrFKl/++21cC4jqBJ0Y2Eg/CH4lqle9VOHmGgN2goVArT7eExZBwtfxwLJvnDlWvEugWRv9a
	R8bFsVcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5H51-00000002jfE-00jY;
	Wed, 25 Mar 2026 05:46:59 +0000
Date: Tue, 24 Mar 2026 22:46:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ravi Singh <ravising@redhat.com>, Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, adilger@dilger.ca, jack@suse.com,
	cem@kernel.org
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <acN20taCrUDjd2v1@infradead.org>
References: <20260312090810.1145908-1-ravising@redhat.com>
 <20260317065947.306954-1-ravising@redhat.com>
 <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
 <20260317133159.GA53921@macsyma-wired.lan>
 <ijwjh525hgf54wclhd4oixvfi3gfrodqrh2pbk7lr3whqw7nqo@k5uotrmekwyt>
 <20260318221810.GM1742010@frogsfrogsfrogs>
 <waksu55vh2fm74ltktchuckhezkjq4ggaooqrosixfzsuli5uo@i4q6ixu7r56x>
 <CAF-d4OvGmXWRinOB_qQYbCX9pckGLQbu1pghqDm-LhzHOaQY6Q@mail.gmail.com>
 <20260325001621.GD6202@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325001621.GD6202@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 24, 2026 at 05:16:21PM -0700, Darrick J. Wong wrote:
> > Without fix: empty output
> > With fix:
> > Disk quotas for User testuser8 (1003)
> > Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted on
> >  /dev/vde                     0      10240      20480   00 [--------] /mnt/test
> 
> Hmm, yes, that looks like a bug to me.

Agreed.

> > Scenario 2: dquot exists with non-zero counts but zero limits (v2 does NOT fix):
> > 
> > A dquot is created for testuser8 before default limits are configured.
> > When the chown runs, xfs_qm_adjust_dqlimits() is called in
> > xfs_trans_apply_dquot_deltas(), but the defaults are all zero at that
> > point so nothing is pushed into the dquot. When the admin later sets
> > limits on ID 0, testuser8's existing dquot is not retroactively updated.
> > xfs_qm_dqget() succeeds and XFS_IS_DQUOT_UNINITIALIZED is
> > false (q_ino.count != 0), so xfs_qm_scall_getquota_fill_qc() returns
> > the dquot's zero limits.
> 
> I think this is a difference in opinion -- the last time I checked, the
> default limits are only supposed to be propagated to newly allocated
> ondisk dquots.

Yes.

> I don't think we should create more userspace abi since nobody seems to
> think that anyone uses quota limit reporting aggressively.  But if
> anyone does, now would be a good time to say something.

Agreed.  The fix one looks sensible, and everything else at this point
feels like a candidate for better documentation of the current
semantics.

