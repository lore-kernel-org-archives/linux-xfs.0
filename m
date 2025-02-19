Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF52192B66;
	Wed, 19 Feb 2025 06:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945617; cv=none; b=kc9d8YVhFJgGUhpRhD7pWH6+v3wEAVrkeWN946eMmv5LaBcmCvUGZje9gFed7wmgmN3Qp22D5MABZbA75rYG0jwGk7AOaCSDPWyJMwS29mbdWgyRpYlaUopd8H+1H5CB7yeNyy2TZhDscMnPcBhk+w/V7MGRJJGCuCo30MOraIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945617; c=relaxed/simple;
	bh=xrZSG6K7SNY6kl1PY6d1AAJO78FxLTXG4++SqjIoB3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WKc64IgiqgJPiQCwR5WwS5P4bgQ8nBpwyqURB5Fga9jUXIp+RPUdLLuwe4A4gd2fNrYFT0paqkZDLligDpBjmg4Ro9xvIAUjV7gdQxUAYIjaRgW3PQ8/KouwjaDQ2ZRUR6h7A0kU5rq8oH/u7pyCPCXOcnXaCDTl21kTs3ASjHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ecm68y8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ecm68y8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A2AC4CED1;
	Wed, 19 Feb 2025 06:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739945616;
	bh=xrZSG6K7SNY6kl1PY6d1AAJO78FxLTXG4++SqjIoB3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ecm68y8xLOvYjidfoiTgqxukY3Usae81gmhIo1Jz543jQEFSnb198WVeM1Ggg7Zze
	 2LlBjebEO+yp8TEBJpiC+YfpdZDCTNgSI4lmlM4PhwPxDOYnnFZUM0OFuEztiJhVtu
	 3wfEmnEV93aeDH3hAbgvrM7CfgyiG4EWxA9ek4PBgMQw/XJquj0mJABU2aEZ8FGeSt
	 Zz9efoJd6RvqsAEfV1MehG6VkD1Ts9xEBrFfv0jZMd4r2TkReH45dAk1PkmZYth23o
	 qo564lp49eUxkHaiJE2sLQJAZYpebX6gQtYRrGPTG/dxzR/Jg8ZEMG3xxgQCA+9LAc
	 mkcLVLg/r96WA==
Date: Tue, 18 Feb 2025 22:13:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCHSET 02/12] fstests: fix logwrites zeroing
Message-ID: <20250219061336.GO21799@frogsfrogsfrogs>
References: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
 <Z7VyWPjJM-M59wJc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7VyWPjJM-M59wJc@infradead.org>

On Tue, Feb 18, 2025 at 09:55:36PM -0800, Christoph Hellwig wrote:
> I don't want to block this part as it's an improvement over the current
> state, but all these games of trying to detect if discard zeroes all
> data despite making no such guarantee whatsoever and being explicitly
> allowed to zero some but not all data just feels wrong.
> 
> The right thing would be to use the BLKZEROOUT, but AFAIK the problem is
> that dm-thin doesn't support that.  Given that the dm-thin discard
> implementation seems do always zero, it should be able to just be
> reusable for BLKZEROOUT.  Can the dm maintainers look into that as it
> is a pretty glaring omission?

Alternately we could make the log replay program call
fallocate(PUNCH_HOLE) on the block device before trying
fallocate(ZERO_RANGE) because AFAICT punch-hole has always called
blkdev_issue_zeroout with NOFALLBACK.  The downside is that fallocate
for block devices came long after BLKDISCARD/BLKZEROOUT so we can't
remove the BLK* ioctl calls without losing some coverage.

--D
