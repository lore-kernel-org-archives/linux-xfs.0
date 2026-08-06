Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D83D88E7;
	Thu,  6 Aug 2026 21:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050569; cv=none; b=ZNHgufPRTE1e1DPL1gGpbQxgaieibvkSqTaaHQVr9g5HAdAHPDSvlpgnp+pnWCC5CUBggmEl+1dD7bMaTwTu54Pm3IoM5gsR1reMKi3LahOMmEektZEdNPWZzyIbq+l/lln5tuDwlfIcPMX9syu/HfMvZuDCCeP+H7aG+MY3gnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050569; c=relaxed/simple;
	bh=H13sT8+LBKqMiAs1WCj9UX0nUq1jWG7KvricOz7/Jd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxkuLOFQ0UT6+IHaRMrjp5UP4aKvibLB2S4z1zeYHogW0WTCJ0n6MboOhlKanIk2L84PWHOG8bjXVX94l9SsqsxemAcpFfpAN3F8sR46Cu+mvwD2PXn2pqaZgOy5voaswFLgW9rWLhl7I/T6Y/JTzeBFbahC7yGKHn1/por0O2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWtohO+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWtohO+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773E61F000E9;
	Thu,  6 Aug 2026 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786050568;
	bh=vGVI6MOdLcTGZdstyW9cWDl+lG61qJD6GmmtXdxWznk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hWtohO+bAgnImK6EeA4RW5QwtBfYTuH53xhGh9pXNp+zqDon6Lq5OQ2ckZCSkHJut
	 5NhJBZCNvCREQ5FyFqM5U4Ud8UefQfTW71vc7Hy+6U5+YFO/e6HTj0LV1GMRGTwbNW
	 e2AwgWI2bpGGjm75hDOKPNwcBfDK17tIDgdw30tamKoBEhVEkP2PzbkDjLK53hgjAP
	 TD2cBczXCt4uaRFi6HUuW69jR4O4SzwyxJjkghF6FCTXZieONJG5QaJfOOTwpRjxw/
	 Rbs3l6ggEe4i6HOp5FJuJw1cG2fQu5bU5x+jQbRdoXJgUL+iNfZJkAnDrZqzV2IXqF
	 6RJrupg9d2l9g==
Date: Thu, 6 Aug 2026 16:09:25 -0500
From: sergeh@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Fix quota evasion on xfs and add capable_noaudit
Message-ID: <anT4BYrW8dF8fTcy@AUS2MQ6190Y76.amd.com>
References: <20260804094602.84766-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804094602.84766-1-cem@kernel.org>

On Tue, Aug 04, 2026 at 11:45:50AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Hi there.
> 
> This is the a new version of the series I've been working on
> to fix a quota evasion issue on xfs. I've got to jump to more urgent
> matters before the previous one so my apologies for the time it took to
> cook this new version.
> 
> The changes to this version compared to the previous one are minor, only
> comments and indentation related. This new version has also been rebased
> on top of current xfs's for-next branch. A description of the changes
> between this and the V3 version are below and more detailed on individual
> patches.
> 
> This bug has originally been introduced by accident while turning off audit
> messages while checking quota limits in xfs by replacing capable() calls by
> as_capability_noaudit().
> 
> This series concatenates both series I sent for xfs and capabilities
> infrastructure as they are dependent.
> 
> The first patch fix the xfs bug in a way that makes it easily portable
> to older LTS kernels.
> 
> From second patch and beyond, it adds a new helper for the capabilities
> framework named capable_noaudit() which as the same semantics as
> capable() but without generating audit messages.
> The following patches then replaces both generic quota call to
> capable() and properly update xfs code to use this new helper.
> 
> Last but not least this unexport has_capability_noaudit which had been
> previously exported.
> 
> Giving this affects different subsystems, I think it would be easier to
> pull everything from a single tree (as long as everything is properly
> reviewed of course).
> 
> Serge, Honza, are you guys ok if I pull those patches and send them to
> Linus through xfs tree so we don't need to split the series?

Oh, I missed this before - yup, please do.


> Also I kept most of the RwB tags from previous versions as there were no
> code changes but minor context updates to fix the conflicts.
> 
> Serge, I removed your RwB on purpose from the patch 2 as I updated the
> comment, so I want to make sure you are ok with the new comment.

thanks - sent a new RwB in reply to that earlier.  All good.

thanks,
-serge

> Changelog from the last state of these patches:
> 
> Patch2: Add more details to the capable_noaudit documentation specifying
> 	it checks for the process effective capabilities.
> 
> Patch4: Fix identation changes introduced in previous versions
> 
> Carlos Maiolino (5):
>   xfs: fix capability check in xfs
>   capability: Add new capable_noaudit
>   quota: Don't issue audit messages on quota enforcing
>   xfs: replace ns_capable_noaudit
>   capability: unexport has_capability_noaudit
> 
>  fs/quota/dquot.c           |  2 +-
>  fs/xfs/xfs_fsmap.c         |  3 +--
>  fs/xfs/xfs_ioctl.c         |  2 +-
>  fs/xfs/xfs_iops.c          |  2 +-
>  include/linux/capability.h |  5 +++++
>  kernel/capability.c        | 19 ++++++++++++++++++-
>  6 files changed, 27 insertions(+), 6 deletions(-)
> 
> -- 
> 2.55.0
> 
