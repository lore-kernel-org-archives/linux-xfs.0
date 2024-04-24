Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF8C101F2
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929972; cv=none; b=fX9pU65WthB+v3mMMf02dWez0l8dQKz5ZlUVg3hWOYrvl2fDV6reWrO4PLsDih8SMCIG0gptlmzNkL9KZidjCUBlshax7ZYnHyfYAeUFrcM8qT+pDbt/o7w0OKsrnZGemclzUDlp2wo0uMVtqM8loPLEPcysuW6APnqEG78Ax8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929972; c=relaxed/simple;
	bh=xPgZv9cjAFtHMRwbW3FiDr7bP5fhaKx6m9ADWP0K6M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfDwrGhyhq30getCPXffhRHTLXg9gxj6PCF6UJEE47+OGyZd2tE2e4V06l/xTuuRohlVYgm0mmHuop1iw1UYag/HZobGqMGSRgiLQI0itGj1ilQEHDV4CeMP0k2v/kudZweCnvUQ5c3zKlRUfSWGHHhYRDETFYmyvSJguWJyb/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2mVqW7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2mVqW7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01C9C116B1;
	Wed, 24 Apr 2024 03:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929972;
	bh=xPgZv9cjAFtHMRwbW3FiDr7bP5fhaKx6m9ADWP0K6M8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W2mVqW7d5+L1GA5JWlpvNNIJsvWsbNy/pyIJ5BVBPoPNxRRKy7oVHPShiUTykwk4g
	 FKOs3ESsWy+ygMAe2XOMofVhuuWbkBN9H4TDtqHHMI20HeiGzjU4uQ9zCbBt6L+BOt
	 shAmHyWqbUL6NzXIcJ54utjYtRQLxIL6GU0+MikYahFYQA2+rQl+VwfnmkKQYydz+N
	 1RAJB/UiOGtkgPGtlagOiYMTzWsfFxbYYZFUmEK1gO1Bo2+vhikA1vTStJYegeq10g
	 MUpzZtLs+yGL7npo/zo6mpzP4VnDPXhaAUYELR+vheMCD0xvF61mLUuSksKNZSzG8h
	 zljQldiyMfkww==
Date: Tue, 23 Apr 2024 20:39:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug 218764] New: xfs_scrub_all.in: NameError: name 'path' is
 not defined
Message-ID: <20240424033931.GE360919@frogsfrogsfrogs>
References: <bug-218764-201763@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-218764-201763@https.bugzilla.kernel.org/>

On Tue, Apr 23, 2024 at 03:24:32AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218764
> 
>             Bug ID: 218764
>            Summary: xfs_scrub_all.in: NameError: name 'path' is not
>                     defined
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: 60510scott@gmail.com
>         Regression: No
> 
> Created attachment 306198
>   --> https://bugzilla.kernel.org/attachment.cgi?id=306198&action=edit
> journalctl -b -u xfs_scrub_all.service
> 
> `path` variable is not defined in
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub_all.in#n166
> 
> 
> Attached is the error log of `xfs_scrub_all.service`

Working on it; there's a largeish rewrite of xfs_scrub{,_all} pending
now that the kernel part is done.  This patch should fix the problem:
https://lore.kernel.org/linux-xfs/168506075234.3746473.4940860665627249144.stgit@frogsfrogsfrogs/

But it might take a bit of time to get the last ~150 userspace patches
merged.

--D

> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
