Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD18288C3D
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115485; cv=none; b=P4vWWPPiGRONFps+GupWTNFB0IMQmYonREji9KAexmvcENtvJVHetAplzIFQZViVZ3I1ZdUeupEBLrQHqDkU2dLl0+jjgcuDCLjk9ifJ8yHHVxS/3I6XCCJf/z5LH2mHln6/yE10LBtE3CWW7Qpy7UR6N1ZyFsdIeisjALAKQ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115485; c=relaxed/simple;
	bh=u1htIQ+cBGbRbD9P6U7xix0lnFYW5IXNgGXzrDz+aWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fPA0MIrIz0h0wRnRwN275+05W7YhqIwNrv2eDMR6TyvVPTqh4C1Mk94RWE7C0Xf7h+beOeyrTz8uMZLNxYb0+3iLR1SDAz/QeqqHJ2nhXSS52L3tvdtx9WDzSSrm8F0UyVW12HFBTQ146vXcplogLtBqQPd3BGONURGHFWk8VnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fRtytCeZ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fRtytCeZ"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-835399c11e0so997068b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 07:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779115483; x=1779720283; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5QC+PoU+YwXsRW92BuD7PelfR56JvKbxUHG8raaMFfs=;
        b=fRtytCeZJc3KHI8ohi8X0/fY1f4yrucjpV8tLF7hueQbc7DcIlFk8pXKPDTbwV3e/Y
         ON1zw0N/cmgme+DlpRm8MKUWkg3dJRt0qcHjnrh6F5x2KLVtxymcPzqGHfKrHoDlOCR1
         3UAK24Hm7H2IUeU67cAYZLz25BFK9eReckj+cTijftv2lcsaDQYeekLzhjVd/o64gZlH
         GCfaZOwEncJjd1JSZsnzFJ9Ee7OiGPuFz+MaqCXQhLp4CPpJypHK+ttGMzmqwmKIdN4C
         cVRStWKwlyV+AylL3vNd6cCSqja5EGGhhVykEQg3mrNB2pAidjRq1fWpjaiDmi2xzmhj
         uOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115483; x=1779720283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5QC+PoU+YwXsRW92BuD7PelfR56JvKbxUHG8raaMFfs=;
        b=R/+WkY2mhQEIP3DjtE274ndfSMzXyuZlAGi8WsBQWYjqtd/h31s30Ysa3wP4+LEPQv
         Xr2qHn2b85wrXVvFw9Pa3YhWifr41areTxYKqeRcejE4n5KD8uZNLEBdF8t5TiLwTFt7
         FrGco0ibFSgBeq/UKr6FxgPUBx2nYJ4q8FCGJdOw2IaJMw6QwShgNfFOVk0f9BegcliP
         Kxnwx82r+NKsTQQ5mTjSELptAg9ruD4DEFYlRaYS/lrTkRMpOVExp3aWDe3fBqKTmjvD
         63hl4wLinjz9o0rY+8+fqDgzMAK25hhUWxtyMpb17vc3iM80O0fBK6ILyJUisNXYNen9
         3EjQ==
X-Forwarded-Encrypted: i=1; AFNElJ+VJshCHWyiJ0tZ5NZH1jAo8Ay31TAN19/zM0V2V3h7IBioMSKtoaXWcfqSu2U63DBepX2v3/E/Wj8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3Xso3y4tMcdzZN7jm7C2YHSEiUr1GeMMvJ7LMxQHeiU5Dk1yG
	jjq8NjiilBnm/AaZA5SHzwxPvJzimqiN7yWR4MCIH0GE6ZLpuR697dYz
X-Gm-Gg: Acq92OHeMFfJeYZGM2CZFMn5FzTO/ujdv0ZyeelPmmpmP8UvICmHMDf8duQxhFWtsv5
	sUTWxNHJ7VYj7UOBOyJV3w+US2gM8gDQrgujl6iFXYyYACzKV/FnPtxclM1YJ0yRFwdsbTJY4wz
	/HAwfy/lqAAvP8Qa7AMxp+8o4Fj3A7wPx43zotpneltT2D2v/ugcm/IAlOo7E1BkQqevxxxdSQ4
	CWgtH4h8wgzU6AFmQR+TN5UzDiSovkCCDoLI8fP2ZnzuerHGSTboF1/MDDI9c5GQJwKSKa4ie11
	B0v9iSz7KUWh3wzIeaXubDUHuDr/Nc8PJxIxpxNGrCFYjz+OtnOqinuqetClRJGnhFr/eI8+Xqn
	nhWJDT1PxFdETThw0BOwukYBP4fp2YLI8SLGABwLM7ZRDRcSSiCv6CSddx3P+AKZBaggVv4KH6g
	SHa6YrJyZ5jLquZW27Ftw0uEkZN1Q=
X-Received: by 2002:a05:6a00:2992:b0:82c:e692:1f91 with SMTP id d2e1a72fcca58-83f33df6ca2mr16284317b3a.39.1779115483338;
        Mon, 18 May 2026 07:44:43 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c5b4bfsm15394428b3a.28.2026.05.18.07.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:44:43 -0700 (PDT)
Message-ID: <82a93174-6897-46af-8602-d7ac9d2d9dc3@gmail.com>
Date: Mon, 18 May 2026 22:44:39 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] fstests: btrfs: test UUID consistency for clones
 with metadata_uuid
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
 djwong@kernel.org
References: <cover.1777357320.git.asj@kernel.org>
 <d079b3f7cce446b0c5bc0762226957b960c7a3ac.1777357321.git.asj@kernel.org>
 <agK9MC0ufkTJj-zu@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <agK9MC0ufkTJj-zu@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/26 13:40, Christoph Hellwig wrote:
> On Tue, Apr 28, 2026 at 02:42:59PM +0800, Anand Jain wrote:
>> Btrfs uses the metadata_uuid superblock feature to change the on-disk UUID
>> without rewriting every block header. This patch adds a sanity check to
>> ensure UUID consistency when a filesystem with metadata_uuid enabled is
>> cloned.
> 
> xfs does the same.
> 
> Can we abstract out the uuid change and generalize the test?

Sure. let me try.

Thanks.
