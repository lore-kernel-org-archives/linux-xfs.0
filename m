Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDDF33A9C4;
	Wed, 10 Jun 2026 05:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781069948; cv=none; b=O5A3iXojLhooR93QPVdyFmRKuViRZvuy6BK863DwQQyT5N2m2r8AjrnKH7eHkh6MnQoKobO705ijPncObGX+fFz4TzycOUY/miBWVjg11rpk9RYW25DHdA/ew9Si6h7REWS9OkUqCF/x/p5U+ljrWscMuk9RvoSK7ESz6td5aJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781069948; c=relaxed/simple;
	bh=FxJZMrpbpjDPmZq2N3oKJy0qLr8tN6tQsJeW4NOva3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CBq5fc01+kIPT/tNZ/QMRSP1VA9+VUy2PEz+AcB7/K8/T72fVEMKYRKge5fpW+h4tCIgLCsjB3hrqk8DR3ETV3UhSFjPjN5syeIIDg6I2IgaCXVmOemkMGtLGaGeUjtstUSsJkSGL6cX8WLGZotKip5D/YDCm/NFobtKUI3vSG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ca3mqQEd; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ca3mqQEd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781069924;
	bh=soyi8nr2xndszymYVGvgeBcBBuWJwpx+s92HErlmGcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=ca3mqQEdXdd+3Sfqrko9KvqQJpCyjYpCuTr6QZibR6Ww4ZLZgI0K0NMk1NQrz/YGt
	 Q+rzCiaYNkxiuKVBSHDeDFY0E2yTtdXX5aOCv0OvNq+1FvK70VLfTwOBiCgKcTpnUv
	 JuKg7B1JSKqIv8wHPV9o5BNvYy7pdwrEDgsrbbjk=
X-QQ-mid: zesmtpgz1t1781069918tdf1610ec
X-QQ-Originating-IP: alu0pNsEpQiVyO7cFW9g45OaBkSLaHdGsC5cJzP6h9g=
Received: from [10.10.73.104] ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 10 Jun 2026 13:38:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6715889066964191562
Message-ID: <97825BD61D843697+a068625d-955e-488f-a571-1db1782f65aa@uniontech.com>
Date: Wed, 10 Jun 2026 13:38:36 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] xfs: clean up attr intent recovery error paths
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-3-gaoyingjie@uniontech.com>
 <20260610051244.GG6078@frogsfrogsfrogs>
From: Yingjie Gao <gaoyingjie@uniontech.com>
Reply-To: 20260610051244.GG6078@frogsfrogsfrogs
In-Reply-To: <20260610051244.GG6078@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: Nlna3a5R+peuRAR7wJKPrf4XzvC+M5L/mMSLWUKcZjpMsGhlCGL88DX1
	iGezdFsChT16JarjBGUVzoGJicRXK7wwihmBxtynI7gSoduu2Q41ZlZP0GGC3/Fo1hcv0Yb
	I5TmbSVtGizFfzNlLk8kref5IEUzs+vrQk14wZH5jqyH5Gd9oH2QKJ4RVX0bXm2F+R2rKpV
	ydRtEj1y1LdMLZxsTgK0/Is0DReHi+qI0zFz0da4UqoxdX5UxE5kW48VabQXvilKotEJTBz
	hRxxPizlwmMVHIyVCcZK26s0+6iTW31g7YHz2l1JeKaXT4pRySN55hmI327ufmPTzAIXIVD
	a3g5g/7MHNvf0xF/l6EsUG7eGtN+ae8lT8XlKfzaE4TkPD/3Rv0iVczP7z19+ukeHjjwySj
	u9WXktK3r25k3mWjIF9p4Lii4V2prCOzp57PNchJEHhOnZ+KqZ1hsAIp37df/S7FZ9s0sLN
	nAtOUX/tET1oQWG7fhHTISlougzBPLvayTQ/kAdSe+oMTruur73n0LH6t6uOYomJGSUrPwc
	V4zbNJ9MBn9SBtFQwUuHYtjjYQ9sngc8STueIq049yAOBCVcr//ygpnzMpaNxs6+RInBpwO
	u1iGCj6aOu2k6zwWVlTNMfxQMkz/0uXBH6HVUdLCGxahfz7rry2uz12nq48z11aRPide4iz
	Ve/dqaxTnTh04iKf6LhNoTdDM9deVmAq/HsSZTNyjgvoECUhslmndlNylBxnSaVdu95igPT
	jvXKL/oOBig/IN2oJBywK849kGGScWCTCHPyKEDz971cPHL4NmSaBXYI+1mzrkj8knCg7im
	Oxmp/gfYtzI5LEqlSlEfFtt/D8I9hY3JbgNsDZkVJgjcA69i6BY2it0+jqcPMCBv3fZQp7Y
	Btg3UBsG0w7izFqsR1Qy8reAwiklsyHNIAFE5oGF0lwfQHnlbXjenpHz6RaGQdZesQ5xRWF
	8/1hVABwzCLrOr7h/xSRxOZsIar++FBN486557dSK+iCYZATX868cSbFbfo3XtnOj3FYlaX
	a3Tur+ov3V6lZDm3JYiAfc85usm7ecJ2cIkHRSxg==
X-QQ-XMRINFO: NyFYKkN4Ny6FHWiufteqgc1E6argzzyh1Q==
X-QQ-RECHKSPAM: 0

在 2026/6/10 13:12, Darrick J. Wong 写道:
> On Wed, Jun 10, 2026 at 10:20:28AM +0800, Yingjie Gao wrote:
>> xfs_attr_recover_work() still uses a backward goto from out_cancel to
>> out_unlock.
> 
> What's so bad about backwards gotos?
> 
> --D
> 
There is nothing wrong with backward gotos. They are perfectly clear
and correct as-is. My only thought was that since the bmap and exchmaps
recovery helpers next door both use the linear fallthrough style, it
might be nice to align this function for consistency. That said, I do
not feel strongly about it -- if you would prefer to leave the backward
goto in place, I am happy to drop patch 2 and proceed with just patch
1.

Either way, thank you for taking the time to review this.

Best regards,
Yingjie
```
>> Restructure the cleanup labels into the same linear fallthrough style
>> used by the neighboring bmap and exchmaps recovery helpers.  Initialize
>> the local error variable to zero as those helpers do as well, which
>> makes the shared return path easier to follow.
>>
>> No functional change intended.
>>
>> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
>> ---
>>  fs/xfs/xfs_attr_item.c | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 841838bc1d0f..f8aa9dd80bb9 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -739,7 +739,7 @@ xfs_attr_recover_work(
>>  	struct xfs_trans_res		resv;
>>  	struct xfs_attri_log_format	*attrp;
>>  	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
>> -	int				error;
>> +	int				error = 0;
>>  	unsigned int			total = 0;
>>  
>>  	/*
>> @@ -789,14 +789,20 @@ xfs_attr_recover_work(
>>  		goto out_cancel;
>>  
>>  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
>> +	if (error)
>> +		goto out_unlock;
>> +
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_irele(ip);
>> +	return 0;
>> +
>> +out_cancel:
>> +	xfs_trans_cancel(tp);
>>  out_unlock:
>>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>>  out_rele:
>>  	xfs_irele(ip);
>>  	return error;
>> -out_cancel:
>> -	xfs_trans_cancel(tp);
>> -	goto out_unlock;
>>  }
>>  
>>  /* Re-log an intent item to push the log tail forward. */
>> -- 
>> 2.20.1
>>
>>
> 
