Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA57363C5E
	for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 10:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777027499; cv=none; b=PXTeE0f1PCwRF1LSSMTexvhIDDYM/x8beYxldSh4VJbA+m308uV0132jpLgIEnAE2LJJw5HnEHi7N4Xk8muSWl3XCdKaZTx2lDXMCuXfsXlTwtnH8+UfwrVYZ78fWtZdozl0iC3JaSJVrSlikXLB8WzCBqJVfDDk8rYHtyiV72s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777027499; c=relaxed/simple;
	bh=aue5GK17Nwv7TVX2jyH7Dwffm9yajeNgfLgAyrxpkss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fg1mmvPGgeXyVdz8INnXQ/p7rmIFrAKaPkwXYSfvcCDXUyYDoz5BLgoick+/5cZNBL2CT80hsvg8LZJMzQqxN+aodn93kc1LGdivI1RyhwlVepGsrsathj2nyvMCzFHBMGRiIbmflU5wviSSNJjWGiO3H3jB+O4OZHuPooMVwdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mgvxQqMW; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mgvxQqMW"
Message-ID: <7ef32f94-f6e0-4274-8e95-078d8be78fc3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777027496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4r5qaoRQ0C2q76b70PzPUZTpnQKjEqFPlRif++uBHcY=;
	b=mgvxQqMWPT+CHsCAH686lSTRPdDuYWYcu1qesC/hCrK+Pnc7/IqVDtPH2UslGrWIuNwOcb
	ea0+hq+UC7AqUPI069ZZ3wOVnsN01pFpPSwyS7qg3xIv9qg3bxSYlIPZ4M7aiGP0hKJZN4
	g+FtK7MayqCqcqXhLnXlTbA6e+XH1k8=
Date: Fri, 24 Apr 2026 12:44:51 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org,
 tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
 <aeqxFKaw1uOk1GuZ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <1pg5tdo2.ritesh.list@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <1pg5tdo2.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

> Ohk, just noticed your reply, after sending a response...
> 
> Thinking it again, I agree we should just always ftruncate it back to
> the original file_size. Because we might have changed to file size while
> testing the writethrough support.
> 
> Thanks for fixing it! This fix looks right to me.
> 
> ~# git diff
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index c9901f65..720bca83 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -2095,7 +2095,7 @@ test_writethrough_io(void)
>                 return 0;
>         }
> 
> -       if (ftruncate(fd, 0) != 0) {
> +       if (ftruncate(fd, file_size) != 0) {
>                 perror("test_writethrough_io: failed to ftruncate to 0\n");
>                 exit(132);
>         }
> 

Yes, this fixes it. I knew it was some issue with fsx itself.

--
Pankaj
