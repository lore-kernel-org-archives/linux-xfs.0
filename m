Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0469E330667;
	Fri, 23 Jan 2026 08:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158634; cv=none; b=BaSrWAp9MbhQ0g6nviHn+uLCbA89YVeJdjKpC+IqcKfYVa12gnW30KPZbNAwQEr/2EGvpM4tcR0z+lM4ZpMljHukLUCUNB+612vz8pL6MO9+IcPAzOfGKMIdfRdfRMlIoFUmx1DOyh1o20PuALJ3HY/8v3jLfQo7t8iooCV+By8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158634; c=relaxed/simple;
	bh=zrUklNG1Z/cl9A9c1qAf759B3mYKxKkGgy3CmXuxI0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XcrQYSmV1HJhY5uuWP424G+/HroC1/hXdCkn9RMIYEZf/x5pDBPQB+KY7I/ySSWmVUvPwEVlqabrvz5wpnoPz7FS1kX9HRDZOt1aHjMAHE9PqcSpXUmSYvBUABMxyTzQJmmooqg+bUWyQV+6xo1cEHBljP1zTnhPvGtCDCyuZyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6gdGT2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6gdGT2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8AEC19422;
	Fri, 23 Jan 2026 08:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158633;
	bh=zrUklNG1Z/cl9A9c1qAf759B3mYKxKkGgy3CmXuxI0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I6gdGT2Mw48yii0NH05Sw3qmorhHRKRnT4Ik/5I7Qc5yjz4I67HrepYSHMuIDJfL1
	 PBDL35qfB1NYVX2bO3+rKFVuWqCVyC4C7biJi96ahYP9h3mMDL/gknOWlQHTpZQjqS
	 tmPVZ0cDyqG7q76/PBbc8oVRVtf3v12W6pFpUepDQMHZ7DXDrW2g1sPRGj6K4Yg6K4
	 +wyyKn0JN+7nBrDt04+7if5tsV3PksboorXeZtZSNvYBrhGO/oB69ygodVXrrq7OIc
	 Ddp/1ZG0gpRTJHAs4wX++Ca7Ep7PT52nSc0FoZTUux5HPEAVTfyUt+bOCtCPiwdv+q
	 +baPLjwVOLUJw==
Message-ID: <001c5810-015e-45a0-b507-0f8718dba643@kernel.org>
Date: Fri, 23 Jan 2026 19:57:10 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/14] iomap: split out the per-bio logic from
 iomap_dio_bio_iter
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-9-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> Factor out a separate helper that builds and submits a single bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
