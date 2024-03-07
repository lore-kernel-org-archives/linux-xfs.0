Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF2C13A241;
	Thu,  7 Mar 2024 21:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709845507; cv=none; b=Q7s4Ds/6NHizsMudzyRz/std0YMMAvwqVu+ojsTW/Vt3p2WEYU5Ngkw6jrWjO5QeH33WGO3FFRa/f5oVn26AaNxg+dp+fllEoep69EoZzfem9fQie4rvMkPwJJdri3CLzjjYBW9Zx2E6rJ45KsfK/LpJ+ZfOIPblCSPGuBcrqHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709845507; c=relaxed/simple;
	bh=XIbVq9MKTymH7R60DIn4dfIatGTqJdL4M2k+U7pGm4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hq6Yh0ERlddH77epIUABGQ7FGVA23KBczYcvKkRk8MHCI9sYteSr0EfpCKEzVi2+qPcnxS46GxqubOOe0zd7tM1ltAbFCXkHri9kbwmzWaDaIQwmXCfVpb5j/vhEvsMM3WNCxgxy3GMO1ufYO/8KyHkSw12hC2TIvyaTuzPhuCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZEOpFiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZEOpFiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0566FC433F1;
	Thu,  7 Mar 2024 21:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709845506;
	bh=XIbVq9MKTymH7R60DIn4dfIatGTqJdL4M2k+U7pGm4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZZEOpFiXyhF+5/1zdSMZXSC6gAIOPCD0JkSU0gn1cKl3W0e8aA87B9ORk3v2bETNq
	 FE96R8sZKlE9bPRFWVSmLkEpaab2rMzr0WHo3E0qdGW4VxximmHcVfW9xTvPHVSfvm
	 RmD+M9e4jnGq3JgQCpY4ph9RsvzLtCOu9AiRrVWHMh7G4UbmZHeurq7/473bv9/mQX
	 soe3s61NMeLQ4SRuWAsNapF+g3Mb+TebrJ0iyg/LVp9f8WxggMUAQ/H9pIb9T5jFBV
	 c+Dkhf4GOMPDoGsAWqCDGoF24hTIm7+1usRAFa1g4pX6aQTlGY2aNGwhSaNsxx22YN
	 IrtZSreoAqWXQ==
Date: Thu, 7 Mar 2024 14:05:03 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: RFC: untangle and fix __blkdev_issue_discard
Message-ID: <Zeor_z55xu6ulRyP@kbusch-mbp>
References: <20240307151157.466013-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307151157.466013-1-hch@lst.de>

On Thu, Mar 07, 2024 at 08:11:47AM -0700, Christoph Hellwig wrote:
> this tries to address the block for-next oops Chandan reported on XFS.
> I can't actually reproduce it unfortunately, but this series should
> sort it out by movign the fatal_signal_pending check out of all but
> the ioctl path.

The last patch moves fatal_signal_pending check to blkdev_issue_discard
path, which has a more users than just the ioctl path. 
