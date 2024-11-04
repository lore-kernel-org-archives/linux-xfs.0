Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02871C07CD
	for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2024 15:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730734865; cv=none; b=VhX6IDQPy/kKI/OlIjkWSHqxo+KirAs88L1feNUD+0NaYpQ0rsU9ISUernXzB4fN3ffEoe/t8f2M8zcEeER3yKnaGo58WRzBbpOB63Iewrw3H1WK1/h4gPnL3URvjOoTkPgsVXw3IR/4kueT8S3NyfSVEbB4DZR5iAVbbk38Ij4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730734865; c=relaxed/simple;
	bh=2SuiNT4LGq9TD2ZfLY0Ta02PE4d0xK6LhgkGbGx2N3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mocZO+UwkfyzQ6T08EoHKowaPr+5d3/FBwxDS2zssLRd0Zeb83aX5cIeFKqisz9yxJy5xLiiw44LfhxCl2vInp07oFRaNYQc/o2THIrW9a4SEuBJzm1DJXsutQwGL6VjaJSajUQnOqOJ0hcq/h45Az7I70ZbOIsyAz9Ni2fKaEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IJGJ79+G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IJGJ79+G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730734862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f0T78hLZwBKrU6sMFjomeByPJgPZT6cke/4FOjeSZFA=;
	b=IJGJ79+G57zT7/OMVWKYVMJrjeiqidseZ40spvqB9DuIlcFtsEGEI0dMLi7moYVreSD+FY
	3gvv7twVYyxxo/i+piMgyOO/o8IHMYgcpM2RzZwd8QCQMjTf3yDz2K8tSPgkBokr+jwExq
	ulvpLg7GFWcX5/638IdNyum1xeCNI88=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-e-bM4yhZOUyzEYCSwOt8SQ-1; Mon, 04 Nov 2024 10:41:01 -0500
X-MC-Unique: e-bM4yhZOUyzEYCSwOt8SQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d609ef9f7so2268385f8f.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2024 07:41:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730734860; x=1731339660;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f0T78hLZwBKrU6sMFjomeByPJgPZT6cke/4FOjeSZFA=;
        b=huAjUAxZuUmw1DCO2pmlC91QDPkM6P2MBs+LGSGl4HMC5TkxP9vZynqVys/lId0elK
         EK3xrRhgudYhTiuCaEjoZ4GJ+lPCTmPu2/dXYePzbg44m3fSLp1790H7NJFVDdt/mQOe
         9lWaEaEbgQlWbNk3rBByXgf+8GB3vXwwsQ92OnP+d5/00YsILZnUhcmsQwhinZAg9WS+
         dB61NNB0MXXjyq1tmawOZ5nvct9PdFmcrAK8BFtvc+RCRaIL+NQvG9RAnJ/e4dOoPZJ5
         kNqgVPOjNaPkbKgRzQnmmTW4kkGxhphDMHWyJ6NZKwysx+KpepNB+3kFW2LYPDeyo1XW
         ZB+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVWQX0RdzRY+PpSRKqwB8P0DRuXKQ2CEFU9t30NxwIN46pATfj0js5JQwpba4O/ED7tTeAWg7Su4iE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoNvWZewKJW42hDVmWH7t/dREoIiiO6o1C4yOAwRwRm6vFRJoM
	VUcZ5kggZNGIQv37HlaIhmztILz7kL9gemblk8hH2n0hfmQ3HtXQB10hBtdz3/RdoW2Xpqg4HGq
	FoZbpvoD2ZdSsR1jv9LX064Pew/rFJ3YE+zYhdcuBRj1qHJ7vyrp08SIgRQ==
X-Received: by 2002:a5d:6d0d:0:b0:37d:4647:155a with SMTP id ffacd0b85a97d-381be560bafmr12893261f8f.0.1730734859886;
        Mon, 04 Nov 2024 07:40:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEep9B/uYoxxoCdMO0my4282vXiJ+yyroiuGgRcxca8Dq5X/TPqSl04rpYvKMT3b8KEjJFFNQ==
X-Received: by 2002:a5d:6d0d:0:b0:37d:4647:155a with SMTP id ffacd0b85a97d-381be560bafmr12893245f8f.0.1730734859388;
        Mon, 04 Nov 2024 07:40:59 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10d473bsm13600643f8f.35.2024.11.04.07.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 07:40:58 -0800 (PST)
Message-ID: <63b7f241-3340-431b-bf20-1cde551a96b8@redhat.com>
Date: Mon, 4 Nov 2024 16:40:58 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs: Xen/HPT related regression in v6.6
To: =?UTF-8?Q?Petr_Van=C4=9Bk?= <arkamar@atlas.cz>, linux-xfs@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>
References: <2024114141121-ZyjWCQr5TJE0JoRT-arkamar@atlas.cz>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <2024114141121-ZyjWCQr5TJE0JoRT-arkamar@atlas.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 04.11.24 15:11, Petr Vaněk wrote:
> I would like to report a regression in XFS introduced in kerenel v6.6 in
> commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"). On a
> system running under Xen, when a process creates a file on an XFS file
> system and writes exactly 2MB or more in a single write syscall,
> accessing memory through mmap on that file causes the process to hang,
> while dmesg is flooded with page fault warnings:

[...]

> [   62.406493]  </TASK>
> 
> As shown in the log above, the issue persists in kernel 6.6.59. However,
> it was recently resolved in commit 2b0f922323cc ("mm: don't install PMD
> mappings when THPs are disabled by the hw/process/vma"). The fix was
> backported to 6.11. Would it make sense to backport it to 6.6 as well?

I was speculating about this in the patch description:

"Is it also a problem when the HW disabled THP using 
TRANSPARENT_HUGEPAGE_UNSUPPORTED?  At least on x86 this would be the 
case without X86_FEATURE_PSE."

I assume we have a HW, where has_transparent_hugepage() == false, so 
likely x86-64 without X86_FEATURE_PSE.

QEMU/KVM should be supporting X86_FEATURE_PSE, but maybe XEN does not 
for its (PC?) guests? If I understood your setup correctly :)

At least years ago, this feature was not available in XEN PV guests [1].


Note that I already sent a backport [2], I should probably ping at this 
point.

[1] 
https://lore.kernel.org/all/57188ED802000078000E431C@prv-mh.provo.novell.com/
[2] https://lkml.kernel.org/r/20241022090952.4101444-1-david@redhat.com

> 
> I encountered this issue while updating a Gentoo VM with an XFS
> filesystem running under Xen. During a final stage of glibc update,
> files were copied to the live system, but when locale-gen started, it
> hung. I couldn't open a new shell, as it attempted to mmap an
> LC_COLLATE-related file, resulting in the same page faults as reported
> above.

Yes, looks like something is not happy about the PMD mapping that we 
installed.

-- 
Cheers,

David / dhildenb

