Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996C2379C28;
	Tue, 12 May 2026 07:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778571372; cv=none; b=HdNrbMRJcX5c2Xc8BmQ+FtLtyF9DBQZ2Fs24nOBs1KdXqx9X6uEvp7VFzEe5oHy+6thQva9KO/Dk4NQET0qgJstiV2pvWSvIFrP20qdlv2wzcZKdnMcC9H5x2ZNHZ7LkcVOEQLBuzbW/AvUCI7yOIvsNttcWNpbvdvUzmfM82GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778571372; c=relaxed/simple;
	bh=xfvW1wpEEpdnJkpRrdMoCWaP4d2q5LDk8OL7iCWt7D8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W1vqb8k3cN5ZmH3rx8nG4iRbcH7R8q41Q6xYYR89rDj7TEjXhpjjFBMzOq+kLEhDy5iQDHEmebdjCFd4A8MvgWmghujg9/GuJLzg9upmbYDDjSWI8kPnsZ13/AfeutC0RIYRd+kjSxzRU/nmBVE+ITrotx7CT5PEnvzMzymjzsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwiA25kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwiA25kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB31C2BCB0;
	Tue, 12 May 2026 07:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571372;
	bh=xfvW1wpEEpdnJkpRrdMoCWaP4d2q5LDk8OL7iCWt7D8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DwiA25kbq/Td3a9MvR3WH58od1Vae6OW7xTi9Au6t+Zxak+ySYwcyXatBRk/nSr+C
	 XiF1aj5t8J/zauFcxSSUJ4UMlZliBxyUBhEOn4t4A0EasYiB9DFsanXEeNirLMMncf
	 /tYXyyBXROFd6YoiJbNa/pMDtPmAKbffUNntnCRP6f59o/WOMTGj5H/hCXhkFoD2s2
	 Gw32M5q4A/mv9h6b32INXyOm2qVf1in/c/G3Mjf1sRDBup+Qe7hjxeBcAsBOS1xK9T
	 QuVhHaZJQauyufFxTordqNNUGfqZO/Is1q930JMRcuGAk8Ge+3gpSB7gtvX7VpFoci
	 iJpVyB+/LUR3Q==
Message-ID: <5eb5cfd6-5062-40b7-ac4f-ef8f13e0a145@kernel.org>
Date: Tue, 12 May 2026 16:36:06 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/12] swap: add a swap_activate_fs_ops helper
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
 <20260512053625.2950900-11-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 14:35, Christoph Hellwig wrote:
> Add a helper abstracting away the low-level details of enabling
> fs_ops-based swapping.  This prepares for taking swap_info_struct
> private.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
