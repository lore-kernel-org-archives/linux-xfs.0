Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0726223D2B1
	for <linux-xfs@vger.kernel.org>; Sun, 30 Nov 2025 23:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764543823; cv=none; b=WIjNj8IJIboZ9yiBDfc8yIuF+c4w0bgBb14J6KDq9YHAfHrcNqVVuFNxXVqUbeYob7LH260Hg7js6LpVPhwwvNRe6VxzpZSV5OOcIvQ4bZUDq+c1bgIrwvM4mIitqGua1/NduwB4ZaVpTHY1F62Mh0Iv6AsNV3bZegHOsqiRwgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764543823; c=relaxed/simple;
	bh=+KhrMhcJSvItbb/04gtqwcqQ9SN2qd7j6u0HCMyKS6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6ubpOGQCBsiB4K6DO/Ns7Jq5daS3IUAXlPS7qFzap3CiOAc779seUlDNyRJGltkmqGq8GHrayi1SH6/sI+rayXLtaPB7oemax7OEhL/X5N0RkQmKA4PRNfUxF1f2Ls8GvCzMJQgJmxzhrI716EZSd8xjB1ikigrpEwCeobpEWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42e2d02a3c9so598429f8f.3
        for <linux-xfs@vger.kernel.org>; Sun, 30 Nov 2025 15:03:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764543820; x=1765148620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+KhrMhcJSvItbb/04gtqwcqQ9SN2qd7j6u0HCMyKS6E=;
        b=wP60iTRhyHUVGcNYB2s662u88VexCR759bC8Gzo4MvwVpYkU/jtYQiIjW76Ie5ZR2i
         zF2O9lXR7aFyqW2vW6kdO/JJaWA6rJaNxIA5p5vHNm3MQgtUm/K1ttRwzCq2O97wr9Jm
         00fyX6rZOOPx2v+ueG3MvOkWgUkQlLIO0+keqfLVamz11nIIrdBx/hMkrwTmIq6aX0Oh
         ufJAGhucrF7Bhqzt6dsZU9nvFcJdUFDdvWp2G5hMMDPfIvV/rVF3bYw/Juafve5moZs3
         AQReWLGDGn3qLjJ3sw+s1F8gO1tnpvWeT68dz0vV7bWtJw4BJV1Rc1k+8WPp6hIZJ+/2
         oiaw==
X-Forwarded-Encrypted: i=1; AJvYcCX+1mApBuSCEEFQdaKMAPxkHSbIJvES5g/pQiJY4NHi0vLbJI32zX0wFvdXp1mg453JONJyvpO7IZc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYdH2mxC79T+yWX7ebz4urqPUvDcSelEkOCykbThqkHaPelESZ
	l86vCTtBuCMOvN4h2F3uaUtzVBbuTMwQk8fA1zqFjB6lwwu0xbLE2BiT
X-Gm-Gg: ASbGncu2rJ0AELWdCD0tTiiTGamqr8LVgDTLEnrITWcUbNOAfYF6EpHiQZWJaUOucQy
	n14GTIJ/5VDS9W3KSCx7SG63dz1khQTNNENOWLWy1pHZGPK9Z3KAnJq6C/2cbWW2wjqXu/bv0NB
	QYK0MFj+roywPC/DaOoh0NRbvB5RsN1p+FLLhhwXsMSBJNcR6gLhIy2FHZxtA/sNdQt9YJOQvTr
	0JZ4zZ+XfBAW8kJYO+74dLj8CJUWtTRgfEj7fVI+TgjrB9XayEj8xFDTUGku2Xx7Dxz/Rt7DvxC
	AFDP9tNnWLPy27qhilluhQ3D/4Q4czj/BhBf4kawg0Oxc28ZsJPR4dPKDa34q03hBZmhHtD8yFC
	D+bn+t/Bpq/TV9ynoAAPZ4GkBp3ZwUmPsJNGemRDZEQqcO2muE8CE59k5aTv/j8nK/kBJf0HvgG
	SLjloNCSTBK5LP4AngwZGIWUzOGw3fFRBz9gkgO7vD
X-Google-Smtp-Source: AGHT+IG0kUJO7SYN4V6YpXy8uJxkqAm9wDLe/yTWTady0nKXHIsEefrNGBZg2POKGw5qhetClLnvgw==
X-Received: by 2002:a05:6000:2484:b0:42c:a449:d68c with SMTP id ffacd0b85a97d-42cc1d0cf34mr37257663f8f.30.1764543820316;
        Sun, 30 Nov 2025 15:03:40 -0800 (PST)
Received: from [10.100.102.74] (89-138-71-2.bb.netvision.net.il. [89.138.71.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caae37esm22401721f8f.40.2025.11.30.15.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Nov 2025 15:03:39 -0800 (PST)
Message-ID: <b33b3587-edb0-4f30-a8ee-baaa2b631ed9@grimberg.me>
Date: Mon, 1 Dec 2025 01:03:37 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio
 chaining
To: zhangshida <starzhangzsd@gmail.com>, Johannes.Thumshirn@wdc.com,
 hch@infradead.org, gruenba@redhat.com, ming.lei@redhat.com,
 siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
 linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhangshida@kylinos.cn
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-13-zhangshida@kylinos.cn>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20251128083219.2332407-13-zhangshida@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Acked-by: Sagi Grimberg <sagi@grimberg.me>
