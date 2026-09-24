Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6053E4746B3;
	Thu, 24 Sep 2026 11:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249916; cv=none; b=sReyk88gAxx959i9urBFyFAUsvrdXsH3o/Gz6euec+9gqubsRz2fUbArwIyLwYtjMRw/0hpIb625L5dvfFT2I19mOI4jLDoLbu/G++2F2WvjcQYASx0C3Grr4W2rozcm9orweBLt8Ef1l41d7bUmWuyuHI7Pl3z/6IqkJQY5OzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249916; c=relaxed/simple;
	bh=xRJ//L7/GhCFVehFq3WovnpRWL81yhDw1Z1nUq0OBZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9aTzXQ+JctovvY0aG9Pq+CyiEy+UTS8LZPBLh1TdLpHniBkbpzg/jcvYakkr8fg6jJ7sJnxIbVwy09a3JOeziqkJeY4ebe6tA3/vHIOkKUk3+NVzBRc+NlNqSgPsC6HxnlFRvboXqMQ5pxtOsp0gbsVjFfcv8zC4Zl+BjzCa84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gjs0c+b9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gjs0c+b9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435791F000FF;
	Thu, 24 Sep 2026 11:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249913;
	bh=OqCrtCGgXXEf6QWkP/rDUVyjLDUqCpf1kFD9GdQ4c6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gjs0c+b9FtVib5MaCrePyAwbjJCGQI2g2LXccmjlK2HMlVmzoZXV8RI2oJzRVz/6O
	 Xibpra4JVJNcGzGqTngUCMhjb2YGK/HIcncJS5bgIl2KnKeVDqYPL9th9Gn03l8R13
	 GvUlnCyGnEd4ejghYUZbYO68X1PSB4xP+8E9vfAF6QxtEwEnjk0ax0pYTkTMXXNkfw
	 lIm+QnPfOgaf7KuDLCvagmJK7DPYYEnL1XtX7Fk9aLDCvphrxJvGIfBF8rR/LjoydV
	 IAqJWXjJQ7nf17LDwYaHjQQGdAbguP8gnRBbcOPk7Cv+vz6RSF9vbSuKQS4cHtlL9y
	 eyuRcV0aL91Gg==
Date: Thu, 24 Sep 2026 13:38:30 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>, 
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/805: skip this test if we can't mount the
 filesystem
Message-ID: <arULpLAWh-Jt2k4w@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260924060245.GE6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924060245.GE6253@frogsfrogsfrogs>

On 2026-09-23 23:02:45, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test doesn't work on filesystems with external devices (e.g. xfs
> realtime) because the SCRATCH_DEV gets formatted with regular scratch fs
> options but the filesystem is mounted with a bare _mount call, not
> _scratch_mount.  Since SCRATCH_DEV is not the dm-linear device created
> earlier in the test, we can't really use that either.
> 
> In any case, if we can't mount the filesystem immediately after
> formatting it, then we're not satisfying a test precondition.  Change
> the _fail to _notrun.
> 
> While we're at it, fix the cleanup function so that unmount failures
> don't pollute the output.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
