Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A48547CC91;
	Tue, 12 May 2026 07:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778570412; cv=none; b=p4V1VU4fVi7fAyUMaZiLHPGE9mdNOnI8bONJA16DtfT5jAJ6T4FSwaiIYgPgNukQArF12RAyxyej6bfZZentB03aOwFs85ob4ZG1+AlWMrcNbl/0UNtrl907KaGMstIGxPspmz+8n82EW+/Zt+DBJBUTELfubMp6BGKvG+HQmTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778570412; c=relaxed/simple;
	bh=gFxSwQ2vwNGN7Wy+a57I0BqMT4+uCuIw9JWDuf1wsoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QbbTBFszi98X66wd3atleZW2H2RmTzj/MGXS99zHvZzi4HP6NMyMgPd83S8ROem1EcTb7Ok9WDjFAhyNsuX+43QmEwlnru3y60jYHt2uMKqB3j9deW5HaYiCV+vp3RLhI+e7o4JldlQ25DMdnoMJqudonZkFzNuJVhTvlsy/uCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=soJoZRoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="soJoZRoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06282C2BCB0;
	Tue, 12 May 2026 07:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570412;
	bh=gFxSwQ2vwNGN7Wy+a57I0BqMT4+uCuIw9JWDuf1wsoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=soJoZRoMxJtn9BFF3dpQwvk0xi820TNJfptJMtJX/cP/qNW+teYamRrcMVyhtuIf2
	 iR30YL5xnlEO3jTCx2tpM77XOC5OsxBpMB1POJFpEuFKTdBQGIEvxGGPmqeJ32yTYY
	 UA2xlPqKw+9LfjJN4MQdMcexmE51BlA+EqPHlH5f+sN6l+N2Pb4HNurNsKuKugTIio
	 ole6921MHwRdIF7HBTc7tpfjCL6KBtD6BTBQ1Q6GwaBCiWuHWUGJB5v8Me5Q8cQ3NI
	 Tq43OhBP9tdm5zD08MqoxYDF0J0eeB07AIqRJJSRbCGW+bEl8POIDqcxOUAfOS/yGy
	 b9paE8zlD9+yw==
Message-ID: <f157c318-790d-4931-bcc2-7b3c95c8c2b0@kernel.org>
Date: Tue, 12 May 2026 16:20:05 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/12] swap,block: move the block device swapon code into
 block/fops.c
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
 <20260512053625.2950900-7-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 14:35, Christoph Hellwig wrote:
> Make use of the abstractions we have.  This is a preparation for
> moving more special casing down into block/.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
