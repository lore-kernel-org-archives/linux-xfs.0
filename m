Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EC8337BBD
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 16:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765990795; cv=none; b=E8eD+bbhpEw43mOr22YuGbglR5/Mz/X9jsn2Mg2hXZJTwUYrt2AbuYiPLEThAUtfMJkc8Sr8LbDU6TVyIWlPBM/bJqf617lV8iVDt4GqKNtTm/Y7w9W6TqJlXCeYJKQo/QZg1Qy+wwIlWKbD0Go0QstUNg4cQMU3gsvdLAFGocM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765990795; c=relaxed/simple;
	bh=4nT3eL+nqqlKXmzFJdFVnTOdEBe7d+tIOLCTKsUwt94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=npF6bpHapjhDmwq5EJTJpbqvWqxDvqBvBxOSMzC6fa0kZsXoUHjTACgxt9H9vaXBJ5JwMNVtsxUjKV/JW63fkP5R4sC6B6Y5Y9whIAMFwBJO2V4Ia8canSr+0a8UhOBuQ3iykAMHzr4p21ebngjwSmiBJI+SG7GvjRGyJpPILK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FQ91WYlr; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQ91WYlr"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f102b013fso73607045ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 08:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765990793; x=1766595593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0JZV4ZTKPnvVOohyqVtnOMKthFN4WCJ75pI/pYQsXF0=;
        b=FQ91WYlrlb3ZNT2Y346nixu0QlqkDboGLvyhaNMUZ8dYVjcO+eA9CSsnPouB3awBFI
         ih/Emu3ORhfKb4Cz9185hKIKT37ySgTcqzLRxCZae46WcNukaR3PiuBY1mBY7HUSTMpz
         wJ669cQUKh5aNIyMPniNwaGCfGkX0hrb2tfRbAlP6w/YlfzWSX0vJtkxntBSTQq2btbL
         XNcLtBIvRujfs81wv2VRkZAIlaNHy5rV6yO5Kw/057FRH1rojLIoVgHNYvnmn1V7gRxh
         fZQppAAVFmtHGmhm563AhC7Wuj/cgutgNiYvdSg3B4T6j4o2pH8rJ3jSs0RJszSjcb45
         DryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765990793; x=1766595593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0JZV4ZTKPnvVOohyqVtnOMKthFN4WCJ75pI/pYQsXF0=;
        b=YzsEQwhee6PgrzMeC2Jd4f4UApbOzOBfuHLIF5DSDdgvDhfwH+nsu+lLk7qypHQNsq
         aakAIn9+p8wZAwmC/PexgBUjvyqvveRUs5L6RoGoKH9uA2V98O+O8N1h+FBvqopY9An+
         cFrVgmCPSQN7hxswcr7EE1rpbPCCFYrk36JciXAuzaDcN0thyuSWQQpT/ZAcYpl0cAwo
         zlJJUWl/BNG5lrO6WOum7a0WWw0i09WluHX5Y1v1t0TZ7/kQMdPy6StRS0vGMwxMkb1K
         7vboaM3geBnINS8y7uxBVCRxhGkvaZ1w9OoUpqRkPaD6xgxR1Sg1lgI2XYIgvpKnwR7i
         jfxA==
X-Forwarded-Encrypted: i=1; AJvYcCXSRrQbAzHHqB72e2UUiTmD/UCX3BtGF4lkVHEgDxsznLETRCw8KvMjbjgYy24JIIU33AAOU1A5ObA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLK5XqxYdr+VkElndImLBctXsxQeVpdRW/C0SNTn+h+Lp2z93f
	XQoCsjhjPSazGl/yez6NBSFl0joME9Zx8PrJCjj59IhSRoeRb8/l56Ta
X-Gm-Gg: AY/fxX7GluQdvMnRZCSqXPN3frNaCDnqHCoe8V38zITgmN4esaiJXexbrVEIZRBnTd5
	HTIF+6WA8wgo6ZwRWhAPGeiGmXsAFfGwd0Z2jC0yz70JLh0H6RuXX1+4I2+feWhIjwoz96Sg+TI
	ycXoBJ9B6TgWPyzxS3xLymGWLiD+b/RJ+1VD5C0dkEkPAVOFv+XE5xLITQ3lCf2Dj0q9xqs3E5i
	OihyVYDaZ/d8GEOZq9UNv+cjliYCFziS36Q2cLjBfcm8ry5+QO3My8BHTWk6GdCGl2WukdXEDyv
	K2MzPf/RsyexksdRfVmYRZG5NQIWna946pSptPIm8RKvB9fPpmJ43vzFCe0Cis7TzUVLxhlWXrE
	ewW6VvNIpRDte4BHXiQs2aKedJqPjsViCVa68orOA2UCZAynU4kH68bL/8LZsgaN+QAw/vO+gI0
	nI7LNfR7PjER/gHbQ=
X-Google-Smtp-Source: AGHT+IFoKMbJ9xsJocF+/SOztzH9OTtMgNQkpOw51+pBJHLXYHTp4rBAb77rmGPybXMBIEZgWFijkA==
X-Received: by 2002:a17:903:458d:b0:29f:135c:5f25 with SMTP id d9443c01a7336-29f23de670cmr175716925ad.4.1765990793498;
        Wed, 17 Dec 2025 08:59:53 -0800 (PST)
Received: from [192.168.50.70] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2ccdc62f6sm107615ad.29.2025.12.17.08.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 08:59:53 -0800 (PST)
Message-ID: <62945fac-eab8-4e42-8f3b-dfdee66a1b15@gmail.com>
Date: Thu, 18 Dec 2025 00:59:50 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] dmflakey: override SCRATCH_DEV in _init_flakey
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20251212082210.23401-1-hch@lst.de>
 <20251212082210.23401-2-hch@lst.de>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251212082210.23401-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


 > where to create the custome dm table.

typo
s/custome/custom/


>   _cleanup_flakey()
>   {
>   	# If dmsetup load fails then we need to make sure to do resume here
>   	# otherwise the umount will hang
>   	test -n "$NON_FLAKEY_LOGDEV" && $DMSETUP_PROG resume $FLAKEY_LOGNAME &> /dev/null
>   	test -n "$NON_FLAKEY_RTDEV" && $DMSETUP_PROG resume $FLAKEY_RTNAME &> /dev/null


> -	$DMSETUP_PROG resume flakey-test > /dev/null 2>&1
> +	test -n "$NON_FLAKEY_DEV" && $DMSETUP_PROG resume flakey-test > /dev/null 2>&1

flakey-test target? Appears to be a typo for $FLAKEY_NAME;
I'll send a separate patch fixing the existing bug.

The rest looks good.

Reviewed-by: Anand Jain <asj@kernel.org>

Thanks.
