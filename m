Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF383672AA;
	Tue, 12 May 2026 07:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778570231; cv=none; b=cXN34lT5QMNiVO9eVo9kdgOSRLkKjH24rjAGAujp/bg+hrQw9RfE9i5uLKGAqaauEE00saQN9dN07wnnV/RVK/Ef7kHLZyL/8VpovuT6gZBtn2oMjF5Et7gQdpxpUysZiUIQgB6zUIODTa/eTUv2U/QO3RV9Z0A4w7vr2JZ8M04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778570231; c=relaxed/simple;
	bh=98mFo7pkXXhyp9+X2ioMv1DmZPs1w2tyrej7VobxKEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ha/i7zdGB6FtKgcJ1zBEyjKhuLsojwdfoqpcJzeNzULp9yVt2fZjfw8HlqRiex3H1WbX1Dz7mI2fv2h38oXqyg2VglYk3K2TdDCR+rZhfQLNGlLKImtCxH1MYEvUkGnMW97OgVbClA2eWVfaEmIKlMxr4N+VE+PN83IRmrVdDNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iIrRBVhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIrRBVhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB1EC2BCB0;
	Tue, 12 May 2026 07:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570230;
	bh=98mFo7pkXXhyp9+X2ioMv1DmZPs1w2tyrej7VobxKEk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iIrRBVhMsfcFd8c2S3m3a8T0kcFhIOtgvw+B1wc4Z+F9AGHqa2Q4wJLfDihSwuvKA
	 9EHcoUhMUamvE0OG5XYIdztmYfey90VXjjTFqwg3o2L6rXQ9SkypKXMe5MeYQjKCPU
	 tsvV+fBHpWRp4j166nAtQPNhdKJVpvb+lAwRMS+df1+5x7pjtjuYvfzhnW29hq2GtH
	 8o1S+/mUmIon2yUaU3SJRUwZKHtx6T6N+tJJ2t2uoihJJtq2Ym+RSFldlpzI/doRk8
	 3JxjxZkF5Srvye0Gf8WDLX0nDvfUzScbFHdd73uZu3gax6MKiiqMjCYtozBL3MMONV
	 pmRlkBWUhk5hA==
Message-ID: <44a01a39-c902-4c54-a7a6-07bc1f4d5f06@kernel.org>
Date: Tue, 12 May 2026 16:17:04 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] swap: restrict to regular files or block devices
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-5-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 14:35, Christoph Hellwig wrote:
> Various swap code assumes it runs either on a block device or on a
> regular file.  Make this restriction explicit using checks right
> after opening the file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
