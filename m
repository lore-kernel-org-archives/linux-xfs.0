Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BE411CA9;
	Wed,  1 Jul 2026 00:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782866508; cv=none; b=E6uibt4CFQyr5tdmHcKveLjKgO09iRMUHwaZdBdebCUeI2cJsPUDCv/F7iG5obm/205+46w14fn81YdDzS50A3LdHNbrU0ye9bTFc3Ncieet7AGSoHPRmXJtb1GwE7VB/b70D774Oc7wlvGz52ir/RYUYE1ZxOucbYVp6ixHE/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782866508; c=relaxed/simple;
	bh=uLLfHH94Kw7uw8PHzehhgdyfxCo/0xvHp+AIKy+jiEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pFYK9BGsMZyJPISt+t3OZNmKbNJvQy1L4H3fv3HQnvPPsgP5PunKpCQsdajpOTM2OL1j7qRjy8SknbCYMcCFdJBEqzoHjHvAbYBfBivqMYa+mp5A08jN10gdHa8x/2mt0lB4nJatIp1YgwVdElVAheJ79HaSDjt2PqATrRBUmCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bli6/3/x; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bli6/3/x"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782866498; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7SebsUrP572pH+7YRkYMc1j6oC+t3eFqawA4JMbNhLY=;
	b=bli6/3/xd05xu2wBcmCegdUBRwubNFCnA8ysbvaqKcZHtUCK/XPIZgtyhgRP0ZT8R35xKltkr0eh3FIJL/JgKz2jax8RPaHvSM6+l2mdwIyOsF4LHinurIFO3H52ev2zaGJFUsFhxLKrpWAlojqaXNgoTFVtpLXhDMTpSNIw47A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X61.QAe_1782866494;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X61.QAe_1782866494 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Jul 2026 08:41:37 +0800
Message-ID: <ea10d591-6372-4a14-a613-2c1e921755aa@linux.alibaba.com>
Date: Wed, 1 Jul 2026 08:41:32 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/18] erofs: convert iomap ops to ->iomap_next()
To: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org, hch@lst.de
Cc: djwong@kernel.org, willy@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>,
 "open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-8-joannelkoong@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260701000949.1666714-8-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/1 08:09, Joanne Koong wrote:
> Convert erofs iomap_ops to the new ->iomap_next() callback. This uses the
> iomap_process() helper, which finishes the previous mapping if needed
> and produces the next one. No functional changes are intended.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
