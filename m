Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75002F4A16
	for <linux-xfs@vger.kernel.org>; Tue, 23 Dec 2025 05:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468241; cv=none; b=hy5wDPI9tCOoVD/6zvaEDN2KCEByW9w0aoAe2jXgQjIKTxitf2Vi9hRxHYyJyw0ZeB5zwPJaxusgrrtByzkAYI53Mh+T6mBUH/L643CsvbGLigV+w8oOlm5IimskpOJxyLijQN+oF2Z2+EEdMNEIy4NsE9Tq0dgw1w1mML7rd+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468241; c=relaxed/simple;
	bh=PhRs88mwlwkazk+ENj6MoiJDiZn71PTbJFD0EWthhgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xb8DxNtfQCYK9La2Kr4uySkkditFYc2nLVFojK7c6y651YdVyuUs8C89ZYD5eTEj7Yegvs5wGVEJ6IHWbpWvbkSprLOkWTFpoYz4CZgxxWmwqFZFLx7GnQXfM3kojOHf8yPqBGrU7GsrPOcXuKE7IAiHStdef4rVQ6pnoacrlTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1L+FowU; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1L+FowU"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29f30233d8aso57588845ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Dec 2025 21:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468238; x=1767073038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A82QF1EkZtulULncIKG5BayS1YlCBJFC1tpTXCRjsWA=;
        b=m1L+FowUPIMlYK4jS0rqd66lJOxSEu9UNgALQ5BaPsZY0mYIff/6weYhiZEE+MrrkM
         9aobe9ahzY2NcVvdmuxqVWtMOkmapJ04qlH+b0btXifJRKnEEtPaUiqLsELDhj6jt70w
         EK7sGlcQ5d76EwzvypNKWSgDYHmPE+8BHcUbIBj4EI4NxbY3KKCwI4ZDp1KQgpy98Bs5
         C6GPDqRf9SXQuuaRHvzF4K3LE21rBYkM/shcj4phJZQDM3tLR9Z+daG+i6MPaX8M21Le
         aEgz9SUcfIi+tbtgXj18ewhgT+GqS2CX4Nhkk1K9SsmOF/RYGt1NhIV1GMZhSPb1cXVy
         zIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468238; x=1767073038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A82QF1EkZtulULncIKG5BayS1YlCBJFC1tpTXCRjsWA=;
        b=O0R7CYfQiKLlgbkx0fBFQzck6xulHY8vxCO52hL0SEGnhi0YSaRJyY2acgL9Cz7EZ9
         hy0Iz4scypvs7DC2dmrNVHs4f5fqGx+c9ZLuoxDUtD0isvt6R8VxMDcmwLtbI1ouE694
         Y/1xxEiuDJby65UGy9IdyEtPrWo8yz0lBYr18XYbuMLmDdx4Jld2iMBfuUNNIjHEn/wS
         Kkr5mTgsrEtOPYrwdZzjBQAYhMnlnlHKinS7nOB/nYzF42zMWAo+yNXxQCOQ7VN94tPf
         ttR45auo5fRymTNHingItqiiHM452MzdZWCKujYTCYy3/IZtvwVw8Hl2uV7WHaKMo8VX
         GeXw==
X-Forwarded-Encrypted: i=1; AJvYcCVru5UzaJRdrw/ISrPfkbv1fVIbEMeCDan5Ln7igXc8iPub/CNiDO5/Q72rciKsx84mt6XHLtW2gL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk1PfQe228FYwwNTg1NjSmIllsPnvZwXqyy4kXYbzqXIb028bm
	n/Lg9S/ce4PH+bimU43roEkMPlqZ/VYo09tfzwFLxV94VS8n2DXqPHYi
X-Gm-Gg: AY/fxX6TY0I5XgJ6v7fWAPab5L0PonprRn+BKZCQcMx02Ilgjl8imYYaoqKs8YjnXku
	WeEv9iACZh+JaUQifdAvSfabrTqOq5eyAwTUm8Tw5YD3mQ1stSZvSErkC3PSpnn0MYKpBPY4pDB
	mDPdrbafp8dJPpIdCbh58mwJiviK/TRQopvCjYQ/Ikbyk3wTkbess8pMaF7we+pSEBcymLb896P
	ftLWCkoFaGPOxy9wk8C1hxrrbjQXDB5Jxj6DgoDbMJ7BiT/i3caoNlJ9rFRMzlFM8a9GRHLaWW+
	fjdblM+0ozUrhiJL7Iy1Z+6DC+1NRA9ej6CYbugUy14gZ8MUsbHLby+pBeTq49z1SxlOKJ+JBa+
	LM/UXOCna6Bwizh8x78MZeuj1t1vOYKOQNPMT4nuHD0vuqybJUbuFn75M7hVMPYDclJQ34RRoSm
	CH+ovyAYDok5hDGMVWWy8xEPIDAMW9hqeUOlGiF4fTKfEPss+3NhIeR76BoCyKPbv09zoOn4wci
	oY=
X-Google-Smtp-Source: AGHT+IFuAa1bEi9iXQ/fVsFOwY92P7NTqag0Itb/bLEcgCW/+Bj05+w6CIPRTwzaf559s5BnxudUFg==
X-Received: by 2002:a05:7022:1e01:b0:11a:5ee1:fd8a with SMTP id a92af1059eb24-121722ab372mr13830811c88.13.1766468237569;
        Mon, 22 Dec 2025 21:37:17 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfd95sm52514131c88.1.2025.12.22.21.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:37:17 -0800 (PST)
Message-ID: <5789c903-d3f6-4c41-b342-8d29387688e5@gmail.com>
Date: Mon, 22 Dec 2025 21:37:16 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] fs: add a ->sync_lazytime method
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
 <20251223003756.409543-8-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Allow the file system to explicitly implement lazytime syncing instead
> of pigging back on generic inode dirtying.  This allows to simplify
> the XFS implementation and prepares for non-blocking lazytime timestamp
> updates.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

