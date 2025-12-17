Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10533D51F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765990107; cv=none; b=sFqOzn4A65p8KP0OI/G2yLu1ulSCEhrb3vehMuE16tKJwiG30gX0NnuyiTKi63OxZw8F4X9bfkqm6cFq39TP6fanH7TIfJM4rKX/vcQhcr/oOvVe8BtaKRQtu6/UxYBQtl9r5+7tQjgXdMLaHkIi2rcPsENbZKOot9YQ+jSbQoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765990107; c=relaxed/simple;
	bh=V1IvXHpJNxWAE5VbRuKgFWhvabMBF0ue0L98hZH88Ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hHs/uTfvg54RDetsnnu0pyJZXHq/13t8fTVKLECn3WbVah2Y/V27yzUMAlaH8iv+0nopuhWIfqCHQ+svrBMrsTxsCMvmJlQTVzxHDcX6bDTzGLlEZhIzuZz4+66tI39m16S5qPcb3LWdmE6C26rtKBiOC4P8/X3Jox3ZcHfxFGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jej0ljN4; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jej0ljN4"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a09a3bd9c5so36869595ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 08:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765990102; x=1766594902; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KCd5OZNqXVj+9SzooIzY9ZDi17gJtPnVjqMWEvO7A2o=;
        b=jej0ljN4sXdYeKW/brQgml8Zknj8vQfV2bt+0b02OgwP6NaRW6+p8/FisD/a6zZPr7
         P9cKMlHk1I8unCD0JaNn1gMv5LHy3XrmJSWdd9BZbCiNI1q8szVRBmWnHRQ10900uCiw
         yoEAsfQUIp/NwMxlyvLLEG6cDK/4h4ToEbw9JKHGRsyEniW0IdPax6zS4gPvhvgp2x1W
         Nq3Crr8kaMoDTW5uErBehnjd6G+JePA54TaBUdGZVTRQ1eVsaJsuuYbXFbhFcaBC6YZM
         l7evNcdERGRttj3LGVxUZW6tUv8RxQnBKmtDHTCpGiVJi+ojXviB2bATiCm3KfosICXl
         b80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765990102; x=1766594902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KCd5OZNqXVj+9SzooIzY9ZDi17gJtPnVjqMWEvO7A2o=;
        b=sq2Pw8fhXk+FeZIouGmg87JUR4EmplC3QVWFzHo9QS+F5vdls3yhGh7J5ExaGy5hwU
         nijNeC7QNBP2a4JDLFniecNqvxT9pvqhhgbsxpXVCpMHAChTgnn9ckBiQUwa7YV6Bg5d
         XTu7AjmDBynJqJz8zhre2oUZd0lVO26hHK4oo+s91MCvwccV7BdvtmZQi0Yshv5doSdI
         FFe99tFLD56VDoD3z1Z3Sb2rJjJu2F9DcfgCGVNeLPg/va6UaTIVgZFNIFNEv2JN1wi2
         624eUA5eELowZEvPZe1jVKZsMiEOgl7JGb/Doqfwsg/io3QJVMdxGhsAgAUC27h/ScMO
         F0OA==
X-Gm-Message-State: AOJu0YxjLrdjMRRxmaVZ3NGJgIeHbRe+ou+1UmQYVdx0WLyVN26WkPxs
	n4UiXiLgKBuMUGmTjkALuUuWEBbbHqksTsCqFY2LVUu5FSQ99mzoPrxgsQoCXQ==
X-Gm-Gg: AY/fxX4r3zkA3V4+OzHei0uOSIBRAQHW/F5pHaHWcKFcKwaQcayvKQRCw+4p+c8losI
	/raTjkzabGoP96iyRzuvcxxhrnVCsHRd+U/1y/3LEz+CxQQmpyKj667uFxIg/BqbJC2kAtM+uVa
	k+zfCeBJm92eercV7BXHwI6JseX8Sq7MdjaMxmeO8BJRGLs7+hcAMU3X6kytBpqucIWv6ve0o+9
	KG0zoycBiCRUSVrAz0izu9H1Tse5OoIzYIwT8bhZqUU5iGLdVmx3vKF0lHoaaIQ4hIAIV05LqWV
	ZTSYXv1lk+23F9E8Bcjs0Xy7l11gzh048XfDM71j/1w2IVZ+pRujiCiq4UTLQsSKaexvwqpSAuZ
	UUeumS0Z6D1symfZlwepMXaSZEcCp57OZroJGjDyfEeEPuRiUF++3uqZyT3JG96C6vJyUasD0Jx
	pdEiTF6Q4Qp6dfJhIeeX41dQ==
X-Google-Smtp-Source: AGHT+IHJedazvEiRzassXuHhwzb+Dgs/6QUmiQkw7X3rRU+P9aTNXTiny2GLQFIjXtXvuX6oEXN3iw==
X-Received: by 2002:a17:903:384d:b0:2a0:e956:8ae8 with SMTP id d9443c01a7336-2a0e9568f38mr147207155ad.14.1765990102011;
        Wed, 17 Dec 2025 08:48:22 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a10e079284sm91257915ad.33.2025.12.17.08.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 08:48:21 -0800 (PST)
Message-ID: <a9f5da12-6b0d-434f-87e5-8bd4f163c245@gmail.com>
Date: Wed, 17 Dec 2025 22:18:17 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xfs: Fix xfs_grow_last_rtg()
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 djwong@kernel.org
References: <1e5fa7c83bd733871c04dd53b1060345599dcef9.1764765730.git.nirjhar.roy.lists@gmail.com>
 <aTFWJrOYXEeFX1kY@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aTFWJrOYXEeFX1kY@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/4/25 15:06, Christoph Hellwig wrote:
> On Wed, Dec 03, 2025 at 06:15:45PM +0530, Nirjhar Roy (IBM) wrote:
>> The last rtg should be able to grow when the size of the
>> last is less than (and not equal to) sb_rgextents.
>> xfs_growfs with realtime groups fails without this
>> patch. The reason is that, xfs_growfs_rtg() tries
>> to grow the last rt group even when the last rt group
>> is at its maximal size i.e, sb_rgextents. It fails with
>> the following messages:
> Please use up all 73 characters of the commit log to improve
> readability.
>
> The change looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Should I have any fixes tag for this fix? I have made the change on top 
of the very first version of the function (xfs_grow_last_rtg()), so 
should I put
Fixes: ee321351487ae ("xfs: grow the realtime section when realtime 
groups are enabled") ?

Also, which Cc tag should I put here?

--NR

>
> Can you submit a test case for this to xfstests?
>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

