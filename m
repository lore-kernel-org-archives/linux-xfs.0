Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0F2384CF2;
	Tue, 12 May 2026 07:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778571302; cv=none; b=m75oqb+kfuuPGHMNC1Q9pEGRWgzu4WbZQGkMXTO1IBDQuRtzHJezPo6CFTDhsVT5+nhPiyEH4sTLI+30Dux8iIZVR1ClIhiXDcFFvKgP6aYODEKNlk+Uf5fjsNe0mtgILdTmU7KELFK1KueDq5nUOZq/R6oL5X/CK4f7eUUHfps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778571302; c=relaxed/simple;
	bh=s/liCqvWpwzbf+Ors2mYM2xHnFEKG2Ez9stMzBy2CUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n/cKh3sMlQSKF/qvqNqUKdxLr/7mWOiRF63CpMof0Xd33Qj7YQUnOo7sqH610173k/4UtumhXAEblcsaKd86lSjE05uGAi241GQFijECGN4ZhP7foVlR4IguquU+3mFkpvFb4le+RogxZ3jME88mNR2ZFSPUGwhjNL7PdIJaX2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLRtx/UM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLRtx/UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46713C2BCB0;
	Tue, 12 May 2026 07:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571301;
	bh=s/liCqvWpwzbf+Ors2mYM2xHnFEKG2Ez9stMzBy2CUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CLRtx/UM0efOdLrvjlbvsWzTtbQven4c5sLOwml2whwHzcCcqJMd7bCclOjdEZ20O
	 UXxIhdcs2qt054/GJeHr0t3YI+ofKCUnTiipODTRt7ADIbQc9JEeasCk+xcR9aOeew
	 Gi2vyLOb8+DJmCJSkdwtTx7cYb0d2rd57ymwPj9cTLhIyaPzAcrpNE2ILkt0jpqzId
	 HkOrmdLVr7An8cZeKIiB8TlR7lnPGvQeaV1/jiF25kcRdf1pFOXUoCx3u/XpqANN/f
	 VbTmMIKsMtE+C2cPfrNbk1D6HdbQj6D6wJTNfrXhs2YxKIj4hNpJ6iQIh+220eEt3H
	 1k5nf0s7jSIog==
Message-ID: <b2fab68d-541a-4f58-85a6-a304134cf127@kernel.org>
Date: Tue, 12 May 2026 16:34:55 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
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
 <20260512053625.2950900-10-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 14:35, Christoph Hellwig wrote:
> Only the file operation method knows what block device we'll swap
> to.  So move down setting sis->bdev and the special blockdev flag
> into ->swap_activate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One nit below. Otherwise, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> @@ -141,7 +141,6 @@ int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
>  		continue;
>  	}
>  	return 0;
> -

whiteline change.

>  bad_bmap:
>  	pr_err("swapon: swapfile has holes\n");
>  	return -EINVAL;
-- 
Damien Le Moal
Western Digital Research
