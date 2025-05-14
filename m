Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C124C6C;
	Wed, 14 May 2025 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747243845; cv=none; b=ZyyGAC0WRo/IcF1ZjTcsaY28Nyn51dm/1deyDRw2ia5aisrSkcLsH4d8HcnG4tjRzXgkYaVeecAvq9cn5OTsOGa0moJG/71y1kh62UpPYsKXQKGkss/knwF9lH6dNyZK5agDneICHum6Rf1CQwZcXnCGxOVv6KqX6faVPNJMr28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747243845; c=relaxed/simple;
	bh=hC229h01NjG4tzMc+UJvdaO4H9bxCIs8sjaXu1XFmBQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TDRcSf77tsG0WBUB/3CdMdmKBuIb+Sc5tm+9fAxvX/nlp3CNLy9KQOFAKWr5U1srkLYy6g6ddQ2Gl+bTyc1UKGFp6L5iB3Fjha7u3LfZCbNXWfHiGTK6yT5qS0p+B+wQBpiW4c/bmTP4Af2coXgwzfn2DB10lPIz3ZUqSrmfnCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/r9sY8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/r9sY8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66126C4CEED;
	Wed, 14 May 2025 17:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747243843;
	bh=hC229h01NjG4tzMc+UJvdaO4H9bxCIs8sjaXu1XFmBQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=j/r9sY8Nl4gdAWyZxEdYNL9e8EhvovdzEa+v3R4mGjDIIQdApGUvXPZZ+5nenIrWN
	 1ABqDrsVmRdB0beNPJdfy6b4EHIaD6vdw5IAZw1hAXJVRre5ozkryVOHl0skcY9+YX
	 crZOW663wapGoWojnhnMr+Wkovj0eDtu+KDVPRfT4z/fOl6UIQDMObYY4QkolLTFA1
	 nJg0zhkeN1DjcprfzxwOrla57miWHQHHln1MvTPJqZtBAtI5KNPPbQc2Mis2+THjIX
	 wLCKArDmIjkGlQ64nuoDDKNZLUAMiPaXtOhs83w8iFzs1vshsDkU/9fyqUlMVuDjly
	 uRTG7DrOpkUyw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20250514104937.15380-1-hans.holmberg@wdc.com>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH 0/2] Add mru cache for inode to zone allocation mapping
Message-Id: <174724384212.752716.9754697485095664382.b4-ty@kernel.org>
Date: Wed, 14 May 2025 19:30:42 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 14 May 2025 10:50:36 +0000, Hans Holmberg wrote:
> These patches cleans up the xfs mru code a bit and adds a cache for
> keeping track of which zone an inode allocated data to last. Placing
> file data in the same zone helps reduce garbage collection overhead,
> and with this patch we add support per-file co-location for random
> writes.
> 
> While I was initially concerned by adding overhead to the allocation
> path, the cache actually reduces it as as we avoid going through the
> zone allocation algorithm for every random write.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: free the item in xfs_mru_cache_insert on failure
      commit: 70b95cb86513d7f6d084ddc8e961a1cab9022e14
[2/2] xfs: add inode to zone caching for data placement
      commit: f3e2e53823b98d55da46ea72d32ac18bd7709c33

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

