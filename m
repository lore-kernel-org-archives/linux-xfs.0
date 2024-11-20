Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB3424B28
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732117077; cv=none; b=K6vF6blpcKdSbM+XLYVfTi96MfepwM+9ffgjMrKlqZfG0EjNiXqT29R88PFGJcTrPTHZiva/9czY2F9hAgnvzWE0YGl1Fx3CBY8+bBf2h77oVUFoyeYAEogzseEX599hA7SJRMhdY0SwwwNLRBKhmgXrw/yUKyqgkpHtldhUq6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732117077; c=relaxed/simple;
	bh=0JOaf6Fc4oX3EuXWi7wZzlKsXgXLXWdlqYqGsC+CHqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ec6Byf/Rv6CCop4s8yRUTdKkCOwvMdE5EDu/FM+sNqqrdMA7u5aRwYnyiLB3jMftPyfqUk5dYZImpzUKLhDMVMV4y3mNZwHg1tO0neMUmN35W0iNQ4yZzHfSWc75FfNWO5QMydQJso6dzrICPnVs56MbZgDjh4rqw6fhXetwlEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=riscstar.com; spf=pass smtp.mailfrom=riscstar.com; dkim=pass (2048-bit key) header.d=riscstar-com.20230601.gappssmtp.com header.i=@riscstar-com.20230601.gappssmtp.com header.b=IKSqd4px; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=riscstar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riscstar.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riscstar-com.20230601.gappssmtp.com header.i=@riscstar-com.20230601.gappssmtp.com header.b="IKSqd4px"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83ab21c269eso151622139f.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 07:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riscstar-com.20230601.gappssmtp.com; s=20230601; t=1732117075; x=1732721875; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ns+8qgp8ihemUk4LALEfrdrF/V/lndEQMLbRy8TsQuE=;
        b=IKSqd4pxegVL2TPPzpxXgninTcvoFe2aCB62xYdmwWF7D3rm9QYgCgAmqZf1K9DKiB
         PEBHugY+tSpzg6SG955LzPBz5sQl3mHLjxhwie03mlRkRur01J4+79hyqlIUc/5B1tZU
         rPWq+KnkOHD1jbc9/3atcJE5LBNpMBWDYeGM4GyDw5a+bNPZe2csvGDulNfI0KK0FywQ
         4a3JwRmMBAH1Uo9pAoYUiyL1zZpfFnMDrDbfQKDPlfmzF4x2dIxGM0hzLrasHbOiihET
         P6SC6ss6aybg1iPMaXmA5mIM2fE/SvN6kfeCPmH+gtvXeBNU04W62P2wVqsu8g9BZfhx
         6bgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732117075; x=1732721875;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ns+8qgp8ihemUk4LALEfrdrF/V/lndEQMLbRy8TsQuE=;
        b=FJnSd5ZvhFaQ3jWSqNA/RWo0PpJpTPTtxLqbNQpRIJLPFA3HauvjMIySU6YS2R4nmn
         dKeK298hUXef7ACY1nJRzoz2OQN8rsmeVVHn+xutg1CGv/16SNKGjDk4CHAoV6YQAgX8
         szjit0xpRUWcqAkpCsn3HK0+r9iSvgA31mdO5xCqKiKD7QyvwaWuUmgY3U73IKt65cN6
         EnfInTCH9KeMQcEGKk8+pHCRVB28/W5EoSLszmdFRFB9A+Y7qeGb3XoG26AkCqSak9GN
         jF9FMTJ/sfVzkHP4MR2KB5CZJ0whVk6FwQPt26B7MX7ccLzu0X9rcbArzRdZSxhCAMkY
         es/g==
X-Gm-Message-State: AOJu0YzHG026dQt/TBG0lj3l2t0JGI/clZem67RvBrg+u9X+Kg49ueuJ
	aVeRwtqCgRhEbnGvXtkxRzZpXy2qNPM8zesqpHzvb7BsMejPeWuyeIbqFlEoqtA=
X-Google-Smtp-Source: AGHT+IEhzzdiy3jkiDuHkj5iHET4WmAI4DlalGu7KztQOSaRQf09JJ91HJPq6IG4dJV7oNVePnYCTA==
X-Received: by 2002:a05:6602:3c6:b0:83a:b3f8:e517 with SMTP id ca18e2360f4ac-83eb5e364c5mr383922139f.0.1732117075090;
        Wed, 20 Nov 2024 07:37:55 -0800 (PST)
Received: from [172.22.22.28] (c-73-228-159-35.hsd1.mn.comcast.net. [73.228.159.35])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e06d6eacebsm3349176173.25.2024.11.20.07.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 07:37:54 -0800 (PST)
Message-ID: <1a9a75bd-d946-40ec-8307-10fa04672300@riscstar.com>
Date: Wed, 20 Nov 2024 09:37:54 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Use xchg() in xlog_cil_insert_pcp_aggregate()
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Dave Chinner <dchinner@redhat.com>
References: <20241120150725.3378-1-ubizjak@gmail.com>
 <ad32f0aa-79df-41b2-90d0-9d98de695a18@riscstar.com>
 <CAFULd4afgt7LtqzZ_oFDz4wtMe+TZKGX3E_XpSo2HD5rQEvOjg@mail.gmail.com>
Content-Language: en-US
From: Alex Elder <elder@riscstar.com>
In-Reply-To: <CAFULd4afgt7LtqzZ_oFDz4wtMe+TZKGX3E_XpSo2HD5rQEvOjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/20/24 9:36 AM, Uros Bizjak wrote:
> On Wed, Nov 20, 2024 at 4:34 PM Alex Elder <elder@riscstar.com> wrote:
>>
>> On 11/20/24 9:06 AM, Uros Bizjak wrote:
>>> try_cmpxchg() loop with constant "new" value can be substituted
>>> with just xchg() to atomically get and clear the location.
>>
>> You're right.  With a constant new value (0), there is no need
>> to loop to ensure we get a "stable" update.
>>
>> Is the READ_ONCE() is still needed?
> 
> No, xchg() guarantees atomic access on its own.
> 
> Uros.

Based on that:

Reviewed-by: Alex Elder <elder@riscstar.com>
