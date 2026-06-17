Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EFB307AC7;
	Wed, 17 Jun 2026 03:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781666231; cv=none; b=K66pB/cevjDKi8GpZp3cZHZ24k51O9a8G4xjgYK1toFufwhxlbl8y7VhrKSITuBIFqn7e9/reXbqxQeoIj2hn9oTiCrIxepHMCCfiZvZjxKiLV9hMDRW84xshANVFzl9ic4cuEwK/zp6g9lB6oJykFsjNRSQoewUo8RnOdRu21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781666231; c=relaxed/simple;
	bh=Ct7iMO6gFYe7eq223fdb1zYPiMkE8rMXINFouPmSLdk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VLgKc3xOkFgmu+b1HgN7QLO1Gtyj5Hoxe3jATQ2XG54cYHOcwcTKP87dqZ5oLA3MPERjwf0+9V65JeYuJy+DgsOt1GvXz0Y6on5QkP/S9V/XYaz5pLvMctAEfnwfsC6z86bt61BSJ/SiSfGfYs20NzhXPyb2pYfYHbYvv534w4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DALtP9L0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DALtP9L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE99A1F000E9;
	Wed, 17 Jun 2026 03:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781666230;
	bh=/XxQiTXNtmMZZ+42Z8EigCzrFqlmyJmwNpk/XdekBPQ=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=DALtP9L0p8+aUXxiIcMFKZv2rjiLUWzBIvBPlQEsPhx+JB6U1kt16NZbokcqsY6Ku
	 kI0vvEqBJu0k2wAT8WwWo1kkS8BIcegPyV9JNf+yOim12kDqg6o5KlfY0eg5FyQDFu
	 Y65s3EdSdcAc2iswoIOtP49uLt85K27I4qn9o3fG//A8IGVY8ZyIIArRb9SceLiFzY
	 5OdNg7da6E6ucmkp1Ws/jRfj6m+QU+aWlxGuOM56R003iYlM4ie9Rerf4Ct9HvTBk1
	 0LcQlYaH8Uvwn9oIJlWOkqc/KXYGLksTwj0AqseE7mhVF1WKH9rQ96EXUltheg0iEP
	 jSAU4Oa1Yqkog==
Message-ID: <77870acc-63a9-4408-a45c-2ec634ebf593@kernel.org>
Date: Wed, 17 Jun 2026 11:17:04 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 15/18] f2fs: open via dedicated fs bdev helpers
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-15-7df6b864028e@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-15-7df6b864028e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/26 22:08, Christian Brauner wrote:
> Route the extra device opens of a multi-device f2fs through
> fs_bdev_file_open_by_path() so each device is registered against the
> superblock, and convert the matching release in destroy_device_list()
> to fs_bdev_file_release(). The first device aliases the main bdev file
> opened by setup_bdev_super() and is already registered through it.
> 
> f2fs opened its extra devices without holder ops, so a freeze, sync, or
> removal of one of them was never propagated to the superblock.
> Registering them wires those events up: every device now freezes,
> thaws, syncs, and shuts down the filesystem like the main device does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,
