Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B843334F485
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 11:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768215731; cv=none; b=ZXnxzt6pzLgjjWB/mWxUfe1BKli34fVc1QGU/FhFftHkFhVJn/4QEx2h+kLzZ91pdQFhhZvSXHQfH5VnK5IdoPWBTqOpjn2NCuJhsP6UieE5aZVzAOd8XgRzA/lcmwEQnqqrPZAWIQH+KVHs2cFRinpJOX3armfetDlcP8jvWiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768215731; c=relaxed/simple;
	bh=3jWGtHHwllRDDT1f5w9iAyvCKDuU00JKbjtlXXVa6hI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QmDKA7Ii4jerbfYylHs0Zg4fpyL+X/DoTu9qMb3jx7C5YbwfuIX5bmStFwHCKsvy6BFPWouTSSsfzf9xb34oXPODISKLHzGFSudfZGzgS5NosnQWEIPVUmf5U6GIaIR5Lv35dQbyrFMGR/CvIoWWp3tBEuI4Ez8ZIMaTIKnzvoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QqRxhyHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QqRxhyHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F172C16AAE;
	Mon, 12 Jan 2026 11:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768215731;
	bh=3jWGtHHwllRDDT1f5w9iAyvCKDuU00JKbjtlXXVa6hI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QqRxhyHVakxY8lwEa77FrEPLQmk0+tFyjPnWPSJklSFOyYnc62QJV5dTWfCcUT2R+
	 jtk9Z4Cne3Ou471vafYqe3lojtoKzTGHNAOW2SPNUNFAMTKulToMYmE1Iy4kBpamrh
	 xyw70Wur11a9y6StkOrr+d1MTLVnAuRhlLpdzhxBS+RwJ3Bl1SeIetiIWPGIFb10Xv
	 ULxse/LwB0oZsfJYiJRt5ycLEe3dPSUCtnVC1SwkAvGT4GQzqWgvu3bTQ92axkBvgz
	 JylOGhlekj3j5H2xMC/6vxf6dh4XnhtSb9dNsbj2wxD0wYE4YicP23FRwRIJ6E9kj9
	 Z7ZZIBo7ga4bg==
Message-ID: <08d54612-defc-44be-8783-57ca84e15da0@kernel.org>
Date: Mon, 12 Jan 2026 12:02:08 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: enable cached zone report v4
To: Christoph Hellwig <hch@lst.de>, Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org
References: <20260109162324.2386829-1-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260109162324.2386829-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 17:22, Christoph Hellwig wrote:
> Enable cached zone report to speed up mkfs and repair on a zoned block
> device (e.g. an SMR disk). Cached zone report support was introduced in
> the kernel with version 6.19-rc1.
> 
> Note: I've taken this series over from Damien as he's busy and it need
> it as a base for further work.

Thanks for doing this !

> 
> Changes from v3:
>  - reorder includes to not need the forward declaration in xfs_zones.h
>  - use the libfrog/ for #include statements
>  - fix the include guard in libfrog/zones.h
>  - fix up i18n string mess
>  - hide the new ioctl definition in libfrog/zones.c
>  - don't add userspace includes to libxfs/xfs_zones.h
>  - reuse the buffer for multiple report zone calls
> 
> Changes from v2:
>  - Complete rework of the series to make the zone reporting code common
>    in libfrog
>  - Added patch 1 and 2 as small cleanups/improvements.
> 
> Changes from v1:
>  - Fix erroneous handling of ioctl(BLKREPORTZONEV2) error to correctly
>    fallback to the regular ioctl(BLKREPORTZONE) if the kernel does not
>    support BLKREPORTZONEV2.
> 
> 


-- 
Damien Le Moal
Western Digital Research
