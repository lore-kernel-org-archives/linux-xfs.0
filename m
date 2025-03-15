Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980221C860B
	for <linux-xfs@vger.kernel.org>; Sat, 15 Mar 2025 12:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742042959; cv=none; b=RTIzhgOCkAysUINoNuDhFVah7DrUR5NPHbkTEUPxTOw7hVQ1ExCyNeJ2rwWklJwkDurL3jxfjt5ueb/W9kUvtt25rkGcoHPYWuU3OTc5MlkGAC641+j8fsoaD2wDr5qHhNeD/vM7aD8rJJEZWdCtaFyIXMQasvRSB8hMhFcOk80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742042959; c=relaxed/simple;
	bh=05JSQo4E4e16yna6TaRjgUO/dZL7kxC7dKCEImr2GTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZClss3TYHJ90eMrKn5eljXeED34zeCgFVtfWmYDBcVIPtF51KWBJBSDbVN71YbQJBJt7VUCqqtKVgLQW4ouESQsAy+lQKKWpzJKRJnfIQWOe0ZbE5c9Gn2wZi1r4x/PMUgqVCBbyaP8DkE1FLStZ71HRc+uW8vY7sS4GuP3izfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RMSpSpat; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RMSpSpat"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d4502ca096so7646575ab.0
        for <linux-xfs@vger.kernel.org>; Sat, 15 Mar 2025 05:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742042956; x=1742647756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wmlHeMPLZ4MzXIMkVv0Emzj2xXJe/d+YNdrC71hs5UY=;
        b=RMSpSpath70UTowSNuZ4dhx/PC5/f6USLnnQdVO6tP4vmEgZsv1zLXfS1RDB1MPB7D
         dA/U4tLRCtI9ZUq5cQJJGGpsQHzWZaQqOAY6MQ+dTaQ9aufuRtBCzYzvjrvtwgcPpmf4
         EHo3VuWwSs5rKQiNz3wPp4AoMOEbxUmDVyS7Htld2/O3sfp3sKNKzmsbkDo9bntTbwKz
         Tx14m0CvtaEPVZhP5PWy5cdH3k7A5t46r6C9Ai0AASsE2/iu7RhyLhg8zSCBlr1RDba8
         4gtJ/6IiMbfb3tKvwdr9ToXLmTZYg1X4K8FmRq0LFu0JTUrjmbex0qzPJti7xomoaEo6
         5ZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742042956; x=1742647756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wmlHeMPLZ4MzXIMkVv0Emzj2xXJe/d+YNdrC71hs5UY=;
        b=a/OOJm1DxifUSV2l86lI9MQh4DK8wwMwouSqdm2QX1nGeWceAJwto/FAI60MYWUtnE
         GMHHl87BOt3exx4RfeUfGaulrKW2c5IXGUGv7zeL/kOX7XB/+BlBNPe8mh44lvJlFQ6t
         UNkAZxfeOu6WaJydqC5ExRJSYJSMQzlTUvovDnesdNz9KmqJuaT0M57XJFuwaJAivf4Z
         qYZhM/e+lz25yRGu2JLfML/U+n/2tLrXh7cLE8G3uTDMNWEAj2E7d+YRi8bMrofOFZn+
         +M2YEMO6jAWcU096fmWEEVYd+gaExYP7b6ou7sB00+SNxf1E6HbCpggpxOmUITyB2Ldv
         GM6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVhGlH24xo8H+l1hlYP06sAFqh/NsjEIzuGBlarcYn+BnbGlxkrQnwfzKqgWgVMj0Weom2vMYSCCo4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQIpfYjvHh7apoZjEacqQRoaHTJS4A9M3X1hVHpz6g0OcyLFmy
	K3ok7nMUbxtlKRqWH5s+ICi9Tstq4QjCoeAnrJHKfPhfwW+8kbju7Vl1gEx+aNM=
X-Gm-Gg: ASbGncvaehlpc4hNUf3lDUHdF/0xoht8Wiv/JGV4Esi9nWv17VRlVXzLHx9GStHdors
	fWroKkQsibbzP3SAuKRCL2UKMNZweS5IsreWTslOIX5tBpIi5yqA7d3IdDPmM3BZr4U1klnAFmh
	EIMFQp6IxygdGwhtKJkDWyMX3Aw3qtO8UTsFh5czhU7iYvrWnf8D55020gzWDCFt2gDbA1ZmRN0
	Syj0KxtD7iokQY/InECdi/agZ15VYAuEW3koU+FDHPMBVTavRun31ZQVh/kAkguVlaNE2NcreDn
	Jfy4ZcBZDyFUWhttPib/o/NF1DA8kdciumuBit93fQ==
X-Google-Smtp-Source: AGHT+IF+CRvPDGmWHAB+4PB2tRha7ylWNaFaXgmGRwUHKHOa4BSkiy1X26EDqqzUYWNC2M43P9DUsA==
X-Received: by 2002:a05:6e02:3f8b:b0:3d2:b0f1:f5bd with SMTP id e9e14a558f8ab-3d4839febd3mr60107935ab.3.1742042956387;
        Sat, 15 Mar 2025 05:49:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a72c8e4sm14787445ab.58.2025.03.15.05.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 05:49:15 -0700 (PDT)
Message-ID: <23e12af4-87aa-42c8-b3fb-045a23b9b18a@kernel.dk>
Date: Sat, 15 Mar 2025 06:49:14 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] xfsprogs: Add support for preadv2() and
 RWF_DONTCACHE
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org
References: <cover.1741340857.git.ritesh.list@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1741340857.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/25 2:20 AM, Ritesh Harjani (IBM) wrote:
> This adds following support to xfs_io:
> - Support for preadv2()
> - Support for uncached buffered I/O (RWF_DONTCACHE) for preadv2() and pwritev2()

Looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

