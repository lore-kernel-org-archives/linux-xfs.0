Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF4833E345;
	Wed, 10 Jun 2026 01:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781056500; cv=none; b=hSXhHpoN/QCdEx6yGxSx+Y1BvJu/iJNVUinffvF5na5KYErUYlhMjMdWtvUuckf9AylAT4glyBQY9v/TXC5/nRI/sCGQjerUGDIgfbpE/M+gpifvARm8sQInC/NDvZqidCj/KncuRKpXNp7ra4lgN3O56a+81/At/pUSUriTCAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781056500; c=relaxed/simple;
	bh=4LvQd217BGdpi81N8qdbm0p0HFJ6Q4x5aGe6K8l5ihg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I1ESUP94sRdLjIJ7fq5xkfKUCP7IZcbK1VApOlGPDlW9gEZtYLF82oPz3sTeUYYh2SuncNqM8b1rr9yG4AH4zsjG3BCxFnADSMTYjy4Lhhd9ZmYSE+jssglnhJQoSHqLrfVj8/AR2UZmydHY287x1wjlbRyfYVASNtdHnPPoPEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=kiDnRcg0; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="kiDnRcg0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781056472;
	bh=F3DirVOKyUwhn5Lv6YUro5fh6nGzSl+Nj5X7Vj/68Ww=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=kiDnRcg0VtF3JJDp1ww91mkWeLcL+x2UJG3vr79RrfgA/nYyWOHHuv6A1HYD/lIzU
	 9afngTxgGCxKtLSRajcqd1oAKJFj5UhOJcmlnj8FhboelrPJJrpojxFlKawnd4yFYl
	 N/QmKCuguO4t06Rsw/GKXbHRg5u1ZYxxHYX6MMPI=
X-QQ-mid: zesmtpsz4t1781056465te676f59d
X-QQ-Originating-IP: +0Ijq6I+EaG/bkoeO+MlKyewpJjLqb7P3KEQ3efNftg=
Received: from [10.10.73.104] ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 10 Jun 2026 09:54:23 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11930092679216207127
Message-ID: <41ABF3A1A793ED1B+7c04334b-ed81-42bc-8215-c2714e852015@uniontech.com>
Date: Wed, 10 Jun 2026 09:54:23 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: fix inode ref leak in attr intent recovery
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
 <20260609111619.1866748-2-gaoyingjie@uniontech.com>
 <20260609145740.GC6078@frogsfrogsfrogs>
From: Yingjie Gao <gaoyingjie@uniontech.com>
Reply-To: 20260609145740.GC6078@frogsfrogsfrogs
In-Reply-To: <20260609145740.GC6078@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: MQPu5pFEJFN4aubmtHOK3c5n7bU62tcIKJ2+4xACHjIdODM/gp4Lzn95
	sYeuaD/NQtorvGsH79myZ4ip6IBqxxsJqVSA/92E8FCjAt9932xD7Lvkin8lNOvrF/MbNWE
	Jf1TnH/1Y+rbi/p7csII54JLwH6RiZm82YLQ08ZpnOVLqxOv4ip6vZqwHOkER5TBYCzmJyd
	I6hYh383crgJo2rRA4wP9Mei0RKb/LiUu+vVHb6f2pxivlDPQuoz88nRw6nTl/nLw3ZKgVE
	2zRaxhZ3rBjJMEwus73RiCqNSiE0LIHSOmiw1S3Ma/I1F4WXL8T8sal1VCmCy2RzmbCEJcJ
	rUV6/irqbvI3BeNBIeszWmCt1jDe7n8H21oHNZwW2wQSdPBHqHuY48fwOHpy/duc1HWo6Qk
	lfr6Wju4oGtXOtBD8itd4eod8wb/lQowMJ05CYaygxCt0w1TM7RyUi71tsoqlV6NL+5n3sr
	Kbftsa8IGSCqOu8st6fsITw9EsLB9VM0hHNaJshoWvtaXqH0ehVEU0k3HoBTDFcGK36xyEs
	xP+1NBg8I2kDNi3YS06zIiYeniq2k/bgayFrYpanqtkOgcaaQRYQPMrNVCAP+arJ/nkLiGU
	/KUGZEtI+VUfUZch4MUHlrZ/AmfeSdWX9l8XFamJrpNZBxWpptzTDb4GRjbn2GK2B12z0SZ
	1njqOAt0LSDLplURMg/16XB/EU8AOlqZxh71tSXZ25YYTvGGLWDogFpZaj0BZnnjXLZfFAp
	GdzjFt1NFOms6jJZALQ32e8Dfzq1z1DzAe6IF9ilTmVX+HJZbYFVNS7eIt2rdheuPqh7Qm+
	y/IG9QjlfhF4pXbYa7iJj7g8OXmqqjcw8jtZ4B6TZ/oV6wMAGlv2WTJICPw5pf7Jd1QTlsN
	PgTbTnwySHEVo8eKBTTTT8Tp3EVVs3nIPCWlQjaawSYpWGk7ROxVWO6WSRigklRFvayRQIk
	5C4Q7GoZxQMaio0ytHCgX3IKKG2Rm0PrNKQh4Ix9KKF4KzGfUjc3QE2GG99CM8nHuFvWD3t
	YmPfNqP8TiDuXv5X3sFriqSewbPs5CNiuT8vKnWMiTxRRjN+Nq
X-QQ-XMRINFO: MSVp+SPm3vtSihJ23AUW6lZVBoTKQpsVvQ==
X-QQ-RECHKSPAM: 0



在 2026/6/9 22:57, Darrick J. Wong 写道:
> On Tue, Jun 09, 2026 at 07:16:18PM +0800, Yingjie Gao wrote:
>> xfs_attri_recover_work() grabs the target inode, attaches it to the
>> reconstructed attr work item, and adds that work item to the defer
>> pending list.
>>
>> If xfs_attr_recover_work() fails to allocate the recovery transaction,
>> it returns immediately without dropping the inode reference.  The later
>> cancel path only frees the attr work item state, so the inode reference
>> leaks.
>>
>> Release the inode before returning the transaction allocation failure.
>>
>> Fixes: e70fb328d527 ("xfs: recreate work items when recovering intent items")
>> Cc: <stable@vger.kernel.org> # v6.8
>> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
>> ---
>>  fs/xfs/xfs_attr_item.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index deab14f31b38..c3d96c7a5bca 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -773,8 +773,10 @@ xfs_attr_recover_work(
>>  	}
>>  	resv = xlog_recover_resv(&resv);
>>  	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
>> -	if (error)
>> +	if (error) {
>> +		xfs_irele(ip);
> 
> Seems fine but I wonder why you don't just add an out_rele label on the
> line above the existing xfs_irele() call and make this goto there?
> 
> --D
> 
Good point, I'll update the patch and send a v2.
Thanks for the review.

-- 
Yingjie
>>  		return error;
>> +	}
>>  	args->trans = tp;
>>  
>>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> -- 
>> 2.20.1
>>
>>
> 

