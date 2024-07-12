Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76301640B
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 03:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720756451; cv=none; b=uzdJRZvMeh1SeO6E19sydR7G9PJ/6i2lgk/xUPwtrq8ZJlPR//PZc0oig4XV/DclpKsDpd+3QX628ndkwKNJ2jwnEqLIjalqsig5ti+unNcoBMGZ62vSBEvPD781GdS6FIlh5QitjVAR3QZwkGBM7chbZqAq3C3hcCrbM5qhmek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720756451; c=relaxed/simple;
	bh=Oywlvc41O/fZ15OgbUg3HsIF1kxs6Qcld6yz5tZjlCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TGNez7CcoNgaHbdD6qlRvdZe4h9sK8sgRKZR6m++10n6EXfiAc793RB2jKL/1lHfNPicmrr8wPuWijH2UMtZepe8KkLZUVuFACE55vPN+i7stmuJsRvvuONspETpBR+qKZyYFIQd7BM6wNPYkCfhp1G+0/P3iOTPVt7NlkJJQwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=pkm-inc.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=CHrzjI83; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="CHrzjI83"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a77dfd3cfc2so10449366b.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 20:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1720756448; x=1721361248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EiszlIMmh6W5WfqcNN/QT9VWluIrTdOMcpksL1/8loc=;
        b=CHrzjI83JsW2/AuE4JQqxuxi1GCeyVPHXgAQyusro7o0cNAmdK0zshAF1e3oEW5KEY
         vKrIQoRw9h8Sfc3Oc9X+HxwwmyYdLhs6F9SpCfnQwojVYAIRAA0MdDuqUimOk/9TmOXs
         ixz6T3hoPoNFkWo0P77nvfsqpoBsTvgSQSNO4oFvGn3x455G2WIMisX6/ZgPAz8Iuhdj
         dasK0LMvTmkABd4vTLmM+YHASrqpgwC08/jY08bpUgwmXB3Ri5TtDYTh9osUAMgTP8c9
         k8FSMoqfitN2vpj+OSF2GweczdizQcr0wDh4Teoo7kq6gBorBQzTldYcrtfywVJzYisP
         2ajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720756448; x=1721361248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EiszlIMmh6W5WfqcNN/QT9VWluIrTdOMcpksL1/8loc=;
        b=BM2YiYdcCXGdnfPXszXeztmYFHmO/I2aUl5s2jUjNFhXInNjdcKZ9cZImjffzZhycd
         gMeZE1Dsrvy23kkMnrZsVs/PAr0cA1Lwkdj8RLnfusceFyAzhGU81AIzgThXGCNuM0jD
         K/u0U1CYoVgIBInimcrhPPPEUdDMfd0/2uXcIBefo0VKhxbgVR/AXrbzu1V5jVbFiyIv
         iWSS41QeHGDCwb3Sve+KnB2T/F62IVcu6avrRTvkVGZJBVWX+BF2vACQHEidh3pqIOck
         na7eghfNtEa5GlYtUsfU4w4jve9drFmIuQmZzm4Mm1k2xMt7nW1NQijzod51px7ic/GL
         2/rQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+f1qmH/iYQQWnp67CKp9qqD6cQ+XrPhxA5aMacellAFbE6S3q2SROekohHOkDBC4fK/YNqxQDhVPDqz+YcPeeR52QiIm72w9X
X-Gm-Message-State: AOJu0YxG1Gs9rqAbnIoW8v1UziVpytmt8JJeAjRRnFq9gVktk+T+WLS7
	hSo/9UCWJtNH0buYBtSiR5IW/yH0PfP487MkFVAH6Nb2ET/EZOT55O5VEXH3/fg=
X-Google-Smtp-Source: AGHT+IGxkEIyhKXzPo0M6Zvyu+W8hbsXRGJ6rwe60tOLQEueZg+jdx48+DugAfVnS6bDG1ecm27afg==
X-Received: by 2002:a17:907:1c27:b0:a79:a1a7:1254 with SMTP id a640c23a62f3a-a79a1a712a7mr25729766b.10.1720756447885;
        Thu, 11 Jul 2024 20:54:07 -0700 (PDT)
Received: from ?IPV6:2001:470:1f1a:1c9::2? (tunnel923754-pt.tunnel.tserv1.bud1.ipv6.he.net. [2001:470:1f1a:1c9::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a6dfa4esm307811566b.61.2024.07.11.20.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jul 2024 20:54:07 -0700 (PDT)
Message-ID: <7c300510-bab8-4389-adba-c3219a11578d@pkm-inc.com>
Date: Fri, 12 Jul 2024 05:54:05 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to debug intermittent increasing md/inflight but no disk
 activity?
To: Dave Chinner <david@fromorbit.com>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 it+linux-raid@molgen.mpg.de
References: <4a706b9c-5c47-4e51-87fc-9a1c012d89ba@molgen.mpg.de>
 <Zo8VXAy5jTavSIO8@dread.disaster.area>
Content-Language: en-GB
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
In-Reply-To: <Zo8VXAy5jTavSIO8@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/07/2024 01:12, Dave Chinner wrote:
> Probably not a lot you can do short of reconfiguring your RAID6
> storage devices to handle small IOs better. However, in general,
> RAID6 /always sucks/ for small IOs, and the only way to fix this
> problem is to use high performance SSDs to give you a massive excess
> of write bandwidth to burn on write amplification....
  
RAID5/6 has the same issues with NVME drives.
Major issue is the bitmap.

5 disk NVMe RAID5, 64K chunk

Test                   BW         IOPS
bitmap internal 64M    700KiB/s   174
bitmap internal 128M   702KiB/s   175
bitmap internal 512M   1142KiB/s  285
bitmap internal 1024M  40.4MiB/s  10.3k
bitmap internal 2G     66.5MiB/s  17.0k
bitmap external 64M    67.8MiB/s  17.3k
bitmap external 1024M  76.5MiB/s  19.6k
bitmap none            80.6MiB/s  20.6k
Single disk 1K         54.1MiB/s  55.4k
Single disk 4K         269MiB/s   68.8k

Tested with fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1 --group_reporting --time_based --name=Raid5
