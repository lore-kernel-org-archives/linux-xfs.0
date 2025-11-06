Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E5E32AADD
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 13:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762435634; cv=none; b=Zr0lkntPuJGJqUbIjD8vnBCKLQdDAIUvAL8A/VaXnaOzzfngMKDJTQrfy0dNDzQ9nrKn4Gad1smCEuj1uCofY6ofzbrLjn+e9J5FCKfEv6dOdosj0gnTcsL1vd+7N9NejiAYtBByiMUTF9Avdqdj7JLpMI8EZQkyruM4VvfdF0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762435634; c=relaxed/simple;
	bh=ziGA7UTgQf6B1yKl9JrQCXIZzWgmcH/10pDTR0wBHvc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EgXfTMc0YENHEkn/Y/AVdUIejXlbPgD2XEDZ4oZ3fOKHLZ7BsQsXYuzGX+MRxj1Nt7CH8wkQ02/28pdewYaui7FN1Hnfow2XZNYuAP42jPRpXQf73/u41Z1AgvDnizg79el6x1FCpgCtvF8+vi/MmqlzHh8l/RBg1Ya/S1wqlew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQ9DypBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQ9DypBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A237EC116D0;
	Thu,  6 Nov 2025 13:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762435634;
	bh=ziGA7UTgQf6B1yKl9JrQCXIZzWgmcH/10pDTR0wBHvc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=QQ9DypBZm5PQ+zS0/VdCFLcb9riO21Al0GKZLXd0Mh69aihCCyDNxpmSpenHSgs9f
	 Z4gROZO0g4MVWvhrQ/3gMptHeGfOxRBFZEH/MNNdGfl++tbElccyOg1B0vfhZe/mLK
	 DX2kACPKod9Ptxnjjg/JUEPRg4gtRh0+3uCSILL7pRbwc8gYMWVRynR3POCcCUgq28
	 vrZUs9fQEuk+QzY1NHjr77DB5TQGLs6aFXOr7yQKJVzVcwHkILbHvxjEDiAvcmZjra
	 7QOpBZvlFWJB/Mp9eyBscI1/0NIS51f9sacAD7/UjwRf8KmeLlD+9CwzKIGvv1IpI9
	 B9x0crlegHSbA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20251104104301.2417171-1-hch@lst.de>
References: <20251104104301.2417171-1-hch@lst.de>
Subject: Re: [PATCH] xfs: free xfs_busy_extents structure when no RT
 extents are queued
Message-Id: <176243563336.345504.8099891120048707880.b4-ty@kernel.org>
Date: Thu, 06 Nov 2025 14:27:13 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 04 Nov 2025 05:43:01 -0500, Christoph Hellwig wrote:
> kmemleak occasionally reports leaking xfs_busy_extents structure
> from xfs_scrub calls after running xfs/528 (but attributed to following
> tests), which seems to be caused by not freeing the xfs_busy_extents
> structure when tr.queued is 0 and xfs_trim_rtgroup_extents breaks out
> of the main loop.  Free the structure in this case.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: free xfs_busy_extents structure when no RT extents are queued
      commit: d8a823c6f04ef03e3bd7249d2e796da903e7238d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

