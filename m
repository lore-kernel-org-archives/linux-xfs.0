Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69FB478E50;
	Tue, 16 Jun 2026 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627768; cv=none; b=Elbpvyq1qLLQIGti/DzmYKT9iTcx4cCAQb2+HxZ1TaeHeeL4NOIz5lJGiW1v5IrdeKHKdYtwxvKCGOt9h7q4RxPCWqU2ql142MwATpG8W16CSEMNbysSHuIcQK16lfm1euiNKtiUvqdimKraK8jnv/BLdJwDhSJRvRX1/Ne1EHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627768; c=relaxed/simple;
	bh=B4jBFIdFiNtDsmQMyWWPd+1DnLb23kwsj3MeQY91MXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqqhmFdGLDlSi+6bx0TApCptVkEMLA5WAmZxzB3OyCRhJqDdkKEhEbCGvfuEKjCBAFYYBIqwKC6HpZzuASZ/uQEz0T6co41l4TbFgku94hZc6j7pwDDok4iG9tWGrPHev1XpKP1/oNs5/DW3bS4BYUQlpTM9/HsgeVL787rpQe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ewlVQ0VJ; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ewlVQ0VJ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781627751; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=B4jBFIdFiNtDsmQMyWWPd+1DnLb23kwsj3MeQY91MXI=;
	b=ewlVQ0VJdl+Fpp2fMC+W/NUu1xBr1uhTfrpAfYrk9n6RgK1AVz14eASzWwamx1z173BwE+71D4aYMDP9qSu25wylUGoScMjYWryeBaOLe1u+cCoLz11JnLGaQczY5CwocuAi/MCnPSgMJxiHvg2uYoLv04My44R/jdyAX3LT8hc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X5.qxzD_1781627749;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5.qxzD_1781627749 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Jun 2026 00:35:50 +0800
Message-ID: <8f1c032b-b951-4d0d-93fa-229248993f2c@linux.alibaba.com>
Date: Wed, 17 Jun 2026 00:35:48 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash table
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
 linux-erofs@lists.ozlabs.org
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
 <20260616123443.GA21024@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260616123443.GA21024@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/16 20:34, Christoph Hellwig wrote:

> IMHO sharing devices between superblocks is a bad idea, but that ship
> has sailed, but please keep it contained inside of erofs.

I'm not sure why it's a bad idea, for example,
the immutable layer model is already applied to layered virtual
block formats (such as qcow2) and layered fs like overlayfs.

and I think device mappers may have some similar immutable
approaches as shared layers but works in a slight different
way.

The principle is that each instance uses shared blobs in a
read-only way, and that is almost a simple and safest way
to share data among filesystem instances.

Yet I don't want to argue with that since it's pretty common
for years and I've seen no practical risk using this model.

Thanks,
Gao Xiang
