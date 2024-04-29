Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0821773A;
	Mon, 29 Apr 2024 09:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714383543; cv=none; b=SuqmzX2GXll1KSJWxI9O01awmFZObl+8UzXQcnU7RJBhaBWqG7CkjDXXn7lv5Xk4ON/UKmJ/TKVCIRhLEbzR/wy5XU8hr1/Ifu3MSVr2My9T5/zIA3mMxQblIH0HT0Alj3z1POSX9kpehO3QhQ8W7SmthKsOxIwFRQwlJAb3YTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714383543; c=relaxed/simple;
	bh=+QHuu6tcrTd2miYwphgGCGGwqwJ2bGdzLGGe1AU7gUk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=ZxTkPt3Q+hLjeF9fQAkosfJ6/OZmrgQ5+Rlx+3OvadAZegN/GuZGY8T6rxQGRKWVIZWaBh4WDD4PmYaAlwTRBaDRUdRDxJu59Cy6sh33seGQvoL5dYB0BAYMBRn9jaq4azeVaFhqTkt0g5euiD3FLA99erGaQxrdVUwl8BANpdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QANXdDR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QANXdDR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA9FC4AF17;
	Mon, 29 Apr 2024 09:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714383542;
	bh=+QHuu6tcrTd2miYwphgGCGGwqwJ2bGdzLGGe1AU7gUk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=QANXdDR9BkIu/RMCRVPiPQ3BYjZqeCdjqma7ryhs1RkcxztLfUDLpEXvz8zRdYqZ9
	 2YUUXh7xUWhthwCdGjSmXLIQzBwSzAI4ZDkM3CJE06RVD+OKOH+0DmIif/ydmCBxCq
	 gC/z8/cRNBr/gagG+aOVRCJ1ZXn/hxjEVRBSz+lLFc6MW9gf1vEVJhk/6RREnOr9ad
	 vzWw65C4fMgWdWSAt9msRszNtucWac7YyaafArPtMFwcz/KyKPDlGsO72NjGZpTyWy
	 sE8x7SQYOcCythGim5Du2efG6mU9pNzimjbZPA9vynbSEVpMev6QlfZip8HEN3oZ9R
	 C/D4LLSTd16IQ==
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-2-hch@lst.de>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove support for tools and kernels with v5
 support
Date: Mon, 29 Apr 2024 15:04:51 +0530
In-reply-to: <20240408133243.694134-2-hch@lst.de>
Message-ID: <871q6oqzik.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Apr 08, 2024 at 03:32:38 PM +0200, Christoph Hellwig wrote:
> v5 file systems have been the default for more than 10 years.  Drop
> support for non-v5 enabled kernels and xfsprogs.
>

Hi,

This patch is causing xfs/077 to fail as shown below,

# ./check xfs/077
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 xfs-crc 6.9.0-rc4+ #2 SMP PREEMPT_DYNAMIC Mon Apr 29 08:08:05 GMT 2024
MKFS_OPTIONS  -- -f -f -m crc=1,reflink=0,rmapbt=0, -i sparse=0 /dev/loop6
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota -o context=system_u:object_r:root_t:s0 /dev/loop6 /media/scratch

xfs/077 9s ... [not run] Kernel doesn't support meta_uuid feature
Ran: xfs/077
Not run: xfs/077
Passed all 1 tests

The corresponding configuration file used had the following,

  export TEST_DEV=/dev/loop5
  export TEST_DIR=/media/test
  export SCRATCH_DEV=/dev/loop6
  export SCRATCH_MNT=/media/scratch
  
  MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0'
  MOUNT_OPTIONS='-o usrquota,grpquota,prjquota'

-- 
Chandan
