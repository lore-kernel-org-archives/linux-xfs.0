Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDCC1624C6
	for <linux-xfs@vger.kernel.org>; Tue, 23 Dec 2025 05:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468155; cv=none; b=Zx9SgFv8p7kv4lZ9zcolgIo7u1lvWlULZdSRdWIHa0gCA2oIoq1sa8DrDv8qXGMClNzibfw0VeN2Wsyktbkl0uxJIOtM6KQCsR2oErseOpxVrMwH3y6bxlVGnR5imTJYby1Q23YZeiXxSckEi3IlOKFTTlb19U6KL912ekAKOZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468155; c=relaxed/simple;
	bh=g9Bt2s+UFC+DeXi/131tDLXltXct0EalOx5ApUtrNkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8EvXVQ/reXmZ7s0qaC+sTohXAUgJbSdlkwI+133PFPQ/JZmokP1I8lEvbyuqAiskMNB7yZAU7LxKjPqpJCPJ8fkly6B4N4QNXCnVRUWb1ctBU7ox7Tg0e7+i4uPnM/0HZubBq0xf5HajaUVxFnl7bFNHPkQE3FL9ezYc2PExvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxX3T1Ps; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxX3T1Ps"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-11beb0a7bd6so7845101c88.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Dec 2025 21:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468152; x=1767072952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1VDWjicrLkuqVcwGv9d1sh+ocm1fa0mGizT1YHR+Z6c=;
        b=LxX3T1PsbL7A9toWeCRP1ZiEISt/so3/Ge3jUHQW4vV4bDI+CFNh2mgvpyMRmaKHoT
         /MVJPZzIUDwB/OoYv1aOhJKvrOm2AivnEB8xW6vyl+8+1t7pR6MlWzwtRfU/GfflqC6K
         3JQu8w0MC9/CxAeX4efBrU98BIUAeM6jx8wPEXyWQR3NDflVWRIrWEIxqQR4++JYkCHY
         bFEz1B+WB9h9jFH2Xqa8kzgS5ZTgD86P5uMkVxwxMjciEze4VsRaDj13pFlXKT13kVUf
         kH4LjKRVTROQaXbg91AnL4dtGRfgA1kC1ZeJH3Do0F3CuIrtVgeWGDs/NQy0SWkny28V
         x0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468152; x=1767072952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1VDWjicrLkuqVcwGv9d1sh+ocm1fa0mGizT1YHR+Z6c=;
        b=V4YWyDHQiwf0r5l+DdeQfLzTE2m9DlFiBlzClNWW9Fv8Xs3H2FNWj475xR7DvyYfY8
         7VpjSXVvY1+mzMeqf793satzfmC6nvIuq8ER8tjAnTeu3HnNsdhaSOC3sky/hVkTpOdC
         xeaYb704m9ONEZXNQKedkuCThAg9vbw2zKrcuZ8TT+LP+SSea3YT/z9uZnQM3IA0t5zU
         AHCBVfYsWIKj87zagC8qC0Yu5ask1QP+g6FEE/MUasGpCsPU459JgeoYE7vSLpxYGM8G
         PQnk7exm2aeQGD77GoOOVXY8lmdgmF0EezMR8uncP5mb4uTfbeBb8nERCLXs6RBftzk6
         JljQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXmhUxbIxKiEVjB0KFtll4PE2CTx5ZmG8vGxQZBlD5MvzrErdcwSQN+1RfeV33QrMJFgbutpwmv/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/EDVGIGGO+n1sFSE6ACmRBTNLgKYHkpw39CIpJ7B7LOr4sa5V
	h7Nu0PUT8SQsF1NpEOhKGjs2KkhJXNAiOrNdKt55WCQpNpHWdyL0BJSA
X-Gm-Gg: AY/fxX7lDTo/eJ/i3USdAx/bSPayL5CNLPxMlEYNf0ciTpaGsxZwAbtPxY88sSv0lWQ
	gK3I7799flbC4gjlFHtBORyam3uRc+QWYfvSqZtM4FxLvUYC2tdn5OuIEDIShFcZU58UEJFpPr8
	VhAqoeGKP+C+3X9CMtkh3nzyjgyHPL889x/mQx7TjW9PXQOmC3FPzNWanp9OQrvs5MH6G/4yFZr
	kvmNIhxSgpwl1r5mrsyyMWSt5tndGt3pkZDuHhpdJGdNHpC25mt+9+P7VEp4PjVCSQwKJh3M19V
	l1CcdcGNGoWMuvgGxfqufS56IeNkUL5U4no7mgOF3MuDrGg2e7tZnGCeQaLAzzXUOi9tl4kFRa5
	IIFUR8R4cVk5grV54vr9p1iVVieOcoAAM719RTyYI4NikgjhxamSdn12SnNzkTCf4n9wahDLxXJ
	hnkLv3X+XlQZ8APG3GaUnaJQPLySFu2dz3T7V+f0jjd+EIfCyj2PoADMr7/PeTT0JB
X-Google-Smtp-Source: AGHT+IFgD3SNwd/4TCZfokt7AW5oqjEJYNTcZgO21z1zxvgYYO/3rgL7QNl7uSOUpz7Nh4qCGFV22A==
X-Received: by 2002:a05:7022:eacd:b0:11a:4ffb:984f with SMTP id a92af1059eb24-12171a85250mr15323051c88.11.1766468151780;
        Mon, 22 Dec 2025 21:35:51 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121725548b5sm54725089c88.17.2025.12.22.21.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:35:51 -0800 (PST)
Message-ID: <6f297260-3c99-4330-92ab-deeb1fc5d8f7@gmail.com>
Date: Mon, 22 Dec 2025 21:35:50 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] fs: delay the actual timestamp updates in
 inode_update_timestamps
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-5-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Perform the actual updates of the inode timestamp at the very end of
> inode_update_timestamps after finishing all checks.  This prepares for
> adding non-blocking timestamp updates where we might bail out instead of
> performing this updates if the update would block.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


