Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55C8B660;
	Fri, 11 Jul 2025 08:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223604; cv=none; b=c2CcuDvq8OLmnhi4Wr0HN2B0LfkoRsf7I2qI6ncpO0ukKd9LQv5fI3yoAoGpqIRWAKz0Pczch+r1SV52W8xVG96aZtYWFpKxXBXIOjTsNXUS5sS360rwSUMUwG/zaDBsEmDVRYfnjsMamx+Jgskgw8gyTKEHJ006+3n+JbzsNrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223604; c=relaxed/simple;
	bh=zz+PKe2EsN0dWLcgsiYIFzIKc+Zya4xi9vnyYf/TK/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FiTGSbWUixOh0M8tRaNQ67pQKTj/DLHon08KIOqDQCHrsNv3p9gLjKqLm4F/wHrJy/FicBtygMdd35Wcdm1Ni3hCie4wnNqtiHmO81453mwAY5RT8N8N+MITcqik9WTwqTymZOIC5F3Z8peBKD4Ho3xjogR5pDxzDrdEhimYufY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=troOG8RC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="troOG8RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADA2C4CEED;
	Fri, 11 Jul 2025 08:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752223604;
	bh=zz+PKe2EsN0dWLcgsiYIFzIKc+Zya4xi9vnyYf/TK/w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=troOG8RClEjyGE8ygTNPlfsvcY+w+84KlZr+jaTgh/8x2kjC6+qlnol2gTDtGQdaL
	 qfr1mxxDPNkaRRrKy24Ynpx+ZNL329fgILm6pgNFTIDOnZvBiXef+oqW2XWCthZsYi
	 7zk80MrmKItxlxsMSbxPkBkUW9iUBFEqnHmVEDH7zjVhyEkF3Vkrv0mdM2u2AmJLiZ
	 NEa5FME1qmKsF3nbC8iw+ZHmoqtJVStTKYUjVxfuJ9bmF9SUezddmEkC37nkO7SxSX
	 JzDrliniDmL0lADcXEQ4VDylcCmQmQ3OqM7c0N1scPV66droDmBAbPAPef/F7jMtAs
	 r6vq6CBycSGmQ==
Message-ID: <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org>
Date: Fri, 11 Jul 2025 17:44:26 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
 nilay@linux.ibm.com, axboe@kernel.dk, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 ojaswin@linux.ibm.com, martin.petersen@oracle.com,
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250711080929.3091196-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/11/25 5:09 PM, John Garry wrote:
> This value in io_min is used to configure any atomic write limit for the
> stacked device. The idea is that the atomic write unit max is a
> power-of-2 factor of the stripe size, and the stripe size is available
> in io_min.
> 
> Using io_min causes issues, as:
> a. it may be mutated
> b. the check for io_min being set for determining if we are dealing with
> a striped device is hard to get right, as reported in [0].
> 
> This series now sets chunk_sectors limit to share stripe size.

Hmm... chunk_sectors for a zoned device is the zone size. So is this all safe
if we are dealing with a zoned block device that also supports atomic writes ?
Not that I know of any such device, but better be safe, so maybe for now do not
enable atomic write support on zoned devices ?



-- 
Damien Le Moal
Western Digital Research
