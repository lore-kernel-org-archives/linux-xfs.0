Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CB21D47BD;
	Thu, 17 Oct 2024 09:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729157564; cv=none; b=sPowj+4fGpYndI4QL+sWimqldIG6+myWYmXFmUsOTi4duPuh6HRbPWxd0UwM6Z5yaMke1NJ8oMMJ1JKs/2mhMaZLa/ry/YNg240WpszwDnND8QP8/mDctgW4pndhRUTFT/V+VVhAs2qTQzx8fU7jysMVBArtvZ2qdYrXlpRatR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729157564; c=relaxed/simple;
	bh=kAIrMwThJccsts8ge5Rghfsp7yNrWi4TXlxtRvtQnK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nSMrX8ABdZR74qrw9CUiEI/NBXYUTmk59P5N6kAWbe76hbWhtvjPeRu7ZeH9lZovCEKIrv0fU5SC1bP1Pb0OqgUruqQFo7qyHtNQXbH8tHWbfPqwIXGkfuMxuWe9GW8Nlsk2bp0BmxbuCtcIWShbOd/p9oOne/mbByhneB1eHLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=acJbvGlQ; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="acJbvGlQ"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4XTjKy2K3Mz9tTZ;
	Thu, 17 Oct 2024 11:32:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1729157558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+txMzFuhagbsogYxWyZvhDRSQj6uVKUwrwWhY2kSds=;
	b=acJbvGlQzeh+zFSBpb57Hk9hsK6/L6BlYpf9k8Ye6ApDkDkN30pXmM6762VmgyBRAeSMap
	HCl/PPpOXAlQN8A1IplAbdnrsHXXl5pnzJlqq/XbvJ+d71yy0PF2HOoj/PB42eOtK3whAJ
	Hsc0Hvf+16yelJYo4qx35pMTe6pKKNMMwq0k/HN2Fk4m5iJhS/87uvI+xbN+DGiyyJCOw2
	zlbmUR3KZ4pBEfOEsu9C71X8m9qSqB0FnE8rJoLuuFn425tLIoeV2hTOmqB9F585tqwRTA
	pm3mLgNbnpdNMtVlM14ygQ6fg4lbELLWGAIe5U31X2Jal7HteLlxN1SnfFPgJA==
Date: Thu, 17 Oct 2024 15:02:27 +0530
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET 1/2] fstests: fix fstests for 64k fsblock size
Message-ID: <jettfsxkievb5prsh36rg5k4nzdcymtyns5wuwjnm5qwqnbgai@tubebxpinjvw>
References: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
X-Rspamd-Queue-Id: 4XTjKy2K3Mz9tTZ

On Wed, Oct 16, 2024 at 04:15:05PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Various patches to fstests to make 64k fsblock filesystems mostly pass.

Thanks for resending xfs/161.

> I haven't gone back through the remaining failures (mostly quota tests)
> to figure out why they fail.
I am on it. I will send the patches soon.

--
Pankaj
