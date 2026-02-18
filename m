Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598F33EBF02
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 07:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771400851; cv=none; b=bajk4li970ffhx96jf9TS8xc9a2fIzbibEO5YW+5m+4t1BFs/+tJ04WwcOy9UgdjB6Q/t4OyLxCmb54cgc+4k10nxNNkqTBi0yOQ/emnyDJ9JImroN5JzeLkTnjZ12t6LWk+DV/dF/nhWZQlnHAL+dir+D4fjdSdpwkg9uE9q4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771400851; c=relaxed/simple;
	bh=ksHQWDVDIOQapAukk2h5bzf/yQ4fqTdliB8WsW15kxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iIevJOeo216l/aCEDGaZk2EFkbOXUYQa4v7GXwBV8zhNRG+n7gaG91Y/M8cpL841+yU1NEGiKXoTsEHWDdPAvN34wjpgLQ0Sgbxwzm3LbOnKVovwUF7V1xcT7ALA7ItjiMobSwt6IqF1Wv+p/JEpYz4c8BCBbMZnJfer2Y1GVYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PCWMNSWY; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PCWMNSWY"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2aaf9191da3so33203035ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 23:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771400850; x=1772005650; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zn21Y2vbR2N+WDLS5+0ZFfHChchkcXZawoLKC6BUxjg=;
        b=PCWMNSWYiqmaOG8TwuNx9GXM8gaFICjlwkfBIQPv4Rh5tHrLUb/KXA1noorR8TM5Qs
         4k8J7nnvFxpXXED8S+ocuf0Ng1MQvZmtBv0Ui2sCdas5z/ZKuFkyIqee8bk+adkoUWqA
         sSLNxGRoy7boQ4uCLvYIPzKGXov89nQh466nsrenBuOcL7y6S8NGQrnDGYRa1bgZCPpb
         r0C2IyWeNXHKwPn4qfhyN7zb8kbXnbDY5KGYryUI4IZIXufhYKsUfqgepvv1FzS/XUee
         Je2OXKLy7eC1+zhFH11/BQy+ZuFURDJnfVAQI/fE+TfWf70xlSLErkqpN3oKGZH4NouF
         16wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771400850; x=1772005650;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zn21Y2vbR2N+WDLS5+0ZFfHChchkcXZawoLKC6BUxjg=;
        b=uyDXAzr5JsikB+3Xm1r+Pz8i4c9tn0oAYF/SoN7q26xNH8DSo2qMcld1DMyneyLnRX
         cbCbNChBsQsfd4xuMNht8wD87HioNpmEcjm9lu6xg5hfoG3uB/Gt5IOtW/fNZJwzWbyS
         4nnmR5hzlRV6Phva12NTY52Lle1HZ252Rdr2uxVsDjQ9B9Vqoh1NXVkux8i+VkcuFvrQ
         ChykfZCnrf4+KgV97cf5iTXZeJyegA1ikjoMkH4f3apdtkv5bjbmNUU6MPYaKR0h8qwy
         i59BEBKNVhwEO+n2bo0m53+QIVYHWEUjASwivwJnqLLJXV68rax5lLhGbWR28Ou2kkdT
         9xoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwRjg2EqdH82AG78x1yHvmwUVJe5fifiBwvVfiP2sB32OhqRd5dYxWatz2f/v/OeHguui+sFcvV70=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaWYZjlZiRJNkr/ehKJDaOg0FdnQKEKsBPjBbZPwI5DC9/KLC5
	0RixJmqBdC+4voqjnsJliHLwvHvm8KAoWOhSEQc3Zg/9n1JlUThDezsf
X-Gm-Gg: AZuq6aJ1FvD4xZtHExkF2iBsSBKz9AKgTw6fDg0wf+a4R7ZLf2yZqotzBzgexUcgFQV
	0pPW3+ywKBnyRD3295cOhuu/55WU5IERenGhJCSYJejWvhGhQIF4je0qeYGgISQuPi8KOipTEOT
	1q35vaGoZcQWZhK89eK8DNADGaDug7zlKryKJ4h4r3R63PI1ivkJwpz7SdGDewyFVqGrkwzKX0/
	VIAAtIkUrOuySvRCkco0dmQp3DlCgY0GSfYvU4h+U8w5v2KlT0OlbUWj0faLAOiHS8Lj4RMrEC4
	6ErH2zkZByFhUDA3iU9RKyICKXJx43ujyPRDiC5lXlClCagAx4IiH9vN8LLn0sgxIj4KhhDoSAY
	TPgk77152kyKEsVqdNSmBu77K2VEmTxLiqvNAU55HgUjcFh9RDZ2ObHcJtH3xuStijexurrSG2k
	CFerAD99N6/y2kncFg6dAo9C0y8hShZnrXUEcuug==
X-Received: by 2002:a17:903:286:b0:2ab:2633:d986 with SMTP id d9443c01a7336-2ad50f9fcf5mr10167155ad.49.1771400849612;
        Tue, 17 Feb 2026 23:47:29 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d6134sm128297885ad.57.2026.02.17.23.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 23:47:29 -0800 (PST)
Message-ID: <b4e97ebc-fa34-4bfa-8331-6a149f65b301@gmail.com>
Date: Wed, 18 Feb 2026 13:17:24 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] xfs: Fix xfs_last_rt_bmblock()
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <8b93afb5feaef3fef206c5e4a6a5f83a6d63b53b.1770904484.git.nirjhar.roy.lists@gmail.com>
 <aZVTwrR4ORzYALSy@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZVTwrR4ORzYALSy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/18/26 11:23, Christoph Hellwig wrote:
> On Thu, Feb 12, 2026 at 07:31:44PM +0530, Nirjhar Roy (IBM) wrote:
>> Reproduce:
>> $ mkfs.xfs -m metadir=0 -r rtdev=/dev/loop1 /dev/loop0 \
>> 	-r rgsize=32768b,size=32769b -f
>> $ mount -o rtdev=/dev/loop1 /dev/loop0 /mnt/scratch
>> $ xfs_growfs -R $(( 32769 + 1 )) /mnt/scratch
>> $ xfs_info /mnt/scratch | grep rtextents
>> $ # We can see that rtextents hasn't changed
> Please wire this up in xfstests.

Yes, I have prepared a bunch of XFS realtime grow and shrink tests as a 
part of XFS realtime shrinkfs work. That will cover this fix (and a 
couple of other fixes that I posted earlier). I will send them shortly 
in a few days.

>
> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you.

--NR

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

