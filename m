Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D142F1E008E
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 22:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734473193; cv=none; b=IA1QfhnttdV98ZDu13LsS3yQh6F44Sb347y7ggVavQIicRYQRWmi4KT1rdt4CJWp3stT3Cs+FsQcKA91JICW+kxovwOP511YHm8ZFKWs8aUU7AQ/kpXXvPBVWCbGyOcy1WkXi7gUW7o/aWF7Cde0HhF8GDUMW/h79yFLpQVb9u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734473193; c=relaxed/simple;
	bh=CFFVeeJGulFiZAVQoOwWWmr2t17+p50wNCCr0sMnZu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=msIWrU4AOvAfJWN/rNKFKCLGYResejDl3zAZGVy3ytpWweJn0lI1MgROjKqlLMQhM7e1glKHhCgAkzTo8+rfrQP6UdpDyHVypoRkqOHq4aaA+TUm3DpMaMYjCVC0HnwtffXd7F/+hFc2vlSMTW/ChWPAm+7jxorcj/HsXE8xWVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cbqKdGNe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbqKdGNe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734473190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OSLYMoWvHcnkmKFurx8SkgSXyiJyqs7HoLAYTVGYrAc=;
	b=cbqKdGNePEHVnCEnSroUIs4pU47mslv31s5mtcL2m8KIGfzZj4rq4J68wSG3D97yI6sctT
	Xs8lFETmNOtOuD2tKBlUvuI430FUK90gzY/bX24cg9PzOCuk5Cc9wMJ+a19cA7n6zPB6Jn
	xWGN3COc8AOgvbQhTgKjOjxKiRIjjr8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-7VNS1hv4Oo-TcKCwSkgT9Q-1; Tue, 17 Dec 2024 17:06:29 -0500
X-MC-Unique: 7VNS1hv4Oo-TcKCwSkgT9Q-1
X-Mimecast-MFC-AGG-ID: 7VNS1hv4Oo-TcKCwSkgT9Q
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385df115288so2427937f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 14:06:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734473188; x=1735077988;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OSLYMoWvHcnkmKFurx8SkgSXyiJyqs7HoLAYTVGYrAc=;
        b=KrbnMGMcbkwH7vDXlTg2Gj6mDQL6zeUfKoQZQCZB8xdNFIs2Y5Xq0QsNyeEc4f+G/I
         9DroWnV4Uv7Q0oZhuWoCP+/fhNdiBcCASXpGxERHYi2ukgT/+GPb/D8GcI2Co/tFHPve
         fwTRKNyqEDqzn5vYl+YFEkAsP/4adtDlhUVaM7b4HtdedLegcuLcoZc3Gm9yDH658TXk
         aiZ7yAjFH66pIm+Ftbmj0/hGNxBol1IYjVWMpDpwv/wlWhrIYBo7ZdWTg3xW+PCLCN3q
         tCdFqdR5k4CbAGkEamKxVG8JYXLwkL/atcXaICzdcYPOpGTFYOx4wxY1hmn4rsUjqZT1
         gKTg==
X-Forwarded-Encrypted: i=1; AJvYcCXX4t+T+BICgqV8KIdqCS1Eg1ec2FlDYsKthsRi+olpR7HeaUzDVgnQ0LWbFJ0Y4lc+HrE/iCOzp98=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyho6vHihlQWpld5JpGMF3kx/BMyDt1BPbsdOTNInOJP7uuqeRv
	V6mCGX3pPvY3VTZ4UR1H+XD9M8IVOl7UaGKA88y/wb3sT+zR85xQPIG8xnXJZ+OJcg5tPMjj5Lc
	iiMdSgbzgggbh4hsJ/duK6nt6QIDRgPniw+BbtRUKb+GLrbZRa5bvIBzuFQ==
X-Gm-Gg: ASbGncv6UOw/RVmSLgC45UcN9JjUZmyZys+s9BGTfDM8G+fqnNS97KkoqtV/mYjSEQR
	q7GxvzZOYFeZbT8/5vmsLwL+OF7PBpo/WYAjWr0FtwQDJKpk1lF+oo4EO4HIl/UzX4nNmK1709z
	YeOQEpiibiHGtNa9jGsVe97VPz0t/6CLpOgaeDtb4yoRmSE9FYQlgJ6usWRkCLfpdG2wD3lZGHm
	RQbycEkP+WPyrnx6Xf6S3lrsE20C0q3oQjaa00ACTyWAu7riDYk6fLhnH4HDgxa7rgvaumnlMSC
	oXMSky88n3/09UBQ640RMlol4jUSlOa2C7B3KDFHq+ie8noM45OWzArwk4ARCl4ZI2563TTNb1R
	KBOCt8nO+
X-Received: by 2002:a05:6000:461a:b0:385:eecb:6f02 with SMTP id ffacd0b85a97d-388e4d8b688mr358659f8f.28.1734473188373;
        Tue, 17 Dec 2024 14:06:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEefTx+5wwgHu5Lo3QBynYxK4sBxxlYTWobNsuzYzh7kr1/3xagCl49eAlHDCo53GInNei+Aw==
X-Received: by 2002:a05:6000:461a:b0:385:eecb:6f02 with SMTP id ffacd0b85a97d-388e4d8b688mr358632f8f.28.1734473188043;
        Tue, 17 Dec 2024 14:06:28 -0800 (PST)
Received: from ?IPV6:2003:cb:c73b:5600:c716:d8e0:609d:ae92? (p200300cbc73b5600c716d8e0609dae92.dip0.t-ipconnect.de. [2003:cb:c73b:5600:c716:d8e0:609d:ae92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c8012112sm12401862f8f.11.2024.12.17.14.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 14:06:27 -0800 (PST)
Message-ID: <ea6eda57-f150-47ea-97b8-fc8eeaf81bd3@redhat.com>
Date: Tue, 17 Dec 2024 23:06:25 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/25] mm/gup.c: Remove redundant check for PCI P2PDMA
 page
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
Cc: lina@asahilina.net, zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
 bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
 will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
 dave.hansen@linux.intel.com, ira.weiny@intel.com, willy@infradead.org,
 djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, peterx@redhat.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 david@fromorbit.com, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.18cbcff3638c6aacc051c44533ebc6c002bf2bd9.1734407924.git-series.apopple@nvidia.com>
 <3f20b8d258d4eb72e1eadd5926d892bc61f0e0d4.1734407924.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <3f20b8d258d4eb72e1eadd5926d892bc61f0e0d4.1734407924.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.12.24 06:12, Alistair Popple wrote:
> PCI P2PDMA pages are not mapped with pXX_devmap PTEs therefore the
> check in __gup_device_huge() is redundant. Remove it
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Dan Wiliams <dan.j.williams@intel.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---

Nit: patch subject should start with "mm/gup: ...".

-- 
Cheers,

David / dhildenb

