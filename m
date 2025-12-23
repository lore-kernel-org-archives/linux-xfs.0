Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A34D2E228D
	for <linux-xfs@vger.kernel.org>; Tue, 23 Dec 2025 05:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468349; cv=none; b=RAIoS1czxRrVYKz4QP8QdBG+lrAEkadwIrVas7VdlAC3JT9XT/Hoc6g3GA9tONHpCplmmsv/5fO7M/hS2DQT2cJQ90vHe6uuCSu/taC/TLS7wNrm8etbzVI2B5hRVWs1k3u2itavYHMlc2vf6qZ2CxwdMiuTNF7VsRaEf0KDIZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468349; c=relaxed/simple;
	bh=4EYwI5dt6aXRXkl+FSZUrQuoyCBEuH9OaUQ78T0nqW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mq0ej06I5EbCSr+AOFj2rB3vaiAW5XRJMBgMC3BnVZU4W3jyBa2X08KsBgBNPKbS2GsYxWgv2e1QmO08monNELKkwMsKb+Ub/DZENrWAKC7IxZTA3+EKUNYzCZYrVvBGKj+hYpTZHQHQCILM7rrmd33c57xlEDUJuWADWKyy7eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AmuGU0S3; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AmuGU0S3"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a099233e8dso40146415ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Dec 2025 21:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468347; x=1767073147; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V0Oa5NOGMRC1AJFdH7RGft89mUSkkZqf9Qovy9KVtFo=;
        b=AmuGU0S3tNTq4XtJ8CPVuHsrup5GslR4U1PsfZM5q7Es9j9PRoBOtcmrNZjZY9bYX2
         UKR+5USfuLaeedQBq8VdFeWlSpdtJwj9cUx0XSPWF6iw2+/Dx0Y5UVucH/qMMErYNCo2
         DmPMJSCgLNX8OFyioDFMPSDOCAjVz+YVUY/Iz/KUSFGJ2xhlgSyingmuGzIf1Ot4VcrN
         bRMe9e6HU5DXOTn41IlUPOezYioUBfH4sOmBJ/VJV2wbgRChwx/8WJgiqq1vVmt2UJG1
         sPq57LHY2hmsktX2yrFZnu8K5GlUfYr80BrqjJruZXf92pssdcqPz8wFkvEzjVdz2E5K
         tIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468347; x=1767073147;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V0Oa5NOGMRC1AJFdH7RGft89mUSkkZqf9Qovy9KVtFo=;
        b=v8CJH/px4KDtWrk9av/w4fgwes1HFgNOPeFzozAUuU4IqEK34g924/JWEuU3Il0r7T
         oUrj1D5pmmDnaW2TXFEE/O/puOPjW+Q8c+eLd8eVU1kHNSOczn0BqlpoSYpheS74QGKi
         h50sbf/YIh83tfM07qZR9X5VPEXLYTwqIfQlI/FV5kkdXZHc/wa91Qjn6b6vlDi7tjPL
         D+a2sFiS46ulAYp7r6TdiqHpUM70ck7nQnSzpK4Hu2TnanSgJVk0qEKUwV3GoOJv+Jae
         QBzhlsAs07e9Fdfvcoab6pYE4liOg7+iGSMK2TlcHow8f2ZJJror7/4IwkI8ZYGdd+Fc
         YszA==
X-Forwarded-Encrypted: i=1; AJvYcCUC09rUKHubd23ljmnJIrIqs4qpscoZJemKVrCACWd05sDUGCF4X92RAvxMj3c9QcvpSdv2ZZisU48=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4VJZNCeWVw2Mz8sBhQfZ2DoFAfsrXNH//1sUEClRrHr9TSRYn
	eAnkRq3mhg4SVYRadjLRlsG5QhLG6UVcU85R4xbEgayAh486aC+AeeLj
X-Gm-Gg: AY/fxX72kU+NKZzSUNWsAG2fPG8E6P23pQ/5rwSmKI3iBlpvo5DTwjd4r9qNgebN4P8
	h+ghy4twLEFeF+FAt18IrxzZcQjNVgjIkVYKSlU5tDgj/Y4yqsoKTYQ6KmjtE+OPbFLIg03+TQs
	JdWphzcpCeO+VwtEbT+VxgPV3JYqYDlJRnK+hWWXhSqZLQhoOZ/p9h7TfM7QVDNHtDrvP53vj82
	1lrR4DDzyMMvzeC9UO0lt5XoxeBmvAxHuwAwDzi0yOQRkmgsQfrQWHQ70qeI3J9ATBzcCcz4882
	APjLLSlJ+xEcKyiRfqe4JmmKVg4gC4jY8ffEQQalNmksx9s+l5mV/QGwQxVHJTJ3Ap1aVvtwXb4
	rjBFLvNf841JBvilafDWyXImgWf+hrVeliVjP6GHgsXhFC8lm+GtcdotB65TeH4tk+U7C7gpTKu
	GiNwZlfacbT/unOOmb9hKEJ2twu1CNLy/T/EFo2qFcEgzqwSZZqflNUgrHG2ohEmyf
X-Google-Smtp-Source: AGHT+IFzlCLo+BvPmOwaQvXqt6LlTFpUSJebHNJribHXa7k68xn/ydFompByNLrYdKm0zAa3YWAnPw==
X-Received: by 2002:a05:7022:793:b0:11b:9386:8257 with SMTP id a92af1059eb24-12172302180mr11142291c88.44.1766468347292;
        Mon, 22 Dec 2025 21:39:07 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de268sm40285157c88.8.2025.12.22.21.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:39:06 -0800 (PST)
Message-ID: <bc999618-1f1a-4ae7-a81c-57062d57614d@gmail.com>
Date: Mon, 22 Dec 2025 21:39:05 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] xfs: enable non-blocking timestamp updates
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
 <20251223003756.409543-12-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> The lazytime path using the generic helpers can never block in XFS
> because there is no ->dirty_inode method that could block.  Allow
> non-blocking timestamp updates for this case by replacing
> generic_update_time with the open coded version without the S_NOWAIT
> check.
>
> Fixes: 66fa3cedf16a ("fs: Add async write file modification handling.")
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


