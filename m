Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BC72E3373
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039486; cv=none; b=jKw1jftNRNw9U40d5NfdkgBm2OBxoW16weuiL9xDb/CHIxUIY75vZpuNzfS8Ko/UBrOOg+aV19+NCtKoYPQckJHrdOb4JqyqF3In4m1u8jzmhIPY/9zZxTcT1XQnmNNOhxm/xupV0sUxBuiJGWfo+4mJGoxQtoyjVM7rjLsyZgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039486; c=relaxed/simple;
	bh=zUZDzYUzg+3AsTA8LAr9g0v2trX8HOm/b8KrBIdgeds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W7vbDcJy1PnuNoEH2mA6lx+UQrT4+X0/VzVDlSQQ91LU1CqMTsertqUXHb4lV92ziYcDtcPvhmqYzTA/4VbUhc0hW5Ba1ooK8gUTKEyeEAiG+rUA+02oBfMIgnYI2n73+//80S82kYkB8RwV23f2YIaQYzdVI3zkYf68vqyotGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jSrjCmp6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSrjCmp6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Q29DhQwTAK6dd4ZAsLxjzERt3jbFaX1obxxBjr33yAU=;
	b=jSrjCmp66Rt/Zd6RcY7cr660wKbHeW293RBAnksNP7JEpU1hAHx5nPn9soPAC2HdULNjZK
	fRCP5hNPq1x+50NOK8Hs8NvELcwNKAMRci391TTQEq3fKZDyvMxcE7vsLGyK5KGT+Qqzhu
	r3/bAnAvGrikxGU+xS2dwCvqFTL/PE0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-5UQpwskzMbqeW7BcctoSJg-1; Tue, 21 Oct 2025 05:38:02 -0400
X-MC-Unique: 5UQpwskzMbqeW7BcctoSJg-1
X-Mimecast-MFC-AGG-ID: 5UQpwskzMbqeW7BcctoSJg_1761039479
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f924ae2a89so6198979f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 02:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039479; x=1761644279;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q29DhQwTAK6dd4ZAsLxjzERt3jbFaX1obxxBjr33yAU=;
        b=vxMF9yC98cH2txeEns7gSczBRe0g3PLnvWHi7AxRhYebt65/phfU7k8KTsMLa2QosI
         DuE36avL6G9+vbGyu48QPvjtYv8OufLmjGUTE0XwiHhJVgujNN7oS4OzsEDL4uGQIlYu
         zwxMoH+ELnnhgz/rL5IP4DV/diNi3yGL/QWzMcdg+ta9IKRPged+4Em0s3wQEuFIBv/+
         D8iPKXy3eMudmAz1UVEa0xM+k/D7L61WnBGSFhe2GmiJuZ8FHK6HVBAdWjfYgtFbClww
         DSezd4Pmf8O5QOY5T2ueT2IOdgTF3gsx1n9yX0WgDFmam0ArK68a4W/VGtS03dLhg1nD
         ZHQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAs5BY/m8VFE5DYuwD1pVhisRQkyBWOss3TkTG4SR5JjDGLcnzmU7YWS9RcP8mKptqCbgjRmlbKR8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2iAQC/rvWuoNkf3FumXd0rWPqDmAMx2XLFofnZy01Z6H0AMXT
	LU5ovLTyKJt8DAj24mmBqYOmjttgq+WBF2ereHN/n6uykbrvsMqvMhN+lBWFYxqofB9UPZMiUPG
	XX0rKJl+yDdsExF4Vuuc7LRUMxwIQ3XgdCuXxJn2gCfSnHDbeAr04ovnJbPyiog==
X-Gm-Gg: ASbGnctmLx6YduObKU+NDSdTeaEuvfG80vot+VQPUj2TJW3bv58po/LBuo+3Pz8Uq3B
	K7eN/qOgbYZxdKFWI3YZeSwZUazo2T6XLVxqacQ0gYdF/7wWgwWBhS/9Mpdps6tsoFqA7CMG3c9
	Nit/XrFrrbLbOcoAIxA5CxM3HGNCb73nVjjH6S2Q6amhuOiY4NgZ5iNujRUjP1DMtlkhNXUGXgA
	G8gTd1pAfzlARlxY+JEparuikZFesClTJJbrG95SOPaoU+FIV1W4WSEJuJaHeppOj+n5DCWFZz6
	TIbdE0Mi2cLmkd/hTHMbcwYvLCxTrvyi/+fmYaIM5luMQjdTlhghFcTJVH7kFH5VtisCkghWEMc
	Hpt9kzxxwUBJvdZy2XJT2L8ZvI6mGtF55j9RH1vkiJOqWUbheruAJWtr5NFbBSKKQOsUWlS5Jzh
	7eKgnP60QPfZ3kVwtARfbLLD9TgkY=
X-Received: by 2002:a5d:64c4:0:b0:40f:5eb7:f234 with SMTP id ffacd0b85a97d-42704d442f9mr12220841f8f.5.1761039479081;
        Tue, 21 Oct 2025 02:37:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKruvi/TAKluPv6cz2boZrb3dbhZ+r79GGju1INC+ReltJyDrEtS+cBV3xo2qL/hT92CNu2g==
X-Received: by 2002:a5d:64c4:0:b0:40f:5eb7:f234 with SMTP id ffacd0b85a97d-42704d442f9mr12220818f8f.5.1761039478657;
        Tue, 21 Oct 2025 02:37:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0f19sm19610031f8f.9.2025.10.21.02.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 02:37:58 -0700 (PDT)
Message-ID: <750cfcac-e048-4fee-bba9-6e84edb7bbe0@redhat.com>
Date: Tue, 21 Oct 2025 11:37:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
 <aPc7HVRJYXA1hT8h@infradead.org>
 <rlu3rbmpktq5f3vgex3zlfjhivyohkhr5whpdmv3lscsgcjs7r@4zqutcey7kib>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <rlu3rbmpktq5f3vgex3zlfjhivyohkhr5whpdmv3lscsgcjs7r@4zqutcey7kib>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.10.25 11:22, Jan Kara wrote:
> On Tue 21-10-25 00:49:49, Christoph Hellwig wrote:
>> On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
>>> Just FYI, because it might be interesting in this context.
>>>
>>> For anonymous memory we have this working by only writing the folio out if
>>> it is completely unmapped and there are no unexpected folio references/pins
>>> (see pageout()), and only allowing to write to such a folio ("reuse") if
>>> SWP_STABLE_WRITES is not set (see do_swap_page()).
>>>
>>> So once we start writeback the folio has no writable page table mappings
>>> (unmapped) and no GUP pins. Consequently, when trying to write to it we can
>>> just fallback to creating a page copy without causing trouble with GUP pins.
>>
>> Yeah.  But anonymous is the easy case, the pain is direct I/O to file
>> mappings.  Mapping the right answer is to just fail pinning them and fall
>> back to (dontcache) buffered I/O.
> 
> I agree file mappings are more painful but we can also have interesting
> cases with anon pages:
> 
> P - anon page
> 
> Thread 1				Thread 2
> setup DIO read to P			setup DIO write from P

Ah, I was talking about the interaction between GUP and having 
BLK_FEAT_STABLE_WRITES set on the swap backend.

I guess what you mean here is: GUP from/to anon pages to/from a device 
that has BLK_FEAT_STABLE_WRITES?

So while we are writing to the device using the anon page as a source, 
the anon page will get modified.

I did not expect that to trigger checksum failures, but I can see the 
problem now.

-- 
Cheers

David / dhildenb

