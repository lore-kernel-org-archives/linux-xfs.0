Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B955D2820A4
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773754462; cv=none; b=Td347eSeHgCzhoRxp0iuYLt+zuOegXOjiDa/A6CC3qBq321WdZU+3v5tYlwZ8QJPbwf/euU4kj0SVlmYatSTnvt5y1JqOyMD5pnAfrjv27nzYnERbYl1b0WKBM3Hdw0EZXboOUQw2UQDpSnrjoPKN0hpbkpVKz5I1PoLrp0sUA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773754462; c=relaxed/simple;
	bh=QB5YcD7hcG8XvGeV+CvyLe4SUxO66JSeZpgN903D+4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NrEEI3/0Eg6cKUVTaLLg8h599gJYWG6rUk+pwsDialDeok7owXz808tsHly60w3vA4aovNMYosis0hEXWR+fiwwVUfZaz/vBxXF+qHtcJqPeQ6UNJZ0wpEiemD/npALIui8CU9MXAHFAEXYiF/zp9+Qhwa0/ckeCKD60pJ4juQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=CW5viBYD; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="CW5viBYD"
Received: from macsyma.thunk.org (pool-173-48-82-106.bstnma.fios.verizon.net [173.48.82.106])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62HDWxTN028157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Mar 2026 09:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773754384; bh=UfzdMpGoqp/+PngQW/zL/MtxxbxWP60HIINjEtoXNCw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=CW5viBYDFmUgqMSzp0wl/D0sturkgc2uLWOLgVtMPhJ2tiNSSneZCA0wvboVnF3N8
	 EdtojisiLUCUKBisE6hsEdIwRcQmDSsY1bxssa5BkMHwchoRllk2J5gln+L6Wr/u7B
	 AudnOSL1BwdWryuL3HQfB5xW4f1bXE37Kj1PnOsZbU5zI5GrfnUSKjln/DdsuhqADI
	 O7RL093MpXA/7a85vetBXg9ROfZAVIhDRsptHlzbrrT2hceHPeD2U4JaS9862yH2kv
	 z3y+a0ncwd/3D0an0glE0ViBwdYMwKi9tj5UiRtv9OIiV3170Y1twLKaeKqkBc6PTz
	 IgnBC9/JxGyTw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 724695DF7013; Tue, 17 Mar 2026 09:31:59 -0400 (EDT)
Date: Tue, 17 Mar 2026 09:31:59 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Ravi Singh <ravising@redhat.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adilger@dilger.ca, jack@suse.com,
        cem@kernel.org
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <20260317133159.GA53921@macsyma-wired.lan>
References: <20260312090810.1145908-1-ravising@redhat.com>
 <20260317065947.306954-1-ravising@redhat.com>
 <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>

On Tue, Mar 17, 2026 at 01:19:23PM +0100, Jan Kara wrote:
> On Tue 17-03-26 14:59:47, Ravi Singh wrote:
> > When an ID has no dquot on disk, Q_XGETQUOTA returns -ENOENT even
> > though default quota limits are configured and enforced against that
> > ID.  This means unprivileged users who have never used any resources
> > cannot see the limits that apply to them.
> > 
> > When xfs_qm_dqget() returns -ENOENT for a non-zero ID, return a
> > zero-usage response with the default limits filled in from
> > m_quotainfo rather than propagating the error.  This is consistent
> > with the enforcement behavior in xfs_qm_adjust_dqlimits(), which
> > pushes the same default limits into a dquot when it is first
> > allocated.
> > 
> > Signed-off-by: Ravi Singh <ravising@redhat.com>
> 
> So XFS guys should also review this but from quota POV this looks like a
> right fix to me. So feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

This was discussed at last week's ext4 conference call, and we
wondered whether we might be better off adding a new
Q_XGETDEFAULTQUOTA or some such which returned the default quota.
This would that the quota userspace utilities would have to be
changed, but it would also mean that userspace could distinguish
between whether the quota limit was due to a default value being used,
or because the user had an actual quota value set.

It also means that in the future, if we wanted to change where the
default quota was stored, it would be possible to do that instead of
overloading the quota value for uid/gid 0.

We also speculated that perhaps there might be cases where if some
process might be running without CAP_SYS_ADMIN, there might be a
reason that quota for uid=0 might actually make sense, and so perhaps
some future file system format change might want to decouple where the
default quota was stored.

This is a API question, and given that I don't really care a whole lot
about quotas (we use quota only for tracking usage, not for actually
enforce quota limits, so I really don't care that much), what do folks
think makes the most amount of sense?

						- Ted
