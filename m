Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072781C84DE;
	Wed, 25 Mar 2026 00:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774397783; cv=none; b=Fr0u2CFzJ854Qb6jIBBKz7Yt1XCPj63ZWjorZZZJH9C6cUc+3merJ0IGOgH7ssy+p0QTI20WxcqNYu3HUH2yK/IBUBbwCxl1qUeIYwVBGAxCb6ZXr2AY8KIzlQ8UyFH7FgXq+rV9+h8kVt9QvfYbC16lsqeDNr0SnpJkM/hIyaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774397783; c=relaxed/simple;
	bh=yInKgXrrlnfqgHhyddsLTRiX+TFR9uQkNY95NKrnCHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3VS2U3GqSQcoFYDGb7sKfAF+IAvQPqCHvweSv08wY5ji3wlevlQlv6PXz1jGWzT4D2gfhisJl20bR6iW6dRQ4Zgx5mG5tCI07AgEkOxl3dqRp0U8nVUHi5TsEFqhRCjI8MsRMnWRQSDaBbm7HTnFatuDhhCPDLPECP1/82DqWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eraXjBEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eraXjBEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BBBC19424;
	Wed, 25 Mar 2026 00:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774397782;
	bh=yInKgXrrlnfqgHhyddsLTRiX+TFR9uQkNY95NKrnCHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eraXjBEZ7Kd8XhkHdmBUznHdgzg3HUJFaPfsZSIeurpVNLvbkN7IzT6Fm4dGPnjaG
	 jQfFa+V0OY9C2Lt/jseKR6w62Ozz05/WCr4ySeDwgSaONWNmvFwlqs41EJ+4xxT0LZ
	 A77prhFzuVDbqomQhPuOAXa3Abn4k+1a+TE4RbM2Hkey3Yz606LDS0FITW/mEhwfNS
	 2uZGTB29ocremmLaNwwgn7Vt9xe4labRG+jTpTCC2pRvpAnO3XEF+e7BoVJ4t0DqHH
	 CHK/pm3VJpYcB5AXPlP7H/nR8X3lm6C+wNCOAWclsl9hHfdQMGVjP4IaC8ICf9a8Vf
	 E9WdsnteA9Tpw==
Date: Tue, 24 Mar 2026 17:16:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger@dilger.ca, jack@suse.com, cem@kernel.org
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <20260325001621.GD6202@frogsfrogsfrogs>
References: <20260312090810.1145908-1-ravising@redhat.com>
 <20260317065947.306954-1-ravising@redhat.com>
 <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
 <20260317133159.GA53921@macsyma-wired.lan>
 <ijwjh525hgf54wclhd4oixvfi3gfrodqrh2pbk7lr3whqw7nqo@k5uotrmekwyt>
 <20260318221810.GM1742010@frogsfrogsfrogs>
 <waksu55vh2fm74ltktchuckhezkjq4ggaooqrosixfzsuli5uo@i4q6ixu7r56x>
 <CAF-d4OvGmXWRinOB_qQYbCX9pckGLQbu1pghqDm-LhzHOaQY6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF-d4OvGmXWRinOB_qQYbCX9pckGLQbu1pghqDm-LhzHOaQY6Q@mail.gmail.com>

On Mon, Mar 23, 2026 at 04:55:31PM +0530, Ravi Singh wrote:
> Hi all,
> 
> Thanks for the feedback. Before posting a v3, I wanted to share some
> additional findings. The v2 patch only covers one of three scenarios
> where an unprivileged user cannot see the default limits applying to them.
> 
> Scenario 1: No dquot on disk (v2 fixes this):
> xfs_qm_dqget() returns -ENOENT, and v2 catches it.
> 
> mkfs.xfs /dev/vde -f
> mount -o quota /dev/vde /mnt/test
> xfs_quota -xc 'limit -u bsoft=10m bhard=20m 0' /mnt/test
> # Do NOT chown anything to testuser8 - no dquot exists
> su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"
> 
> Without fix: empty output
> With fix:
> Disk quotas for User testuser8 (1003)
> Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted on
>  /dev/vde                     0      10240      20480   00 [--------] /mnt/test

Hmm, yes, that looks like a bug to me.

> Scenario 2: dquot exists with non-zero counts but zero limits (v2 does NOT fix):
> 
> A dquot is created for testuser8 before default limits are configured.
> When the chown runs, xfs_qm_adjust_dqlimits() is called in
> xfs_trans_apply_dquot_deltas(), but the defaults are all zero at that
> point so nothing is pushed into the dquot. When the admin later sets
> limits on ID 0, testuser8's existing dquot is not retroactively updated.
> xfs_qm_dqget() succeeds and XFS_IS_DQUOT_UNINITIALIZED is
> false (q_ino.count != 0), so xfs_qm_scall_getquota_fill_qc() returns
> the dquot's zero limits.

I think this is a difference in opinion -- the last time I checked, the
default limits are only supposed to be propagated to newly allocated
ondisk dquots.

It's true that it would make more sense if the ondisk dquot had a flag
to say "I've had limits applied here" such that default limits would
apply to a dquot that already existed on disk but hadn't had limits set.
Plus then you could modify a dquot with explicit limits to revert back
to the defaults.

Unfortunately there's no such flag in the ondisk format so we'd have to
rev the disk format to add that behavior.  As such ... I don't think
this is easily fixable.  The only way you could revert to defaults is
if...

> mkfs.xfs /dev/vde -f
> mount -o quota /dev/vde /mnt/test
> mkdir /mnt/test/testuser8
> chown testuser8:testuser8 /mnt/test/testuser8
> xfs_quota -xc 'limit -u bsoft=10m bhard=20m 0' /mnt/test
> su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"
> # empty output
> 
> Scenario 3 : dquot all zeros / XFS_IS_DQUOT_UNINITIALIZED (v2 does NOT fix):
> 
> A dquot record persists on disk with all zero fields after ownership
> is transferred away. xfs_qm_dqget() succeeds, but XFS_IS_DQUOT_UNINITIALIZED
> returns true and the query returns -ENOENT. The v2 fallback does not
> trigger because it only handles the xfs_qm_dqget() error path.

...you delete all usage for the dquot and set the limits to zero, right?
Or does setting the limits to zero actually work even if there's quota
usage?

Either way if the ondisk dquot is totally uninitialized then I don't
think we need to emit a record unless there's also a default limit.

> mkfs.xfs /dev/vde -f
> mount -o quota /dev/vde /mnt/test
> mkdir /mnt/test/testuser8
> chown testuser8:testuser8 /mnt/test/testuser8
> chown root:root /mnt/test/testuser8
> xfs_quota -xc 'limit -u bsoft=10m bhard=20m 0' /mnt/test
> su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"
> # empty output
> 
> I see two approaches for v3 and would appreciate guidance:
> 
> 1. Fix all three in xfs_qm_scall_getquota() by merging default limits
>     into the response for any zero-valued limit field, mirroring
>     xfs_qm_adjust_dqlimits().
> 2.  Expose default limits through Q_XGETQSTATV using the available
>      padding space in fs_quota_statv, as Jan suggested, and let
>      userspace tools merge them.
> 
> Thoughts?

I don't think we should create more userspace abi since nobody seems to
think that anyone uses quota limit reporting aggressively.  But if
anyone does, now would be a good time to say something.

--D

> Thanks,
> Ravi
> 
> 
