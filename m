Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683353D45ED;
	Wed, 13 May 2026 07:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778658300; cv=none; b=ARgSZwA60aJ7u7PYwYqgcoWRLN3SIrjl48wKTi99iQEPiLtlCn2gDdzbvbq21+m4+i4ereiEbzqD2LNLQtX4lXX2YVtaVd0qXEm5mmFidEsjPRh0VN/C6hBnOEw5h8GjQDFVpSY379uEm0cgazbbqsHZ9N2c4z1vUndEL1BK1r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778658300; c=relaxed/simple;
	bh=Dg2nW1p160NOCn5umFdjytzvydm/ZD4Y8VIlSf+k0CM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jtNbTVwYaPydxxyfaIk4XIcA0fEKB1KM6EiLVoANWvnwJtZL3Ln9KyBWyMH8q4cf5zyDzPI3ADh1o4g0gzb0knIgnuxum3U1QNjFL1GIt3qc4QGgZZNaOFmn7b2aRsUYcOdQGRfex/nYg9sAiM4aTuOf5G/dpB/Bp3T34QSqpuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W88QhGV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W88QhGV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B4FC2BCB7;
	Wed, 13 May 2026 07:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778658300;
	bh=Dg2nW1p160NOCn5umFdjytzvydm/ZD4Y8VIlSf+k0CM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W88QhGV5fNBgG29b6A8+2aMpfRcsRHQN/DvQSObUW7md2OERCUFlHgf1cKsHqoq2S
	 8ykZnWkud0SccegE0umMkD4j5jJ7KgzhBrzoBcb9I/I9zNm6SNrd0Urp9aI7aA2mFH
	 Ls43dph0TYLcQ7SHMgIKKiqIjYNGHdG0bRvkSKaUSVLbUqXi1S0+3eREdcpqS6vbou
	 pjHmEbKTKNOrbnUGt7tcluhtcMyTN3bE6oKaewls6oT44KMpU3eYtzejZxITRlsKNU
	 MrtDtAfOwb3/X7OZISUgYCyAwxQnZAGj2NCGbnTCksT5zjWWNFVhk+szDVycr1iBRH
	 EXReRb+kSdmJg==
Message-ID: <acd6428b-a352-4f7b-a349-b2c9e341fd87@kernel.org>
Date: Wed, 13 May 2026 16:44:53 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
To: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Christian Brauner <brauner@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-10-hch@lst.de>
 <20260512170846.GJ9555@frogsfrogsfrogs> <20260513055806.GC1236@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260513055806.GC1236@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/13/26 14:58, Christoph Hellwig wrote:
> On Tue, May 12, 2026 at 10:08:46AM -0700, Darrick J. Wong wrote:
>>> +	/* Only one bdev per swap file for now. */
>>> +	if (!sis->bdev)
>>> +		sis->bdev = bdev;
>>> +	else if (bdev != sis->bdev)
>>> +		return -EINVAL;
>>
>> Should this return error if the bdev is zoned?  AFAICT XFS and zonefs
>> already guard against this, but other fses might be more naïve.
> 
> Yes, now that the bdev is passed down to add_swap_extent we could
> consolidate the check here.

Hmmm... With zonefs, swap files can be created on top of conventional zone
files. So enforcing "no swap on zoned device" here would break that.


-- 
Damien Le Moal
Western Digital Research
