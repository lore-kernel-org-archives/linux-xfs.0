Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B252F39C1
	for <linux-xfs@vger.kernel.org>; Tue, 23 Dec 2025 05:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468313; cv=none; b=drD5sP7FtUQugMBLUNldp8Fz7oJAJr4t7+e3cLsaCwJJxiohnMBlRbWq3qd/pKafEFnm5D+/bzq7WM6mCYbzc2MD33FlWU7y/5R7pMeEsYcY4y8Hb4FV4iJpfQSY4jCVK5ulQ6VS0Y5jhk8p1Q2SBfUAvfpf0zHGbb+YAmxev30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468313; c=relaxed/simple;
	bh=zTV5Fl6uJEq6bikfRl+2GZKAfKdgBpPPlmOrmzDQ1Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KpwCRtqu2dKmc6HVqG6bP5Kec4xqk7He0ajvg84Ayi1ZBYDyOl5Jgy5cSyRHYh+DryP9+PP6mkvrnV0e5ZiDxTDTV9G19l9SiGNFoXoT1fKZRyVX3snP8C2SUChejFaB6WaijuT2/mHdioja2ebA1J/JmqW1+lrto6fhLeMbA/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/39yZPJ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/39yZPJ"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-34c21417781so4579267a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Dec 2025 21:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468311; x=1767073111; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2eUzqzQcRAv7TL9i3u7rXqYthkznBqBfs67/HNYTk8I=;
        b=k/39yZPJRd/lUcRJkV7mXQEWc1+ntOQZ3mgr8kFI765nq8VXzciXpYKgKPQG/tmkAM
         owjPUkIe3CFME/oQ1dh1e+schfxGr1GebTc60fpUHpvMD21xSXHx1R6rHRmQnGi7e77b
         K8gWq0Odf6lE5z7xabI1OfkODM0SiBVhCyDtkdpfiQCqP28IV5iuZ3X2EFOvRV2Gg7UZ
         OwnNQdnzXvu1PxMtIuBAX2FJOYDAFMzk3ZDVkCoSbErCXRMukkSvcsMp9nWx55EwuwEJ
         7Pdlo1cgbWzgOgds7F9Lpvihye3j+92iv8K2QF0XqTlcbb/5O/MwGRalD5ldn/b0XsSo
         WZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468311; x=1767073111;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2eUzqzQcRAv7TL9i3u7rXqYthkznBqBfs67/HNYTk8I=;
        b=E1s+0Hhqv3b10dDXHKw6MkS0lkosxFEEwz/tSdu3IKKSWj4MNulRGZXspcCCytun+N
         YhNZYGyW5idh112zPa552I05vYdTy/CXQ7+wCAgAVJb06Q8wHWVhHKm53eC/wLtRLm4/
         LicxqohqfULOJwB7nMyPZhVdVUIPu2v6IJuWwZg6gdSY0UeVHURVxw/Qa03v9MVORNcR
         5b/S4kyizb7OOQBz2qfSlZNZ2jEba1ywLRRE8+dp9+2KTsIEyHAiAX88euCk2dSUUupo
         jtlCK923rZWeqk3gr8+L5QY18XXj9RIyEM1sTy0sKfVPqSkTJpawhLQIJBzWhHTDcuUE
         eL4A==
X-Forwarded-Encrypted: i=1; AJvYcCU9iyAVGR+du3olYgr22nT2lDZk2lsKIJaVkmneGfBtIvIFhY23tGVXHwCCHDDLcRi8afJrRrt67mI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmw57uxp08yb4ezRV+lOSCV2PHyAArQW65Joi90/QwuaiKLo5v
	Qu+/2oR6+9ue+UdXgMSp8Mz/ReaEDbd0aWxkyidt3C9MRV5LD3sRRB8i
X-Gm-Gg: AY/fxX6PkV3y8tIK58Xdi4UZ4An9uuYkDbCdCbvchEFJ7KXSiZziD84fofmyhYErNzJ
	QsW9WDpeOaYZIpSfRPwN3PC+Qz4EI/aAwEPSWNqmrc96jz9CQ2GrKNb9uGWHH7kV4izK7GkX0Zb
	E881riwl2A4CPXGRm774iimmEkx6plEbAftfLFic8A5uRLiEd2NjzYuR6NsSn+sXUSpWqryXA7S
	KbN8CLG7a96jGzHznqG6u8jnDAYcTwIahZpuVuEWiLmnayS+ZXpDeBgiObFgN5XdI9c40iW2/Wb
	6opu3vYWqpjJVamALT0aU1VxmfCOvHb5w276/L19fKvPdZEYhmX4JCcAv2nb9Dbc9wyQTxBDcIg
	4UfXdm5WeoBNlTCDP0JINxLku4kZdH4emuSsQEMJXO+G3gssoixeAjIsTuL3fYC/dHgFzz/x4Dh
	m0vSsdcspXDtdXU+MQhN3WTTtr0E9mWeUjRvNWs6o4AHMZd43zXcupn+/BZFJChNG3GdJKNWCzY
	fk=
X-Google-Smtp-Source: AGHT+IFwAZOrVWcdz0GU+cDO+t7ewKrgjzgkHtOiGD0/poJQvRMMxSdMeBecD46MhF4AsSDjM1RyIA==
X-Received: by 2002:a05:7022:799:b0:119:e56b:957e with SMTP id a92af1059eb24-121722ac244mr18354800c88.3.1766468311123;
        Mon, 22 Dec 2025 21:38:31 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm56187439c88.16.2025.12.22.21.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:38:30 -0800 (PST)
Message-ID: <37febb65-038e-47a7-9a5b-3b4c2773994f@gmail.com>
Date: Mon, 22 Dec 2025 21:38:29 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] fs: add support for non-blocking timestamp updates
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
 <20251223003756.409543-9-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Currently file_update_time_flags unconditionally returns -EAGAIN if any
> timestamp needs to be updated and IOCB_NOWAIT is passed.  This makes
> non-blocking direct writes impossible on file systems with granular
> enough timestamps.
>
> Add a S_NOWAIT to ask for timestamps to not block, and return -EAGAIN in
> all methods for now.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


