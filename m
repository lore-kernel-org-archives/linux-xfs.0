Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECE6205E20
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 23:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741131814; cv=none; b=lobEleluV6GESSQheE6MsiQhmMd/HcnwwYcsOXlTdEl66gYq2tGYaXGw6FY4v+/uPkwlLgYtH65Dm3fO4C0gXZ78NT4j+XFtR+jlk0s0goRGCWsochb29fvkz0zJzoHSi85Ndp58FBX03kPXGtvyHnaOmByXxt3WSOuWwPUW2VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741131814; c=relaxed/simple;
	bh=LQ2dObE9xnjHqX4o4VZ6lldO1Qoq22S95Oe8bf3ZaRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lc5onniD3Rg2JAza/iITMOalgfNokrxotrlvBiIGHfHI3JZHBlXkyb56q/DL25Bqyu3/GubFnQX43s0tSe2uhD8EogGFmDY/OEUUBTSG49A2GcFnfk16pPeGqfAz23NEV63ilC62aNygMzPenGXaY5a7x/jWiT/+ZJf5zHBoDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PeO2Qd9z; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PeO2Qd9z"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d2b6ed8128so1097555ab.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Mar 2025 15:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741131811; x=1741736611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=adL3a2anGdh9vo2wHq8fefFVpNlV6pB2upjJtDZhv9U=;
        b=PeO2Qd9zxnVs3UcbSfhqR6qottgXEhCLXw476JOVPf6U2G3JjzElJ0ij8NCpPVzOA7
         emwRXD6wjFsG1xNFFgSGtn8aAYs+SBSvdTx7T0EAmRseNYrXDG920KGKyVQeixdyup5w
         8Wuoiv1iKaM/MeWQhUTjKhu4El+LUelxkaj7ubJhJIWM5qeIENpo7KmoQnHmbIL0RMej
         2KTV5Gtjm0Sjpgq2Ap6Onga9ZAzic1gHgVSzzsGp1D6klhprqFxyGKy+vJzQ53ezB8sV
         2nUMvXwVXXEuQCDKoR2V1hJ0KfNndt3MmCSPp1Nlt0FWTE6m5p9rEx9OWNNCrPiI2iKl
         4G7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741131811; x=1741736611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=adL3a2anGdh9vo2wHq8fefFVpNlV6pB2upjJtDZhv9U=;
        b=t/YJOGeydHZAxVGkPi8iC+gm5yiTnA2p+esPd6dDwcmXvB8cykk8Knejf91XpQkrE4
         ukAGZ08/tHMxAaKnll4xAYL3hN0tuTMrpvZKBw7skyWJM7imkEQRsC5rg8T2g+HfAD+G
         5MtyD0drjzc/7BqtUwCWXC0pHMuNt8OirytV/+qBMMk6IciLp1EeAoB0U5PQh6JphxIo
         X2HPsD/ufcU+BHdoe59drLpE22yNqmvsU/jZNwXWLTO3O3njz8SR7jQEgJhV5EVSua7n
         qg+zZ3RXuH/oFxV3v6e3hAnQsPWCaJKHYn7RxexojWqK9WkLO2CueTETf2/1bpnlbG5S
         PZcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfe/jWTxG66B/A5vlQQ27E6t1qqqZE9N+ou6+4/xWcntAtN2ufM+QPb1NSEX5CW/N32j/nGmrJGEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw798SX3C0oBD5jXPA1FGmWBYOjgpoJ4FcEGHKYZWet0sK945Iv
	GDRGsu5eWXHhfwiLnbrvDBma+y+/byEO3CrV0UOiG37XQ2L027O4G1iyiAVIpTo=
X-Gm-Gg: ASbGncvl5icHC8Vo/6GJK/dOtDqcx9Ndh3Dx2Nk4JI5LMdzfEzmgqIqHf7tupphqUkT
	A5JgJI3xS1D96x/QYYz6u3ihbsw/4HssL/J+HT1YYeEcTPzEXMU3+TtLG9QzAms5Mp4l7FyThmc
	i0zONRVzt2x4C0XiIL0nf98rZlihHQsr3kStLixZ2qc8/HyIlmqM1Yxx38B0V+EXuywfXfshCsl
	PPCZwC49tcUhiHj2g7/xxbz4XGtp73LHDUJ2flb2oMYY7wY883xx2H4Z9Or7f7YIli20Nzz3pax
	i9YGi5f3ng43Mbgp0u7gND+VySvSd0V0vtIchis4hw==
X-Google-Smtp-Source: AGHT+IHRIfVPTO2H+vhGXg2gihyT9kT8cJpre62fDKYP0upABmDl9eg4B1dQhkHIWNRySymN6Tqkfg==
X-Received: by 2002:a05:6e02:12e6:b0:3d3:fa69:6755 with SMTP id e9e14a558f8ab-3d42b96c243mr11906105ab.5.1741131811472;
        Tue, 04 Mar 2025 15:43:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d428e8749asm3788845ab.43.2025.03.04.15.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 15:43:30 -0800 (PST)
Message-ID: <876fa989-ee26-41b3-9cd4-2663343d21f7@kernel.dk>
Date: Tue, 4 Mar 2025 16:43:29 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
 <1e7bbcdf-f677-43e4-b888-7a4614515c62@kernel.dk>
 <Z8eMPU7Tvduo0IVw@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z8eMPU7Tvduo0IVw@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/25 4:26 PM, Christoph Hellwig wrote:
> On Tue, Mar 04, 2025 at 10:36:16AM -0700, Jens Axboe wrote:
>> stable and actual production certainly do. Not that this should drive
>> upstream development in any way, it's entirely unrelated to the problem
>> at hand.
> 
> And that's exactly what I'm saying.  Do the right thing instead of
> whining about backports to old kernels.

Yep we agree on that, that's obvious. What I'm objecting to is your
delivery, which was personal rather than factual, which you should imho
apologize for. It's not that hard to stay on topic and avoid random
statements like that, which are entirely useless, counterproductive, and
just bullshit to be honest.

And honestly pretty tiring that this needs to be said, still. Really.

-- 
Jens Axboe
