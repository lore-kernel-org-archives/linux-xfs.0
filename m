Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA3422DF85
	for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 07:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755848291; cv=none; b=eI/5MotabB9oM02QkqIH2Uky2jRr563JgUFs75mccGryfqaLq3WeGTImMEX2xkgNGxS7JGCEiCCjo++Gf0WCHU1/qVHHC3GPhJC0vDbI3YIBJ4UqgxHRDs0zPiHrkvfxLMuhIKTBt/Yi7yhfpGospZa6jEEjfLfg66mrdOEzI1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755848291; c=relaxed/simple;
	bh=7wLwNKR1tIPJStSDpT9R+IB7+XoxGhpzkWHmWpSyQqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gg+qIgbfp5n47wwqjAuXif0AstfF9d1p61N1fO6BounrsgXf54Yq/eVyMYXXvXVBfKZxy4WLukyAk3B8wnBQVxVaObK4aZLqCcbO+7fhHV9r2/GDQ/PS3oYf91GwHpS8Amr1T9oYqpI6lXn/ODkxAMG1MBZJmB67by4QcveOrpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DqtHxXmo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DqtHxXmo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755848288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q5EBpRSPdoWQMyDULk73prUYhBE8dVOybsWq8vk4XLc=;
	b=DqtHxXmoflJ9NBo4BCCJg8dNPJo6VIkjwYg4Y9wLzSxnNnBFDC8AdNZ8TAKi93r68JuGde
	UOC95jTEwsajuEJArXxNn692sJqJHzVBqXcYUYS9dZqtTLhaA13Ax6fAbNQfI4wGam1z+h
	nr4hV5sN33ZUcZZA7XDvC+5mSQy8v1w=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-Pyl-3ThXP3m4sKJoAO7_fA-1; Fri, 22 Aug 2025 03:38:06 -0400
X-MC-Unique: Pyl-3ThXP3m4sKJoAO7_fA-1
X-Mimecast-MFC-AGG-ID: Pyl-3ThXP3m4sKJoAO7_fA_1755848286
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b471757dec5so3042302a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 00:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755848286; x=1756453086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q5EBpRSPdoWQMyDULk73prUYhBE8dVOybsWq8vk4XLc=;
        b=u+dQSufFmvzbDPs1t4R6Ks0qKicVSBhle2USFfL75zZR95shwSwLI/uHzJOI6uffaz
         uo4I0z/YBreubV/9AnhABryPfX26XSr4vOJIckBZQ3YR3zL/QKaxzJs7R3ahFSzyIhH3
         dcp4Sv/xuWIYJAHI2GVHEs8e0sEGU/dKCGkOoNhOAb6xEB5TzLxDsTXwOE2yslKlRE0D
         yJxjPYaITFgLHD49C6gRLZRYquhPB15vSz+AShcydr7n5Fy2r9jmPSlaQ7KNRmByidV3
         Etks5+FsTj6ssuihSr0R300WR9n9D+ZwYO7uLXWW/oMUcwFr0Jr/JK6jIUlQH4HjjCdj
         +vuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlAeYy4dfYzDbY3VRz+LtwLlGC12uKF1WshM9+uA2QDkujryfZAYn2ogHQhmjsDzl48lPYoQAuEQM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi5ZPokfmlsfrT/hXq+ZPjYMBiTo0Pdr63DAuuPxbH+KxxRLrI
	KI6mrIQgmuK749M50tzmWBxAm+M4VcmtEMH7oredlqI8xAzqStFZ8jo7dX6eAxSBvRlLKsx27nt
	HowpCMildPKbqQtc117jXeZiR/LpgxaD1vabAH/SJVgBmxUbfRr6qvegKTT9Uvw==
X-Gm-Gg: ASbGnctIe557lPNL29OZ/0tD9S23WeZ5/yOItbv9/3mbLfmxp1vQkrkAsoG75x/EXuQ
	C6sUCvv/UjxPmsODXmdt25vnJdUQ/rsiujAOuaAMsKQ3vFLHo5S0okAWE7o+AZohYwshe5jggor
	ekZ863cjrYkPTebDnbNeexKq6bgnk32kEpRy11Np9Y1+QrAwuSwkCxDFFokNkK2j62jHvX8LsEz
	h7KFwAJi1O6FX5Nj/+IAlVkC/wJCtErxm2QIysvJcCUcuhSi3FfPXutMlVOiBODLjplgB7VG53Q
	uTZAQtMnV8cGtVCtLBAPoBFn6NAMjcQSo2BKdPvw2XFE8fY+4sqV8ibQsfAdyxUGrHqswJAC++7
	OZp4cyZo/7J0=
X-Received: by 2002:a17:903:1a24:b0:246:4d93:78a8 with SMTP id d9443c01a7336-2464d937c89mr7884085ad.6.1755848285939;
        Fri, 22 Aug 2025 00:38:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHblZ2x1GxwxhiWSp7NdeXcvamAUKXYDKq+XPbbFjW3ymTVUdzepCW8RBpE05hUj4wtxQ2BzQ==
X-Received: by 2002:a17:903:1a24:b0:246:4d93:78a8 with SMTP id d9443c01a7336-2464d937c89mr7883865ad.6.1755848285550;
        Fri, 22 Aug 2025 00:38:05 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:8cd:5151:364a:2095? ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed33aa3esm75979975ad.24.2025.08.22.00.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 00:38:05 -0700 (PDT)
Message-ID: <335cc90f-8d08-43a3-a472-5a3ea5c270e5@redhat.com>
Date: Fri, 22 Aug 2025 17:38:01 +1000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
To: Eric Sandeen <sandeen@sandeen.net>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <20250818204533.GV7965@frogsfrogsfrogs>
 <zyfEYJMTkKD5zOCGC1U7KIpJyi-frJE_rYWyR5xVhz1u_VwOJDZm00KBbDZs-fKPTDD-Q7BOfuJrybFyo31WbQ==@protonmail.internalid>
 <85ac8fbf-2d12-4b2e-9bfa-010867a91ecd@redhat.com>
 <22vxocakop5le2flnejcrkuftszwdweqzco4qdf3fbvxsf2a5e@j3ffahfdd2zh>
 <e719e02a-508b-4417-8819-c27b8ea5c60b@sandeen.net>
Content-Language: en-US
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <e719e02a-508b-4417-8819-c27b8ea5c60b@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 22/8/25 06:06, Eric Sandeen wrote:
> On 8/21/25 7:52 AM, Carlos Maiolino wrote:
>> On Thu, Aug 21, 2025 at 07:16:49PM +1000, Donald Douwsma wrote:
>>>
>>>
>>> On 19/8/25 06:45, Darrick J. Wong wrote:
>>>> On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
>>>>> We had a report that a failing scsi disk was oopsing XFS when an xattr
>>>>> read encountered a media error. This is because the media error returned
>>>>> -ENODATA, which we map in xattr code to -ENOATTR and treat specially.
>>
>> scsi_debug can be configured to return a MEDIUM error which if I follow
>> the discussion properly, would result in the block layer converting it
>> to ENODATA.
> 
> Yep that does work though very old scsi_debug modules can't control
> which sector returns ENODATA. But for semi-modern scsi_debug it should
> work quite well.
> 
> -Eric
> 

Thanks Carlos, Eric, that works well.

I should able to make it work without knowing the sector if I stat the
inode before enabling the error if we need support for older kernels.

I'll file off the rough edges and post it for review.

Don


